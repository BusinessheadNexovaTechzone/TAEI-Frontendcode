import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';

class VerifyAbhaNumberScreen extends StatefulWidget {
  final Future<void> Function(String message)? onNext;

  const VerifyAbhaNumberScreen({super.key, this.onNext});

  @override
  State<VerifyAbhaNumberScreen> createState() => _VerifyAbhaNumberScreenState();
}

class _VerifyAbhaNumberScreenState extends State<VerifyAbhaNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _abhaPartControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _abhaFocusNodes = List.generate(4, (_) => FocusNode());
  final _captchaController = TextEditingController();
  late final VerifyAbhaController _controller;
  late String _captchaQuestion;
  late String _captchaAnswer;
  String _selectedMethod = 'Aadhaar OTP';
  String _abhaNumberError = '';

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
    for (final controller in _abhaPartControllers) {
      controller.dispose();
    }
    for (final focusNode in _abhaFocusNodes) {
      focusNode.dispose();
    }
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    final first = 2 + DateTime.now().millisecond % 5;
    final second = 1 + DateTime.now().second % 6;
    _captchaQuestion = '$first + $second';
    _captchaAnswer = '${first + second}';
    _captchaController.clear();
  }

  String _buildFormattedAbhaNumber() {
    final parts = _abhaPartControllers
        .map((controller) => controller.text.trim())
        .toList();
    return '${parts[0]}-${parts[1]}-${parts[2]}-${parts[3]}';
  }

  bool _isAbhaNumberValid() {
    final parts = _abhaPartControllers
        .map((controller) => controller.text.trim())
        .toList();
    if (parts.length != 4) {
      return false;
    }

    if (parts.any((part) => part.isEmpty)) {
      return false;
    }

    final combinedDigits = parts.join();
    if (combinedDigits.length != 14) {
      return false;
    }

    return RegExp(r'^\d{14}$').hasMatch(combinedDigits);
  }

  Future<void> _handleNext() async {
    if (!_isAbhaNumberValid()) {
      setState(() {
        _abhaNumberError = 'Please enter a valid 14-digit ABHA Number.';
      });
      FocusScope.of(context).requestFocus(_abhaFocusNodes[0]);
      return;
    }

    setState(() {
      _abhaNumberError = '';
    });

    if (!_formKey.currentState!.validate()) return;

    final abhaNumber = _buildFormattedAbhaNumber();
    final method =
        _selectedMethod == 'Aadhaar OTP' ? 'abha-aadhaar' : 'abha-abha';

    debugPrint('========== VERIFY ABHA ==========');
    debugPrint('Selected Method : $method');
    debugPrint('Formatted ABHA : $abhaNumber');
    debugPrint('Digits Only : ${abhaNumber.replaceAll(RegExp(r"\D"), "")}');
    debugPrint(
        'Digit Count : ${abhaNumber.replaceAll(RegExp(r"\D"), "").length}');
    debugPrint('===============================');

    final sent = await _controller.sendOtp(
      method: method,
      loginId: abhaNumber,
    );
    if (!sent) return;

    final message = _controller.otpMessage.value.isNotEmpty
        ? _controller.otpMessage.value
        : method == 'abha-aadhaar'
            ? 'OTP sent to your Aadhaar registered mobile number.'
            : 'OTP sent to your ABHA registered mobile number.';

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
                Text('ABHA Number Verification',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Choose a verification method and continue.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: const Color(0xFF616161))),
                const SizedBox(height: 16),
                Text('Authentication Type',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  value: 'Aadhaar OTP',
                  groupValue: _selectedMethod,
                  onChanged: (value) =>
                      setState(() => _selectedMethod = value ?? 'Aadhaar OTP'),
                  title: const Text('Aadhaar OTP'),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  value: 'ABHA Number OTP',
                  groupValue: _selectedMethod,
                  onChanged: (value) => setState(
                      () => _selectedMethod = value ?? 'ABHA Number OTP'),
                  title: const Text('ABHA Number OTP'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                Text('ABHA Number',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(4, (index) {
                    final maxLength = index == 0 ? 2 : 4;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < 3 ? 8 : 0),
                        child: TextFormField(
                          controller: _abhaPartControllers[index],
                          focusNode: _abhaFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(maxLength),
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                          textInputAction: index < 3
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              _abhaNumberError = '';
                            });
                            if (value.length >= maxLength && index < 3) {
                              FocusScope.of(context)
                                  .requestFocus(_abhaFocusNodes[index + 1]);
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(_abhaFocusNodes[index - 1]);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                if (_abhaNumberError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _abhaNumberError,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
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
