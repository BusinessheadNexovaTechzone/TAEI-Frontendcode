import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/abha_verified_profile.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_otp_utils.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';
import '../services/verify_service.dart';

String _coalesceString(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return '';
}

String _buildResidentialAddress(
  Map<String, dynamic> response,
  Map<String, dynamic> accountData,
) {
  final candidates = <String?>[
    accountData['residentialAddress']?.toString(),
    response['residentialAddress']?.toString(),
    accountData['address']?.toString(),
    response['address']?.toString(),
    _coalesceString([
      accountData['houseNumber']?.toString(),
      accountData['street']?.toString(),
      accountData['village']?.toString(),
      accountData['area']?.toString(),
      accountData['districtName']?.toString(),
      accountData['stateName']?.toString(),
      accountData['pinCode']?.toString(),
      response['houseNumber']?.toString(),
      response['street']?.toString(),
      response['village']?.toString(),
      response['area']?.toString(),
      response['districtName']?.toString(),
      response['stateName']?.toString(),
      response['pinCode']?.toString(),
      response['pincode']?.toString(),
    ])
  ];

  final joined = <String>[];
  final parts = <String?>[
    accountData['houseNumber']?.toString(),
    accountData['street']?.toString(),
    accountData['village']?.toString(),
    accountData['area']?.toString(),
    accountData['districtName']?.toString(),
    accountData['stateName']?.toString(),
    accountData['pinCode']?.toString(),
    response['houseNumber']?.toString(),
    response['street']?.toString(),
    response['village']?.toString(),
    response['area']?.toString(),
    response['districtName']?.toString(),
    response['stateName']?.toString(),
    response['pinCode']?.toString(),
    response['pincode']?.toString(),
  ];

  for (final part in parts) {
    if (part != null && part.trim().isNotEmpty) {
      joined.add(part.trim());
    }
  }

  final directAddress = _coalesceString(candidates);
  if (directAddress.isNotEmpty) {
    return directAddress;
  }

  return joined.join(', ');
}

Map<String, dynamic> buildProfileCardPayloadFromVerifyResponse(
    Map<String, dynamic> response) {
  final normalizedProfiles = AbhaVerifiedProfile.fromResponseList(response);
  final profilePayloads = normalizedProfiles.map((normalized) {
    final fullName = normalized.name;
    final nameParts = fullName == 'Not Available'
        ? <String>[]
        : fullName.split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final middleName = nameParts.length > 2 ? nameParts[1] : '';
    final lastName = nameParts.length > 1
        ? nameParts.length > 2
            ? nameParts.sublist(2).join(' ')
            : nameParts.last
        : '';

    final abhaNumber = normalized.abhaNumber == 'Not Available'
        ? ''
        : normalized.abhaNumber;
    final preferredAbhaAddress = normalized.abhaAddress == 'Not Available'
        ? ''
        : normalized.abhaAddress;
    final residentialAddress = normalized.address == 'Not Available'
        ? preferredAbhaAddress
        : normalized.address;

    return <String, dynamic>{
      if (normalized.profileId != null) 'profileId': normalized.profileId,
      'ABHANumber': abhaNumber,
      'abhaNumber': abhaNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'name': normalized.name,
      'mobile': normalized.mobile == 'Not Available' ? '' : normalized.mobile,
      'mobileNumber': normalized.mobile == 'Not Available' ? '' : normalized.mobile,
      'address': residentialAddress,
      'residentialAddress': residentialAddress,
      'preferredAbhaAddress': preferredAbhaAddress,
      'abhaAddress': preferredAbhaAddress,
      'stateName': normalized.state == 'Not Available' ? '' : normalized.state,
      'districtName': normalized.district == 'Not Available' ? '' : normalized.district,
      'pinCode': normalized.pincode == 'Not Available' ? '' : normalized.pincode,
      'photo': normalized.profilePhoto,
      'profilePhoto': normalized.profilePhoto,
      'status': normalized.status,
      'accountStatus': normalized.status,
      'verificationStatus': normalized.verificationStatus,
      'verifiedStatus': normalized.verificationStatus,
      'verificationType': normalized.verificationType,
      'verificationMethod': normalized.verificationType,
      'gender': normalized.gender == 'Not Available' ? '' : normalized.gender,
      'dob': normalized.dateOfBirth == 'Not Available' ? '' : normalized.dateOfBirth,
      'dateOfBirth': normalized.dateOfBirth == 'Not Available' ? '' : normalized.dateOfBirth,
      'age': normalized.age,
    };
  }).toList(growable: false);

  return {
    'result': {
      'ABHAProfile': profilePayloads.length == 1
          ? profilePayloads.first
          : profilePayloads,
    },
  };
}

