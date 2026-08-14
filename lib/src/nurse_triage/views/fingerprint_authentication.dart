import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/fingerprint_auth_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_otp_utils.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class FingerprintAuthenticationScreen extends StatefulWidget {
  const FingerprintAuthenticationScreen({
    super.key,
    required this.aadhaar,
    this.mobile,
  });

  final String aadhaar;
  final String? mobile;

  @override
  State<FingerprintAuthenticationScreen> createState() =>
      _FingerprintAuthenticationScreenState();
}

class _FingerprintAuthenticationScreenState
    extends State<FingerprintAuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  late final FingerprintAuthController _fingerprintController;
  late final NurseTriageController _nurseController;
  bool _isLoading = false;
  String _statusMessage = '';
  bool _captureCompleted = false;

  @override
  void initState() {
    super.initState();
    _fingerprintController = Get.isRegistered<FingerprintAuthController>()
        ? Get.find<FingerprintAuthController>()
        : Get.put(FingerprintAuthController());
    _nurseController = Get.isRegistered<NurseTriageController>()
        ? Get.find<NurseTriageController>()
        : Get.put(NurseTriageController());
    _mobileController.text = widget.mobile ??
        _nurseController.createTriageModel.value?.triage?.patientMobileNumber ??
        '';
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _scanFingerprint() async {
    if (_isLoading) return;

    final aadhaar = widget.aadhaar.replaceAll(RegExp(r'\D'), '');
    final rawMobile = _mobileController.text;
    final trimmedMobile = rawMobile.trim();
    final mobile = trimmedMobile.replaceAll(RegExp(r'\D'), '');
    final isMobileValid = RegExp(r'^\d{10}$').hasMatch(mobile);

    log('====================================');
    log('Raw Mobile Controller: "$rawMobile"');
    log('Trimmed Mobile: "$trimmedMobile"');
    log('Digits Only: $mobile');
    log('Length: ${mobile.length}');
    log('Validation Result: $isMobileValid');
    log('====================================');

    if (aadhaar.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter a valid 12-digit Aadhaar number.',
      );
      return;
    }

    if (!isMobileValid) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter a valid 10-digit mobile number.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Initializing fingerprint capture...';
      _captureCompleted = false;
    });

    try {
      log('========== FINGERPRINT AUTH FLOW START ==========');
      log('Aadhaar: ${aadhaar.replaceRange(0, aadhaar.length - 4, '*' * (aadhaar.length - 4))}');
      log('Mobile: ${mobile.replaceRange(0, mobile.length - 4, '*' * (mobile.length - 4))}');

      // Step 1: Capture fingerprint from local Mantra RD Service
      log('Step 1: Calling captureFingerprint...');
      final captureSuccess = await _fingerprintController.captureFingerprint();

      if (!captureSuccess) {
        final message = _fingerprintController.errorMessage.value.isNotEmpty
            ? _fingerprintController.errorMessage.value
            : 'Fingerprint capture failed. Please try again.';
        log('Fingerprint capture failed: $message');
        await CommonErrorDialog.show(context, message: message);
        setState(() {
          _statusMessage = message;
        });
        return;
      }

      log('Fingerprint captured successfully');
      log('PID length: ${_fingerprintController.fingerPrintAuthPid.value.length}');

      setState(() {
        _statusMessage = 'Fingerprint captured. Enrolling with ABHA...';
        _captureCompleted = true;
      });

      // Step 2: Send captured PID to ABHA backend for enrollment
      log('Step 2: Calling enrollFingerprint with captured PID...');
      final enrollResponse = await _fingerprintController.enrollFingerprint(
        aadhaar: aadhaar,
        mobile: mobile,
      );

      if (enrollResponse == null) {
        final message = _fingerprintController.errorMessage.value.isNotEmpty
            ? _fingerprintController.errorMessage.value
            : 'Fingerprint enrollment failed. Please try again.';
        log('ABHA enrollment failed: $message');
        await CommonErrorDialog.show(context, message: message);
        setState(() {
          _statusMessage = message;
        });
        return;
      }

      if (enrollResponse['success'] == false ||
          enrollResponse['result'] == null &&
              enrollResponse['ABHAProfile'] == null) {
        final message =
            CommonErrorDialog.extractFriendlyErrorMessage(enrollResponse);
        log('ABHA enrollment response indicates failure: $message');
        await CommonErrorDialog.show(
          context,
          message:
              message.isNotEmpty ? message : 'Fingerprint enrollment failed.',
        );
        setState(() {
          _statusMessage = message;
        });
        return;
      }

      // Step 3: Store response and update triage model
      _nurseController.aadhaarProfileData.value = enrollResponse;
      _nurseController.createTriageModel.value!.triage!.aadhaar = aadhaar;
      _nurseController.createTriageModel.value!.triage!.patientMobileNumber =
          mobile;
      _nurseController.createTriageModel.refresh();

      final responseTxn = enrollResponse['txnId']?.toString() ??
          enrollResponse['data']?['txnId']?.toString() ??
          _fingerprintController.txnId.value;
      if (responseTxn.isNotEmpty) {
        _fingerprintController.txnId.value = responseTxn;
      }

      // Extract and store profileId from enrollment response
      final profileId = extractAbhaProfileId(enrollResponse);
      if (profileId != null && profileId > 0) {
        _nurseController.currentProfileId.value = profileId.toString();
        _nurseController.createTriageModel.value?.triage?.abhaProfileId = profileId;
        log('[FINGERPRINT] profileId extracted: $profileId');
      } else {
        log('[FINGERPRINT] WARNING: profileId not found in enrollment response');
      }

      setState(() {
        _statusMessage = 'Enrollment successful. Showing ABHA profile.';
      });
      log('Fingerprint enrollment successful. Showing profile card.');
      log('========== FINGERPRINT AUTH FLOW COMPLETE ==========');

      // Step 4: Display ABHA profile card using existing flow
      _nurseController.showLastAadhaarProfileCard();
    } catch (e) {
      log('Fingerprint flow exception: $e');
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      await CommonErrorDialog.show(
        context,
        message: friendlyMessage.isNotEmpty
            ? friendlyMessage
            : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
      );
      setState(() {
        _statusMessage = friendlyMessage.isNotEmpty
            ? friendlyMessage
            : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Colors.red;
    const secondaryColor = Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Fingerprint Authentication'),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3F3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          size: 70,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Fingerprint Authentication',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Verify your identity using your fingerprint.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF616161),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aadhaar Number',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.aadhaar.replaceAll(RegExp(r'\D'), ''),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'This Aadhaar number will be used for fingerprint enrollment. Do not re-enter Aadhaar.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF616161),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Mobile Number',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            width: 58,
                            alignment: Alignment.center,
                            child: const Text('+91',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          hintText: 'Enter 10-digit mobile number',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Mobile number is required.';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                            return 'Enter a valid 10-digit mobile number.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_statusMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _captureCompleted
                              ? const Color(0xFFEAF6EB)
                              : const Color(0xFFFFF3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _statusMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _captureCompleted
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFB00020),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                await _scanFingerprint();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _isLoading ? 'Scanning...' : 'Scan Fingerprint',
                          style: const TextStyle(fontSize: 16),
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
