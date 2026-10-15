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
  bool _isSearching = false;
  bool _isSendingOtp = false;
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

  void _generateCaptcha() {
    final first = 2 + DateTime.now().millisecond % 5;
    final second = 1 + DateTime.now().second % 6;
    _captchaQuestion = '$first + $second';
    _captchaAnswer = '${first + second}';
    _captchaController.clear();
  }

  Future<void> _searchProfiles() async {
    if (!_formKey.currentState!.validate()) return;

    final rawMobile = _mobileController.text.trim();
    final mobile = rawMobile.replaceAll(RegExp(r'\D'), '');

    debugPrint('===== VERIFY MOBILE ENTRY =====');
    debugPrint('Raw mobile input: $rawMobile');
    debugPrint('Digits-only mobile: $mobile');
    debugPrint('Mobile length: ${mobile.length}');

    setState(() {
      _isSearching = true;
      _selectedProfileIndex = null;
    });
    try {
      final found = await _controller.searchAbhaByMobile(mobile: mobile);
      if (!mounted || !found) return;
      setState(() {});
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _sendOtpForSelectedProfile() async {
    final index = _selectedProfileIndex;
    if (index == null) return;

    setState(() => _isSendingOtp = true);
    try {
      final sent = await _controller.sendMobileSearchOtp(index: index);
      if (!mounted || !sent) return;
      final message = _controller.otpMessage.value.isNotEmpty
          ? _controller.otpMessage.value
          : 'OTP sent to your registered mobile number.';
      await widget.onNext?.call(message);
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  String _profileValue(Map<String, dynamic> profile, List<String> keys) {
    for (final key in keys) {
      final value = profile[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  Widget _buildSearchResults(ThemeData theme) {
    final profiles = _controller.mobileSearchProfiles;
    if (profiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Select the ABHA profile to verify',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        ...profiles.map((profile) {
          final recordIndex = _controller.mobileSearchRecordIndex(profile);
          final name = _profileValue(
            profile,
            const ['name', 'fullName', 'full_name'],
          );
          final abhaNumber = _profileValue(
            profile,
            const ['ABHANumber', 'abhaNumber', 'abha_number'],
          );
          final abhaAddress = _profileValue(
            profile,
            const [
              'preferredAbhaAddress',
              'abhaAddress',
              'abha_address',
              'preferred_abha_address',
            ],
          );
          final details = <String>[
            if (recordIndex != null) 'Index $recordIndex',
            if (name.isNotEmpty) name,
            if (abhaAddress.isNotEmpty) abhaAddress,
          ].join(' • ');

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color:
                    recordIndex != null && _selectedProfileIndex == recordIndex
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFE5E7EB),
              ),
            ),
            child: Semantics(
              button: true,
              selected:
                  recordIndex != null && _selectedProfileIndex == recordIndex,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _isSendingOtp || recordIndex == null
                    ? null
                    : () => setState(
                          () => _selectedProfileIndex = recordIndex,
                        ),
                child: ListTile(
                  leading: Icon(
                    recordIndex != null && _selectedProfileIndex == recordIndex
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: recordIndex != null &&
                            _selectedProfileIndex == recordIndex
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6B7280),
                  ),
                  title: Text(
                    abhaNumber.isNotEmpty
                        ? abhaNumber
                        : recordIndex == null
                            ? 'ABHA profile'
                            : 'ABHA profile $recordIndex',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: recordIndex == null
                      ? const Text('Missing ABHA record index')
                      : details.isEmpty
                          ? null
                          : Text(details),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedProfileIndex == null || _isSendingOtp
                    ? null
                    : _sendOtpForSelectedProfile,
                icon: _isSendingOtp
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.sms_outlined),
                label: Text(
                  _isSendingOtp
                      ? 'Sending OTP...'
                      : 'Send OTP to selected ABHA',
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
      ],
    );
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
                        enabled: !_isSearching && !_isSendingOtp,
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
                        onChanged: (_) {
                          if (_controller.mobileSearchProfiles.isNotEmpty ||
                              _selectedProfileIndex != null) {
                            _controller.clearMobileSearchResults();
                            setState(() => _selectedProfileIndex = null);
                          }
                        },
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
                  _buildSearchResults(theme),
                  const SizedBox(height: 24),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSearching || _isSendingOtp
                              ? null
                              : _searchProfiles,
                          icon: _isSearching
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
                            _isSearching ? 'Searching...' : 'Search ABHA',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
