import 'dart:developer';

import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/models/lgd_models.dart';
import 'package:taei_gov/src/nurse_triage/services/demo_auth_service.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class DemoAuthController extends GetxController {
  final DemoAuthService _service = DemoAuthService();

  final RxBool isSubmitting = false.obs;
  final RxString status = 'idle'.obs;
  final RxString errorMessage = ''.obs;
  final RxnInt profileId = RxnInt();
  final Rxn<Map<String, dynamic>> responseData = Rxn<Map<String, dynamic>>();

  // LGD State and District selections
  final RxnString selectedStateName = RxnString();
  final RxnString selectedDistrictName = RxnString();
  final RxList<LGDState> availableStates = RxList<LGDState>(lgdStates);
  final RxList<LGDDistrict> availableDistricts = RxList<LGDDistrict>([]);

  String maskAadhaar(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 4) {
      return digits.isEmpty ? '****' : '*' * digits.length;
    }
    final visible = digits.substring(digits.length - 4);
    return '${'*' * (digits.length - 4)} $visible';
  }

  String? validateRequired(String? value, String fieldName) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select State';
    }
    return null;
  }

  String? validateDistrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select District';
    }
    return null;
  }

  void selectState(String? stateName) {
    if (stateName != null) {
      selectedStateName.value = stateName;
      log('[LGD] Selected State: $stateName');
      
      // Find the state code for logging
      final state = lgdStates.firstWhereOrNull((s) => s.name == stateName);
      if (state != null) {
        log('[LGD] Selected State Value: ${state.code}');
      }
      
      // Update available districts
      availableDistricts.value = getDistrictsForState(stateName);
      // Clear district selection when state changes
      selectedDistrictName.value = null;
    }
  }

  void selectDistrict(String? districtName) {
    if (districtName != null) {
      selectedDistrictName.value = districtName;
      log('[LGD] Selected District: $districtName');
    }
  }

  String? validateDob(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Date of birth is required.';
    if (!RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(trimmed)) {
      return 'Date of birth must be in DD-MM-YYYY format.';
    }

    try {
      final parts = trimmed.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return 'Please provide a valid date of birth.';
      }
    } catch (_) {
      return 'Please provide a valid date of birth.';
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select gender.';
    }
    return null;
  }

  String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^\d{10}$').hasMatch(digits)) {
      return 'Please provide a valid mobile number.';
    }
    return null;
  }

  String? validatePinCode(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^\d{6}$').hasMatch(digits)) {
      return 'Please provide a valid PIN code.';
    }
    return null;
  }

  Future<bool> submitDemoAuth({
    required String aadhaar,
    required String stateName,
    required String districtName,
    required String dateOfBirth,
    required String gender,
    required String name,
    String? mobile,
    String? pinCode,
    bool consentAccepted = false,
  }) async {
    errorMessage.value = '';
    status.value = 'validating';
    profileId.value = null;
    responseData.value = null;

    final cleanedAadhaar = aadhaar.replaceAll(RegExp(r'\D'), '');
    if (!consentAccepted) {
      errorMessage.value = 'Please accept the consent to continue.';
      status.value = 'error';
      return false;
    }

    if (cleanedAadhaar.length != 12) {
      errorMessage.value = 'Aadhaar information is unavailable. Please restart the ABHA enrollment process.';
      status.value = 'error';
      return false;
    }

    final requiredChecks = [
      validateState(stateName),
      validateDistrict(districtName),
      validateDob(dateOfBirth),
      validateGender(gender),
      validateName(name),
    ];

    for (final error in requiredChecks) {
      if (error != null && error.isNotEmpty) {
        errorMessage.value = error;
        status.value = 'error';
        return false;
      }
    }

    final mobileError = validateMobile(mobile);
    if (mobileError != null) {
      errorMessage.value = mobileError;
      status.value = 'error';
      return false;
    }

    final pinError = validatePinCode(pinCode);
    if (pinError != null) {
      errorMessage.value = pinError;
      status.value = 'error';
      return false;
    }

    isSubmitting.value = true;
    status.value = 'submitting';

    try {
      final body = <String, dynamic>{
        'aadhaar': cleanedAadhaar,
        'stateName': stateName.trim(),
        'districtName': districtName.trim(),
        'dateOfBirth': dateOfBirth.trim(),
        'gender': gender.trim(),
        'name': name.trim(),
      };

      // Log state and district names for debugging
      log('[ABHA] State Name: ${stateName.trim()}');
      log('[ABHA] District Name: ${districtName.trim()}');

      final trimmedMobile = mobile?.trim() ?? '';
      final trimmedPin = pinCode?.trim() ?? '';
      if (trimmedMobile.isNotEmpty) {
        body['mobile'] = trimmedMobile;
      }
      if (trimmedPin.isNotEmpty) {
        body['pinCode'] = trimmedPin;
      }

      final response = await _service.enrollByAadhaar(body: body);
      if (response == null) {
        errorMessage.value = 'Unable to complete Demo Authentication. Please try again.';
        status.value = 'error';
        return false;
      }

      final directProfileId = response['profileId'];
      int? extractedProfileId;
      if (directProfileId != null) {
        extractedProfileId = int.tryParse(directProfileId.toString());
      }

      if (extractedProfileId == null || extractedProfileId <= 0) {
        errorMessage.value = 'ABHA profile was created, but the profile ID could not be retrieved.';
        status.value = 'error';
        return false;
      }

      responseData.value = response;
      profileId.value = extractedProfileId;
      status.value = 'success';
      return true;
    } catch (e) {
      final message = CommonErrorDialog.extractFriendlyErrorMessage(e);
      errorMessage.value = message.isNotEmpty ? message : 'Demo authentication failed. Please try again.';
      status.value = 'error';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
