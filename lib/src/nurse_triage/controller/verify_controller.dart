import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/abha_verified_profile.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_otp_utils.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';
import '../services/verify_service.dart';
import '../services/abha_error_message_service.dart';

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

    final abhaNumber =
        normalized.abhaNumber == 'Not Available' ? '' : normalized.abhaNumber;
    final preferredAbhaAddress =
        normalized.abhaAddress == 'Not Available' ? '' : normalized.abhaAddress;
    final residentialAddress =
        normalized.address == 'Not Available' ? '' : normalized.address;

    return <String, dynamic>{
      if (normalized.profileId != null) 'profileId': normalized.profileId,
      'ABHANumber': abhaNumber,
      'abhaNumber': abhaNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'name': normalized.name,
      'mobile': normalized.mobile == 'Not Available' ? '' : normalized.mobile,
      'mobileNumber':
          normalized.mobile == 'Not Available' ? '' : normalized.mobile,
      'address': residentialAddress,
      'residentialAddress': residentialAddress,
      'preferredAbhaAddress': preferredAbhaAddress,
      'abhaAddress': preferredAbhaAddress,
      'stateName': normalized.state == 'Not Available' ? '' : normalized.state,
      'districtName':
          normalized.district == 'Not Available' ? '' : normalized.district,
      'pinCode':
          normalized.pincode == 'Not Available' ? '' : normalized.pincode,
      'photo': normalized.profilePhoto,
      'profilePhoto': normalized.profilePhoto,
      'status': normalized.status,
      'accountStatus': normalized.status,
      'verificationStatus': normalized.verificationStatus,
      'verifiedStatus': normalized.verificationStatus,
      'verificationType': normalized.verificationType,
      'verificationMethod': normalized.verificationType,
      'gender': normalized.gender == 'Not Available' ? '' : normalized.gender,
      'dob': normalized.dateOfBirth == 'Not Available'
          ? ''
          : normalized.dateOfBirth,
      'dateOfBirth': normalized.dateOfBirth == 'Not Available'
          ? ''
          : normalized.dateOfBirth,
      'age': normalized.age,
    };
  }).toList(growable: false);

  return {
    'result': {
      'ABHAProfile':
          profilePayloads.length == 1 ? profilePayloads.first : profilePayloads,
    },
  };
}

class VerifyAbhaController extends GetxController {
  final VerifyAbhaService _service = VerifyAbhaService();
  String? _verifiedAbhaAccessToken;

  final RxList<Map<String, dynamic>> mobileSearchProfiles =
      <Map<String, dynamic>>[].obs;
  final RxString mobileSearchTxnId = ''.obs;
  final RxString mobileSearchOtpTxnId = ''.obs;
  final RxString mobileSearchNumber = ''.obs;
  final RxnInt selectedMobileSearchIndex = RxnInt();

  final RxString selectedLoginType = 'aadhaar-aadhaar-otp'.obs;
  final RxString selectedMethod = 'aadhaar'.obs;
  final RxString selectedLoginId = ''.obs;
  final RxString selectedTxnId = ''.obs;
  final RxString otpMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<Map<String, dynamic>> lastApiError = Rxn<Map<String, dynamic>>();
  final Rxn<Map<String, dynamic>> verifiedAuthResponse =
      Rxn<Map<String, dynamic>>();

  bool get _usesAbhaAccountDetails =>
      selectedMethod.value == 'aadhaar' ||
      selectedMethod.value == 'abha-aadhaar' ||
      selectedMethod.value == 'abha-abha';

  bool get _usesMobileAccountVerification =>
      selectedMethod.value == 'mobile' ||
      selectedMethod.value == 'mobile-search';

  bool get _usesPhrProfile =>
      selectedMethod.value == 'abha-address-mobile' ||
      selectedMethod.value == 'abha-address-aadhaar';

