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
    final parts = _abhaPartControllers.map((controller) => controller.text.trim()).toList();
    return '${parts[0]}-${parts[1]}-${parts[2]}-${parts[3]}';
  }

  bool _isAbhaNumberValid() {
    final parts = _abhaPartControllers.map((controller) => controller.text.trim()).toList();
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

  void _distributeAbhaDigits(String digits) {
    final sanitized = digits.replaceAll(RegExp(r'\D'), '');
    final sizes = [2, 4, 4, 4];
    var cursor = 0;
    for (var index = 0; index < _abhaPartControllers.length; index++) {
      final size = sizes[index];
      final end = cursor + size;
      if (cursor >= sanitized.length) {
        _abhaPartControllers[index].text = '';
      } else {
        final chunk = sanitized.substring(cursor, end > sanitized.length ? sanitized.length : end);
        _abhaPartControllers[index].text = chunk;
      }
      cursor = end;
    }

    final nextIndex = sanitized.length <= 2
        ? 0
        : sanitized.length <= 6
            ? 1
            : sanitized.length <= 10
                ? 2
                : 3;
    if (nextIndex < _abhaFocusNodes.length) {
      FocusScope.of(context).requestFocus(_abhaFocusNodes[nextIndex]);
    }
  }

  void _handleAbhaPartChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final maxLength = index == 0 ? 2 : 4;
    if (digits.length > maxLength) {
      _distributeAbhaDigits(digits);
      return;
    }

    if (digits.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_abhaFocusNodes[index - 1]);
      return;
    }

    if (digits.length == maxLength && index < 3) {
      FocusScope.of(context).requestFocus(_abhaFocusNodes[index + 1]);
    }
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
    final method = _selectedMethod == 'Aadhaar OTP' ? 'abha-aadhaar' : 'abha-abha';

    debugPrint('========== VERIFY ABHA ==========');
    debugPrint('Selected Method : $method');
    debugPrint('Formatted ABHA : $abhaNumber');
    debugPrint('Digits Only : ${abhaNumber.replaceAll(RegExp(r"\D"), "")}');
    debugPrint('Digit Count : ${abhaNumber.replaceAll(RegExp(r"\D"), "").length}');
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
                        child: const Icon(Icons.medical_services_outlined, color: Color(0xFFEF4444), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ABHA Number Verification',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Choose a verification method and continue.',
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
                    'Authentication Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => _selectedMethod = 'Aadhaar OTP'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'Aadhaar OTP',
                                  groupValue: _selectedMethod,
                                  onChanged: (value) => setState(() => _selectedMethod = value ?? 'Aadhaar OTP'),
                                  activeColor: const Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 4),
                                const Expanded(child: Text('Aadhaar OTP', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151)))),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => _selectedMethod = 'ABHA Number OTP'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'ABHA Number OTP',
                                  groupValue: _selectedMethod,
                                  onChanged: (value) => setState(() => _selectedMethod = value ?? 'ABHA Number OTP'),
                                  activeColor: const Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 4),
                                const Expanded(child: Text('ABHA Number OTP', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151)))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'ABHA Number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 72,
                        child: TextFormField(
                          controller: _abhaPartControllers[0],
                          focusNode: _abhaFocusNodes[0],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
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
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              _abhaNumberError = '';
                            });
                            _handleAbhaPartChanged(0, value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _abhaPartControllers[1],
                          focusNode: _abhaFocusNodes[1],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
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
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              _abhaNumberError = '';
                            });
                            _handleAbhaPartChanged(1, value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _abhaPartControllers[2],
                          focusNode: _abhaFocusNodes[2],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
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
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              _abhaNumberError = '';
                            });
                            _handleAbhaPartChanged(2, value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _abhaPartControllers[3],
                          focusNode: _abhaFocusNodes[3],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
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
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              _abhaNumberError = '';
                            });
                            _handleAbhaPartChanged(3, value);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_abhaNumberError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _abhaNumberError,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
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
