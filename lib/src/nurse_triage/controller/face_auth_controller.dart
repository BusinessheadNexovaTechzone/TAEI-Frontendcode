import 'dart:async';
import '../controller/nurse_triage_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../services/face_rd_service.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class FaceAuthController extends GetxController {
  final FaceRDService _service = FaceRDService();

  final RxBool isLoading = false.obs;
  final RxString txnId = ''.obs;
  final RxString faceAuthUrl = ''.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> startFaceAuth() async {
    if (isLoading.value) {
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';
    txnId.value = '';
    faceAuthUrl.value = '';

    try {
      debugPrint('INIT API START');
      final initTxnId = await _service.initFaceAuth();
      txnId.value = initTxnId;
      // ADD THIS
      final nurse = Get.find<NurseTriageController>();
      nurse.faceTxnId.value = initTxnId;
      print("Face Controller txnId : ${txnId.value}");
      print("Nurse Controller txnId : ${nurse.faceTxnId.value}");
      debugPrint('INIT RESPONSE');
      debugPrint('txnId: ${txnId.value}');

      debugPrint('CAPTURE API START');

      final captureResponse = await _service.captureFaceAuth(txnId.value);

      final capturedUrl = _service.getFaceAuthUrl(captureResponse);

      if (capturedUrl == null || capturedUrl.isEmpty) {
        throw Exception(
          "Face Authentication URL not received",
        );
      }

      faceAuthUrl.value = capturedUrl;

      debugPrint('CAPTURE RESPONSE');

      debugPrint(captureResponse.toString());

      debugPrint('faceAuthUrl: ${faceAuthUrl.value}');

      debugPrint('Launching Production ABHA App');
      await _service.launchAbhaApp(faceAuthUrl.value);
      debugPrint('Success');

      Get.snackbar(
        'Face Auth',
        'Production ABHA app has been launched.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on TimeoutException {
      _handleError('Face authentication timed out. Please try again.');
      return false;
    } on FormatException catch (e) {
      _handleError('Invalid face authentication response. ${e.message}');
      return false;
    } on PlatformException catch (e) {
      debugPrint('Failure: ${e.message}');
      _handleError('ABHA app is not installed on this device.');
      return false;
    } catch (e) {
      debugPrint('Failure: $e');
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      _handleError(friendlyMessage.isNotEmpty
          ? friendlyMessage
          : 'Face verification could not be completed.\n\nPlease scan your face again and ensure your face is clearly visible.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String message) {
    errorMessage.value = message;
    debugPrint('Failure: $message');
    Get.snackbar(
      'Face Auth',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
