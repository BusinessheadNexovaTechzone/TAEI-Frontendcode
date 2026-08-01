import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/views/abha_address_creation.dart';
import 'package:taei_gov/src/nurse_triage/views/aadhaar_authentication.dart';
import 'package:taei_gov/src/nurse_triage/views/consent_collection.dart';

class CreateAbhaScreen extends StatefulWidget {
  const CreateAbhaScreen({super.key});

  @override
  State<CreateAbhaScreen> createState() => _CreateAbhaScreenState();
}

class _CreateAbhaScreenState extends State<CreateAbhaScreen> {
  final NurseTriageController controller =
      Get.isRegistered<NurseTriageController>()
          ? Get.find<NurseTriageController>()
          : Get.put(NurseTriageController());
  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _healthIdFormKey = GlobalKey<FormState>();

  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _healthIdController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final List<TextEditingController> _aadhaarPartControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _aadhaarFocusNodes =
      List.generate(3, (_) => FocusNode());

  static const Color _primaryColor = Colors.red;
  static const Color _secondaryColor = Colors.redAccent;
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _primaryTextColor = Color(0xFF212121);
  static const Color _secondaryTextColor = Color(0xFF616161);
  static const Color _borderColor = Color(0xFFE0E0E0);
  static const Color _successColor = Color(0xFF2E7D32);

  final List<TextEditingController> _otpDigitControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  int _currentStep = 0;
  bool _consentAccepted = false;
  bool _aadhaarVisible = false;
  String? _selectedAuthMethod;
  String _captchaAnswer = '';
  String _captchaQuestion = '';
  bool _isSubmitting = false;
  bool _otpSent = false;
  int _resendSeconds = 60;
  Timer? _resendTimer;
  bool _showSuccess = false;
  Map<String, dynamic>? _verificationResponse;

  String? _abhaNumber;
  String? _abhaAddress;
  String? _healthId;
  int? _abhaProfileId;