class VerifyAbhaController extends GetxController {
  final VerifyAbhaService _service = VerifyAbhaService();

  final RxString selectedLoginType = 'aadhaar-aadhaar-otp'.obs;
  final RxString selectedMethod = 'aadhaar'.obs;
  final RxString selectedLoginId = ''.obs;
  final RxString selectedTxnId = ''.obs;
  final RxString otpMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<Map<String, dynamic>> lastApiError = Rxn<Map<String, dynamic>>();
  final Rxn<Map<String, dynamic>> verifiedAuthResponse =
      Rxn<Map<String, dynamic>>();

  void setSelection({
    required String loginType,
    required String loginId,
    required String method,
  }) {
    selectedLoginType.value = loginType;
    selectedLoginId.value = loginId;
    selectedMethod.value = method;
  }

  String resolveLoginType({required String method}) {
    late final String loginType;

    switch (method) {
      case 'mobile':
        loginType = 'mobile-mobile-otp';
        break;
      case 'aadhaar':
        loginType = 'aadhaar-aadhaar-otp';
        break;
      case 'abha-aadhaar':
        loginType = 'abha-number-aadhaar-otp';
        break;
      case 'abha-abha':
        loginType = 'abha-number-abha-otp';
        break;
      case 'abha-address-mobile':
        loginType = 'abha-address-mobile-otp';
        break;
      case 'abha-address-aadhaar':
        loginType = 'abha-address-aadhaar-otp';
        break;
      default:
        loginType = 'abha-number-aadhaar-otp';
        break;
    }

    debugPrint('resolveLoginType()');
    debugPrint('Input Method : $method');
    debugPrint('Resolved LoginType : $loginType');
    return loginType;
  }

  String normalizeInput(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  bool isValidAbhaAddress(String value) {
    final trimmed = value.trim();

    debugPrint('=============================');
    debugPrint('VALIDATION STARTED');
    debugPrint('Value : $value');
    debugPrint('Trimmed : $trimmed');
    debugPrint('Length : ${trimmed.length}');

    final regex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+(?:\.[A-Za-z]{2,})?$',
    );
    final matches = regex.hasMatch(trimmed);
    debugPrint('Regex Result : $matches');

    return matches;
  }

  bool validateInput({required String method, required String value}) {
    final digitsOnly = normalizeInput(value);

    debugPrint('validateInput()');
    debugPrint('Method : $method');
    debugPrint('Value : $value');
    debugPrint('Digits : $digitsOnly');
    debugPrint('Length : ${digitsOnly.length}');

    if (method == 'mobile') {
      debugPrint('Running Mobile validation');
      return digitsOnly.length == 10;
    }
    if (method == 'aadhaar') {
      debugPrint('Running Aadhaar validation');
      return digitsOnly.length == 12;
    }
    if (method == 'abha-aadhaar' || method == 'abha-abha') {
      debugPrint('Running ABHA validation');
      return digitsOnly.length == 14;
    }
    if (method == 'abha-address-mobile' || method == 'abha-address-aadhaar') {
      debugPrint('Running ABHA Address validation');
      return isValidAbhaAddress(value);
    }

    debugPrint('Running default validation');
    return false;
  }

  Future<bool> sendOtp(
      {required String method, required String loginId}) async {
    debugPrint('Controller sendOtp()');
    debugPrint('Method : $method');
    debugPrint('LoginId : $loginId');

    final normalizedLoginId = method == 'mobile' || method == 'aadhaar'
        ? normalizeInput(loginId)
        : loginId.trim();
    debugPrint('Controller Input : $loginId');
    debugPrint('Normalized : $normalizedLoginId');
    debugPrint('Length : ${normalizedLoginId.length}');
    debugPrint(
        'Current selected login type before send: ${selectedLoginType.value}');

    if (!validateInput(method: method, value: normalizedLoginId)) {
      final message = method == 'mobile'
          ? 'Mobile number must contain exactly 10 digits.'
          : method == 'aadhaar'
              ? 'Aadhaar must contain exactly 12 digits.'
              : method == 'abha-address-mobile' || method == 'abha-address-aadhaar'
                  ? 'Please enter a valid ABHA Address.'
                  : 'Please enter a valid 14-digit ABHA number.';

      if (Get.context != null) {
        await CommonErrorDialog.show(Get.context!, message: message);
      }
      return false;
    }

    final loginType = resolveLoginType(method: method);
    final requestLoginId = method == 'abha-aadhaar' || method == 'abha-abha' || method == 'abha-address-mobile' || method == 'abha-address-aadhaar'
        ? loginId.trim()
        : normalizedLoginId;

    setSelection(
      loginType: loginType,
      loginId: requestLoginId,
      method: method,
    );

    debugPrint('Final LoginId : $requestLoginId');
    debugPrint('Login Type : $loginType');

    if (method == 'abha-address-mobile' || method == 'abha-address-aadhaar') {
      debugPrint('=============================');
      debugPrint('VERIFY ABHA ADDRESS');
      debugPrint('Authentication Method : $method');
      debugPrint('ABHA Address : $requestLoginId');
      debugPrint('loginType : $loginType');
    }

    isLoading.value = true;
    try {
      final response = method == 'abha-address-mobile' || method == 'abha-address-aadhaar'
          ? await _service.sendAbhaAddressOtp(
              loginType: loginType,
              loginId: requestLoginId,
            )
          : await _service.sendOtp(
              loginType: loginType,
              loginId: requestLoginId,
            );
      debugPrint('sendOtp service response: $response');

      if (response == null) {
        lastApiError.value = {'message': 'Unable to send OTP right now.'};
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: 'Unable to send OTP right now.',
          );
        }
        return false;
      }

