import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_108_caselist_model.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_dashboard_model.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_details_model.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_list_model.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_lookup_model.dart';
import 'package:taei_gov/src/transit_care/model/transit_care_model.dart';
import 'package:taei_gov/src/transit_care/model/transitcare_dashboard_count_model.dart';
import 'package:taei_gov/src/emo_user/model/emo_lookup_model.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import '../models/create_triage_model.dart';
import '../models/update_mobile_verify_otp_response.dart';
import '../services/triage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/face_rd_service.dart';
import '../utils/abha_debug_logger.dart';
import '../utils/abha_otp_utils.dart';

class NurseTriageController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxString searchController = ''.obs;

  RxString faceTxnId = ''.obs;
  RxBool isFaceLoading = false.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  static final _client = CustomHttpHelper();

  var triageDetails = Rxn<TriageDetailsModel>();

  var triage108CaseList = <CaseListData>[].obs;

  var lookupList = Rxn<TriageLookupModel>();
  RxBool isLookupLoading = true.obs;

  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  /// Prem Below 12 years
  var premBelow12Years = false.obs;

  Future<bool> getLookup() async {
    try {
      lookupList.value = null;
      var data = await TriageService.getLookup();
      log("Triage Lookup ${data.toString()}");
      if (data != null) {
        lookupList.value = data;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool isValidAadhaar(String? aadhaar) {
    return aadhaar != null && RegExp(r'^[0-9]{12}$').hasMatch(aadhaar);
  }

  String _maskValue(String? value, {int visibleChars = 4}) {
    if (value == null || value.isEmpty) return 'n/a';
    final digits = value.toString();
    if (digits.length <= visibleChars) return '*${digits.substring(0, digits.length)}';
    final suffix = digits.substring(digits.length - visibleChars);
    return '${'*' * (digits.length - visibleChars)}$suffix';
  }

  String _maskOtp(String? otp) {
    if (otp == null || otp.isEmpty) return 'n/a';
    return '*' * otp.length;
  }

  void _logFlow(String message) => log(message);

  RxString aadhaarTxnId = ''.obs;
  RxString currentProfileId = ''.obs;
  RxString currentMobile = ''.obs;
  RxString aadhaarOtpDeliveryMessage = ''.obs;
  final Rxn<Map<String, dynamic>> lastApiError = Rxn<Map<String, dynamic>>();

  Future<bool> sendAadhaarOtp({String? flowId}) async {
    String? aadhaar = createTriageModel.value?.triage?.aadhaar;

    // ✅ REMOVE DASHES AND NON-DIGITS
    aadhaar = aadhaar?.replaceAll(RegExp(r'\D'), '');

    log('sendAadhaarOtp inputs: aadhaar=$aadhaar');

    if (!isValidAadhaar(aadhaar)) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Please enter a valid 12-digit Aadhaar number.',
        );
      }
      return false;
    }

    try {
      _logFlow('========== CREATE ABHA AADHAAR FLOW ==========');
      _logFlow('[AADHAAR] Aadhaar number entered');
      _logFlow('[AADHAAR] Aadhaar number length: ${aadhaar?.length ?? 0}');
      _logFlow('[AADHAAR] Calling generate OTP API...');
      _logFlow('[AADHAAR] Request: aadhaar=${_maskValue(aadhaar)}');

      isSendingAadhaarOtp.value = true;
      aadhaarOtpSent.value = false;
      aadhaarVerified.value = false;
      mobileUpdateTxnId.value = '';
      currentProfileId.value = '';

      final d = await TriageService.sendAadhaarOtp(
        aadhaar: aadhaar!,
        flowId: flowId,
      );

      if (d != null) {
        _logFlow('[AADHAAR] Generate OTP response received');
        _logFlow('[AADHAAR] Response: $d');

        final responseMessage = CommonErrorDialog.extractErrorMessage(d);
        final txnId = d['txnId'] ?? d['data']?['txnId'];
        final deliveryMessage = d['message'] ?? d['data']?['message'] ?? '';

        if (txnId != null) {
          aadhaarTxnId.value = txnId.toString();
          _logFlow('[AADHAAR] Transaction ID received: ${_maskValue(txnId.toString(), visibleChars: 6)}');
        } else {
          _logFlow('[AADHAAR] ERROR: transaction ID missing in generate OTP response');
        }

        if (deliveryMessage.toString().trim().isNotEmpty) {
          aadhaarOtpDeliveryMessage.value = deliveryMessage.toString().trim();
        }

        if (txnId == null && responseMessage.isNotEmpty) {
          lastApiError.value = d;
          if (Get.context != null) {
            await CommonErrorDialog.showFromResponse(
              Get.context!,
              response: d,
            );
          }
          return false;
        }

        aadhaarOtpSent.value = true;
        _logFlow('[AADHAAR] OTP sent successfully');
        _startAadhaarOtpTimer();
        return true;
      }

      lastApiError.value = {'message': 'Unable to send Aadhaar OTP right now.'};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Unable to send Aadhaar OTP right now.',
        );
      }
      return false;
    } catch (e) {
      log('sendAadhaarOtp exception: $e');
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
      isSendingAadhaarOtp.value = false;
    }
  }

  Future<bool> verifyAadhaarOtp({bool showDialog = true, String? flowId}) async {
    final otp = aadhaarOtp.value;
    final txnId = aadhaarTxnId.value;
    final mobile = createTriageModel.value?.triage?.patientMobileNumber;
    log('verifyAadhaarOtp inputs: txnId=$txnId, otp=$otp, mobile=$mobile');

    if (txnId.isEmpty) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Please request a new OTP and try again.',
        );
      }
      return false;
    }
    if (otp.isEmpty) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Please enter the complete 6-digit OTP.',
        );
      }
      return false;
    }
    if (mobile == null || mobile.length != 10) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Please enter a valid 10-digit mobile number.',
        );
      }
      return false;
    }

    try {
      _logFlow('========== AADHAAR OTP VERIFICATION ==========');
      _logFlow('[AADHAAR OTP] OTP entered');
      _logFlow('[AADHAAR OTP] OTP length: ${otp.length}');
      _logFlow('[AADHAAR OTP] Transaction ID exists: ${txnId.isNotEmpty}');
      _logFlow('[AADHAAR OTP] Calling verify OTP API...');

      final d = await TriageService.verifyAadhaarOtp(
        txnId: txnId,
        otp: otp,
        mobile: mobile,
        flowId: flowId,
      );
      _logFlow('[AADHAAR OTP] Verify response received');
      _logFlow('[AADHAAR OTP] Response: $d');

      if (d == null) {
        aadhaarVerified.value = false;
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: 'Unable to verify Aadhaar OTP.',
          );
        }
        return false;
      }

      final backendMessage = CommonErrorDialog.extractErrorMessage(d);
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(d);
      final isFailure = d['success'] == false ||
          d['status'] == 'failed' ||
          d['status'] == 'error' ||
          (backendMessage.isNotEmpty &&
              !d.containsKey('result') &&
              !d.containsKey('profileId') &&
              !d.containsKey('abhaNumber') &&
              !d.containsKey('address'));
      final hasSuccessPayload = d['result'] != null ||
          d['profileId'] != null ||
          d['data']?['profileId'] != null ||
          d['abhaNumber'] != null ||
          d['address'] != null;

      if (isFailure && !hasSuccessPayload) {
        aadhaarVerified.value = false;
        lastApiError.value = d;
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            title: 'Unable to Continue',
            message: friendlyMessage.isNotEmpty
                ? friendlyMessage
                : 'OTP verification failed. Please enter the correct OTP and try again.',
          );
        }
        return false;
      }

      aadhaarVerified.value = true;
      _logFlow('[AADHAAR OTP] Verify success: true');

      final profileId = extractAbhaProfileId(d);
      if (profileId != null && profileId > 0) {
        currentProfileId.value = profileId.toString();
        createTriageModel.value?.triage?.abhaProfileId = profileId;
        _logFlow('[AADHAAR OTP] profileId extracted: true');
        _logFlow('[AADHAAR OTP] profileId: $profileId');
      } else {
        _logFlow('[AADHAAR OTP] ERROR: profileId was not found in verification response');
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: 'We couldn\'t continue with the mobile verification step. Please try again.',
          );
        }
        return false;
      }

      for (var c in otpControllers) {
        c.clear();
      }
      aadhaarOtp.value = '';

      showAadhaarSuccessDialog(d, showDialog: showDialog);

      return true;
    } catch (e) {
      log('verifyAadhaarOtp exception: $e');
      aadhaarVerified.value = false;
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
    }
  }

  Future<bool> sendMobileUpdateOtp({
    required int profileId,
    required String mobile,
    String? flowId,
  }) async {
    if (profileId <= 0) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'We could not identify your ABHA profile. Please try again.',
        );
      }
      return false;
    }

    if (mobile.length != 10) {
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Please enter a valid 10-digit mobile number.',
        );
      }
      return false;
    }

    try {
      _logFlow('========== MOBILE UPDATE OTP ==========');
      _logFlow('[MOBILE UPDATE] Starting send OTP');
      _logFlow('[MOBILE UPDATE] profileId available: true');
      _logFlow('[MOBILE UPDATE] mobile available: ${mobile.isNotEmpty}');
      _logFlow('[MOBILE UPDATE] mobile length: ${mobile.length}');
      _logFlow('[MOBILE UPDATE] Calling updatemobile/send-otp...');

      isSendingMobileUpdateOtp.value = true;
      mobileUpdateOtpSent.value = false;
      mobileUpdateVerified.value = false;

      final d = await TriageService.sendMobileUpdateOtp(
        profileId: profileId,
        mobile: mobile,
        flowId: flowId,
      );

      _logFlow('[MOBILE UPDATE] Send OTP response received');
      _logFlow('[MOBILE UPDATE] Response: $d');

      if (d == null) {
        _logFlow('[MOBILE UPDATE] ERROR: send OTP returned no payload');
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: 'We couldn\'t send the verification OTP to your mobile number. Please try again.',
          );
        }
        return false;
      }

      final txnId = d['txnId'] ?? d['data']?['txnId'];
      final deliveryMessage = d['message'] ?? d['data']?['message'] ?? '';
      if (txnId != null) {
        mobileUpdateTxnId.value = txnId.toString();
        _logFlow('[MOBILE UPDATE] mobileUpdateTxnId extracted: true');
        _logFlow('[MOBILE UPDATE] Transaction ID received successfully');
        if (deliveryMessage.toString().trim().isNotEmpty) {
          mobileUpdateOtpDeliveryMessage.value = deliveryMessage.toString().trim();
        }
        mobileUpdateOtpSent.value = true;
        return true;
      }

      _logFlow('[MOBILE UPDATE] ERROR: Transaction ID missing');

      lastApiError.value = d;
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: CommonErrorDialog.extractFriendlyErrorMessage(d),
        );
      }
      return false;
    } catch (e) {
      log('sendMobileUpdateOtp exception: $e');
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      lastApiError.value = {'message': friendlyMessage};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: friendlyMessage.isNotEmpty
              ? friendlyMessage
              : 'We couldn\'t send the verification OTP to your mobile number. Please try again.',
        );
      }
      return false;
    } finally {
      isSendingMobileUpdateOtp.value = false;
    }
  }

  Future<bool> verifyMobileUpdateOtp({
    required int profileId,
    required String txnId,
    required String otp,
    String? flowId,
  }) async {
    debugPrint('[ABHA][TRACE][FLOW:${flowId ?? 'unknown'}] ENTER controller.verifyMobileUpdateOtp');
    debugPrint('[ABHA][VALIDATION][FLOW:${flowId ?? 'unknown'}] profileId: $profileId');
    if (profileId <= 0) {
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] profileId is missing or invalid');
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'We could not verify your mobile number because the session expired. Please try again.',
        );
      }
      return false;
    }

    if (txnId.isEmpty) {
      debugPrint('[ABHA][VALIDATION][FLOW:${flowId ?? 'unknown'}] txnId present: false');
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'We could not verify your mobile number because the session expired. Please try again.',
        );
      }
      return false;
    }

    debugPrint('[ABHA][VALIDATION][FLOW:${flowId ?? 'unknown'}] txnId present: true');

    if (otp.isEmpty || otp.length != 6) {
      debugPrint('[ABHA][VALIDATION][FLOW:${flowId ?? 'unknown'}] OTP length: ${otp.length}');
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: 'Please enter the complete 6-digit OTP.',
        );
      }
      return false;
    }

    debugPrint('[ABHA][VALIDATION][FLOW:${flowId ?? 'unknown'}] OTP length: ${otp.length}');

    try {
      _logFlow('========== MOBILE OTP VERIFICATION ==========');
      _logFlow('[MOBILE OTP] OTP length: ${otp.length}');
      _logFlow('[MOBILE OTP] profileId available: ${profileId > 0}');
      _logFlow('[MOBILE OTP] mobileUpdateTxnId available: ${txnId.isNotEmpty}');
      _logFlow('[MOBILE OTP] Calling verify mobile OTP...');

      final d = await TriageService.verifyMobileUpdateOtp(
        profileId: profileId,
        txnId: txnId,
        otp: otp,
        flowId: flowId,
      );
      _logFlow('[MOBILE OTP] Verify response received');
      _logFlow('[MOBILE OTP] Response: $d');

      if (d == null) {
        mobileUpdateVerified.value = false;
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            message: 'We couldn\'t verify your mobile number. Please try again.',
          );
        }
        return false;
      }

      final payload = d is Map<String, dynamic> ? d : Map<String, dynamic>.from(d);
      final response = UpdateMobileVerifyOtpResponse.fromJson(payload);
      final backendAuth = (payload['authResult'] ?? '').toString().trim().toLowerCase();
      final isAuthSuccess = backendAuth == 'success' || response.isSuccess;

      if (!isAuthSuccess) {
        mobileUpdateVerified.value = false;
        lastApiError.value = payload;
        debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] update-mobile/verify-otp failed');
        debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] authResult: ${payload['authResult'] ?? 'missing'}');
        debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] RESPONSE BODY: ${jsonEncode(payload)}');
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            title: 'Unable to Continue',
            message: CommonErrorDialog.extractFriendlyErrorMessage(payload).isNotEmpty
                ? CommonErrorDialog.extractFriendlyErrorMessage(payload)
                : 'The mobile verification OTP is incorrect. Please check the OTP and try again.',
          );
        }
        return false;
      }

      debugPrint('============================================================');
      debugPrint('[ABHA][WORKFLOW][FLOW:${flowId ?? 'unknown'}] MOBILE OTP VERIFICATION SUCCESS');
      debugPrint('============================================================');
      debugPrint('[ABHA][WORKFLOW][FLOW:${flowId ?? 'unknown'}] authResult: success');
      debugPrint('[ABHA][WORKFLOW][FLOW:${flowId ?? 'unknown'}] Mobile number updated successfully');
      debugPrint('============================================================');

      mobileUpdateVerified.value = true;
      _logFlow('[MOBILE OTP] Verification success: true');
      return true;
    } catch (e, stackTrace) {
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] update-mobile/verify-otp exception: $e');
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] stackTrace: $stackTrace');
      log('verifyMobileUpdateOtp exception: $e');
      mobileUpdateVerified.value = false;
      final friendlyMessage = CommonErrorDialog.extractFriendlyErrorMessage(e);
      lastApiError.value = {'message': friendlyMessage};
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          message: friendlyMessage.isNotEmpty
              ? friendlyMessage
              : 'We couldn\'t verify your mobile number. Please try again.',
        );
      }
      return false;
    }
  }

  Future<void> processScannedAbhaQr(String rawValue) async {
    log("====================================");
    log("QR RAW SCANNED VALUE:");
    log(rawValue);
    log("====================================");

    try {
      final parsedPayload = jsonDecode(rawValue);

      log("JSON PARSED SUCCESSFULLY");
      log(parsedPayload.toString());

      // OLD EXISTING FORMAT
      if (parsedPayload['result'] != null &&
          parsedPayload['result']['ABHAProfile'] != null) {
        showAadhaarSuccessDialog(parsedPayload);
        return;
      }

      // NEW QR FORMAT CONVERSION
      if (parsedPayload['hidn'] != null || parsedPayload['name'] != null) {
        final fullName = parsedPayload['name']?.toString().trim() ?? '';

        final nameParts = fullName.split(' ');

        final convertedResult = {
          'result': {
            'ABHAProfile': {
              'ABHANumber': parsedPayload['hidn']?.toString() ??
                  parsedPayload['hid']?.toString() ??
                  'Not Available',
              'firstName': nameParts.isNotEmpty ? nameParts.first : '',
              'middleName': '',
              'lastName':
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
              'mobile': parsedPayload['mobile']?.toString() ?? 'Not Available',
              'address': parsedPayload['address']?.toString() ?? '',
              'stateName': parsedPayload['state name']?.toString() ?? '',
              'districtName': parsedPayload['district_name']?.toString() ?? '',
              'photo': null,
              'gender': parsedPayload['gender']?.toString() ?? '',
              'dob': parsedPayload['dob']?.toString() ?? '',
              'healthId': parsedPayload['hid']?.toString() ?? '',
            }
          }
        };

        createTriageModel.value?.triage?.abhaCard =
            convertedResult['result']!['ABHAProfile']!['ABHANumber'].toString();

        createTriageModel.refresh();

        showAadhaarSuccessDialog(convertedResult);
        return;
      }
    } catch (e) {
      log("JSON PARSE FAILED: $e");
    }

    Fluttertoast.showToast(
      msg: "Invalid QR format",
    );
  }

  Map<String, dynamic>? _tryParseJsonString(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  String? _extractAbhaNumber(String rawValue) {
    final normalized = rawValue.trim();
    final abhaNumberMatch = RegExp(r'(?:(?:ABHA|abha)[^0-9]*)([0-9]{12,20})')
        .firstMatch(normalized);
    if (abhaNumberMatch != null) {
      return abhaNumberMatch.group(1);
    }

    final digitsOnly = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length >= 12) {
      return digitsOnly;
    }
    return null;
  }

  Map<String, dynamic>? _resolveAbhaProfilePayload(Map<String, dynamic> d) {
    final candidates = <dynamic>[
      d['result']?['ABHAProfile'],
      d['result']?['profile'],
      d['result']?['data'],
      d['data']?['ABHAProfile'],
      d['data']?['profile'],
      d['ABHAProfile'],
      d['profile'],
    ];

    for (final candidate in candidates) {
      if (candidate is Map<String, dynamic>) {
        return candidate;
      }
      if (candidate is Map) {
        return Map<String, dynamic>.from(candidate);
      }
    }

    return null;
  }

  void showLastAadhaarProfileCard() {
    log('View ABHA button clicked');

    final data = aadhaarProfileData.value;
    if (data != null) {
      log('ABHA profile payload available in cache: ${data.keys}');
      if (_resolveAbhaProfilePayload(data) == null) {
        Fluttertoast.showToast(msg: 'No ABHA profile data available to view');
        return;
      }

      log('Opening existing ABHA profile popup from cached profile payload');
      showAadhaarSuccessDialog(data);
      return;
    }

    final triage = createTriageModel.value?.triage;
    final abhaCard = triage?.abhaCard?.trim() ?? '';
    if (abhaCard.isEmpty) {
      log('No ABHA profile data available to view');
      Fluttertoast.showToast(msg: 'No imported profile data available');
      return;
    }

    log('Falling back to local triage model data for ABHA profile popup');
    final fullName = (triage?.nameOfPatient ?? '').trim();
    final nameParts = fullName.split(RegExp(r'\s+'));
    final fallbackPayload = <String, dynamic>{
      'result': {
        'ABHAProfile': {
          'ABHANumber': abhaCard,
          'firstName': nameParts.isNotEmpty ? nameParts.first : '',
          'middleName': nameParts.length > 2 ? nameParts[1] : '',
          'lastName':
              nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          'mobile': triage?.patientMobileNumber ?? '',
          'address': triage?.addressLine ?? '',
          'stateName': '',
          'districtName': '',
          'photo': null,
        },
      },
    };

    log('Opening existing ABHA profile popup from fallback payload');
    showAadhaarSuccessDialog(fallbackPayload);
  }

  RxBool isDownloadingAbhaCard = false.obs;

  Future<void> downloadAbhaCard({String? flowId}) async {
    final profileIdStr = currentProfileId.value.trim();

    log('[ABHA CARD][DOWNLOAD] Button clicked');
    debugPrint('[ABHA][CARD][FLOW:${flowId ?? 'unknown'}] DOWNLOAD ABHA CARD PRESSED');

    // Prevent duplicate clicks
    if (isDownloadingAbhaCard.value) {
      log('[ABHA CARD][DOWNLOAD] Already downloading, ignoring duplicate click');
      return;
    }

    // Validate profileId
    if (profileIdStr.isEmpty) {
      log('[ABHA CARD][DOWNLOAD] profileId missing');
      Fluttertoast.showToast(
        msg: 'ABHA card is not available yet. Please complete ABHA verification first.',
      );
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          title: 'ABHA Card Not Available',
          message: 'ABHA card is not available yet. Please complete ABHA verification first.',
        );
      }
      return;
    }

    final profileId = int.tryParse(profileIdStr);
    if (profileId == null || profileId <= 0) {
      log('[ABHA CARD][DOWNLOAD] profileId invalid: $profileIdStr');
      Fluttertoast.showToast(
        msg: 'ABHA card is not available yet. Please complete ABHA verification first.',
      );
      if (Get.context != null) {
        await CommonErrorDialog.show(
          Get.context!,
          title: 'Invalid ABHA Profile',
          message: 'ABHA profile ID is invalid. Please try again.',
        );
      }
      return;
    }

    isDownloadingAbhaCard.value = true;
    try {
      log('[ABHA CARD][DOWNLOAD] profileId available: true');
      log('[ABHA CARD][DOWNLOAD] profileId: $profileId');

      // Call backend API to download official ABHA card
      final result = await TriageService.downloadAbhaCard(
        profileId: profileId,
        flowId: flowId,
      );

      if (result['success'] != true) {
        final errorMessage = result['error']?.toString() ??
            'Unable to download the ABHA card. Please try again.';
        log('[ABHA CARD][DOWNLOAD][ERROR] ${result["error"]}');

        Fluttertoast.showToast(msg: errorMessage);
        if (Get.context != null) {
          await CommonErrorDialog.show(
            Get.context!,
            title: 'Download Failed',
            message: errorMessage,
          );
        }
        return;
      }

      // Extract downloaded bytes and file info
      final bytes = result['bytes'] as Uint8List?;
      final contentType = result['contentType']?.toString() ?? 'application/octet-stream';
      final filename = result['filename']?.toString() ?? 'ABHA_Card.pdf';

      if (bytes == null || bytes.isEmpty) {
        log('[ABHA CARD][DOWNLOAD][ERROR] Downloaded bytes are empty');
        Fluttertoast.showToast(msg: 'ABHA card download returned empty file.');
        return;
      }

      log('[ABHA CARD][DOWNLOAD] Download response received');
      log('[ABHA CARD][DOWNLOAD] Filename: $filename');
      log('[ABHA CARD][DOWNLOAD] Content-Type: $contentType');
      log('[ABHA CARD][DOWNLOAD] Byte Length: ${bytes.length}');

      // Trigger browser download
      log('[ABHA CARD][DOWNLOAD] WEB DOWNLOAD START');
      await _triggerWebDownloadForBackendCard(bytes, filename, contentType);
      log('[ABHA CARD][DOWNLOAD] WEB DOWNLOAD SUCCESS');

      debugPrint(
        '[ABHA][CARD][FLOW:${flowId ?? 'unknown'}] ABHA CARD DOWNLOAD SUCCESS',
      );
      Fluttertoast.showToast(msg: 'ABHA Card downloaded successfully.');
      log('[ABHA CARD][DOWNLOAD] SUCCESS');
    } catch (e) {
      debugPrint(
        '[ABHA][CARD][FLOW:${flowId ?? 'unknown'}] ABHA CARD DOWNLOAD FAILED',
      );
      debugPrint(
        '[ABHA][CARD][FLOW:${flowId ?? 'unknown'}] Error: ${e.toString()}',
      );
      log('[ABHA CARD][DOWNLOAD][ERROR] ${e.toString()}');
      Fluttertoast.showToast(
        msg: 'Unable to download the ABHA Card. Please try again.',
      );
    } finally {
      isDownloadingAbhaCard.value = false;
    }
  }

  Future<void> _triggerWebDownloadForBackendCard(
    Uint8List fileBytes,
    String filename,
    String contentType,
  ) async {
    try {
      log('[ABHA CARD][WEB DOWNLOAD] Starting web download');
      log('[ABHA CARD][WEB DOWNLOAD] Filename: $filename');
      log('[ABHA CARD][WEB DOWNLOAD] Content-Type: $contentType');

      // Use universal_html for web-safe download
      final blob = html.Blob([fileBytes], contentType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = filename
        ..style.display = 'none';

      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);

      log('[ABHA CARD][WEB DOWNLOAD] Browser download triggered: $filename');
    } catch (e) {
      log('[ABHA CARD][WEB DOWNLOAD][ERROR] Web download mechanism failed: $e');
      rethrow;
    }
  }

  void _applyAadhaarResponseData(Map<String, dynamic> d) {
    log("APPLY FUNCTION CALLED: $d");

    final data = _resolveAbhaProfilePayload(d);
    final triage = createTriageModel.value?.triage;
    if (triage == null || data == null) return;

    log("ABHA Profile data: $data");

    // ✅ Mark profile as imported
    aadhaarProfileImported.value = true;

    // ✅ Name
    final firstName = data['firstName']?.toString() ?? '';
    final middleName = data['middleName']?.toString() ?? '';
    final lastName = data['lastName']?.toString() ?? '';

    triage.nameOfPatient =
        "$firstName $middleName $lastName".trim().replaceAll(RegExp(' +'), ' ');

    // ✅ Mobile
    triage.patientMobileNumber = data['mobile']?.toString() ??
        data['mobileNumber']?.toString() ??
        triage.patientMobileNumber;

// ✅ ABHA ID
    triage.abhaCard = data['ABHANumber']?.toString() ??
        data['abhaNumber']?.toString() ??
        triage.abhaCard;

    // ✅ ABHA Profile ID for card download - try multiple possible field names
    log("Looking for profile ID in data keys: ${data.keys}");
    if (data['id'] != null) {
      triage.abhaProfileId = int.tryParse(data['id'].toString());
      log("Found abhaProfileId from 'id': ${triage.abhaProfileId}");
    } else if (data['profileId'] != null) {
      triage.abhaProfileId = int.tryParse(data['profileId'].toString());
      log("Found abhaProfileId from 'profileId': ${triage.abhaProfileId}");
    } else if (data['abhaProfileId'] != null) {
      triage.abhaProfileId = int.tryParse(data['abhaProfileId'].toString());
      log("Found abhaProfileId from 'abhaProfileId': ${triage.abhaProfileId}");
    } else if (data['ABHAProfileId'] != null) {
      triage.abhaProfileId = int.tryParse(data['ABHAProfileId'].toString());
      log("Found abhaProfileId from 'ABHAProfileId': ${triage.abhaProfileId}");
    } else {
      log("WARNING: No profile ID found in ABHA response data");
    }

    if (triage.abhaCard != null && triage.abhaCard!.isNotEmpty) {
      showCreateAbha.value = false;
      aadhaarOtpSent.value = false;
      aadhaarVerified.value = true;
    }

    // ✅ Address
    final residentialAddress = data['residentialAddress']?.toString() ??
        data['address']?.toString() ??
        '';
    if (residentialAddress.isNotEmpty) {
      triage.addressLine = residentialAddress;
    }

    final pincode =
        data['pinCode']?.toString() ?? data['pincode']?.toString() ?? '';
    if (pincode.isNotEmpty) {
      triage.pincode = pincode;
    }

    // ✅ Gender
    final gender = data['gender']?.toString();
    if (gender != null) {
      triage.gender = _mapGenderToLookupId(gender);
    }

    // ✅ State
    final stateName = data['stateName']?.toString();
    if (stateName != null) {
      triage.state = _mapStateNameToLookupId(stateName);
    }

    // ✅ District
    final districtName = data['districtName']?.toString();
    if (districtName != null) {
      triage.district = _mapDistrictNameToLookupId(districtName);
    }

    // ✅ DOB → Age
    final dob = data['dob']?.toString();
    if (dob != null) {
      _applyAgeFromDob(dob);
    }

    createTriageModel.refresh();
    debugPrint(
        'Applied Aadhaar fields: ${createTriageModel.value?.triage?.toJson()}');
    log("FINAL TRIAGE: ${triage.toJson()}");
  }

  // Helper method to get masked mobile number as stars
  String getMaskedMobileNumber(String? mobileNumber) {
    if (mobileNumber == null || mobileNumber.isEmpty) {
      return '';
    }
    final len = mobileNumber.length;
    return '*' * len; // mask the number with stars
  }

  int? _mapGenderToLookupId(String gender) {
    if (lookupList.value?.genders == null) return null;
    final token = gender.toLowerCase();
    final found = lookupList.value!.genders!.firstWhere(
      (e) {
        if (e.name == null) return false;
        final n = e.name!.toLowerCase();
        return n == token || n.startsWith(token) || token.startsWith(n);
      },
      orElse: () => LooksUpItem(),
    );
    return found.id;
  }

  int? _mapStateNameToLookupId(String stateName) {
    if (lookupList.value?.state == null) return null;
    final token = stateName.toLowerCase();
    final found = lookupList.value!.state!.firstWhere(
      (e) => e.name != null && e.name!.toLowerCase().contains(token),
      orElse: () => LooksUpItem(),
    );
    return found.id;
  }

  int? _mapDistrictNameToLookupId(String districtName) {
    if (lookupList.value?.district == null) return null;
    final token = districtName.toLowerCase();
    final found = lookupList.value!.district!.firstWhere(
      (e) => e.name != null && e.name!.toLowerCase().contains(token),
      orElse: () => LooksUpItem(),
    );
    return found.id;
  }

  void _applyAgeFromDob(String dob) {
    try {
      // API format: dd-MM-yyyy
      final parts = dob.split('-');
      if (parts.length != 3) return;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int years = today.year - birthDate.year;
      int months = today.month - birthDate.month;

      // ✅ adjust if birthday not yet reached this year
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        years--;
        months = today.month + (12 - birthDate.month);
      }

      // ✅ fix negative month
      if (months < 0) {
        months += 12;
      }

      final triage = createTriageModel.value?.triage;
      if (triage != null) {
        triage.ageYear = years;
        triage.ageMonth = months;
      }

      log("AGE CALCULATED: $years years, $months months");
    } catch (e) {
      log("DOB ERROR: $e");
    }
  }

  var selectedEHR = Rxn<String>();

  RxBool isSendingAadhaarOtp = false.obs;
  RxBool aadhaarOtpSent = false.obs;
  RxBool aadhaarVerified = false.obs;
  RxBool isSendingMobileUpdateOtp = false.obs;
  RxBool mobileUpdateOtpSent = false.obs;
  RxBool mobileUpdateVerified = false.obs;
  RxBool showCreateAbha = false.obs;
  RxBool aadhaarProfileImported = false.obs;
  Rxn<Map<String, dynamic>> aadhaarProfileData = Rxn<Map<String, dynamic>>();
  RxString aadhaar = ''.obs;
  RxString aadhaarOtp = ''.obs;
  RxString mobileUpdateTxnId = ''.obs;
  RxString mobileUpdateOtpDeliveryMessage = ''.obs;
  List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  RxInt aadhaarOtpRemainingSeconds = 0.obs;
  Timer? aadhaarOtpTimer;
  RxString lastAadhaarSent = ''.obs;
  TextEditingController aadhaarController = TextEditingController();

  void showAadhaarInfoPopup({FutureOr<void> Function()? onContinue}) {
    Get.dialog(
      AlertDialog(
        title: Text("Aadhaar Verification"),
        content: Text(
          "OTP will be sent to Aadhaar registered mobile number.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // close popup
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // close popup
              if (onContinue != null) {
                onContinue();
                return;
              }

              // ✅ open Aadhaar section
              showCreateAbha.value = true;

              // ✅ reset values
              aadhaarController.clear();
              aadhaar.value = '';
              aadhaarOtpSent.value = false;
              aadhaarVerified.value = false;
            },
            child: Text("Continue"),
          ),
        ],
      ),
    );
  }

  void resetAbhaFlow() {
    showCreateAbha.value = false;

    aadhaarController.clear();
    aadhaar.value = '';

    for (var c in otpControllers) {
      c.clear();
    }
    aadhaarOtp.value = '';

    aadhaarOtpSent.value = false;
    aadhaarVerified.value = false;
    aadhaarProfileImported.value = false;
    aadhaarOtpRemainingSeconds.value = 0;
  }

  void _startAadhaarOtpTimer() {
    aadhaarOtpTimer?.cancel();
    aadhaarOtpRemainingSeconds.value = 30;
    aadhaarOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (aadhaarOtpRemainingSeconds.value <= 1) {
        timer.cancel();
        aadhaarOtpRemainingSeconds.value = 0;
      } else {
        aadhaarOtpRemainingSeconds.value--;
      }
    });
  }

  void _stopAadhaarOtpTimer() {
    aadhaarOtpTimer?.cancel();
    aadhaarOtpRemainingSeconds.value = 0;
  }

  @override
  void onInit() {
    super.onInit();

    aadhaarController.addListener(() {
      aadhaar.value = aadhaarController.text;
      createTriageModel.value!.triage!.aadhaar = aadhaarController.text;
    });
  }

  @override
  void onClose() {
    aadhaarOtpTimer?.cancel();
    super.onClose();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
  }

  Future<void> autoSendAadhaarOtp(String? aadhaar) async {
    if (aadhaar == null || aadhaar.length != 12) return;
    if (lastAadhaarSent.value == aadhaar) return;
    lastAadhaarSent.value = aadhaar;
    await sendAadhaarOtp();
  }

  var createTriageModel = Rxn<TriageModel>(
    TriageModel(
      triage: Triage(),
      triageBy108: TriageBy108(),
      triageDtls: TriageDtls(),
    ),
  );

  Future<Map<String, dynamic>?> showAadhaarSuccessDialog(
    Map<String, dynamic> d, {
    bool showDialog = true,
    bool returnToCaller = false,
  }) async {
    aadhaarProfileData.value = d; // store payload for later "View Card"
    final profile = _resolveAbhaProfilePayload(d);

    if (profile == null) {
      Fluttertoast.showToast(msg: "No ABHA data found");
      return null;
    }

    if (!showDialog) {
      _applyAadhaarResponseData(d);
      return null;
    }

    _applyAadhaarResponseData(d);

    final firstName = profile['firstName']?.toString() ?? '';
    final middleName = profile['middleName']?.toString() ?? '';
    final lastName = profile['lastName']?.toString() ?? '';
    final name = '$firstName $middleName $lastName'.trim();
    final abhaNumber = profile['ABHANumber']?.toString() ??
        profile['abhaNumber']?.toString() ??
        'Not Available';
    final mobile = profile['mobile']?.toString() ?? 'Not Available';
    final maskedMobile = _maskValue(mobile);
    final preferredAbhaAddress = profile['preferredAbhaAddress']?.toString() ??
        profile['abhaAddress']?.toString() ??
        profile['address']?.toString() ??
        '';
    final residentialAddress = profile['residentialAddress']?.toString() ??
        profile['address']?.toString() ??
        '';
    final dob = profile['dob']?.toString() ?? 'Not Available';
    final gender = profile['gender']?.toString() ?? 'Not Available';
    final status = profile['abhaStatus']?.toString() ?? 'Not Available';
    final profileId = profile['id']?.toString() ??
        profile['profileId']?.toString() ??
        profile['abhaProfileId']?.toString() ??
        profile['ABHAProfileId']?.toString() ??
        'Not Available';
    final photoRaw = profile['photo']?.toString();

    ImageProvider? photoProvider;
    if (photoRaw != null && photoRaw.isNotEmpty) {
      try {
        final cleanPhoto = photoRaw.contains(',')
            ? photoRaw.split(',').last
            : photoRaw;
        photoProvider = MemoryImage(base64Decode(cleanPhoto));
      } catch (_) {
        photoProvider = null;
      }
    }

    final dialogResult = await Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, minWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[50],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.person,
                            color: Colors.blue.shade700,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ABHA PROFILE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your ABHA profile is ready to view and download.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFFF8FAFC),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          image: photoProvider != null
                              ? DecorationImage(
                                  image: photoProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: photoProvider == null
                            ? Icon(Icons.person, size: 46, color: Colors.grey[600])
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDialogInfoRow('Name', name.isEmpty ? 'Unknown' : name),
                    _buildDialogInfoRow('ABHA Number', abhaNumber),
                    _buildDialogInfoRow('ABHA Address',
                        preferredAbhaAddress.isNotEmpty ? preferredAbhaAddress : 'Not available'),
                    _buildDialogInfoRow('Date of Birth', dob),
                    _buildDialogInfoRow('Gender', gender),
                    _buildDialogInfoRow('Mobile', maskedMobile),
                    _buildDialogInfoRow('Status', status),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => downloadAbhaCard(),
                            icon: const Icon(Icons.download_rounded),
                            label: const Text('DOWNLOAD ABHA CARD'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _applyAadhaarResponseData(d);
                              final result = <String, dynamic>{
                                'abhaNumber': profile['ABHANumber']?.toString() ??
                                    profile['abhaNumber']?.toString() ??
                                    '',
                                'abhaAddress': preferredAbhaAddress,
                                'fullName': name,
                                'mobile': mobile,
                              };
                              if (returnToCaller) {
                                if (Get.isDialogOpen ?? false) {
                                  Get.back(result: result);
                                } else {
                                  Get.back(result: result);
                                }
                              } else {
                                if (Get.isDialogOpen ?? false) {
                                  Get.back();
                                }
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('USE THIS PROFILE'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          if (Get.isDialogOpen ?? false) {
                            Get.back();
                          }
                        },
                        child: const Text('CLOSE'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$label',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NOTE: keep old method name for compatibility
  void showAadhaarSuccessDialogLegacy(Map<String, dynamic> d) {
    showAadhaarSuccessDialog(d);
  }

  Future<bool> createTriage() async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.createTriage);
      var response = await _client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(createTriageModel.value!.toCleanJson()),
      );
      log('Triage Create Payload: ${createTriageModel.value!.toCleanJson()}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: d["message"]);
        log('Triage Create Response: ${d.toString()}');
        isLoading.value = false;
        // Get.back();
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to create triage");
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> getTriageById({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getTriageById + id);
      var response = await _client.get(url);
      log('Triage GetID: ${response.body}');
      if (response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        createTriageModel.value = TriageModel.fromJson(d);
        Fluttertoast.showToast(msg: d["message"]);
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  var dashboard = TransitCareDashboardModel().obs;
  var dataMap = <String, String>{}.obs;

  var triageDashboard = TriageDashBoard().obs;
  var triageDataMap = <String, String>{}.obs;

  ////// Transit-Care Dash Board
  Future<void> fetchDashboard({
    required String startDate,
    required String endDate,
  }) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(
          "${Urls.getTransitCareDashboard}?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('DAs${response.body}');
      if (response.body.isNotEmpty) {
        log('DASHBOARD${response.body}');
        final parsed = jsonDecode(response.body);
        final json = parsed is List ? parsed.first : parsed;
        dashboard.value = TransitCareDashboardModel.fromJson(json);
        dataMap.value = {
          "Total": dashboard.value.total?.toString() ?? "0",
          "Critical": dashboard.value.critical?.toString() ?? "0",
          "Non Critical": dashboard.value.nonCritical?.toString() ?? "0",
          "IFT": dashboard.value.ift?.toString() ?? "0",
          "Scene": dashboard.value.scene?.toString() ?? "0",
          // "Emergency": dashboard.value.emergency?.toString() ?? "0",
          // "Admitted": dashboard.value.admitted?.toString() ?? "0",
          "Pending": dashboard.value.pending?.toString() ?? "0",
        };
        isLoading.value = false;
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// get triage 108 case list
  var mycurrentPage = 1.obs; // API current page
  var mytotalPages = 1.obs;
  var rowsPerPage = 20.obs;
  final transitStartDate = ''.obs;
  final transitEndDate = ''.obs;

  var searchText = "".obs;

// filtered list getter
  List<CaseListData> get filteredTriage108CaseList {
    if (searchText.value.isEmpty) {
      return triage108CaseList;
    }

    return triage108CaseList.where((e) {
      final name = (e.patientName ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getTriage108CaseList({
    required String hospitalName,
    required String startDate,
    required String endDate,
    int? pageNumber,
    int? pageSize,
  }) async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.getTriage108CaseList);
      var response = await _client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "date": startDate,
          "to_date": endDate,
          "pageNumber": pageNumber ?? mycurrentPage.value,
          "pageSize": pageSize ?? rowsPerPage.value,
          "hospital_name": hospitalName,
        }),
      );

      if (response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        var data = Triage108CaseListModel.fromJson(d);

        if (data.data != null && data.data!.isNotEmpty) {
          triage108CaseList.value = data.data!;
          mycurrentPage.value = data.currentPage ?? 1;
          mytotalPages.value = data.totalPages ?? 1;
          transitStartDate.value = startDate;
          transitEndDate.value = endDate;

          return true;
        } else {
          triage108CaseList.clear();
          Fluttertoast.showToast(msg: "No Data Found");
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: "No Data Found");
        return false;
      }
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Error loading data");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTriage() async {
    try {
      isLoading.value = true;
      debugPrint('===== UPDATE TRIAGE STARTED =====');
      debugPrint('Triage payload: ${createTriageModel.value?.toJson()}');

      final triageId = createTriageModel.value?.triage?.id?.toString();
      if (triageId == null || triageId.isEmpty) {
        debugPrint('Triage update skipped because no triage id is available');
        return true;
      }

      final url = Uri.parse('${Urls.updateTriage}$triageId');
      final response = await _client.put(
        url,
        body: jsonEncode(createTriageModel.value),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      debugPrint('Triage update status: ${response.statusCode}');
      debugPrint('Triage update response: ${response.body}');

      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 204;

      if (isSuccess) {
        try {
          final payload = response.body.trim().isEmpty
              ? <String, dynamic>{}
              : jsonDecode(response.body);
          final message = payload is Map && payload['message'] != null
              ? payload['message'].toString()
              : 'Triage updated successfully';
          Fluttertoast.showToast(msg: message);
          debugPrint('Triage update completed successfully');
          return true;
        } catch (e) {
          debugPrint('Triage response parse warning: $e');
          return true;
        }
      }

      Fluttertoast.showToast(msg: 'Failed to update triage');
      debugPrint('Triage update failed');
      return false;
    } catch (e) {
      debugPrint('Triage update exception: $e');
      Fluttertoast.showToast(msg: 'Failed to update triage');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //// Transit Care
//   var triageList = Rxn<TriageList>();
  RxList<TriageList> triageList = <TriageList>[].obs;
  RxBool isTriageLoading = true.obs;

  // Pagination
  var triageCurrentPage = 1.obs;
  var triageTotalPages = 1.obs;
  final int triageLimit = 20; // Fixed
  var triageTotalCount = 0.obs;
  var triageStartDate = Rxn<DateTime>();
  var triageEndDate = Rxn<DateTime>();

  var triageSearchText = "".obs;

// filtered list getter
  List<TriageList> get filteredTriageList {
    if (triageSearchText.value.isEmpty) {
      return triageList;
    }

    return triageList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(triageSearchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getTriageList({
    required String startDate,
    required String endDate,
    bool premBelow12Years = false,
    int pageNumber = 1, // offset in your API
  }) async {
    try {
      isTriageLoading.value = true;
      //is_age12
      final url = Uri.parse(
        "${Urls.getTriageList}?limit=$triageLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&is_age12=$premBelow12Years",
      );

      final response = await _client.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      log("Triage List URL: $url");
      log("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = TriageListModel.fromJson(jsonDecode(response.body));
        triageList.value = data.rows ?? [];

        triageTotalCount.value = data.totalCount ?? 0;
        triageTotalPages.value = (triageTotalCount.value / triageLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        triageStartDate.value = DateTime.parse(startDate);
        triageEndDate.value = DateTime.parse(endDate);
        triageCurrentPage.value = pageNumber;

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error in getTriageList: $e");
      return false;
    } finally {
      isTriageLoading.value = false;
    }
  }

  ///// Triage Nurse Dash Board
  Future<bool> fetchTriageDashboard({
    required String startDate,
    required String endDate,
    bool premBelow12Years = false,
  }) async {
    try {
      final url = Uri.parse(
          "${Urls.getTriageNurseDashboard}?start_date=$startDate&end_date=$endDate&is_age12=$premBelow12Years");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('DAs${response.body}');
      if (response.body.isNotEmpty) {
        log('DASHBOARD${response.body}');
        final parsed = jsonDecode(response.body);
        final json = parsed is List ? parsed.first : parsed;
        triageDashboard.value = TriageDashBoard.fromJson(json);
        triageDataMap.value = {
          "Total": triageDashboard.value.total ?? '0',
          "108": triageDashboard.value.the108 ?? '0',
          "Red": triageDashboard.value.red ?? '0',
          "Yellow": triageDashboard.value.yellow ?? '0',
          "Green": triageDashboard.value.green ?? '0',
          "Black": triageDashboard.value.black ?? '0',
          "Pending": triageDashboard.value.pending ?? '0'
        };
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
      return false;
    }
  }

  setEHR(value) {
    if (selectedEHR.value == "CMCHIS Card") {
      createTriageModel.value!.triage!.cmchisCard = value;
    } else if (selectedEHR.value == "ABHA Card") {
      createTriageModel.value!.triage!.abhaCard = value;
    } else if (selectedEHR.value == "PHR ID") {
      createTriageModel.value!.triage!.phrId = value;
    } else if (selectedEHR.value == "HMIS ID") {
      createTriageModel.value!.triage!.hmisId = value;
    }
  }

//// ED Line List\
  var currentPage = 1.obs;
  final int itemsPerPage = 10;
  var edLineList = <TransitCareModel>[].obs; // ✅ store cases, not models
  var isLoading = false.obs;

  LoginController loginController = Get.find();
  var totalPages = 1.obs;

  Future<bool> getEdLineList(
      {bool isRefresh = false,
      String fromDate = "9/22/2025",
      String toDate = "9/22/2025"}) async {
    if (isLoading.value) return false;

    try {
      isLoading.value = true;

      final url = Uri.parse(
          "https://taei.co.in/WebAPI108/TransitCareLinelist?Page_Number=${"1"}&FromDate=$fromDate&ToDate=$toDate&Search_Text=&Hospital=${loginController.userDetails.value?.user?.hospital?.hospitalid}&DistrictId=0&HospitalType=null");
      log('LLLLLLLL${url.toString()}');

      final response = await http.get(url);
      log(response.body);
      debugPrint(
          "Hospital Name: ${loginController.userDetails.value?.user?.hospital?.hospitalname}");
      debugPrint(
          "Hospital ID: ${loginController.userDetails.value?.user?.hospital?.hospitalid}");
      debugPrint(
          "District Name: ${loginController.userDetails.value?.user?.hospital?.districtname}");
      debugPrint(
          "API Hospital: ${loginController.userDetails.value?.user?.hospital?.hospitalname108}");
      debugPrint(
          "User Type ID: ${loginController.userDetails.value?.user?.username}");
      debugPrint("UID: ${loginController.userDetails.value?.user?.id}");

      if (response.body.isNotEmpty) {
        log("TransitCare New LIst: ${response.body}");
        final parsed = transitCareResponseFromJson(response.body);
        edLineList.assignAll(parsed.data ?? []);
        totalPages.value = parsed.pageCount ?? 1;
        currentPage.value++;
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      isLoading.value = false;
      log("getTransitCareList error: $ex");
      return false;
    }
  }

  /// get Triage Details
  Future<bool> getTriageDetails({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getTriageDetails + id);
      var response = await _client.get(url);
      log('Triage Details: ${response.body}');

      if (response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        triageDetails.value = TriageDetailsModel.fromJson(d);
        Fluttertoast.showToast(msg: 'Details Fetched Successfully');
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<void> downloadTriageDetailsPdf({required String id}) async {
    try {
      final url = Uri.parse(Urls.getTriageDetails + id);
      final response = await _client.get(url);

      if (response.body.isEmpty) {
        Fluttertoast.showToast(msg: "No details found.");
        return;
      }

      final decoded = jsonDecode(response.body);
      triageDetails.value = TriageDetailsModel.fromJson(decoded);

      final data = triageDetails.value;
      final pdf = pw.Document();

      pw.Widget sectionTitle(String title) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          );

      pw.Widget infoRow(String label, dynamic value) {
        final String displayValue =
            (value == null || value.toString().trim().isEmpty)
                ? "-"
                : value.toString();

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  label,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              /// Dash separator
              // pw.Padding(
              //   padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              //   child: pw.Text(
              //     "-",
              //     style: pw.TextStyle(
              //       fontWeight: pw.FontWeight.bold,
              //     ),
              //   ),
              // ),

              /// Value or "-"
              pw.Expanded(
                flex: 5,
                child: pw.Text(displayValue),
              ),
            ],
          ),
        );
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "Triage Details Report",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ),
            pw.SizedBox(height: 16),

            // 👤 Patient Details
            sectionTitle("Patient Details"),
            infoRow("Name", data?.triageDetails?.nameOfPatient),
            infoRow("Gender", data?.triageDetails?.gender),
            infoRow(
              "Age",
              "${data?.triageDetails?.ageYear ?? ''} yrs ${data?.triageDetails?.ageMonth ?? ''} mths",
            ),
            infoRow("Marital Status", data?.triageDetails?.maritalStatus),
            infoRow("Father's Name", data?.triageDetails?.fathername),
            infoRow("Mother's Name", data?.triageDetails?.mothername),
            infoRow("Mobile", data?.triageDetails?.patientMobileNumber),
            infoRow("Education", data?.triageDetails?.education),
            infoRow("Occupation", data?.triageDetails?.occupation),

            pw.Divider(),

            sectionTitle("Hospital Details"),
            infoRow("Source Type", data?.triageDetails?.sourceType),
            infoRow("Source Hospital", data?.triageDetails?.sourceHospital),
            infoRow("Destination Hospital",
                data?.triageDetails?.destinationHospital),
            infoRow("Referral Reason", data?.triageDetails?.reasonForReferral),
            infoRow("Referral Doctor", data?.triageDetails?.referralDoctorName),
            infoRow("Condition of Patient",
                data?.triageDetails?.conditionOfPatient),

            if (data?.triageBy108Details?.callId != null) pw.Divider(),

            if (data?.triageBy108Details?.callId != null)
              sectionTitle("108 Call Details"),
            if (data?.triageBy108Details?.callId != null) ...[
              infoRow("Call ID", data?.triageBy108Details?.callId),
              infoRow("District", data?.triageBy108Details?.districtName),
              infoRow("Vehicle No", data?.triageBy108Details?.vehicleNumber),
              infoRow(
                  "Chief Complaint", data?.triageBy108Details?.chiefComplaint),
              infoRow(
                  "Emergency Type", data?.triageBy108Details?.emergencyType),
              infoRow("Pulse", data?.triageBy108Details?.pulse),
            ],

            pw.Divider(),

            sectionTitle("Medical Details"),
            infoRow("Accompanied By", data?.triageDtlsDetails?.accompaniedBy),
            infoRow("Primary Medical Emergency",
                data?.triageDtlsDetails?.pcMedicalEmergency),
            infoRow("Cause", data?.triageDtlsDetails?.cause),
            infoRow("AVPU", data?.triageDtlsDetails?.avpu),
            infoRow("Pulse", data?.triageDtlsDetails?.pulse),
            infoRow(
              "BP",
              "${data?.triageDtlsDetails?.bpSystolic ?? ''}/${data?.triageDtlsDetails?.bpDiastolic ?? ''}",
            ),
            infoRow("SpO2", data?.triageDtlsDetails?.spo2),
            infoRow("Temperature", data?.triageDtlsDetails?.temperature),
            infoRow("Triage Flag", data?.triageDtlsDetails?.triageFlag),
            infoRow("Triage Done By", data?.triageDtlsDetails?.triageDoneBy),

            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by TAEI System  ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "Triage_Details_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/Triage_Details_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
      }
    } catch (e, st) {
      Fluttertoast.showToast(msg: "Failed to generate PDF: $e");
      log("PDF Generation Error: $e\n$st");
    }
  }

  Future<void> downloadCaseListPdf({required CaseListData caseData}) async {
    try {
      final pdf = pw.Document();
      pw.Widget sectionTitle(String title) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          );

      pw.Widget infoRow(String label, dynamic value) {
        if (value == null || value.toString().isEmpty) return pw.SizedBox();
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  "$label:",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Expanded(
                flex: 5,
                child: pw.Text(value.toString()),
              ),
            ],
          ),
        );
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "Case Details Report",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            sectionTitle("Patient & Case Overview"),
            infoRow("Case ID", caseData.caseId?.toString()),
            infoRow("Patient Name", caseData.patientName),
            infoRow("Age", caseData.age?.toString()),
            infoRow("District", caseData.districtName),
            infoRow("Taluk", caseData.talukName),
            infoRow("City", caseData.cityName),
            pw.Divider(),
            sectionTitle("Hospital & Location Details"),
            infoRow("Base Location", caseData.baseLocation),
            infoRow("Hospital Name", caseData.hospitalName),
            infoRow("Source Hospital", caseData.sourceHospital),
            infoRow("Vehicle No", caseData.vehicleNumber),
            pw.Divider(),
            sectionTitle("Emergency & Call Info"),
            infoRow("Call Type", caseData.callType),
            infoRow("Chief Complaint", caseData.chiefComplaint),
            infoRow("Emergency Type", caseData.emergencyType),
            infoRow("Emergency Sub Type", caseData.emergencySubType),

            pw.Divider(),

            // 🩺 Patient Vitals
            sectionTitle("Patient Vitals"),
            infoRow("SPO2", caseData.spo2?.toString()),
            infoRow("RR", caseData.rr?.toString()),
            infoRow("Temperature", caseData.temperature?.toString()),
            infoRow(
              "BP (SBP/DBP)",
              "${caseData.bpSbp?.toString() ?? ''}/${caseData.bpDbp?.toString() ?? ''}",
            ),
            infoRow("Carotid Pulse", caseData.carotidPulse?.toString()),
            infoRow("Pupil Left", caseData.pupilSizeLeft),
            infoRow("Pupil Right", caseData.pupilSizeRight),
            infoRow(
              "Condition",
              caseData.isCritical == true ? "Critical" : "Normal",
            ),
            pw.Divider(),
            sectionTitle("Timestamps"),
            infoRow("Vehicle Assigned Time",
                caseData.vehicleAssignedTime?.toString()),
            infoRow("Inserted Date", caseData.insertedDate?.toString()),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by TAEI System  ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "Case_Details_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/Case_Details_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to app folder: ${file.path}");
      }
    } catch (e, st) {
      Fluttertoast.showToast(msg: "Failed to generate PDF: $e");
      log("CaseList PDF Error: $e\n$st");
    }
  }

  Future<void> startFaceAuth() async {
    print("========================================");
    print("FACE AUTH STARTED");
    print("========================================");

    final faceService = FaceRDService();

    try {
      isFaceLoading.value = true;

      //----------------------------------------------------
      // STEP 1
      //----------------------------------------------------

      final txnId = await faceService.initFaceAuth();

      faceTxnId.value = txnId;

      //----------------------------------------------------
      // STEP 2
      //----------------------------------------------------

      final captureResponse = await faceService.captureFaceAuth(txnId);

      final faceUrl = faceService.getFaceAuthUrl(captureResponse);

      if (faceUrl == null || faceUrl.isEmpty) {
        Fluttertoast.showToast(
          msg: "Face URL not received",
        );
        return;
      }

      //----------------------------------------------------
      // STEP 3
      //----------------------------------------------------

      await faceService.launchAbhaApp(faceUrl);

      //----------------------------------------------------
// STEP 4
//----------------------------------------------------

      final aadhaar = createTriageModel.value?.triage?.aadhaar ?? "";

      final mobile = createTriageModel.value?.triage?.patientMobileNumber ?? "";

      if (aadhaar.isEmpty) {
        Fluttertoast.showToast(
          msg: "Aadhaar Number is required",
        );

        return;
      }

      if (mobile.isEmpty) {
        Fluttertoast.showToast(
          msg: "Mobile Number is required",
        );

        return;
      }
    } catch (e, stack) {
      print(e);
      print(stack);

      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } finally {
      faceService.dispose();

      isFaceLoading.value = false;
    }
  }

  Future<void> pollFaceStatus(
    String txnId,
    String aadhaar,
    String mobile, {
    bool showDialog = true,
  }) async {
    final faceService = FaceRDService();

    const int maxAttempts = 60;

    for (int i = 1; i <= maxAttempts; i++) {
      print("================================");
      print("Polling Attempt : $i");
      print("================================");

      await Future.delayed(
        const Duration(seconds: 3),
      );

      //------------------------------------------------
      // CALL CAPTURE API AGAIN
      //------------------------------------------------

      Map<String, dynamic> captureResponse;

      try {
        captureResponse = await faceService.captureFaceAuth(txnId);
      } catch (e) {
        print("Capture API Exception");

        print(e);

        continue;
      }

      if (captureResponse.isEmpty) {
        continue;
      }

      final status = captureResponse["status"]?.toString().toUpperCase();
      print(captureResponse);
      print("STATUS : $status");

      //------------------------------------------------
      // STILL WAITING
      //------------------------------------------------

      if (status == "PENDING") {
        print("Waiting for face scan...");

        continue;
      }

      //------------------------------------------------
      // FACE COMPLETED
      //------------------------------------------------

      if (status == "COMPLETE") {
        final enrollResponse = await TriageService.createAbhaUsingFace(
          txnId: txnId,
          aadhaar: aadhaar,
          mobile: mobile,
        );

        if (enrollResponse == null) {
          Fluttertoast.showToast(
            msg: "Enroll API returned NULL",
          );
          return;
        }

        if (enrollResponse["success"] == false) {
          Fluttertoast.showToast(
            msg: enrollResponse["message"] ?? "Enroll API Failed",
          );
          return;
        }

        if (enrollResponse["result"] == null) {
          Fluttertoast.showToast(
            msg: enrollResponse["message"] ?? "Enroll API Failed",
          );
          return;
        }

        print(enrollResponse);

        showAadhaarSuccessDialog(enrollResponse);

        return;
      }

      //------------------------------------------------
      // FAILED
      //------------------------------------------------

      if (status == "FAILED") {
        Fluttertoast.showToast(
          msg: "Face Verification Failed",
        );

        return;
      }
    }

    Fluttertoast.showToast(
      msg: "Face Scan Timeout",
    );
  }

  Future<void> verifyFace({bool showDialog = true}) async {
    if (faceTxnId.value.isEmpty) {
      Fluttertoast.showToast(msg: "Please Scan Face First");

      return;
    }

    final service = FaceRDService();

    try {
      isFaceLoading.value = true;

      final response = await service.captureFaceAuth(
        faceTxnId.value,
      );

      final status = response["status"]?.toString().toUpperCase();

      if (status == "PENDING") {
        Fluttertoast.showToast(msg: "Face Scan not completed");

        return;
      }

      if (status == "FAILED") {
        Fluttertoast.showToast(msg: "Face Verification Failed");

        return;
      }

      if (status == "COMPLETE") {
        final enrollResponse = await TriageService.createAbhaUsingFace(
          txnId: faceTxnId.value,
          aadhaar: createTriageModel.value!.triage!.aadhaar!,
          mobile: createTriageModel.value!.triage!.patientMobileNumber!,
        );

        print("======================================");
        print("ENROLL RESPONSE");
        print(enrollResponse);
        print("======================================");

        if (enrollResponse == null) {
          Fluttertoast.showToast(
            msg: "Enroll API returned NULL",
          );
          return;
        }

        if (enrollResponse["success"] == false) {
          Fluttertoast.showToast(
            msg: enrollResponse["message"] ?? "Enroll API Failed",
          );
          return;
        }

        if (enrollResponse["result"] == null) {
          Fluttertoast.showToast(
            msg: enrollResponse["message"] ?? "Enroll API Failed",
          );

          return;
        }

        showAadhaarSuccessDialog(enrollResponse);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } finally {
      isFaceLoading.value = false;
    }
  }
}
