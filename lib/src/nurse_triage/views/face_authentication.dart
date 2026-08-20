import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/face_auth_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/services/face_rd_service.dart';
import 'package:taei_gov/src/nurse_triage/services/triage_service.dart';
import 'package:taei_gov/src/nurse_triage/services/abha_error_message_service.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class FaceAuthenticationScreen extends StatefulWidget {
  const FaceAuthenticationScreen({
    super.key,
    required this.aadhaar,
    this.mobile,
  });

  final String aadhaar;
  final String? mobile;

  @override
  State<FaceAuthenticationScreen> createState() =>
      _FaceAuthenticationScreenState();
}

class _FaceAuthenticationScreenState extends State<FaceAuthenticationScreen> {
  final TextEditingController _mobileController = TextEditingController();
  late final FaceAuthController _faceAuthController;
  late final NurseTriageController _controller;
  late final FaceRDService _faceService;

  bool _isLoading = false;
  bool _faceScanCompleted = false;
  bool _showMobileInput = false;
  String? _txnId;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _faceAuthController = Get.isRegistered<FaceAuthController>()
        ? Get.find<FaceAuthController>()
        : Get.put(FaceAuthController());
    _controller = Get.isRegistered<NurseTriageController>()
        ? Get.find<NurseTriageController>()
        : Get.put(NurseTriageController());
    _faceService = FaceRDService();
    _mobileController.text = widget.mobile ??
        _controller.createTriageModel.value?.triage?.patientMobileNumber ??
        '';
    _txnId = _controller.faceTxnId.value;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _faceService.dispose();
    super.dispose();
  }

  Future<void> _startFaceAuth() async {
    if (_isLoading) return;

    final aadhaar = widget.aadhaar.replaceAll(RegExp(r'\D'), '');
    if (aadhaar.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Aadhaar number is required to continue.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Starting face authentication...';
    });

    try {
      debugPrint('==================================');
      debugPrint('FACE AUTH START');
      debugPrint('==================================');
      debugPrint('Aadhaar : $aadhaar');
      debugPrint('Mobile : ${_mobileController.text}');

      final started = await _faceAuthController.startFaceAuth();
      if (!started) {
        final message = _faceAuthController.errorMessage.value.isNotEmpty
            ? _faceAuthController.errorMessage.value
            : 'Face authentication did not start.';
        await CommonErrorDialog.show(context, message: message);
        return;
      }

      final txnId = _faceAuthController.txnId.value.isNotEmpty
          ? _faceAuthController.txnId.value
          : _controller.faceTxnId.value;

      if (txnId.isEmpty) {
        await CommonErrorDialog.show(
          context,
          message: 'Face authentication session was not created.',
        );
        return;
      }

      _txnId = txnId;
      _controller.faceTxnId.value = txnId;
      _controller.createTriageModel.value!.triage!.aadhaar = aadhaar;
      _controller.createTriageModel.value!.triage!.patientMobileNumber =
          _mobileController.text.replaceAll(RegExp(r'\D'), '');
      _controller.createTriageModel.refresh();
      _faceScanCompleted = false;
      _showMobileInput = false;

      debugPrint('==================================');
      debugPrint('INIT API');
      debugPrint('txnId : $txnId');
      debugPrint('==================================');
      debugPrint('Launching ABHA App');
      debugPrint('==================================');

      setState(() {
        _statusMessage =
            'ABHA app has been launched. Please complete the face scan and return here.';
      });
    } catch (e) {
      await CommonErrorDialog.show(
        context,
        message: AbhaErrorMessageService.map(e),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleVerifyPressed() async {
    if (_txnId == null || _txnId!.trim().isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Please scan the face first before verifying.',
      );
      return;
    }

    if (!_showMobileInput) {
      setState(() {
        _showMobileInput = true;
        _statusMessage =
            'Enter the mobile number to continue with verification.';
      });
      return;
    }

    await _verifyFaceAndEnroll();
  }

  Future<void> _verifyFaceAndEnroll() async {
    if (_isLoading) return;

    final txnId = (_txnId ?? _controller.faceTxnId.value).trim();
    if (txnId.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Face authentication session is not available.',
      );
      return;
    }

    final mobile = _mobileController.text.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter a valid 10-digit mobile number.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Verifying face scan...';
    });

    try {
      debugPrint('==================================');
      debugPrint('VERIFY FACE CLICKED');
      debugPrint('==================================');
      debugPrint('txnId : $txnId');

      final response = await _faceService.captureFaceAuth(txnId);
      debugPrint('==================================');
      debugPrint('CAPTURE API AGAIN');
      debugPrint('txnId : $txnId');
      debugPrint(response.toString());
      debugPrint('==================================');

      final status = response['status']?.toString().toUpperCase();
      if (status == 'PENDING') {
        setState(() {
          _statusMessage =
              'Face scan is still pending. Please complete the scan and try again.';
          _faceScanCompleted = false;
        });
        return;
      }

      if (status == 'FAILED') {
        await CommonErrorDialog.show(
          context,
          message: 'Face verification failed. Please try again.',
        );
        return;
      }

      if (status != 'COMPLETE' && (status?.isNotEmpty ?? false)) {
        await CommonErrorDialog.show(
          context,
          message: 'Face verification could not be completed.',
        );
        return;
      }

      _controller.createTriageModel.value!.triage!.aadhaar =
          widget.aadhaar.replaceAll(RegExp(r'\D'), '');
      _controller.createTriageModel.value!.triage!.patientMobileNumber = mobile;
      _controller.createTriageModel.refresh();

      debugPrint('==================================');
      debugPrint('ENROLL API');
      debugPrint('txnId : $txnId');
      debugPrint('aadhaar : ${widget.aadhaar.replaceAll(RegExp(r'\D'), '')}');
      debugPrint('mobile : $mobile');
      debugPrint('==================================');

      final enrollResponse = await TriageService.createAbhaUsingFace(
        txnId: txnId,
        aadhaar: widget.aadhaar.replaceAll(RegExp(r'\D'), ''),
        mobile: mobile,
      );

      debugPrint('==================================');
      debugPrint('ENROLL RESPONSE');
      debugPrint(enrollResponse.toString());
      debugPrint('==================================');

      if (enrollResponse == null) {
        await CommonErrorDialog.show(
          context,
          message: AbhaErrorMessageService.map(null, context: 'createProfile'),
        );
        return;
      }

      if (AbhaErrorMessageService.isFailure(enrollResponse)) {
        await CommonErrorDialog.show(
          context,
          message: AbhaErrorMessageService.map(
            enrollResponse,
            context: 'createProfile',
          ),
        );
        return;
      }

      if (enrollResponse['result'] == null) {
        await CommonErrorDialog.show(
          context,
          message: AbhaErrorMessageService.map(
            enrollResponse,
            context: 'createProfile',
          ),
        );
        return;
      }

      _controller.aadhaarProfileData.value = enrollResponse;
      _controller.createTriageModel.value!.triage!.aadhaar =
          widget.aadhaar.replaceAll(RegExp(r'\D'), '');
      _controller.createTriageModel.value!.triage!.patientMobileNumber = mobile;
      _controller.createTriageModel.refresh();
      _faceScanCompleted = true;
      setState(() {
        _statusMessage = 'Face scan completed. Showing ABHA profile.';
      });

      debugPrint('==================================');
      debugPrint('SHOW PROFILE CARD');
      debugPrint('==================================');
      _controller.showLastAadhaarProfileCard();
    } catch (e) {
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      await CommonErrorDialog.show(
        context,
        message: friendlyMessage.isNotEmpty
            ? friendlyMessage
            : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.red;
    final secondaryColor = Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Face Authentication'),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(20),
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3F3),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(
                          Icons.face_retouching_natural_rounded,
                          size: 64,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Face Authentication',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your identity verification using the official ABHA application.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF616161),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildStepChip('1', 'Generate Session', true),
                        const SizedBox(width: 8),
                        _buildStepChip('2', 'Capture Face', _txnId != null),
                        const SizedBox(width: 8),
                        _buildStepChip(
                            '3', 'Complete Verification', _faceScanCompleted),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What to do next',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildBullet(
                              'Keep your internet connection enabled.'),
                          _buildBullet(
                              'Ensure the official ABHA app is installed.'),
                          _buildBullet(
                              'Complete the face scan before returning.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_statusMessage != null && _statusMessage!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _faceScanCompleted
                              ? const Color(0xFFEAF6EB)
                              : const Color(0xFFFFF3F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _faceScanCompleted
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              color: _faceScanCompleted
                                  ? const Color(0xFF2E7D32)
                                  : secondaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _statusMessage!,
                                style: const TextStyle(
                                  color: Color(0xFF212121),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 18),
                    if (_showMobileInput) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Mobile Number *',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone_iphone_rounded),
                          hintText: 'Enter 10-digit mobile number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _startFaceAuth,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(
                                Icons.face_retouching_natural_rounded),
                            label: const Text('Scan Face'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ||
                                    (_txnId == null || _txnId!.trim().isEmpty)
                                ? null
                                : _handleVerifyPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.verified_user_rounded),
                            label: Text(
                              _isLoading
                                  ? 'Please wait...'
                                  : (_showMobileInput
                                      ? 'Verify Face'
                                      : 'Verify Face'),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStepChip(String number, String title, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF3F3) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? Colors.red : const Color(0xFFE0E0E0),
          ),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.red : const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.red : const Color(0xFF616161),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child:
                Icon(Icons.check_circle_outline, size: 16, color: Colors.red),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF616161),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
