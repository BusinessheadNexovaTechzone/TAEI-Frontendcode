import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/utils/create_abha_validation.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_otp_utils.dart';
import 'package:taei_gov/src/nurse_triage/views/abha_address_creation.dart';
import 'package:taei_gov/src/nurse_triage/views/aadhaar_authentication.dart';
import 'package:taei_gov/src/nurse_triage/views/consent_collection.dart';
import 'package:taei_gov/src/nurse_triage/views/demo_authentication.dart';
import 'package:taei_gov/src/nurse_triage/views/face_authentication.dart';
import 'package:taei_gov/src/nurse_triage/views/fingerprint_authentication.dart';
import 'package:taei_gov/src/nurse_triage/views/update_mobile_otp_dialog.dart';
import 'package:taei_gov/src/nurse_triage/services/triage_service.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_debug_logger.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class CreateAbhaScreen extends StatefulWidget {
  const CreateAbhaScreen({super.key});

  @override
  State<CreateAbhaScreen> createState() => _CreateAbhaScreenState();
}

enum _AbhaWorkflowState {
  idle,
  aadhaarOtpPending,
  aadhaarVerifying,
  aadhaarVerified,
  checkingMobile,
  mobileMatched,
  mobileUpdateRequired,
  mobileUpdateOtpSending,
  mobileUpdateOtpPending,
  mobileUpdateVerifying,
  mobileUpdated,
  abhaAddressCreating,
  completed,
  error,
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
  final List<String> _otpDigitCache = List.generate(6, (_) => '');

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
  bool _isProcessingMobileUpdate = false;
  bool _showMobileUpdateOtp = false;
  bool _isMobileOtpDialogVisible = false;
  String _currentOtpMode = 'aadhaar';
  Map<String, dynamic>? _verificationResponse;
  _AbhaWorkflowState _workflowState = _AbhaWorkflowState.idle;
  String? _abhaFlowId;
  bool _consentFieldTouched = false;
  bool _authMethodFieldTouched = false;
  bool _captchaFieldTouched = false;
  bool _aadhaarFieldTouched = false;
  bool _otpFieldTouched = false;
  bool _mobileFieldTouched = false;
  int _resendAttempts = 0;
  static const int _maxResendAttempts = 3;

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
    _abhaFlowId = _generateFlowId();
    AbhaDebugLogger.ui('Create ABHA screen loaded', flowId: _abhaFlowId);
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
    setState(() {
      _resendSeconds = 60;
      _resendAttempts = 0;
    });
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

  String _maskValue(String? value, {int visibleChars = 4}) {
    if (value == null || value.isEmpty) return 'n/a';
    final digits = value.toString();
    if (digits.length <= visibleChars) return '*${digits.substring(0, digits.length)}';
    final suffix = digits.substring(digits.length - visibleChars);
    return '${'*' * (digits.length - visibleChars)}$suffix';
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

  Future<bool> _sendOtp() async {
    if (!_consentAccepted) {
      await CommonErrorDialog.show(
        context,
        message: 'Please accept the consent to continue.',
      );
      return false;
    }

    if (!_isValidAadhaar(_aadhaarController.text)) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter a valid 12 digit Aadhaar number.',
      );
      return false;
    }

    final aadhaar = _aadhaarController.text.replaceAll(RegExp(r'\D'), '');

    final wasPreviouslyOtpSent = _otpSent;
    _clearOtpFields();
    AbhaDebugLogger.workflow('AADHAAR VERIFICATION STARTED', flowId: _abhaFlowId);
    AbhaDebugLogger.workflow('Aadhaar OTP request started', flowId: _abhaFlowId);
    AbhaDebugLogger.workflow('Masked Aadhaar value: ${AbhaDebugLogger.maskMobile(aadhaar)}', flowId: _abhaFlowId);