  String? _extractAccessToken(Map<String, dynamic> response) {
    const tokenKeys = {
      'accesstoken',
      'token',
      'ttoken',
      'xtoken',
      'abhausertoken',
    };

    String? findToken(Object? value) {
      if (value is Map) {
        for (final entry in value.entries) {
          if (tokenKeys.contains(entry.key
              .toString()
              .toLowerCase()
              .replaceAll('_', '')
              .replaceAll('-', ''))) {
            final token = entry.value?.toString().trim();
            if (token != null && token.isNotEmpty) return token;
          }
        }
        for (final nested in value.values) {
          final token = findToken(nested);
          if (token != null) return token;
        }
      } else if (value is List) {
        for (final item in value) {
          final token = findToken(item);
          if (token != null) return token;
        }
      }
      return null;
    }

    return findToken(response);
  }

  String? _extractAbhaNumber(Map<String, dynamic> response) {
    final accounts = response['accounts'];
    if (accounts is! List) return null;

    for (final account in accounts) {
      if (account is! Map) continue;
      for (final key in const ['ABHANumber', 'abhaNumber']) {
        final value = account[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }
    return null;
  }

  void setSelection({
    required String loginType,
    required String loginId,
    required String method,
  }) {
    _verifiedAbhaAccessToken = null;
    if (Get.isRegistered<NurseTriageController>()) {
      final nurseController = Get.find<NurseTriageController>();
      nurseController.verifiedAbhaAccessToken = null;
      nurseController.verifiedAbhaUsesPhrCard = false;
    }
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

  void clearMobileSearchResults() {
    mobileSearchProfiles.clear();
    mobileSearchTxnId.value = '';
    mobileSearchOtpTxnId.value = '';
    mobileSearchNumber.value = '';
    selectedMobileSearchIndex.value = null;
    if (selectedMethod.value == 'mobile-search') {
      selectedMethod.value = 'mobile';
      selectedLoginType.value = 'mobile-mobile-otp';
      selectedLoginId.value = '';
      selectedTxnId.value = '';
    }
  }

  int? mobileSearchRecordIndex(Map<String, dynamic> profile) {
    final value = profile['index'];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  List<Map<String, dynamic>> _extractMobileSearchProfiles(
    Map<String, dynamic> response,
  ) {
    Map<String, dynamic>? toStringMap(Object? value) {
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
      return null;
    }

    List<Map<String, dynamic>>? profilesFrom(Object? value) {
      if (value is List) {
        final profiles =
            value.map(toStringMap).whereType<Map<String, dynamic>>().toList();
        return profiles.isEmpty ? null : profiles;
      }
      final profile = toStringMap(value);
      return profile == null ? null : [profile];
    }

    List<Map<String, dynamic>>? search(Object? value, {int depth = 0}) {
      if (depth > 3) return null;
      if (value is List) {
        final profiles = profilesFrom(value);
        if (profiles != null) return profiles;
        for (final item in value) {
          final nested = search(item, depth: depth + 1);
          if (nested != null) return nested;
        }
        return null;
      }

      final map = toStringMap(value);
      if (map == null) return null;

      for (final key in const [
        'profiles',
        'accounts',
        'users',
        'ABHAProfile',
        'abhaProfiles',
        'records',
      ]) {
        final profiles = profilesFrom(map[key]);
        if (profiles != null) return profiles;
      }

      for (final key in const ['result', 'data', 'payload']) {
        final nested = search(map[key], depth: depth + 1);
        if (nested != null) return nested;
      }
      return null;
    }

    return search(response) ?? const [];
  }

  Object? _responseValue(
    Map<String, dynamic> response,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = response[key];
      if (value != null && value.toString().trim().isNotEmpty) return value;
    }

    for (final wrapperKey in const ['result', 'data', 'payload']) {
      final wrapper = response[wrapperKey];
      if (wrapper is Map) {
        for (final key in keys) {
          final value = wrapper[key];
          if (value != null && value.toString().trim().isNotEmpty) {
            return value;
          }
        }
      }
    }
    return null;
  }

  Future<bool> searchAbhaByMobile({required String mobile}) async {
    final normalizedMobile = normalizeInput(mobile);
    if (normalizedMobile.length != 10) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: AbhaErrorMessageService.invalid('mobile', incomplete: true),
        );
      }
      return false;
    }

    isLoading.value = true;
    clearMobileSearchResults();
    otpMessage.value = '';
    try {
      final response =
          await _service.searchAbhaByMobile(mobile: normalizedMobile);
      if (response == null || AbhaErrorMessageService.isFailure(response)) {
        lastApiError.value = response ??
            {
              'message': AbhaErrorMessageService.map(
                null,
                context: 'generateOtp',
              ),
            };
        if (Get.context != null) {
          if (response == null) {
            await CommonErrorDialog.show(
              Get.context!,
              message: AbhaErrorMessageService.map(
                null,
                context: 'generateOtp',
              ),
            );
          } else {
            await CommonErrorDialog.showFromResponse(
              Get.context!,
              response: response,
            );
          }
        }
        return false;
      }

      final txnId = _responseValue(response, const ['txnId'])?.toString();
      final profiles = _extractMobileSearchProfiles(response);
      if (txnId == null || txnId.isEmpty || profiles.isEmpty) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(
            Get.context!,
            response: {
              ...response,
              'message': 'No ABHA profiles were found for this mobile number.',
            },
          );
        }
        return false;
      }

