import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/services/fingerprint_service.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

enum FingerprintCaptureState {
  idle,
  checkingRdService,
  checkingDevice,
  waitingForFinger,
  capturing,
  fingerprintCaptured,
  sendingToAbha,
  abhaResponseReceived,
  success,
  error,
}

class FingerprintAuthController extends GetxController {
  final FingerprintService _service = FingerprintService();

  final RxBool isLoading = false.obs;
  final Rx<FingerprintCaptureState> captureState =
      FingerprintCaptureState.idle.obs;
  final RxString fingerPrintAuthPid = ''.obs;
  final RxString pidXml = ''.obs;
  final RxString txnId = ''.obs;
  final RxString profileId = ''.obs;
  final Rxn<dynamic> tokens = Rxn<dynamic>();
  final RxString errorMessage = ''.obs;
  final RxString statusMessage = ''.obs;
  final Rxn<Map<String, dynamic>> enrollmentResponse =
      Rxn<Map<String, dynamic>>();

  Future<bool> captureFingerprint() async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    errorMessage.value = '';
    fingerPrintAuthPid.value = '';
    pidXml.value = '';
    txnId.value = '';
    captureState.value = FingerprintCaptureState.idle;
    statusMessage.value = '';

    try {
      log('===== FINGERPRINT AUTH CAPTURE START =====');

      // Step 1: Check RD Service availability
      captureState.value = FingerprintCaptureState.checkingRdService;
      statusMessage.value = 'Checking Mantra RD Service...';
      log('[FINGERPRINT] Checking RD Service availability');

      final serviceAvailable = await _service.getServiceInfo();
      if (!serviceAvailable) {
        errorMessage.value =
            'Unable to communicate with Mantra RD Service. Please verify that Mantra RD Service is running on this device.';
        captureState.value = FingerprintCaptureState.error;
        log('[FINGERPRINT] RD Service unavailable');
        return false;
      }

      log('[FINGERPRINT] RD Service available');

      // Step 2: Check device information
      captureState.value = FingerprintCaptureState.checkingDevice;
      statusMessage.value = 'Checking fingerprint device...';
      log('[FINGERPRINT] Checking device information');

      final deviceInfo = await _service.getDeviceInfo();
      if (deviceInfo == null || deviceInfo['success'] != true) {
        final error = deviceInfo?['error'] ?? 'Mantra MFS110 device not detected.';
        errorMessage.value = error;
        captureState.value = FingerprintCaptureState.error;
        log('[FINGERPRINT] Device check failed: $error');
        return false;
      }

      log('[FINGERPRINT] Device detected: ${deviceInfo['deviceType']}');

      // Step 3: Wait for finger placement
      captureState.value = FingerprintCaptureState.waitingForFinger;
      statusMessage.value = 'Place your finger on the Mantra scanner...';
      log('[FINGERPRINT] Waiting for finger placement');

      // Step 4: Capture fingerprint
      captureState.value = FingerprintCaptureState.capturing;
      statusMessage.value = 'Capturing fingerprint...';
      log('[FINGERPRINT] Starting fingerprint capture');

      final captureResponse = await _service.captureFingerprint();

      if (captureResponse == null || captureResponse['success'] != true) {
        final error = captureResponse?['error'] ?? 'Fingerprint capture failed.';
        errorMessage.value = error;
        captureState.value = FingerprintCaptureState.error;
        log('[FINGERPRINT] Capture failed: $error');
        return false;
      }

      // Step 5: Extract captured data
      fingerPrintAuthPid.value = captureResponse['fingerPrintAuthPid'] ?? '';
      pidXml.value = captureResponse['pidXml'] ?? '';

      if (fingerPrintAuthPid.value.isEmpty) {
        errorMessage.value =
            'Failed to extract fingerprint data. Please try again.';
        captureState.value = FingerprintCaptureState.error;
        log('[FINGERPRINT] Failed to extract PID');
        return false;
      }

      captureState.value = FingerprintCaptureState.fingerprintCaptured;
      statusMessage.value = 'Fingerprint captured successfully.';
      log('[FINGERPRINT] Fingerprint captured successfully');
      log('[FINGERPRINT] PID length: ${fingerPrintAuthPid.value.length}');

      return true;
    } catch (e) {
      log('[FINGERPRINT] Capture exception: $e');
      errorMessage.value =
          CommonErrorDialog.extractFriendlyErrorMessage(e);
      if (errorMessage.value.isEmpty) {
        errorMessage.value = 'Fingerprint capture failed. Please try again.';
      }
      captureState.value = FingerprintCaptureState.error;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> enrollFingerprint({
    required String aadhaar,
    required String mobile,
  }) async {
    if (isLoading.value) return null;
    if (fingerPrintAuthPid.value.isEmpty) {
      errorMessage.value = 'Fingerprint data is missing. Please capture again.';
      captureState.value = FingerprintCaptureState.error;
      return null;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      log('===== FINGERPRINT AUTH ENROLL START =====');

      // Step 6: Send to ABHA backend
      captureState.value = FingerprintCaptureState.sendingToAbha;
      statusMessage.value = 'Sending fingerprint to ABHA...';

      final aadharMasked = aadhaar.replaceRange(
          0, aadhaar.length - 4, '*' * (aadhaar.length - 4));
      final mobileMasked = mobile.replaceRange(
          0, mobile.length - 4, '*' * (mobile.length - 4));

      log('[ABHA] BIOMETRIC ENROLL START');
      log('[ABHA] Aadhaar: $aadharMasked');
      log('[ABHA] Mobile: $mobileMasked');
      log('[ABHA] PID length: ${fingerPrintAuthPid.value.length}');

      final response = await _service.enrollFingerprint(
        aadhaar: aadhaar,
        mobile: mobile,
        fingerPrintAuthPid: fingerPrintAuthPid.value,
      );

      log('[ABHA] BIOMETRIC ENROLL STATUS - Response received');

      if (response == null) {
        errorMessage.value = 'Fingerprint enrollment failed.';
        captureState.value = FingerprintCaptureState.error;
        return null;
      }

      // Step 7: Validate response
      captureState.value = FingerprintCaptureState.abhaResponseReceived;

      final status = response['status']?.toString().toLowerCase() ?? '';
      final hasProfile = response['result']?['ABHAProfile'] != null ||
          response['ABHAProfile'] != null ||
          response['profile'] != null;

      if (status == 'failed' ||
          status == 'error' ||
          (!hasProfile && response['success'] == false)) {
        errorMessage.value =
            CommonErrorDialog.extractFriendlyErrorMessage(response);
        if (errorMessage.value.isEmpty) {
          errorMessage.value =
              'Fingerprint enrollment failed. Please try again.';
        }
        captureState.value = FingerprintCaptureState.error;
        log('[ABHA] BIOMETRIC ENROLL FAILED: ${errorMessage.value}');
        return response;
      }

      // Step 8: Extract transaction and profile data
      final txn = response['txnId']?.toString() ??
          response['data']?['txnId']?.toString() ??
          response['result']?['txnId']?.toString() ??
          '';
      if (txn.isNotEmpty) {
        txnId.value = txn;
      }

      final profile = response['result']?['ABHAProfile'] ??
          response['ABHAProfile'] ??
          response['profile'];
      if (profile is Map<String, dynamic>) {
        final pid =
            profile['profileId']?.toString() ?? profile['id']?.toString() ?? '';
        if (pid.isNotEmpty) {
          profileId.value = pid;
        }
      }

      tokens.value = response['tokens'];
      enrollmentResponse.value = response;

      captureState.value = FingerprintCaptureState.success;
      statusMessage.value = 'Enrollment successful.';
      log('[ABHA] BIOMETRIC ENROLL SUCCESS');
      log('[ABHA] Profile ID: ${profileId.value}');
      log('[ABHA] Transaction ID: ${txnId.value}');

      return response;
    } catch (e) {
      log('[ABHA] Enroll exception: $e');
      errorMessage.value =
          CommonErrorDialog.extractFriendlyErrorMessage(e);
      if (errorMessage.value.isEmpty) {
        errorMessage.value = 'Fingerprint enrollment failed. Please try again.';
      }
      captureState.value = FingerprintCaptureState.error;
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
