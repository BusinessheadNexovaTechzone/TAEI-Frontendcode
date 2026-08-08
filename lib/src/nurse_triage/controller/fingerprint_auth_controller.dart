import 'dart:developer';

import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/services/fingerprint_service.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class FingerprintAuthController extends GetxController {
  final FingerprintService _service = FingerprintService();

  final RxBool isLoading = false.obs;
  final RxString fingerPrintAuthPid = ''.obs;
  final RxString pidXml = ''.obs;
  final RxString txnId = ''.obs;
  final RxString profileId = ''.obs;
  final Rxn<dynamic> tokens = Rxn<dynamic>();
  final RxString errorMessage = ''.obs;
  final Rxn<Map<String, dynamic>> enrollmentResponse =
      Rxn<Map<String, dynamic>>();

  Future<bool> captureFingerprint() async {
    if (isLoading.value) return false;
    isLoading.value = true;
    errorMessage.value = '';
    fingerPrintAuthPid.value = '';
    pidXml.value = '';
    txnId.value = '';

    try {
      log('===== FINGERPRINT AUTH CAPTURE START =====');
      final response = await _service.captureFingerprint();
      log('Capture Response: $response');

      if (response == null) {
        errorMessage.value = 'Fingerprint capture failed.';
        return false;
      }

      final status = response['status']?.toString().toLowerCase() ?? '';
      final pid = response['fingerPrintAuthPid']?.toString() ?? '';
      final xml = response['pidXml']?.toString() ?? '';

      if (status != 'success' || pid.isEmpty) {
        errorMessage.value =
            CommonErrorDialog.extractFriendlyErrorMessage(response);
        if (errorMessage.value.isEmpty) {
          errorMessage.value = 'Fingerprint capture failed. Please try again.';
        }
        return false;
      }

      fingerPrintAuthPid.value = pid;
      pidXml.value = xml;

      log('Capture Success');
      log('fingerPrintAuthPid : ${fingerPrintAuthPid.value}');
      log('pidXml : ${pidXml.value}');

      return true;
    } catch (e) {
      log('Fingerprint capture exception: $e');
      errorMessage.value = CommonErrorDialog.extractFriendlyErrorMessage(e);
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
      return null;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      log('===== FINGERPRINT AUTH ENROLL START =====');
      log('Request Body: aadhaar=$aadhaar, mobile=$mobile, fingerPrintAuthPid=${fingerPrintAuthPid.value}');

      final response = await _service.enrollFingerprint(
        aadhaar: aadhaar,
        mobile: mobile,
        fingerPrintAuthPid: fingerPrintAuthPid.value,
      );

      log('Enroll Response: $response');

      if (response == null) {
        errorMessage.value = 'Fingerprint enrollment failed.';
        return null;
      }

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
        return response;
      }

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

      log('Enrollment success, profileId: ${profileId.value}');
      log('Enrollment txnId: ${txnId.value}');
      log('Enrollment tokens: ${tokens.value}');

      return response;
    } catch (e) {
      log('Fingerprint enroll exception: $e');
      errorMessage.value = CommonErrorDialog.extractFriendlyErrorMessage(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