      final txnId = response['txnId']?.toString();
      final message = response['message']?.toString() ?? '';
      if (txnId != null && txnId.isNotEmpty) {
        selectedTxnId.value = txnId;
      }
      if (message.isNotEmpty) {
        otpMessage.value = message;
      }

      if (txnId == null || txnId.isEmpty) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(Get.context!,
              response: response);
        }
        return false;
      }

      return true;
    } catch (e) {
      log('Verify ABHA send OTP exception: $e');
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      lastApiError.value = {'message': friendlyMessage};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: friendlyMessage.isNotEmpty
              ? friendlyMessage
              : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resendOtp() async {
    return sendOtp(
      method: selectedMethod.value,
      loginId: selectedLoginId.value,
    );
  }

  Map<String, dynamic> _buildAadhaarProfileCardPayload(
      Map<String, dynamic> response) {
    return buildProfileCardPayloadFromVerifyResponse(response);
  }

  Future<void> _syncVerifiedResponse(Map<String, dynamic> response) async {
    debugPrint('===== VERIFY OTP RESPONSE =====');
    debugPrint(response.toString());

    verifiedAuthResponse.value = response;

    final nurseController = Get.isRegistered<NurseTriageController>()
        ? Get.find<NurseTriageController>()
        : null;
    if (nurseController == null) {
      debugPrint('NurseTriageController not available for profile sync');
      return;
    }

    final payload = _buildAadhaarProfileCardPayload(response);
    debugPrint('===== PROFILE PAYLOAD =====');
    debugPrint(payload.toString());
    nurseController.aadhaarProfileData.value = payload;
    nurseController.aadhaarProfileImported.value = true;

    // Extract and store profileId from verify response
    final profileId = extractAbhaProfileId(response);
    if (profileId != null && profileId > 0) {
      nurseController.currentProfileId.value = profileId.toString();
      log('[VERIFY ABHA] profileId extracted: $profileId');
    } else {
      log('[VERIFY ABHA] WARNING: profileId not found in verify response');
    }

    debugPrint('Opening shared profile card from verify flow');
    await nurseController.showAadhaarSuccessDialog(
      payload,
      returnToCaller: true,
    );
  }

  Future<bool> verifyOtp({required String otp}) async {
    if (otp.replaceAll(RegExp(r'\D'), '').length != 6) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'OTP must contain exactly 6 digits.',
        );
      }
      return false;
    }

    isLoading.value = true;
    try {
      final response = selectedMethod.value == 'abha-address-mobile' ||
              selectedMethod.value == 'abha-address-aadhaar'
          ? await _service.verifyAbhaAddressOtp(
              loginType: selectedLoginType.value,
              txnId: selectedTxnId.value,
              otp: otp,
            )
          : await _service.verifyOtp(
              loginType: selectedLoginType.value,
              txnId: selectedTxnId.value,
              otp: otp,
            );

      if (response == null) {
        lastApiError.value = {'message': 'Unable to verify OTP right now.'};
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: 'Unable to verify OTP right now.',
          );
        }
        return false;
      }

      debugPrint('verifyOtp response payload: $response');

      final success = response['success'] == true ||
          response['status'] == 'success' ||
          response['message']?.toString().toLowerCase().contains('success') ==
              true;
      debugPrint('verifyOtp success flag resolved to: $success');

      if (!success) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(Get.context!,
              response: response);
        }
        return false;
      }

      await _syncVerifiedResponse(response);
      return true;
    } catch (e) {
      log('Verify ABHA verify OTP exception: $e');
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      lastApiError.value = {'message': friendlyMessage};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: friendlyMessage.isNotEmpty
              ? friendlyMessage
              : 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
