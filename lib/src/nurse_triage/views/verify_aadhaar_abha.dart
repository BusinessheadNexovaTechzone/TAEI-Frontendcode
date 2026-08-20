import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';
import 'package:taei_gov/src/nurse_triage/services/abha_error_message_service.dart';

class VerifyAadhaarAbhaScreen extends StatefulWidget {
  final Future<void> Function(String message)? onNext;

  const VerifyAadhaarAbhaScreen({super.key, this.onNext});

  @override
  State<VerifyAadhaarAbhaScreen> createState() => _VerifyAadhaarAbhaScreenState();
}

class _VerifyAadhaarAbhaScreenState extends State<VerifyAadhaarAbhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _aadhaarControllers = List.generate(3, (_) => TextEditingController());
  final List<FocusNode> _aadhaarFocusNodes = List.generate(3, (_) => FocusNode());
  final _captchaController = TextEditingController();
  late final VerifyAbhaController _controller;
  late String _captchaQuestion;
  late String _captchaAnswer;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<VerifyAbhaController>()
        ? Get.find<VerifyAbhaController>()
        : Get.put(VerifyAbhaController());
    _generateCaptcha();
  }

  @override
  void dispose() {
    for (final controller in _aadhaarControllers) {
      controller.dispose();
    }
    for (final focusNode in _aadhaarFocusNodes) {
      focusNode.dispose();
    }
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    final first = 2 + DateTime.now().millisecond % 4;
    final second = 1 + DateTime.now().second % 6;
    _captchaQuestion = '$first + $second';
    _captchaAnswer = '${first + second}';
    _captchaController.clear();
  }

  void _distributeAadhaarDigits(String digits) {
    final sanitized = digits.replaceAll(RegExp(r'\D'), '');
    for (var index = 0; index < _aadhaarControllers.length; index++) {
      final start = index * 4;
      final end = start + 4;
      if (start >= sanitized.length) {
        _aadhaarControllers[index].text = '';
      } else {
        final chunk = sanitized.substring(start, end > sanitized.length ? sanitized.length : end);
        _aadhaarControllers[index].text = chunk;
      }
    }

    final nextIndex = sanitized.length >= 12 ? 2 : (sanitized.length / 4).floor();
    if (nextIndex < _aadhaarFocusNodes.length) {
      FocusScope.of(context).requestFocus(_aadhaarFocusNodes[nextIndex]);
    }
  }

  void _handleAadhaarChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) {
      _distributeAadhaarDigits(digits);
      return;
    }

    if (digits.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_aadhaarFocusNodes[index - 1]);
      return;
    }

    if (digits.length == 4 && index < 2) {
      FocusScope.of(context).requestFocus(_aadhaarFocusNodes[index + 1]);
    }
  }

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;

    final aadhaar = _aadhaarControllers.map((controller) => controller.text.trim()).join();
    final normalizedAadhaar = aadhaar.replaceAll(RegExp(r'\D'), '');
    if (normalizedAadhaar.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(normalizedAadhaar.isEmpty
              ? AbhaErrorMessageService.required('aadhaar')
              : AbhaErrorMessageService.invalid('aadhaar', incomplete: true)),
        ),
      );
      return;
    }

    debugPrint('===== VERIFY AADHAAR ENTRY =====');
    debugPrint('Raw Aadhaar input: $aadhaar');
    debugPrint('Digits-only Aadhaar: $normalizedAadhaar');
    debugPrint('Aadhaar length: ${normalizedAadhaar.length}');

    final sent = await _controller.sendOtp(method: 'aadhaar', loginId: normalizedAadhaar);
    debugPrint('sendOtp result for aadhaar: $sent');
    if (!sent) return;

    final message = _controller.otpMessage.value.isNotEmpty
        ? _controller.otpMessage.value
        : 'OTP sent to Aadhaar registered mobile number.';
    debugPrint('OTP message from controller: $message');

    await widget.onNext?.call(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F3F7)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x12000000),
                  blurRadius: 26,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.verified_user_outlined, color: Color(0xFFEF4444), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aadhaar Verification',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Enter your Aadhaar number to receive an OTP on the registered mobile number.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF6B7280),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Aadhaar Number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: index < 2 ? 16 : 0),
                          child: TextFormField(
                            controller: _aadhaarControllers[index],
                            focusNode: _aadhaarFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textInputAction: index < 2 ? TextInputAction.next : TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.red, width: 1.8),
                              ),
                            ),
                            onChanged: (value) => _handleAadhaarChanged(index, value),
                            validator: (value) {
                              final combined = _aadhaarControllers.map((controller) => controller.text.trim()).join();
                              if (combined.replaceAll(RegExp(r'\D'), '').length != 12) {
                                return 'Aadhaar must contain exactly 12 digits.';
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.shield_outlined, size: 18, color: Color(0xFF6B7280)),
                            SizedBox(width: 8),
                            Text('Human Verification', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Solve the captcha to continue',
                          style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_captchaQuestion = ?',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _captchaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter answer',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                              borderSide: const BorderSide(color: Colors.red, width: 1.8),
                            ),
                          ),
                          validator: (value) {
                            if ((value ?? '').trim() != _captchaAnswer) {
                              return 'Incorrect answer.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _handleNext,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Next'),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
