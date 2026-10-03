import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'face_authentication.dart';
import 'fingerprint_authentication.dart';

enum VerifyBiometricMethod { face, fingerprint }

class VerifyBiometricAbhaScreen extends StatefulWidget {
  const VerifyBiometricAbhaScreen({
    super.key,
    required this.method,
  });

  final VerifyBiometricMethod method;

  @override
  State<VerifyBiometricAbhaScreen> createState() =>
      _VerifyBiometricAbhaScreenState();
}

class _VerifyBiometricAbhaScreenState extends State<VerifyBiometricAbhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aadhaarController = TextEditingController();
  final _mobileController = TextEditingController();

  String get _title => widget.method == VerifyBiometricMethod.face
      ? 'Face Verification'
      : 'Fingerprint Verification';

  String get _description => widget.method == VerifyBiometricMethod.face
      ? 'Use face authentication through the official ABHA application.'
      : 'Verify your identity using your fingerprint.';

  @override
  void dispose() {
    _aadhaarController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    final aadhaar = _aadhaarController.text.replaceAll(RegExp(r'\D'), '');
    final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');

    final screen = widget.method == VerifyBiometricMethod.face
        ? FaceAuthenticationScreen(aadhaar: aadhaar, mobile: mobile)
        : FingerprintAuthenticationScreen(aadhaar: aadhaar, mobile: mobile);

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = widget.method == VerifyBiometricMethod.face
        ? Icons.face_retouching_natural_rounded
        : Icons.fingerprint_rounded;

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
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 26,
                  offset: Offset(0, 10),
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
                        child: Icon(icon, color: const Color(0xFFEF4444), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _description,
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
                  TextFormField(
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: _inputDecoration('Enter 12-digit Aadhaar number'),
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                      return digits.length == 12
                          ? null
                          : 'Aadhaar number must contain exactly 12 digits.';
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Mobile Number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: _inputDecoration('Enter 10-digit mobile number'),
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                      return digits.length == 10
                          ? null
                          : 'Mobile number must contain exactly 10 digits.';
                    },
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _continue,
                      icon: Icon(icon),
                      label: Text('Continue with $_title'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }
}
