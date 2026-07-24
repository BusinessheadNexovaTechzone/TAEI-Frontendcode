import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
import 'package:taei_gov/utils/helpers/http_helper.dart';
import '../models/create_triage_model.dart';
import '../services/triage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/face_rd_service.dart';

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

  RxString aadhaarTxnId = ''.obs;

  Future<bool> sendAadhaarOtp() async {
    String? aadhaar = createTriageModel.value?.triage?.aadhaar;

    // ✅ REMOVE DASHES AND NON-DIGITS
    aadhaar = aadhaar?.replaceAll(RegExp(r'\D'), '');

    final mobile = createTriageModel.value?.triage?.patientMobileNumber;

    log('sendAadhaarOtp inputs: aadhaar=$aadhaar, mobile=$mobile');

    if (!isValidAadhaar(aadhaar)) {
      Fluttertoast.showToast(msg: 'Please enter valid 12 digit Aadhaar number');
      return false;
    }

    try {
      isSendingAadhaarOtp.value = true;
      aadhaarOtpSent.value = false;
      aadhaarVerified.value = false;

      final d = await TriageService.sendAadhaarOtp(aadhaar: aadhaar!);

      if (d != null) {
        final txnId = d['txnId'] ?? d['data']?['txnId'];
        if (txnId != null) {
          aadhaarTxnId.value = txnId.toString();
        }
        aadhaarOtpSent.value = true;
        _startAadhaarOtpTimer();
        Fluttertoast.showToast(
            msg: d['message'] ?? 'OTP sent to registered mobile');
        return true;
      }

      Fluttertoast.showToast(msg: 'Failed to send Aadhaar OTP');
      return false;
    } catch (e) {
      log('sendAadhaarOtp exception: $e');
      Fluttertoast.showToast(msg: 'Failed to send Aadhaar OTP');
      return false;
    } finally {
      isSendingAadhaarOtp.value = false;
    }
  }

  Future<bool> verifyAadhaarOtp() async {
    final otp = aadhaarOtp.value;
    final txnId = aadhaarTxnId.value;
    final mobile = createTriageModel.value?.triage?.patientMobileNumber;
    log('verifyAadhaarOtp inputs: txnId=$txnId, otp=$otp, mobile=$mobile');

    if (txnId.isEmpty) {
      Fluttertoast.showToast(msg: 'Please generate Aadhaar OTP first');
      return false;
    }
    if (otp.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter OTP');
      return false;
    }
    if (mobile == null || mobile.length != 10) {
      Fluttertoast.showToast(
          msg: 'Please enter valid registered mobile number');
      return false;
    }

    try {
      final d = await TriageService.verifyAadhaarOtp(
        txnId: txnId,
        otp: otp,
        mobile: mobile,
      );
      log('verifyAadhaarOtp raw response: $d');
      debugPrint('verifyAadhaarOtp raw response: $d');
      if (d != null) {
        aadhaarVerified.value = true;

        Fluttertoast.showToast(msg: d['message'] ?? 'Aadhaar verified');

        // ✅ Extract profileId from verifyAadhaarOtp response
        final profileId = d['profileId'] ??
            d['data']?['profileId'] ??
            d['result']?['profileId'];
        if (profileId != null) {
          final parsedProfileId = int.tryParse(profileId.toString());
          if (parsedProfileId != null) {
            createTriageModel.value?.triage?.abhaProfileId = parsedProfileId;
            log("ABHA PROFILE ID STORED from verifyAadhaarOtp: $parsedProfileId");
          }
        }

        // ✅ CLEAR OTP HERE (CORRECT PLACE)
        for (var c in otpControllers) {
          c.clear();
        }
        aadhaarOtp.value = '';

        // Show success popup
        showAadhaarSuccessDialog(d);

        return true;
      }
      aadhaarVerified.value = false;
      Fluttertoast.showToast(msg: 'Failed to verify Aadhaar OTP');
      return false;
    } catch (e) {
      log('verifyAadhaarOtp exception: $e');
      aadhaarVerified.value = false;
      Fluttertoast.showToast(msg: 'Failed to verify Aadhaar OTP');
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

  void showLastAadhaarProfileCard() {
    final data = aadhaarProfileData.value;
    if (data == null) {
      Fluttertoast.showToast(msg: 'No imported profile data available');
      return;
    }
    showAadhaarSuccessDialog(data);
  }

  Future<void> downloadAbhaCard() async {
    final profileId = createTriageModel.value?.triage?.abhaProfileId;
    log('Download ABHA Card - Current abhaProfileId: $profileId');
    log('Download ABHA Card - Full triage data: ${createTriageModel.value?.triage?.toJson()}');

    if (profileId == null) {
      // Try to fetch updated triage data from backend
      if (createTriageModel.value?.triage?.id != null) {
        log('Profile ID not found locally, trying to fetch from backend...');
        final fetched = await getTriageById(
            id: createTriageModel.value!.triage!.id.toString());
        if (fetched) {
          final updatedProfileId =
              createTriageModel.value?.triage?.abhaProfileId;
          log('Fetched updated profile ID from backend: $updatedProfileId');
          if (updatedProfileId != null) {
            // Retry download with fetched ID
            await _performAbhaCardDownload(updatedProfileId);
            return;
          }
        }
      }

      Fluttertoast.showToast(msg: 'ABHA Profile ID not found');
      return;
    }

    await _performAbhaCardDownload(profileId);
  }

  Future<void> _performAbhaCardDownload(int profileId) async {
    try {
      final url = '${Urls.local}api/abha/card/$profileId';
      log('Downloading ABHA card from: $url');

      // Download and save the file
      final filePath = await TriageService.downloadFile(url);
      if (filePath != null) {
        Fluttertoast.showToast(
            msg:
                'ABHA Card downloaded successfully!\nFile: ${filePath.split('/').last}');
        log('ABHA Card saved to: $filePath');
      } else {
        Fluttertoast.showToast(
            msg:
                'Failed to download ABHA Card - Check ProfileId or API response');
        log('Download returned null filepath');
      }
    } catch (e) {
      log('Download ABHA card error: $e');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  void _applyAadhaarResponseData(Map<String, dynamic> d) {
    log("APPLY FUNCTION CALLED: $d");

    final data = d['result']?['ABHAProfile'];
    final triage = createTriageModel.value?.triage;
    if (triage == null) return;

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
    triage.addressLine = data['address']?.toString();
    triage.pincode = data['pinCode']?.toString();

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
  RxBool showCreateAbha = false.obs;
  RxBool aadhaarProfileImported = false.obs;
  Rxn<Map<String, dynamic>> aadhaarProfileData = Rxn<Map<String, dynamic>>();
  RxString aadhaar = ''.obs;
  RxString aadhaarOtp = ''.obs;
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

  void showAadhaarSuccessDialog(Map<String, dynamic> d) {
    aadhaarProfileData.value = d; // store payload for later "View Card"
    final profile = d['result']?['ABHAProfile'];

    if (profile == null) {
      Fluttertoast.showToast(msg: "No ABHA data found");
      return;
    }

    final name =
        "${profile['firstName'] ?? ''} ${profile['middleName'] ?? ''} ${profile['lastName'] ?? ''}"
            .trim();

    final mobile = profile['mobile'] ?? 'Not Available';
    final abha = profile['ABHANumber'] ?? 'Not Available';
    final address = profile['address'] ?? '';
    final state = profile['stateName'] ?? '';
    final district = profile['districtName'] ?? '';

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520, minWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.info,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'ABHA Already Exists',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Verified Record Found',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Color(0xFFDFF6FF),
                padding: EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        image: (profile != null &&
                                profile['photo'] != null &&
                                profile['photo'].toString().isNotEmpty)
                            ? DecorationImage(
                                image: MemoryImage(base64Decode(profile['photo']
                                    .toString()
                                    .split(',')
                                    .last)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: (profile == null ||
                              profile['photo'] == null ||
                              profile['photo'].toString().isEmpty)
                          ? Icon(Icons.person,
                              size: 30, color: Colors.grey[700])
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PATIENT NAME',
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 10,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold)),
                                    Text(name.isEmpty ? 'Unknown' : name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                    SizedBox(height: 6),
                                    Text('MOBILE',
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 10,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold)),
                                    Text(mobile,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ABHA ID',
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 10,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold)),
                                    Text(abha,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('ADDRESS',
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold)),
                          Text(
                              address.isEmpty
                                  ? 'Address not available'
                                  : address,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('No',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        minimumSize: Size(170, 42),
                      ),
                      onPressed: () async {
                        _applyAadhaarResponseData(d);
                        // Update triage to persist ABHA profile ID to backend
                        await updateTriage();
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Yes, Import Profile',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward,
                              size: 16, color: Colors.white),
                        ],
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

  // Update Triage
  Future<bool> updateTriage() async {
    try {
      isLoading.value = true;
      log(createTriageModel.toJson().toString());
      var url = Uri.parse(
          Urls.updateTriage + createTriageModel.value!.triage!.id.toString() ??
              "");
      var response = await _client
          .put(url, body: jsonEncode(createTriageModel.value), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('Triage Update Payload: ${createTriageModel.value!}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: d["message"]);
        log('Triage Update Response: ${d.toString()}');
        isLoading.value = false;
        Get.back();
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to create triage");
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
      return false;
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
    String mobile,
  ) async {
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


  Future<void> verifyFace() async {

    if(faceTxnId.value.isEmpty){

        Fluttertoast.showToast(
            msg:"Please Scan Face First"
        );

        return;
    }

    final service = FaceRDService();

    try{

        isFaceLoading.value=true;

        final response =
            await service.captureFaceAuth(
                faceTxnId.value,
            );

        final status =
            response["status"]
            ?.toString()
            .toUpperCase();

        if(status=="PENDING"){

            Fluttertoast.showToast(
                msg:"Face Scan not completed"
            );

            return;

        }

        if(status=="FAILED"){

            Fluttertoast.showToast(
                msg:"Face Verification Failed"
            );

            return;

        }

        if(status=="COMPLETE"){

            final enrollResponse =
                await TriageService.createAbhaUsingFace(

                    txnId: faceTxnId.value,

                    aadhaar:
                    createTriageModel.value!
                        .triage!
                        .aadhaar!,

                    mobile:
                    createTriageModel.value!
                        .triage!
                        .patientMobileNumber!,
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

    }
    catch(e){

        Fluttertoast.showToast(
            msg:e.toString(),
        );

    }
    finally{

        isFaceLoading.value=false;

    }

}
}
