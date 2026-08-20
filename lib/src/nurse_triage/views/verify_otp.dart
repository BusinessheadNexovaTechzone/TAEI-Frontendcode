import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';
import 'package:taei_gov/src/nurse_triage/services/abha_error_message_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String message;
  final Future<void> Function()? onResendOtp;
  final Future<bool> Function(String otp)? onVerify;

  const VerifyOtpScreen({super.key, required this.message, this.onResendOtp, this.onVerify});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late final VerifyAbhaController controller;
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<VerifyAbhaController>()
        ? Get.find<VerifyAbhaController>()
        : Get.put(VerifyAbhaController());
    debugPrint('===== VERIFY OTP SCREEN OPENED =====');
    debugPrint('Message: ${widget.message}');
    debugPrint('Selected login type: ${controller.selectedLoginType.value}');
    debugPrint('Selected method: ${controller.selectedMethod.value}');
    debugPrint('Selected txnId: ${controller.selectedTxnId.value}');
    debugPrint('Selected loginId: ${controller.selectedLoginId.value}');
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final otpController in _otpControllers) {
      otpController.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        }
      });
    });
  }

  void _handleOtpChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
      }
      return;
    }

    if (digits.length > 1) {
      for (var i = 0; i < 6; i++) {
        final char = i < digits.length ? digits[i] : '';
        _otpControllers[i].text = char;
      }

      final nextIndex = digits.length >= 6 ? 5 : digits.length;
      FocusScope.of(context).requestFocus(_otpFocusNodes[nextIndex]);
      return;
    }

    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    }
  }

  Future<void> _handleResendOtp() async {
    await widget.onResendOtp?.call();
    if (mounted) {
      _startTimer();
    }
  }

  Future<void> _handleVerify() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(otp.isEmpty
              ? AbhaErrorMessageService.required('otp')
              : AbhaErrorMessageService.invalid('otp', incomplete: true)),
        ),
      );
      return;
    }

    debugPrint('===== VERIFY OTP SUBMIT =====');
    debugPrint('Entered OTP: $otp');
    debugPrint('TxnId: ${controller.selectedTxnId.value}');
    debugPrint('LoginType: ${controller.selectedLoginType.value}');

    final verified = await widget.onVerify?.call(otp) ?? await controller.verifyOtp(otp: otp);
    debugPrint('verifyOtp result: $verified');
    if (!verified) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification completed successfully.')));
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F3F7)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x12000000),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.lock_outline_rounded, color: Color(0xFFEF4444), size: 24),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Verify OTP',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: SizedBox(
                            width: 50,
                            height: 58,
                            child: TextFormField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.green, width: 2),
                                ),
                              ),
                              onChanged: (value) => _handleOtpChanged(index, value),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _handleResendOtp,
                          child: const Text('Resend OTP', style: TextStyle(color: Color(0xFFEF4444))),
                        ),
                        Text(
                          _remainingSeconds > 0 ? '$_remainingSeconds s' : 'Resend available',
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _handleVerify,
                          icon: const Icon(Icons.verified_rounded),
                          label: const Text('Verify'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