    setState(() => _isSubmitting = true);
    try {
      controller.createTriageModel.value!.triage!.aadhaar = aadhaar;
      controller.currentProfileId.value = '';
      controller.mobileUpdateTxnId.value = '';

      AbhaDebugLogger.ui('Verify Aadhaar OTP button pressed', flowId: _abhaFlowId);
      AbhaDebugLogger.controller('sendAadhaarOtp() called', flowId: _abhaFlowId);
      final otpSent = await controller.sendAadhaarOtp(flowId: _abhaFlowId);
      if (!otpSent) {
        AbhaDebugLogger.error('sendAadhaarOtp() failed', flowId: _abhaFlowId);
        return false;
      }

      setState(() {
        _otpSent = true;
        _isSubmitting = false;
        if (!wasPreviouslyOtpSent) {
          _resendAttempts = 0;
        }
      });
      log('[OTP RESEND] Initial resend attempt count: $_resendAttempts');
      _startResendTimer();
      _goToStep(1);
      return true;
    } catch (e) {
      log('ABHA send otp error: $e');
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      await CommonErrorDialog.show(
        context,
        message: friendlyMessage.isNotEmpty
            ? friendlyMessage
            : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
      );
    } finally {
      if (mounted && !_otpSent) setState(() => _isSubmitting = false);
    }
    return false;
  }

  String? _validateFaceAuthInputs() {
    final aadhaarValidation = CreateAbhaValidation.validateAadhaar(
      _aadhaarController.text,
      shouldShowError: true,
    );
    if (aadhaarValidation != null) return aadhaarValidation;

    final consentValidation = CreateAbhaValidation.validateConsent(
      _consentAccepted,
      shouldShowError: true,
    );
    if (consentValidation != null) return consentValidation;

    final captchaValidation = CreateAbhaValidation.validateCaptcha(
      _captchaController.text,
      shouldShowError: true,
      expectedAnswer: _captchaAnswer,
    );
    if (captchaValidation != null) return captchaValidation;

    return null;
  }

  Future<void> _handleConsentNext() async {
    setState(() {
      _consentFieldTouched = true;
      _aadhaarFieldTouched = true;
      _authMethodFieldTouched = true;
      _captchaFieldTouched = true;
    });

    if (!_formKey.currentState!.validate()) return;

    final validationMessage = _validateFaceAuthInputs();
    if (validationMessage != null) {
      await CommonErrorDialog.show(
        context,
        message: validationMessage,
      );
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
      case 'Demo Authentication':
        await _authenticateWithDemo();
        break;
      default:
        await CommonErrorDialog.show(
          context,
          message: 'Please select a method.',
        );
    }
  }

  Future<void> _authenticateWithDemo() async {
    final aadhaar = (controller.createTriageModel.value?.triage?.aadhaar ?? '')
        .replaceAll(RegExp(r'\D'), '');
    if (aadhaar.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Aadhaar information is unavailable. Please restart the ABHA enrollment process.',
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const DemoAuthenticationScreen(),
      ),
    );
  }

  Future<void> _authenticateWithFace() async {
    await _authenticateWithBiometric('Face Authentication');
  }

  Future<void> _authenticateWithFingerprint() async {
    await _authenticateWithBiometric('Fingerprint Authentication');
  }

  Future<void> _authenticateWithBiometric(String authMethod) async {
    final aadhaar = (controller.createTriageModel.value?.triage?.aadhaar ?? '')
        .replaceAll(RegExp(r'\D'), '');

    if (aadhaar.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Aadhaar number is required for $authMethod.',
      );
      return;
    }

    if (!mounted) return;

    if (authMethod == 'Fingerprint Authentication') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FingerprintAuthenticationScreen(
            aadhaar: aadhaar,
            mobile: _mobileController.text,
          ),
        ),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FaceAuthenticationScreen(
          aadhaar: aadhaar,
          mobile: _mobileController.text,
        ),
      ),
    );
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) return;

    if (_currentOtpMode == 'mobileUpdate') {
      final profileIdText = controller.currentProfileId.value;
      final profileId = int.tryParse(profileIdText);
      final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');
      if (profileId != null && profileId > 0) {
        await _requestMobileUpdateOtp(profileId, mobile);
      }
      return;
    }

    if (_resendAttempts >= _maxResendAttempts) {
      log('[OTP RESEND] Resend OTP limit reached - $_resendAttempts/$_maxResendAttempts');
      await CommonErrorDialog.show(
        context,
        message:
            'You have reached the maximum of $_maxResendAttempts OTP resend attempts for this transaction. Please try again after a new OTP request.',
      );
      return;
    }

    final otpSent = await _sendOtp();
    if (otpSent) {
      setState(() => _resendAttempts += 1);
      log('[OTP RESEND] Resend OTP successful - attempt: $_resendAttempts/$_maxResendAttempts');
    }
  }

  Future<void> _verifyOtpAndContinue() async {
    AbhaDebugLogger.workflow('OTP VERIFICATION FLOW STARTED', flowId: _abhaFlowId);
    setState(() {
      _otpFieldTouched = true;
      _mobileFieldTouched = true;
    });

    if (_otpDigitControllers.where((c) => c.text.isNotEmpty).length != 6) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter the complete 6-digit OTP.',
      );
      return;
    }

    final otp = _otpDigitControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter the complete 6-digit OTP.',
      );
      return;
    }

    final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');

    if (!_isValidMobile(mobile)) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter a valid 10-digit mobile number.',
      );
      return;
    }

    if (_currentOtpMode == 'mobileUpdate') {
      AbhaDebugLogger.workflow('MOBILE OTP VERIFICATION STARTED', flowId: _abhaFlowId);
      AbhaDebugLogger.workflow('Calling updatemobile/verify-otp', flowId: _abhaFlowId);
      await _verifyMobileUpdateOtp(otp);
      return;
    }

    AbhaDebugLogger.workflow('AADHAAR OTP VERIFICATION STARTED', flowId: _abhaFlowId);
    AbhaDebugLogger.ui('Verify Aadhaar OTP button pressed', flowId: _abhaFlowId);
    AbhaDebugLogger.controller('verifyAadhaarOtp() started', flowId: _abhaFlowId);
    setState(() {
      _isSubmitting = true;
      _workflowState = _AbhaWorkflowState.aadhaarVerifying;
    });
    _logWorkflowState();

    try {
      final response = await TriageService.verifyAadhaarOtp(
        txnId: controller.aadhaarTxnId.value,
        otp: otp,
        mobile: mobile,
        flowId: _abhaFlowId,
      );

      if (response == null) {
        await CommonErrorDialog.show(
          context,
          message: 'We couldn\'t read the verification response. Please try again.',
        );
        setState(() {
          _workflowState = _AbhaWorkflowState.error;
        });
        return;
      }

      final message = (response['result'] != null && response['result'] is Map)
          ? (response['result']['message']?.toString() ?? '')
          : (response['message']?.toString() ?? '');
      final messageLower = message.trim().toLowerCase();

      final rawIsNew = response['result']?['isNew'];
      final isNew = rawIsNew is bool
          ? rawIsNew
          : rawIsNew?.toString().trim().toLowerCase() == 'true';

      final profileMobileRaw = _extractAbhaProfileMobile(response);
      final abhaMobile = profileMobileRaw?.trim();
      final hasAbhaMobile = abhaMobile != null && abhaMobile.isNotEmpty;
      final maskedProfileMobile = hasAbhaMobile ? _maskValue(abhaMobile) : 'NULL';

      AbhaDebugLogger.section('API RESPONSE', flowId: _abhaFlowId);
      AbhaDebugLogger.response(
        api: 'aadhaar/verify-otp',
        statusCode: 200,
        data: {
          'message': message,
          'isNew': isNew,
          'profileId': response['profileId'] ?? controller.currentProfileId.value,
          'profileMobile': maskedProfileMobile,
          'mobileVerified': response['result']?['ABHAProfile']?['mobileVerified'] ?? 'n/a',
          'ABHANumber': '[REDACTED]',
          'abhaStatus': response['result']?['ABHAProfile']?['abhaStatus'] ?? 'n/a',
        },
        flowId: _abhaFlowId,
      );

      if (messageLower == 'this account already exist' || isNew == false) {
        AbhaDebugLogger.workflow('EXISTING ACCOUNT DETECTED', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Message: $message', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('No mobile comparison required', flowId: _abhaFlowId);
        AbhaDebugLogger.skip('updatemobile/send-otp NOT CALLED', flowId: _abhaFlowId);
        AbhaDebugLogger.skip('updatemobile/verify-otp NOT CALLED', flowId: _abhaFlowId);
        AbhaDebugLogger.skip('abha_address_creation NOT CALLED', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Showing existing ABHA profile', flowId: _abhaFlowId);

        try {
          final result = await controller.showAadhaarSuccessDialog(
            response,
            returnToCaller: true,
          );
          if (mounted && result != null) {
            Navigator.of(context).pop(result);
          }
        } catch (e, stackTrace) {
          AbhaDebugLogger.error('Failed to show existing ABHA profile: $e', flowId: _abhaFlowId);
          AbhaDebugLogger.error('StackTrace: $stackTrace', flowId: _abhaFlowId);
          controller.showLastAadhaarProfileCard();
        }
        AbhaDebugLogger.workflow('CREATE ABHA FLOW TERMINATED', flowId: _abhaFlowId);
        AbhaDebugLogger.navigation('Existing profile displayed', flowId: _abhaFlowId);
        return;
      }

      if (messageLower == 'account created successfully' || isNew == true) {
        final profileIdText = controller.currentProfileId.value;
        final profileIdFromController = int.tryParse(profileIdText);
        final responseProfileId = extractAbhaProfileId(response);
        final profileId = profileIdFromController != null && profileIdFromController > 0
            ? profileIdFromController
            : responseProfileId;

        if (profileId == null || profileId <= 0) {
          await CommonErrorDialog.show(
            context,
            message: 'We couldn\'t continue with the mobile verification step. Please try again.',
          );
          setState(() {
            _workflowState = _AbhaWorkflowState.error;
          });
          return;
        }

        AbhaDebugLogger.workflow('NEW ACCOUNT CREATED', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Message: Account created successfully', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('isNew: true', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('User entered mobile: ${AbhaDebugLogger.maskMobile(mobile)}', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('ABHA profile mobile: ${hasAbhaMobile ? AbhaDebugLogger.maskMobile(abhaMobile) : 'NULL'}', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Comparing mobile numbers...', flowId: _abhaFlowId);

        if (!hasAbhaMobile) {
          AbhaDebugLogger.workflow('ABHAProfile.mobile is NULL/EMPTY', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('MOBILE UPDATE REQUIRED', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('Treating NULL mobile as MOBILE UPDATE REQUIRED', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('New account mobile is missing', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('Using user-entered mobile for update', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('User mobile: ${AbhaDebugLogger.maskMobile(mobile)}', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('Calling updatemobile/send-otp', flowId: _abhaFlowId);

          final startedMobileUpdate = await _requestMobileUpdateOtp(profileId, mobile);
          if (!startedMobileUpdate) {
            setState(() {
              _workflowState = _AbhaWorkflowState.error;
            });
            return;
          }

          setState(() {
            _currentOtpMode = 'mobileUpdate';
            _showMobileUpdateOtp = true;
            _otpFieldTouched = false;
            _workflowState = _AbhaWorkflowState.mobileUpdateOtpPending;
          });
          _clearOtpFields();
          return;
        }

        final normalizedEnteredMobile = _normalizeMobile(mobile);
        final normalizedProfileMobile = _normalizeMobile(abhaMobile);

        if (normalizedEnteredMobile == normalizedProfileMobile) {
          setState(() {
            _workflowState = _AbhaWorkflowState.mobileMatched;
          });
          AbhaDebugLogger.workflow('MOBILE MATCH', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('User mobile matches ABHA profile mobile', flowId: _abhaFlowId);
          AbhaDebugLogger.skip('updatemobile/send-otp NOT CALLED', flowId: _abhaFlowId);
          AbhaDebugLogger.skip('updatemobile/verify-otp NOT CALLED', flowId: _abhaFlowId);
          AbhaDebugLogger.workflow('Proceeding to ABHA address creation', flowId: _abhaFlowId);
          AbhaDebugLogger.navigation('Opening abha_address_creation.dart', flowId: _abhaFlowId);
          _goToStep(2);
          return;
        }

        setState(() {
          _workflowState = _AbhaWorkflowState.mobileUpdateRequired;
        });
        AbhaDebugLogger.workflow('MOBILE MISMATCH', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Mobile update workflow is required', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Calling updatemobile/send-otp', flowId: _abhaFlowId);

        final startedMobileUpdate = await _requestMobileUpdateOtp(profileId, mobile);
        if (!startedMobileUpdate) {
          setState(() {
            _workflowState = _AbhaWorkflowState.error;
          });
          return;
        }

        setState(() {
          _currentOtpMode = 'mobileUpdate';
          _showMobileUpdateOtp = true;
          _otpFieldTouched = false;
          _workflowState = _AbhaWorkflowState.mobileUpdateOtpPending;
        });
        _clearOtpFields();
        return;
      }

      AbhaDebugLogger.error('Unrecognized response message: $message', flowId: _abhaFlowId);
      await CommonErrorDialog.show(
        context,
        message: 'Unexpected response from server. Please contact support.',
      );
      setState(() {
        _workflowState = _AbhaWorkflowState.error;
      });
      return;
    } catch (e) {
      AbhaDebugLogger.error('ABHA verify otp error: $e', flowId: _abhaFlowId);
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      await CommonErrorDialog.show(
        context,
        message: friendlyMessage.isNotEmpty
            ? friendlyMessage
            : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<bool> _requestMobileUpdateOtp(int profileId, String mobile) async {
    if (_isProcessingMobileUpdate) return false;
    setState(() {
      _isProcessingMobileUpdate = true;
      _workflowState = _AbhaWorkflowState.mobileUpdateOtpSending;
    });
    try {
      log('========== MOBILE UPDATE OTP REQUEST ==========');
      log('[MOBILE UPDATE] Update mobile OTP flow started');
      log('[MOBILE UPDATE] profileId available: ${profileId > 0}');
      log('[MOBILE UPDATE] mobile available: ${mobile.isNotEmpty}');
      log('[MOBILE UPDATE] Calling updatemobile/send-otp');
      // Ensure controller knows current profileId so verify can use it
      controller.currentProfileId.value = profileId.toString();
      debugPrint('[ABHA][TRACE][FLOW:$_abhaFlowId] controller.currentProfileId set: ${controller.currentProfileId.value}');

      final sent = await controller.sendMobileUpdateOtp(
        profileId: profileId,
        mobile: mobile,
        flowId: _abhaFlowId,
      );
      if (!sent) {
        AbhaDebugLogger.error('updatemobile/send-otp failed', flowId: _abhaFlowId);
        setState(() {
          _showMobileUpdateOtp = false;
          _workflowState = _AbhaWorkflowState.error;
        });
        return false;
      }

      AbhaDebugLogger.response(
        api: 'updatemobile/send-otp',
        statusCode: 200,
        data: {'message': 'Mobile OTP sent successfully'},
        flowId: _abhaFlowId,
      );
      AbhaDebugLogger.workflow('Mobile OTP sent successfully', flowId: _abhaFlowId);
      AbhaDebugLogger.workflow('Waiting for user to enter mobile OTP', flowId: _abhaFlowId);
      setState(() {
        _showMobileUpdateOtp = true;
        _currentOtpMode = 'mobileUpdate';
        _workflowState = _AbhaWorkflowState.mobileUpdateOtpPending;
      });
      _clearOtpFields();
      _startResendTimer();
      if (mounted) {
        _showMobileOtpDialog();
      }
      return true;
    } finally {
      if (mounted) setState(() => _isProcessingMobileUpdate = false);
    }
  }

  Future<bool> _verifyMobileUpdateOtp(String otp) async {
    if (_isProcessingMobileUpdate) {
      debugPrint('[ABHA][UI][FLOW:${_abhaFlowId ?? 'unknown'}] [OTP] Duplicate verification ignored');
      return false;
    }

    setState(() {
      _isProcessingMobileUpdate = true;
      _workflowState = _AbhaWorkflowState.mobileUpdateVerifying;
    });
    try {
      log('========== MOBILE OTP VERIFICATION ==========');
      log('[MOBILE OTP] Verifying OTP');
      final profileIdText = controller.currentProfileId.value;
      final profileId = int.tryParse(profileIdText);
      if (profileId == null || profileId <= 0) {
        await CommonErrorDialog.show(
          context,
          message: 'We could not continue with the mobile verification step. Please try again.',
        );
        setState(() {
          _workflowState = _AbhaWorkflowState.error;
        });
        return false;
      }

      AbhaDebugLogger.ui('Verify mobile OTP button pressed', flowId: _abhaFlowId);
      AbhaDebugLogger.workflow('MOBILE OTP VERIFICATION STARTED', flowId: _abhaFlowId);
      AbhaDebugLogger.workflow('Calling updatemobile/verify-otp', flowId: _abhaFlowId);
      final success = await controller.verifyMobileUpdateOtp(
        profileId: profileId,
        txnId: controller.mobileUpdateTxnId.value,
        otp: otp,
        flowId: _abhaFlowId,
      );

      if (!success) {
        setState(() {
          _workflowState = _AbhaWorkflowState.error;
        });
        return false;
      }

      AbhaDebugLogger.workflow('MOBILE UPDATE SUCCESS', flowId: _abhaFlowId);
      AbhaDebugLogger.workflow('New mobile verified successfully', flowId: _abhaFlowId);
      setState(() {
        _showMobileUpdateOtp = false;
        _currentOtpMode = 'aadhaar';
        _isMobileOtpDialogVisible = false;
        _workflowState = _AbhaWorkflowState.mobileUpdated;
      });
      _clearOtpFields();
      if (mounted && _isMobileOtpDialogVisible == false) {
        Navigator.of(context, rootNavigator: true).maybePop();
      }
      await CommonErrorDialog.show(
        context,
        message: 'Mobile number verified successfully.',
      );
      if (mounted) {
        AbhaDebugLogger.workflow('MOBILE UPDATE SUCCESS', flowId: _abhaFlowId);
        AbhaDebugLogger.workflow('Proceeding to ABHA address creation', flowId: _abhaFlowId);
        AbhaDebugLogger.navigation('Opening abha_address_creation.dart', flowId: _abhaFlowId);
        _goToStep(2);
      }
      return true;
    } finally {
      if (mounted) setState(() => _isProcessingMobileUpdate = false);
    }
  }

  void _clearOtpFields() {
    for (final controller in _otpDigitControllers) {
      controller.clear();
    }
    for (var i = 0; i < _otpDigitCache.length; i++) {
      _otpDigitCache[i] = '';
    }
    _otpFieldTouched = false;
    _mobileFieldTouched = false;
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
    _debugOtpState('clear otp fields');
  }

  void _showMobileOtpDialog() {
    if (_isMobileOtpDialogVisible || !mounted) return;
    setState(() => _isMobileOtpDialogVisible = true);
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _debugOtpState('show mobile OTP dialog');
      }
    });

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final profileIdText = controller.currentProfileId.value;
        final profileId = int.tryParse(profileIdText) ?? 0;
        final txnId = controller.mobileUpdateTxnId.value;

        return UpdateMobileOtpDialog(
          flowId: _abhaFlowId ?? 'unknown',
          profileId: profileId,
          txnId: txnId,
          message: controller.mobileUpdateOtpDeliveryMessage.value.isNotEmpty
              ? controller.mobileUpdateOtpDeliveryMessage.value
              : 'OTP sent to your registered mobile number.',
          onVerify: (otp) async {
            final result = await _verifyMobileUpdateOtp(otp);
            return result;
          },
          onResend: () async {
            final profileIdText = controller.currentProfileId.value;
            final profileId = int.tryParse(profileIdText) ?? 0;
            final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');
            if (profileId <= 0 || mobile.isEmpty) return false;
            return await _requestMobileUpdateOtp(profileId, mobile);
          },
        );
      },
    ).then((verified) {
      if (mounted) {
        setState(() => _isMobileOtpDialogVisible = false);
      }
      if (verified == true) {
        debugPrint('[ABHA][WORKFLOW][FLOW:${_abhaFlowId ?? 'unknown'}] MOBILE UPDATE SUCCESS');
        debugPrint('[ABHA][NAVIGATION][FLOW:${_abhaFlowId ?? 'unknown'}] Opening abha_address_creation.dart');
      }
    });
  }

  void _handleOtpBackspace(int index) {
    if (index <= 0) return;
    final previousIndex = index - 1;
    _otpDigitControllers[previousIndex].clear();
    FocusScope.of(context).requestFocus(_otpFocusNodes[previousIndex]);
    _debugOtpState('backspace from index ${index + 1}');
  }

  void _handleOtpKey(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.backspace) {
        if (_otpDigitControllers[index].text.isEmpty) {
          _handleOtpBackspace(index);
        } else {
          _otpDigitControllers[index].clear();
          _otpDigitCache[index] = '';
          _otpFieldTouched = true;
          if (mounted) setState(() {});
          FocusScope.of(context).requestFocus(_otpFocusNodes[index]);
        }
      }
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _logWorkflowState() {
    log('[ABHA][WORKFLOW STATE] $_workflowState');
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

  String _normalizeMobile(String? value) {
    return (value ?? '').toString().replaceAll(RegExp(r'\D'), '');
  }

  String? _extractAbhaProfileMobile(Map<String, dynamic>? response) {
    if (response == null) return null;

    final profile = response['result']?['ABHAProfile'] as Map<String, dynamic>?;
    final profileMobile = profile?['mobile']?.toString().trim();
    if (profileMobile != null && profileMobile.isNotEmpty) {
      return profileMobile;
    }

    final fallbackProfile = response['ABHAProfile'] as Map<String, dynamic>?;
    final fallbackMobile = fallbackProfile?['mobile']?.toString().trim();
    if (fallbackMobile != null && fallbackMobile.isNotEmpty) {
      return fallbackMobile;
    }

    return null;
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
        setState(() {
          _consentAccepted = value ?? false;
          _consentFieldTouched = true;
        });
      },
      selectedAuthMethod: _selectedAuthMethod,
      onAuthMethodChanged: (value) => setState(() {
        _selectedAuthMethod = value;
        _authMethodFieldTouched = true;
      }),
      captchaQuestion: _captchaQuestion,
      captchaAnswer: _captchaAnswer,
      captchaController: _captchaController,
      onRefreshCaptcha: _refreshCaptcha,
      isSubmitting: _isSubmitting,
      canProceed: canProceed,
      shouldShowAadhaarError: _aadhaarFieldTouched,
      shouldShowConsentError: _consentFieldTouched,
      shouldShowAuthMethodError: _authMethodFieldTouched,
      shouldShowCaptchaError: _captchaFieldTouched,
      onAadhaarFieldChanged: () => setState(() => _aadhaarFieldTouched = true),
      onCaptchaChanged: () => setState(() => _captchaFieldTouched = true),
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

  String _getOtpValue() =>
      _otpDigitControllers.map((c) => c.text.trim()).join();

  bool _isOtpComplete() => _getOtpValue().length == 6;

  bool _hasExistingAbhaResponse(Map<String, dynamic>? response) {
    if (response == null) return false;

    final message = CommonErrorDialog
        .extractErrorMessage(response)
        .toString()
        .toLowerCase();
    if (message.contains('abha already exists') ||
        message.contains('already exists')) {
      return true;
    }

    if (response['result'] is Map<String, dynamic> &&
        response['result']?['ABHAProfile'] != null) {
      return true;
    }

    if (response['ABHAProfile'] != null || response['abhaNumber'] != null) {
      return true;
    }

    return false;
  }

  bool _isHandlingOtpChange = false;

  String _generateFlowId() => DateTime.now().millisecondsSinceEpoch.toString();

  void _logAbhaFlowStart(String message) {
    _abhaFlowId = _generateFlowId();
    AbhaDebugLogger.section(message, flowId: _abhaFlowId);
    AbhaDebugLogger.workflow('$message started', flowId: _abhaFlowId);
  }

  void _debugOtpState(String msg) {
    AbhaDebugLogger.ui('[OTP] $msg', flowId: _abhaFlowId);
  }

  void _handleOtpDigitChanged(int index, String value) {
    if (_isHandlingOtpChange) return;
    _isHandlingOtpChange = true;
    try {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      final previousValue = _otpDigitCache[index];

      if (digits.isEmpty) {
        _otpDigitControllers[index].clear();
        _otpDigitCache[index] = '';
        if (index > 0) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
        }
        _debugOtpState('empty value at index ${index + 1}');
        return;
      }

      if (digits.length == 1) {
        final digit = digits;
        if (previousValue.isNotEmpty && previousValue != digit) {
          final nextIndex = index + 1;
          if (nextIndex < _otpDigitControllers.length) {
            _otpDigitControllers[index].text = previousValue;
            _otpDigitCache[index] = previousValue;
            _otpDigitControllers[nextIndex].text = digit;
            _otpDigitCache[nextIndex] = digit;
            if (nextIndex + 1 < _otpFocusNodes.length) {
              FocusScope.of(context).requestFocus(_otpFocusNodes[nextIndex + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
            _debugOtpState('shifted digit from index ${index + 1} to ${nextIndex + 1}');
          } else {
            _otpDigitControllers[index].text = digit;
            _otpDigitCache[index] = digit;
            FocusScope.of(context).unfocus();
          }
        } else {
          _otpDigitControllers[index].text = digit;
          _otpDigitCache[index] = digit;
          final nextIndex = index + 1;
          if (nextIndex < _otpFocusNodes.length) {
            FocusScope.of(context).requestFocus(_otpFocusNodes[nextIndex]);
          } else {
            FocusScope.of(context).unfocus();
          }
          _debugOtpState('entered digit at index ${index + 1}');
        }
      } else {
        var writeIndex = index;
        for (final digit in digits.split('')) {
          if (writeIndex > 5) break;
          _otpDigitControllers[writeIndex].text = digit;
          _otpDigitCache[writeIndex] = digit;
          writeIndex++;
        }
        if (writeIndex < _otpFocusNodes.length) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[writeIndex]);
        } else {
          FocusScope.of(context).unfocus();
        }
        _debugOtpState('pasted digits starting at index ${index + 1}');
      }

      final otpValue = _otpDigitCache.join();
      final otpComplete = RegExp(r'^\d{6} *? *?').hasMatch(otpValue); // placeholder
      _debugOtpState('OTP length: ${otpValue.length}');
      _debugOtpState('OTP complete: ${otpValue.length == 6}');
    } finally {
      _isHandlingOtpChange = false;
    }
  }

  Widget _buildOtpStep(ThemeData theme, Color primary) {
    if (_isMobileOtpDialogVisible) {
      return const SizedBox.shrink();
    }

    final otpComplete = _isOtpComplete();
    final mobileComplete = _isValidMobile(_mobileController.text);
    final isMobileUpdate = _currentOtpMode == 'mobileUpdate';

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
      onOtpKey: _handleOtpKey,
      mobileController: _mobileController,
      resendSeconds: _resendSeconds,
      onResendOtp: _resendOtp,
      resendAttempts: _resendAttempts,
      maxResendAttempts: _maxResendAttempts,
      onVerify: () async {
        if (!_otpFormKey.currentState!.validate()) return;
        await _verifyOtpAndContinue();
      },
      isSubmitting: _isSubmitting || _isProcessingMobileUpdate,
      otpComplete: otpComplete,
      mobileComplete: mobileComplete,
      otpDeliveryMessage: isMobileUpdate
          ? (controller.mobileUpdateOtpDeliveryMessage.value.isNotEmpty
              ? controller.mobileUpdateOtpDeliveryMessage.value
              : 'OTP sent to your registered mobile number.')
          : (controller.aadhaarOtpDeliveryMessage.value.isNotEmpty
              ? controller.aadhaarOtpDeliveryMessage.value
              : 'OTP Verification *'),
      formatResendTimer: _formatResendTimer,
      buildMaskedMobileNumber: _buildMaskedMobileNumber,
      isValidMobile: _isValidMobile,
      shouldShowOtpError: _otpFieldTouched,
      shouldShowMobileError: _mobileFieldTouched,
      onOtpFieldChanged: () => setState(() => _otpFieldTouched = true),
      onMobileFieldChanged: () => setState(() => _mobileFieldTouched = true),
      title: isMobileUpdate ? 'Verify Mobile Number' : 'Confirm OTP',
      description: isMobileUpdate
          ? 'A verification OTP has been sent to your registered mobile number.\n\nEnter the 6-digit OTP to continue.'
          : (controller.aadhaarOtpDeliveryMessage.value.isNotEmpty
              ? controller.aadhaarOtpDeliveryMessage.value
              : 'OTP sent to your Aadhaar registered mobile number.'),
      buttonLabel: isMobileUpdate ? 'Verify Mobile OTP' : 'Verify & Continue',
      showMobileNumberField: !isMobileUpdate,
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