      mobileSearchNumber.value = normalizedMobile;
      mobileSearchTxnId.value = txnId;
      mobileSearchProfiles.assignAll(profiles);
      lastApiError.value = null;
      return true;
    } catch (error) {
      log('Verify ABHA mobile search exception: $error');
      lastApiError.value = {'message': error.toString()};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: AbhaErrorMessageService.map(
            error,
            context: 'generateOtp',
          ),
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendMobileSearchOtp({required int index}) async {
    final selectedRecord = mobileSearchProfiles.where(
      (profile) => mobileSearchRecordIndex(profile) == index,
    );
    if (selectedRecord.isEmpty || mobileSearchTxnId.value.isEmpty) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Select an ABHA profile before requesting an OTP.',
        );
      }
      return false;
    }

    isLoading.value = true;
    try {
      final response = await _service.sendAbhaSearchOtp(
        txnId: mobileSearchTxnId.value,
        index: index,
      );
      if (response == null || AbhaErrorMessageService.isFailure(response)) {
        lastApiError.value = response ??
            {
              'message': AbhaErrorMessageService.map(
                null,
                context: 'generateOtp',
              ),
            };
        if (Get.context != null) {
          if (response == null) {
            await CommonErrorDialog.show(
              Get.context!,
              message: AbhaErrorMessageService.map(
                null,
                context: 'generateOtp',
              ),
            );
          } else {
            await CommonErrorDialog.showFromResponse(
              Get.context!,
              response: response,
            );
          }
        }
        return false;
      }

      final otpTxnId =
          _responseValue(response, const ['otpTxnId', 'txnId'])?.toString();
      if (otpTxnId == null || otpTxnId.isEmpty) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(
            Get.context!,
            response: response,
          );
        }
        return false;
      }

      selectedMobileSearchIndex.value = index;
      mobileSearchOtpTxnId.value = otpTxnId;
      selectedLoginType.value = 'mobile-search-otp';
      selectedMethod.value = 'mobile-search';
      selectedLoginId.value = mobileSearchNumber.value;
      selectedTxnId.value = otpTxnId;
      otpMessage.value =
          _responseValue(response, const ['message'])?.toString() ?? '';
      lastApiError.value = null;
      return true;
    } catch (error) {
      log('Verify ABHA mobile search OTP request exception: $error');
      lastApiError.value = {'message': error.toString()};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: AbhaErrorMessageService.map(
            error,
            context: 'generateOtp',
          ),
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
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
    final normalizedLoginId = method == 'mobile' || method == 'aadhaar'
        ? normalizeInput(loginId)
        : loginId.trim();

    if (!validateInput(method: method, value: normalizedLoginId)) {
      final message = normalizedLoginId.isEmpty
          ? AbhaErrorMessageService.required(method == 'mobile'
              ? 'mobile'
              : method == 'aadhaar'
                  ? 'aadhaar'
                  : method.startsWith('abha-address')
                      ? 'abhaAddress'
                      : 'abhaNumber')
          : AbhaErrorMessageService.invalid(
              method == 'mobile'
                  ? 'mobile'
                  : method == 'aadhaar'
                      ? 'aadhaar'
                      : method.startsWith('abha-address')
                          ? 'abhaAddress'
                          : 'abhaNumber',
              incomplete: method == 'aadhaar' || method == 'mobile');

      if (Get.context != null) {
        await CommonErrorDialog.show(Get.context!, message: message);
      }
      return false;
    }

    final loginType = resolveLoginType(method: method);
    final requestLoginId = method == 'abha-aadhaar' ||
            method == 'abha-abha' ||
            method == 'abha-address-mobile' ||
            method == 'abha-address-aadhaar'
        ? loginId.trim()
        : normalizedLoginId;

    setSelection(
      loginType: loginType,
      loginId: requestLoginId,
      method: method,
    );

    if (method == 'abha-address-mobile' || method == 'abha-address-aadhaar') {
      debugPrint('=============================');
      debugPrint('VERIFY ABHA ADDRESS');
      debugPrint('Authentication Method : $method');
      debugPrint('loginType : $loginType');
    }

    isLoading.value = true;
    try {
      final response =
          method == 'abha-address-mobile' || method == 'abha-address-aadhaar'
              ? await _service.sendAbhaAddressOtp(
                  loginType: loginType,
                  loginId: requestLoginId,
                )
              : await _service.sendOtp(
                  loginType: loginType,
                  loginId: requestLoginId,
                );
      if (response == null) {
        final message =
            AbhaErrorMessageService.map(null, context: 'generateOtp');
        lastApiError.value = {'message': message};
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: message,
          );
        }
        return false;
      }

      if (AbhaErrorMessageService.isFailure(response)) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(
            Get.context!,
            response: response,
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
          await CommonErrorDialog.showFromResponse(
            Get.context!,
            response: response,
          );
        }
        return false;
      }

      return true;
    } catch (e) {
      log('Verify ABHA send OTP exception: $e');
      final friendlyMessage =
          AbhaErrorMessageService.map(e, context: 'generateOtp');
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
    if (selectedMethod.value == 'mobile-search') {
      final index = selectedMobileSearchIndex.value;
      if (index == null) return false;
      return sendMobileSearchOtp(index: index);
    }
    return sendOtp(
      method: selectedMethod.value,
      loginId: selectedLoginId.value,
    );
  }

  Map<String, dynamic> normalizeVerifyResponsePayload(
      Map<String, dynamic> response) {
    if (response.isEmpty) return response;

    final wrappedResult = response['result'];
    if (wrappedResult is Map &&
        (wrappedResult['ABHAProfile'] is Map ||
            wrappedResult['profile'] is Map)) {
      return response;
    }

    final wrappedData = response['data'];
    if (wrappedData is Map &&
        (wrappedData['ABHAProfile'] is Map || wrappedData['profile'] is Map)) {
      return response;
    }

    if (response.containsKey('ABHAProfile') && response['ABHAProfile'] is Map) {
      return response;
    }

    final hasProfileLikeFields = response.containsKey('ABHANumber') ||
        response.containsKey('abhaNumber') ||
        response.containsKey('name') ||
        response.containsKey('mobile') ||
        response.containsKey('profileId') ||
        response.containsKey('id');

    if (!hasProfileLikeFields) {
      return response;
    }

    final profilePayload = <String, dynamic>{};
    for (final entry in response.entries) {
      profilePayload[entry.key] = entry.value;
    }

    return {
      'result': {
        'ABHAProfile': profilePayload,
      },
    };
  }

  Map<String, dynamic> _buildAadhaarProfileCardPayload(
      Map<String, dynamic> response) {
    final normalizedResponse = normalizeVerifyResponsePayload(response);
    return buildProfileCardPayloadFromVerifyResponse(normalizedResponse);
  }

  int? _resolveProfileIdFromResponse(Map<String, dynamic> response) {
    final normalizedResponse = normalizeVerifyResponsePayload(response);

    final directProfileId = extractAbhaProfileId(normalizedResponse);
    if (directProfileId != null && directProfileId > 0) {
      return directProfileId;
    }

    final parsedProfiles =
        AbhaVerifiedProfile.fromResponseList(normalizedResponse);
    for (final parsedProfile in parsedProfiles) {
      final parsedProfileId = parsedProfile.profileId;
      if (parsedProfileId != null && parsedProfileId > 0) {
        return parsedProfileId;
      }
    }

    final payload = _buildAadhaarProfileCardPayload(normalizedResponse);
    final payloadProfileId = extractAbhaProfileId(payload);
    if (payloadProfileId != null && payloadProfileId > 0) {
      return payloadProfileId;
    }

    return null;
  }

  Map<String, dynamic> _injectProfileIdIntoPayload(
    Map<String, dynamic> payload,
    int? profileId,
  ) {
    if (profileId == null || profileId <= 0) return payload;

    final enriched = <String, dynamic>{...payload};
    enriched['profileId'] = profileId;

    final result = enriched['result'];
    if (result is Map) {
      final abhaProfile = result['ABHAProfile'];
      if (abhaProfile is Map) {
        abhaProfile['profileId'] = profileId;
      }
      if (result['profile'] is Map) {
        result['profile']['profileId'] = profileId;
      }
    }

    final profile = enriched['ABHAProfile'];
    if (profile is Map) {
      profile['profileId'] = profileId;
    }

    return enriched;
  }

  Future<void> _syncVerifiedResponse(
    Map<String, dynamic> response, {
    String? accessToken,
    bool usePhrCard = false,
  }) async {
    final normalizedResponse = normalizeVerifyResponsePayload(response);

    verifiedAuthResponse.value = normalizedResponse;

    final nurseController = Get.isRegistered<NurseTriageController>()
        ? Get.find<NurseTriageController>()
        : null;
    if (nurseController == null) {
      debugPrint('NurseTriageController not available for profile sync');
      return;
    }

    nurseController.verifiedAbhaAccessToken = accessToken;
    nurseController.verifiedAbhaUsesPhrCard = usePhrCard;
    nurseController.clearAbhaCardPreviewCache();
    final profileId = _resolveProfileIdFromResponse(normalizedResponse);
    final payload = _buildAadhaarProfileCardPayload(normalizedResponse);
    final enrichedPayload = _injectProfileIdIntoPayload(payload, profileId);

    nurseController.aadhaarProfileData.value = enrichedPayload;
    nurseController.verifiedAbhaProfileData.value = enrichedPayload;
    nurseController.aadhaarProfileImported.value = true;

    if (profileId != null && profileId > 0) {
      nurseController.currentProfileId.value = profileId.toString();
      if (nurseController.createTriageModel.value?.triage != null) {
        nurseController.createTriageModel.value!.triage!.abhaProfileId =
            profileId;
      }
      log('[VERIFY ABHA] profileId extracted: $profileId');
    } else {
      final fallbackProfileId = extractAbhaProfileId(enrichedPayload);
      if (fallbackProfileId != null && fallbackProfileId > 0) {
        nurseController.currentProfileId.value = fallbackProfileId.toString();
        if (nurseController.createTriageModel.value?.triage != null) {
          nurseController.createTriageModel.value!.triage!.abhaProfileId =
              fallbackProfileId;
        }
      }
      log('[VERIFY ABHA] WARNING: profileId not found in verify response');
    }

    debugPrint('Verified ABHA profile is ready for the caller to display');
  }

  Future<bool> verifyOtp({required String otp}) async {
    if (otp.replaceAll(RegExp(r'\D'), '').length != 6) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: otp.trim().isEmpty
              ? AbhaErrorMessageService.required('otp')
              : AbhaErrorMessageService.invalid('otp', incomplete: true),
        );
      }
      return false;
    }

    isLoading.value = true;
    try {
      final response = selectedMethod.value == 'mobile-search'
          ? await _service.verifyAbhaSearchOtp(
              otpTxnId: mobileSearchOtpTxnId.value,
              otp: otp,
            )
          : selectedMethod.value == 'abha-address-mobile' ||
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
        final message = AbhaErrorMessageService.map(null, context: 'otp');
        lastApiError.value = {'message': message};
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: message,
          );
        }
        return false;
      }

      if (AbhaErrorMessageService.isFailure(response)) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(
            Get.context!,
            response: response,
          );
        }
        return false;
      }

      final success = response['success'] == true ||
          response['status'] == 'success' ||
          response['message']?.toString().toLowerCase().contains('success') ==
              true;
      debugPrint('verifyOtp success flag resolved to: $success');

      if (!success) {
        lastApiError.value = response;
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(Get.context!, response: {
            ...response,
            'message': AbhaErrorMessageService.map(response, context: 'otp'),
          });
        }
        return false;
      }

      if (_usesMobileAccountVerification) {
        final txnId = _responseValue(response, const ['txnId'])?.toString();
        final otpToken = _extractAccessToken(response);
        final abhaNumber = _extractAbhaNumber(response);
        if (txnId == null ||
            txnId.trim().isEmpty ||
            otpToken == null ||
            abhaNumber == null) {
          const message =
              'Mobile verification succeeded, but the response is missing the transaction ID, token, or ABHA number.';
          lastApiError.value = {'message': message};
          if (Get.context != null) {
            await CommonErrorDialog.show(
              Get.context!,
              message: message,
            );
          }
          return false;
        }

        final verifiedUser = await _service.verifyAbhaUser(
          abhaNumber: abhaNumber,
          txnId: txnId,
          tToken: otpToken,
        );
        if (verifiedUser == null ||
            AbhaErrorMessageService.isFailure(verifiedUser)) {
          lastApiError.value =
              verifiedUser ?? {'message': 'Unable to verify the ABHA user.'};
          if (Get.context != null) {
            await CommonErrorDialog.showFromResponse(
              Get.context!,
              response: lastApiError.value!,
            );
          }
          return false;
        }

        _verifiedAbhaAccessToken = _extractAccessToken(verifiedUser);
        if (_verifiedAbhaAccessToken == null) {
          const message =
              'ABHA user verification succeeded, but no account-details token was returned.';
          lastApiError.value = {'message': message};
          if (Get.context != null) {
            await CommonErrorDialog.show(
              Get.context!,
              message: message,
            );
          }
          return false;
        }
      } else if (_usesAbhaAccountDetails || _usesPhrProfile) {
        _verifiedAbhaAccessToken = _extractAccessToken(response);
        if (_verifiedAbhaAccessToken == null) {
          const message =
              'Verification succeeded, but no ABHA access token was returned.';
          lastApiError.value = {'message': message};
          if (Get.context != null) {
            await CommonErrorDialog.show(
              Get.context!,
              message: message,
            );
          }
          return false;
        }
      } else {
        await _syncVerifiedResponse(response);
        return true;
      }

      final profileDetails = _usesPhrProfile
          ? await _service.getAbhaPhrProfile(
              accessToken: _verifiedAbhaAccessToken!,
            )
          : await _service.getAbhaAccountDetails(
              accessToken: _verifiedAbhaAccessToken!,
            );
      if (profileDetails == null ||
          AbhaErrorMessageService.isFailure(profileDetails)) {
        lastApiError.value = profileDetails ??
            {
              'message': _usesPhrProfile
                  ? 'Unable to retrieve ABHA PHR profile details.'
                  : 'Unable to retrieve ABHA account details.',
            };
        if (Get.context != null) {
          await CommonErrorDialog.showFromResponse(
            Get.context!,
            response: lastApiError.value!,
          );
        }
        return false;
      }
      await _syncVerifiedResponse(
        profileDetails,
        accessToken: _verifiedAbhaAccessToken,
        usePhrCard: _usesPhrProfile,
      );
      return true;
    } catch (e) {
      log('Verify ABHA verify OTP exception: $e');
      final friendlyMessage = AbhaErrorMessageService.map(e, context: 'otp');
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