  @override
  void initState() {
    super.initState();
    _aadhaarController.text =
        controller.createTriageModel.value?.triage?.aadhaar ?? '';
    _syncAadhaarPartsFromController();
    _mobileController.text =
        controller.createTriageModel.value?.triage?.patientMobileNumber ?? '';
    _fullNameController.text =
        controller.createTriageModel.value?.triage?.nameOfPatient ?? '';
    _generateCaptcha();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _aadhaarController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _captchaController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _healthIdController.dispose();
    for (final controller in _otpDigitControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    for (final focusNode in _aadhaarFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _generateCaptcha() {
    final first = 2 + DateTime.now().millisecond % 5;
    final second = 1 + DateTime.now().second % 6;
    _captchaQuestion = '$first + $second';
    _captchaAnswer = '${first + second}';
    _captchaController.clear();
  }

  void _refreshCaptcha() {
    _generateCaptcha();
    if (mounted) setState(() {});
  }

  void _syncAadhaarPartsFromController() {
    final digits = _aadhaarController.text.replaceAll(RegExp(r'\D'), '');
    for (var i = 0; i < _aadhaarPartControllers.length; i++) {
      final start = i * 4;
      final end = start + 4;
      final chunk = digits.length > start
          ? digits.substring(start, digits.length < end ? digits.length : end)
          : '';
      if (_aadhaarPartControllers[i].text != chunk) {
        _aadhaarPartControllers[i].text = chunk;
      }
    }
  }

  String _getMergedAadhaar() =>
      _aadhaarPartControllers.map((c) => c.text).join();

  void _handleAadhaarPartChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final safeValue = digits.length > 4 ? digits.substring(0, 4) : digits;
    if (_aadhaarPartControllers[index].text != safeValue) {
      _aadhaarPartControllers[index].value = TextEditingValue(
        text: safeValue,
        selection: TextSelection.collapsed(offset: safeValue.length),
      );
    }
    _aadhaarController.text = _getMergedAadhaar();

    if (safeValue.length == 4 && index < 2) {
      FocusScope.of(context).requestFocus(_aadhaarFocusNodes[index + 1]);
    } else if (safeValue.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_aadhaarFocusNodes[index - 1]);
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendSeconds = 0);
      } else {
        if (mounted) setState(() => _resendSeconds--);
      }
    });
  }

  bool _isValidAadhaar(String? value) {
    return RegExp(r'^\d{12}$').hasMatch(value ?? '');
  }

  bool _isValidMobile(String? value) {
    return RegExp(r'^\d{10}$').hasMatch(value ?? '');
  }

  bool _isValidHealthId(String? value) {
    final v = value?.trim() ?? '';
    if (v.length < 8 || v.length > 18) return false;
    return RegExp(r'^[A-Za-z][A-Za-z0-9._-]*$').hasMatch(v);
  }

  String? _validateHealthId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a Health ID';
    }
    if (!_isValidHealthId(value)) {
      return 'Use 8-18 chars, start with a letter, and only use letters, numbers, ., -, _';
    }
    return null;
  }

  Future<void> _sendOtp() async {
    if (!_consentAccepted) {
      Get.snackbar(
          'Consent required', 'Please accept the consent to continue.');
      return;
    }

    if (!_isValidAadhaar(_aadhaarController.text)) {
      Get.snackbar(
          'Invalid Aadhaar', 'Please enter a valid 12 digit Aadhaar number.');
      return;
    }

    final aadhaar = _aadhaarController.text.replaceAll(RegExp(r'\D'), '');

    setState(() => _isSubmitting = true);
    try {
      controller.createTriageModel.value!.triage!.aadhaar = aadhaar;

      final otpSent = await controller.sendAadhaarOtp();
      if (!otpSent) {
        Get.snackbar('OTP failed', 'Unable to send Aadhaar OTP right now.');
        return;
      }

      setState(() {
        _otpSent = true;
        _isSubmitting = false;
      });
      _startResendTimer();
      _goToStep(1);
    } catch (e) {
      log('ABHA send otp error: $e');
      Get.snackbar('OTP failed', e.toString());
    } finally {
      if (mounted && !_otpSent) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleConsentNext() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consentAccepted) {
      Get.snackbar(
          'Consent required', 'Please accept the consent to continue.');
      return;
    }

    if (!_isValidAadhaar(_aadhaarController.text)) {
      Get.snackbar(
          'Invalid Aadhaar', 'Please enter a valid 12 digit Aadhaar number.');
      return;
    }

    final aadhaar = _aadhaarController.text.replaceAll(RegExp(r'\D'), '');
    final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');

    controller.createTriageModel.value!.triage!.aadhaar = aadhaar;
    controller.createTriageModel.value!.triage!.patientMobileNumber = mobile;

    switch (_selectedAuthMethod) {
      case 'Aadhaar OTP':
        await _sendOtp();
        break;
      case 'Face Authentication':
        await _authenticateWithFace();
        break;
      case 'Fingerprint Authentication':
        await _authenticateWithFingerprint();
        break;
      default:
        Get.snackbar('Authentication required', 'Please select a method.');
    }
  }

  Future<void> _authenticateWithFace() async {
    final aadhaar = controller.createTriageModel.value?.triage?.aadhaar ?? '';
    final mobile =
        controller.createTriageModel.value?.triage?.patientMobileNumber ?? '';

    setState(() => _isSubmitting = true);
    try {
      await controller.startFaceAuth();
      if (controller.faceTxnId.value.isEmpty) {
        Get.snackbar('Face auth failed', 'Face authentication did not start.');
        return;
      }

      await controller.pollFaceStatus(
        controller.faceTxnId.value,
        aadhaar,
        mobile,
        showDialog: false,
      );

      _handleAuthResult(controller.aadhaarProfileData.value);
    } catch (e) {
      log('ABHA face auth error: $e');
      Get.snackbar('Face auth failed', e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _authenticateWithFingerprint() async {
    setState(() => _isSubmitting = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      controller.aadhaarVerified.value = true;
      _handleAuthResult(null);
    } catch (e) {
      log('ABHA fingerprint auth error: $e');
      Get.snackbar('Fingerprint auth failed', e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleAuthResult(Map<String, dynamic>? response) {
    final profile = response?['result']?['ABHAProfile'];

    if (profile != null) {
      final profileName = <String>[
        profile['firstName']?.toString() ?? '',
        profile['middleName']?.toString() ?? '',
        profile['lastName']?.toString() ?? '',
      ].where((part) => part.isNotEmpty).join(' ');

      _abhaNumber = profile['ABHANumber']?.toString() ??
          profile['abhaNumber']?.toString();
      _abhaAddress = profile['address']?.toString();
      _healthId = profile['healthId']?.toString() ?? profile['hid']?.toString();
      _abhaProfileId = int.tryParse(
        profile['id']?.toString() ??
            profile['profileId']?.toString() ??
            profile['abhaProfileId']?.toString() ??
            profile['ABHAProfileId']?.toString() ??
            '',
      );

      if (profileName.isNotEmpty) {
        _fullNameController.text = profileName;
      }

      final mobile =
          profile['mobile']?.toString() ?? profile['mobileNumber']?.toString();
      if (mobile != null && mobile.isNotEmpty) {
        _mobileController.text = mobile;
      }

      setState(() {
        _showSuccess = true;
      });
      return;
    }

    setState(() {
      _showSuccess = false;
    });
    _goToStep(2);
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) return;

    await _sendOtp();
    if (mounted) {
      Fluttertoast.showToast(msg: 'OTP resent successfully');
    }
  }

  Future<void> _verifyOtpAndContinue() async {
    if (_otpDigitControllers.where((c) => c.text.isNotEmpty).length != 6) {
      Get.snackbar('OTP required', 'Please enter the complete 6-digit OTP.');
      return;
    }

    final otp = _otpDigitControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      Get.snackbar('OTP required', 'Please enter the complete 6-digit OTP.');
      return;
    }

    final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');

    if (!_isValidMobile(mobile)) {
      Get.snackbar(
          'Invalid mobile', 'Please enter a valid 10 digit mobile number.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      controller.createTriageModel.value!.triage!.patientMobileNumber = mobile;
      controller.aadhaarOtp.value = otp;

      final success = await controller.verifyAadhaarOtp(showDialog: false);
      if (!success) {
        return;
      }

      final response = controller.aadhaarProfileData.value;
      _verificationResponse = response;
      final resultMessage =
          (response?['result']?['message'] ?? response?['message'])
              ?.toString()
              .trim();

      if (resultMessage == 'This account already exist') {
        controller.showLastAadhaarProfileCard();
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mounted && (Get.isDialogOpen ?? false);
        });
        if (mounted) {
          final result = <String, dynamic>{
            'abhaNumber': _abhaNumber ?? '',
            'abhaAddress': _abhaAddress ?? '',
            'healthId': _healthId ?? '',
            'fullName': _fullNameController.text.trim(),
            'email': _emailController.text.trim(),
            'mobile': _mobileController.text.trim(),
          };
          Get.back(result: result);
        }
        return;
      }

      if (resultMessage == 'Account created successfully') {
        _goToStep(2);
        return;
      }

      _handleAuthResult(response);
      controller.createTriageModel.refresh();
    } catch (e) {
      log('ABHA verify otp error: $e');
      Get.snackbar('Verification failed', e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  Future<void> _finalizeCreation() async {
    if (!_healthIdFormKey.currentState!.validate()) return;

    final healthId = _healthIdController.text.trim();
    setState(() {
      _healthId = healthId;
      _showSuccess = true;
    });
  }

  void _returnToForm() {
    final result = <String, dynamic>{
      'abhaNumber': _abhaNumber ?? '',
      'abhaAddress': _abhaAddress ?? '',
      'healthId': _healthId ?? '',
      'fullName': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _mobileController.text.trim(),
    };
    Get.back(result: result);
  }

  InputDecoration _buildInputDecoration({
    String? labelText,
    String? hintText,
    String? counterText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      counterText: counterText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade600),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = _primaryColor;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Create ABHA Card'),
        foregroundColor: Colors.white,
        backgroundColor: primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: _showSuccess
                    ? _buildSuccessView(theme, primary)
                    : _buildStepView(theme, primary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepView(ThemeData theme, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressHeader(theme, primary),
        const SizedBox(height: 20),
        if (_currentStep == 0) _buildConsentStep(theme, primary),
        if (_currentStep == 1) _buildOtpStep(theme, primary),
        if (_currentStep == 2) _buildHealthIdStep(theme, primary),
      ],
    );
  }

  Widget _buildProgressHeader(ThemeData theme, Color primary) {
    final steps = ['Consent', 'OTP', 'Health ID'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your ABHA profile securely',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: _primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Follow the guided steps below to create a new ABHA card.',
          style:
              theme.textTheme.bodyMedium?.copyWith(color: _secondaryTextColor),
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(steps.length, (index) {
            final isActive = _currentStep == index;
            final isCompleted = _currentStep > index;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                decoration: BoxDecoration(
                  color: isCompleted || isActive ? primary : _borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          'Step ${_currentStep + 1} of 3 • ${steps[_currentStep]}',
          style:
              theme.textTheme.bodySmall?.copyWith(color: _secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildConsentStep(ThemeData theme, Color primary) {
    final aadhaarValue = _aadhaarController.text.replaceAll(RegExp(r'\D'), '');
    final canProceed = aadhaarValue.length == 12 &&
        _consentAccepted &&
        _selectedAuthMethod != null &&
        (_captchaController.text.trim() == _captchaAnswer);

    return ConsentCollectionStep(
      formKey: _formKey,
      theme: theme,
      primaryColor: primary,
      borderColor: _borderColor,
      secondaryColor: _secondaryColor,
      primaryTextColor: _primaryTextColor,
      secondaryTextColor: _secondaryTextColor,
      surfaceColor: _surfaceColor,
      aadhaarPartControllers: _aadhaarPartControllers,
      aadhaarFocusNodes: _aadhaarFocusNodes,
      aadhaarVisible: _aadhaarVisible,
      onToggleAadhaarVisibility: () =>
          setState(() => _aadhaarVisible = !_aadhaarVisible),
      onAadhaarPartChanged: _handleAadhaarPartChanged,
      consentAccepted: _consentAccepted,
      onConsentChanged: (value) {
        setState(() => _consentAccepted = value ?? false);
      },
      selectedAuthMethod: _selectedAuthMethod,
      onAuthMethodChanged: (value) =>
          setState(() => _selectedAuthMethod = value),
      captchaQuestion: _captchaQuestion,
      captchaAnswer: _captchaAnswer,
      captchaController: _captchaController,
      onRefreshCaptcha: _refreshCaptcha,
      isSubmitting: _isSubmitting,
      canProceed: canProceed,
      onCancel: () => Navigator.of(context).maybePop(),
      onNext: _handleConsentNext,
      isValidAadhaar: _isValidAadhaar,
      buildInputDecoration: _buildInputDecoration,
      otpHintText: _buildConsentOtpHint(),
    );
  }

  String _formatResendTimer() {
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _buildMaskedMobileNumber() {
    final storedValue = controller
            .createTriageModel.value?.triage?.patientMobileNumber
            ?.replaceAll(RegExp(r'\D'), '') ??
        '';
    final currentValue = _mobileController.text.replaceAll(RegExp(r'\D'), '');
    final digits = storedValue.isNotEmpty ? storedValue : currentValue;
    if (digits.length <= 4) return digits;
    return '******${digits.substring(digits.length - 4)}';
  }

  String? _buildConsentOtpHint() {
    final value = controller
            .createTriageModel.value?.triage?.patientMobileNumber
            ?.replaceAll(RegExp(r'\D'), '') ??
        _mobileController.text.replaceAll(RegExp(r'\D'), '');
    if (value.length < 4) return null;
    return 'OTP will be sent to the registered mobile number ending with ${value.substring(value.length - 4)}.';
  }

  void _handleOtpDigitChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 1) {
      final pasted = digits.substring(0, digits.length.clamp(0, 6));
      for (var i = 0; i < 6; i++) {
        _otpDigitControllers[i].text = i < pasted.length ? pasted[i] : '';
      }
      if (pasted.length >= 6) {
        FocusScope.of(context).unfocus();
        return;
      }
    } else {
      _otpDigitControllers[index].text = digits;
    }

    if (digits.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
      }
    } else if (index < 5) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    }
  }

  Widget _buildOtpStep(ThemeData theme, Color primary) {
    final otpValue = _otpDigitControllers.map((c) => c.text).join();
    final otpComplete = otpValue.length == 6;
    final mobileComplete = _isValidMobile(_mobileController.text);

    return AadhaarAuthenticationStep(
      formKey: _otpFormKey,
      theme: theme,
      primaryColor: primary,
      borderColor: _borderColor,
      secondaryColor: _secondaryColor,
      primaryTextColor: _primaryTextColor,
      secondaryTextColor: _secondaryTextColor,
      surfaceColor: _surfaceColor,
      otpDigitControllers: _otpDigitControllers,
      otpFocusNodes: _otpFocusNodes,
      onOtpDigitChanged: _handleOtpDigitChanged,
      mobileController: _mobileController,
      resendSeconds: _resendSeconds,
      onResendOtp: _resendOtp,
      onVerify: () async {
        if (!_otpFormKey.currentState!.validate()) return;
        await _verifyOtpAndContinue();
      },
      isSubmitting: _isSubmitting,
      otpComplete: otpComplete,
      mobileComplete: mobileComplete,
      formatResendTimer: _formatResendTimer,
      buildMaskedMobileNumber: _buildMaskedMobileNumber,
      isValidMobile: _isValidMobile,
    );
  }

  Widget _buildHealthIdStep(ThemeData theme, Color primary) {
    return AbhaAddressCreationStep(
      formKey: _healthIdFormKey,
      theme: theme,
      primaryColor: primary,
      primaryTextColor: _primaryTextColor,
      secondaryTextColor: _secondaryTextColor,
      healthIdController: _healthIdController,
      onCreate: _finalizeCreation,
      isSubmitting: _isSubmitting,
      buildInputDecoration: _buildInputDecoration,
      validateHealthId: _validateHealthId,
      verificationResponse: _verificationResponse,
    );
  }

  Widget _buildSuccessView(ThemeData theme, Color primary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color(0xFFEAF6EB),
                    borderRadius: BorderRadius.circular(999)),
                child: const Icon(Icons.check_circle,
                    color: _successColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('ABHA Card Created Successfully',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _primaryTextColor,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('ABHA Number', _abhaNumber ?? 'Not available'),
          const SizedBox(height: 12),
          _buildInfoRow(
              'ABHA Address',
              _abhaAddress?.isNotEmpty == true
                  ? _abhaAddress!
                  : 'Not available'),
          const SizedBox(height: 12),
          _buildInfoRow('Health ID', _healthId ?? 'Not available'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _abhaProfileId == null
                      ? null
                      : () => controller.downloadAbhaCard(),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download ABHA Card'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _returnToForm,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Return to Form'),
                  style: ElevatedButton.styleFrom(backgroundColor: primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFFFFF7F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: Text(value,
                  style: const TextStyle(color: _primaryTextColor))),
        ],
      ),
    );
  }
}
