import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';

class VerifyAadhaarAbhaScreen extends StatefulWidget {
  final Future<void> Function(String message)? onNext;

  const VerifyAadhaarAbhaScreen({super.key, this.onNext});

  @override
  State<VerifyAadhaarAbhaScreen> createState() =>
      _VerifyAadhaarAbhaScreenState();
}

class _VerifyAadhaarAbhaScreenState extends State<VerifyAadhaarAbhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aadhaarController = TextEditingController();
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
    _aadhaarController.dispose();
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

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;

    final rawAadhaar = _aadhaarController.text.trim();
    final aadhaar = rawAadhaar.replaceAll(RegExp(r'\D'), '');
    if (aadhaar.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Aadhaar must contain exactly 12 digits.')));
      return;
    }

    debugPrint('===== VERIFY AADHAAR ENTRY =====');
    debugPrint('Raw Aadhaar input: $rawAadhaar');
    debugPrint('Digits-only Aadhaar: $aadhaar');
    debugPrint('Aadhaar length: ${aadhaar.length}');

    final sent = await _controller.sendOtp(method: 'aadhaar', loginId: aadhaar);
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
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aadhaar Verification',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                    'Enter your Aadhaar number to receive an OTP on the registered mobile number.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: const Color(0xFF616161))),
                const SizedBox(height: 20),
                Text('Aadhaar Number',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _aadhaarController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12)
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter 12-digit Aadhaar number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().length != 12) {
                      return 'Aadhaar must contain exactly 12 digits.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Human Verification',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solve the captcha to continue'),
                      const SizedBox(height: 8),
                      Text('$_captchaQuestion = ?',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _captchaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter answer',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleNext,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
