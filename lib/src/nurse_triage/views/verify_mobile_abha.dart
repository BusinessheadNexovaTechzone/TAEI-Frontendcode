import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';

class VerifyMobileAbhaScreen extends StatefulWidget {
  final Future<void> Function(String message)? onNext;

  const VerifyMobileAbhaScreen({super.key, this.onNext});

  @override
  State<VerifyMobileAbhaScreen> createState() => _VerifyMobileAbhaScreenState();
}

class _VerifyMobileAbhaScreenState extends State<VerifyMobileAbhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _captchaController = TextEditingController();
  late final VerifyAbhaController _controller;
  late String _captchaQuestion;
  late String _captchaAnswer;
  bool _isSendingOtp = false;
  List<Map<String, dynamic>> _profiles = [];
  int? _selectedProfileIndex;

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
    _mobileController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  String _profileName(Map<String, dynamic> profile) {
    return (profile['name'] ?? profile['fullName'] ?? 'Unknown User').toString();
  }

  String _profileAbhaNumber(Map<String, dynamic> profile) {
    return (profile['ABHANumber'] ?? profile['abhaNumber'] ?? 'ABHA Number')
        .toString();
  }

  void _generateCaptcha() {
    final first = 2 + DateTime.now().millisecond % 5;
    final second = 1 + DateTime.now().second % 6;
    _captchaQuestion = '$first + $second';
    _captchaAnswer = '${first + second}';
    _captchaController.clear();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');

    setState(() {
      _isSendingOtp = true;
      _profiles = [];
      _selectedProfileIndex = null;
    });

    try {
      final searchSucceeded = await _controller.searchAbhaByMobile(
        mobile: mobile,
      );
      if (!mounted || !searchSucceeded) return;

      final profiles = List<Map<String, dynamic>>.from(_controller.mobileSearchProfiles);
      if (profiles.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No ABHA profiles found for this mobile number.')),
          );
        }
        return;
      }

      setState(() {
        _profiles = profiles;
        _selectedProfileIndex = profiles.length == 1 ? 0 : null;
      });
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _sendSelectedOtp() async {
    if (_selectedProfileIndex == null || _selectedProfileIndex! >= _profiles.length) {
      return;
    }

    final selectedIndex = _controller.mobileSearchRecordIndex(_profiles[_selectedProfileIndex!]) ??
        _selectedProfileIndex!;

    setState(() => _isSendingOtp = true);
    try {
      final otpSent = await _controller.sendMobileSearchOtp(index: selectedIndex);
      if (!mounted || !otpSent) return;

      final message = _controller.otpMessage.value.isNotEmpty
          ? _controller.otpMessage.value
          : 'OTP sent to the selected ABHA profile.';
      await widget.onNext?.call(message);
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
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
                        child: const Icon(Icons.phone_android_outlined,
                            color: Color(0xFFEF4444), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile Number Verification',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Enter your mobile number to receive a verification OTP.',
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
                    'Mobile Number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 420,
                      child: TextFormField(
                        controller: _mobileController,
                        enabled: !_isSendingOtp,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('+91',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF111827))),
                                const SizedBox(width: 8),
                                Container(
                                    width: 1,
                                    height: 20,
                                    color: Color(0xFFD1D5DB)),
                              ],
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 64),
                          hintText: 'Enter 10-digit mobile number',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.8),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().length != 10) {
                            return 'Mobile number must contain exactly 10 digits.';
                          }
                          return null;
                        },
                      ),
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
                            Icon(Icons.shield_outlined,
                                size: 18, color: Color(0xFF6B7280)),
                            SizedBox(width: 8),
                            Text('Human Verification',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Solve the captcha to continue',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_captchaQuestion = ?',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827)),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _captchaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter answer',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.8),
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
                  const SizedBox(height: 24),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSendingOtp ? null : _sendOtp,
                          icon: _isSendingOtp
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search_rounded),
                          label: Text(
                            _isSendingOtp ? 'Searching ...' : 'Search ABHA Profile',
                          ),
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
                  if (_profiles.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Matching ABHA Profiles',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._profiles.asMap().entries.map((entry) {
                            final index = entry.key;
                            final profile = entry.value;
                            final isSelected = _selectedProfileIndex == index;
                            final name = _profileName(profile);
                            final abhaNumber = _profileAbhaNumber(profile);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFFF3CD)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFE6C653)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Text(name),
                                subtitle: Text(abhaNumber),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : const Icon(Icons.radio_button_unchecked),
                                onTap: () => setState(() => _selectedProfileIndex = index),
                              ),
                            );
                          }),
                          if (_selectedProfileIndex != null) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isSendingOtp ? null : _sendSelectedOtp,
                                icon: _isSendingOtp
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(Icons.send_rounded),
                                label: Text(
                                  _isSendingOtp ? 'Sending OTP...' : 'Send OTP',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
