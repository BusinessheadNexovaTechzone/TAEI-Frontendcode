class Urls {
  /// Triage API
  static const String baseUrl = 'https://dev.taei.co.in/';
  static const String local = 'https://taei.nexovatechzone.com/';
  static const String phone = 'http://192.168.1.5:5000/';
  //  ABHA Face API
  //  static const String baseUrl = "http://192.168.1.6:5000";
  static const String authUrl = 'https://auth.taei.co.in/';
  static const String taeiReportUrl = 'https://web.taei.co.in/';

  static const createAbhaUsingFace = "${local}api/abha/face/enroll";

  /// district List
  static const String getDistrict = '${baseUrl}api/dashboard/get-district';

  /// directorate List
  static const String getDirectorate =
      '${baseUrl}api/dashboard/get-directorate';

  //// Hospital API
  static const String getHospitalList = '${baseUrl}api/triage/hospitals';

  /// Triage API
  static const String createTriage = '${local}api/triage/create';

  /// Triage API
  static const String getTriageList = '${baseUrl}api/triage/list';

  // Get Lookup
  static const String getTriageLookup = '${baseUrl}api/triage/lookup';

  /// Update Triage
  static const String updateTriage = '${baseUrl}api/triage/';

  /// Get Triage by ID
  static const String getTriageById = '${baseUrl}api/triage/byId/';

  /// Get Triage Details
  static const String getTriageDetails = '${baseUrl}api/triage/nonIndex/';

  static const String getBitesDetails = '${baseUrl}api/bitesStings/nonIndex/';
  static const String getHangingDetails = '${baseUrl}api/hanging/nonIndex/';
  static const String getStrokeDetails = '${baseUrl}api/stroke/nonIndex/';
  static const String getPremDetails = '${baseUrl}api/prem/nonIndex/';
  static const String getPoisionDetails = '${baseUrl}api/poisons/nonIndex/';
  static const String getStemiDetails = '${baseUrl}api/stemi/nonIndex/';
  static const String getDrowningDetails = '${baseUrl}api/drowning/nonIndex/';

  static const String getStemiDetailsOp = '${baseUrl}api/stemi/nonIndexop/';

  /// Get Triage 108 Case List
  static const String getTriage108CaseList =
      '${baseUrl}api/api108/get-caselist';

  /// Dashboard
  ///"http://dev.taei.co.in/api/summary/TransitCare?start_date=$startDate&end_date=$endDate"
  static const String getTransitCareDashboard =
      '${baseUrl}api/summary/TransitCare';

  static const String getTriageNurseDashboard =
      '${baseUrl}api/summary/TriageNurse';

  static const String getStemiDashboard = '${baseUrl}api/summary/stemi';

  static const String getDrowningDashboard = '${baseUrl}api/summary/drowning';

  // sync api
  static const String syncApi = '${baseUrl}api/api108/api-sync';

  /// EMO DashBoard List
  static const String getEMODashboard = '${baseUrl}api/summary/Emo';

  /// Create EMO API
  static const String createEmo = '${baseUrl}api/emoTriage/create';

  /// Update EMO - Triage
  static const String updateEmo = '${baseUrl}api/emotriage/';

  /// Get List of EMO
  static const String getEmo = '${baseUrl}api/emotriage/getAll';

  /// Get EMO List
  static const String getEmoList = '${baseUrl}api/emotriage/';

  /// Get EMO - Triage by ID
  static const String getEmoById = '${baseUrl}api/emotriage/byId/';

  /// Delete EMO - Triage by ID
  static const String deleteEmo = '${baseUrl}api/emotriage/1';

  /// Get EMO - Triage Lookup
  static const String getEmoLookup = '${baseUrl}api/emotriage/lookup';

  /// Get EMO Details
  static const String getEmoDetails = '${baseUrl}api/emotriage/nonIndex/';

  //imman

  /// Create EMO API
  static const String createPrem = '${baseUrl}api/prem/create';

  /// Update EMO - Triage
  static const String updatePrem = '${baseUrl}api/prem/';

  /// Get List of EMO
  static const String getPrem = '${baseUrl}api/prem/list';

  /// Get Prem Dashboard
  static const String getPremDashboard = '${baseUrl}api/summary/Prem';

  /// Get EMO - Triage by ID
  static const String getPremById = '${baseUrl}api/prem/getById/';

  /// Delete EMO - Triage by ID
  static const String deletePrem = '${baseUrl}api/prem/';

  /// Get EMO - Triage Lookup
  static const String getPremLookup = '${baseUrl}api/prem/lookup';

  /// Create EMO API
  static const String createStemi = '${baseUrl}api/stemi/stemi-all/create';

  /// Update EMO - Triage
  static const String updateStemi = '${baseUrl}api/prem/';

  /// Get List of EMO
  // static const String getPrem = '${baseUrl}api/prem';
  //
  // /// Get EMO - Triage by ID
  static const String getStemiById = '${baseUrl}api/stemi/stemi-all/';

  // static const String deletePrem = '${baseUrl}api/prem/';

  /// Get EMO - Triage Lookup
  static const String getStemiLookup = '${baseUrl}api/stemi/lookup';

  static const String getStemiList = '${baseUrl}api/stemi/stemi-admission/list';
  static const String getStemiOpList = '${baseUrl}api/stemi/stemi-all/0/';
  static const String getOp = '${baseUrl}api/stemi/stemi-op/list';

  //imman

  static const String createBites = '${baseUrl}api/bitesStings/create';

  /// Update EMO - Triage
  static const String updateBites = '${baseUrl}api/bitesStings/';

  /// Get List of EMO
  static const String getBites = '${baseUrl}api/bitesStings/list';

  /// Get EMO - Triage by ID
  static const String getBitesById = '${baseUrl}api/bitesStings/getById/';

  static const String getBitesByTriageId =
      '${baseUrl}api/bitesStings/getByTriageId/';

  static const String getPoisonByTriageId =
      '${baseUrl}api/poisons/getByTriageId/';

  // get bites stings dashboard
  static const String getBitesStingsDashboard =
      '${baseUrl}api/summary/BitesStings';

  /// Delete EMO - Triage by ID
  static const String deleteBites = '${baseUrl}api/bitesStings/';

  /// Get EMO - Triage Lookup
  static const String getBitesLookup = '${baseUrl}api/bitesStings/lookup';

  /// Create Trauma API
  static const String createTrauma = '${baseUrl}api/trauma/create';

  /// Update Trauma API
  static const String updateTrauma = '${baseUrl}api/trauma/';

  /// Get List of Trauma
  static const String getTrauma = '${baseUrl}api/trauma/';

  /// Get List of Trauma Summary
  static const String getTraumaDashboard = '${baseUrl}api/summary/Trauma';

  /// Get List of Case
  static const String getCaseList =
      '${baseUrl}api/trauma/list?limit=10&offset=0';

  /// Get Trauma by ID
  static const String getTraumaById = '${baseUrl}api/trauma/getById/';

  /// Delete Trauma by ID
  static const String deleteTrauma = '${baseUrl}api/trauma/';

  /// Get Trauma Lookup
  static const String getTraumaLookup =
      '${baseUrl}api/trauma/lookup'; // create burn record
  static const String createBurnRecord = '${baseUrl}api/burns/create';

  static const String getTraumaDetails = '${baseUrl}api/trauma/nonIndex/';

  // get burn record
  static const String getBurnRecord = '${baseUrl}api/burns';

  /// Get burn by ID
  static const String getBurnById = '${baseUrl}api/burns/GetById/';

  // update burn record
  static const String updateBurnRecord = '${baseUrl}api/burns/';

  // delete burn record
  static const String deleteBurnRecord = '${baseUrl}api/burns';

  /// Get burn list
  static const String getBurnList = '${baseUrl}api/burns/';

  // get burns dashboard
  static const String getBurnsDashboard = '${baseUrl}api/summary/Burns';

  // get burn record by id
  static const String getBurnRecordById = '${baseUrl}api/burns/GetById';

  // get burn lookup
  static const String getBurnLookup = '${baseUrl}api/Burns/lookup';

  // get burn details
  static const String getBurnDetails = '${baseUrl}api/burns/nonIndex/';

  // Login
  static const String login = '${authUrl}api/auth/login';

  // validate token
  static const String validateToken = '${authUrl}api/auth/validate-token';

  // Aadhaar OTP APIs
  static const String sendAadhaarOtp = '${local}api/abha/aadhaar/generate-otp';
  static const String verifyAadhaarOtp = '${local}api/abha/aadhaar/verify-otp';
  static const String updateMobileSendOtp = '${local}api/abha/updatemobile/send-otp';
  static const String updateMobileVerifyOtp = '${local}api/abha/updatemobile/verify-otp';
  static const String sendVerifyAbhaOtp = '${local}api/abha/login/send-otp';
  static const String verifyVerifyAbhaOtp = '${local}api/abha/login/verify-otp';
  static const String mobileOtpVerify = '${local}api/abha/login/mobile/verify-otp';
  static const String abhaAddressSendOtp = '${local}api/abha/abha-address/send-otp';
  static const String abhaAddressVerifyOtp =
      '${local}api/abha/abha-address/verify-otp';
  static const String abhaAddressSuggestions =
      '${local}api/abha/address/suggestions';
  static const String abhaAddressCreate = '${local}api/abha/address/create';

  static const String fingerprintCapture =
      '${local}api/abha/fingerprint/capture';
  static const String biometricFingerprintEnroll =
      '${local}api/abha/aadhaar/biometric-fingerprint-enroll';
  static const String demoAuthEnrollByAadhaar =
      '${local}api/abha/aadhaar/enrol-by-aadhaar';
  static const String downloadAbhaCard =
      '${local}api/abha/card'; // Append /{profileId}

  // Add Screipt
  static const String createScript = '${baseUrl}api/stroke/create';

  // getById Script
  static const String getScriptById = '${baseUrl}api/stroke/getById/';

  /// update Script
  static const String updateScript = '${baseUrl}api/stroke/';

  // Get Script List
  static const String getScriptList = '${baseUrl}api/stroke/';

  // Get Script Lookup
  static const String scriptLookup = '${baseUrl}api/stroke/lookup';

  // get stroke dashboard
  static const String getStrokeDashboard = '${baseUrl}api/summary/Stroke';

  /// Get Poisoning List

  static const String createPoisoning = '${baseUrl}api/poisons/create';
  static const String getPoisoningList = '${baseUrl}api/poisons/';
  static const String getPoisoningLookup = '${baseUrl}api/Poisons/lookup';
  static const String getPoisoningById = '${baseUrl}api/poisons/getById/';
  static const String updatePoisoning = '${baseUrl}api/poisons/';
  static const String getPoisoningDashboard = '${baseUrl}api/summary/Poison';
  static const String getPoisoningDetails = '${baseUrl}api/poisons/nonIndex/';

  // hanging lookup list
  static const String hangingLookupList = '${baseUrl}api/hanging/lookup';

  // create hanging record
  static const String createHangingRecord = '${baseUrl}api/hanging/create';

  // get hanging record
  static const String getHangingRecord = '${baseUrl}api/hanging/list';

  // get hanging record by id
  static const String getHangingRecordById = '${baseUrl}api/hanging/getById/';

  // update hanging record
  static const String updateHangingRecord = '${baseUrl}api/hanging/';

  // delete hanging record
  static const String deleteHangingRecord = '${baseUrl}api/hanging';

  // get hanging dashboard
  static const String getHangingDashboard = '${baseUrl}api/summary/Hanging';

  // create drowning
  static const String createDrowningRecord =
      '${baseUrl}api/drowning/drowning-all/create';

  // get drowning record
  static const String getDrowningRecord = '${baseUrl}api/drowning/list';

  // get drowning record by id
  static const String getDrowningRecordById =
      '${baseUrl}api/drowning/drowning-all/';

  // update drowning record
  static const String updateDrowningRecord =
      '${baseUrl}api/drowning/drowning-all/create';

  // drowning lookup
  static const String drowningLookup = '${baseUrl}api/drowning/lookups';

  ///////////////////////////////////////////////
  /// Institutional Dashboard
  static const String getInstitutionalDashboard =
      '${baseUrl}api/dashboard/get-poison-report-new';

  static const String getKPI = '${baseUrl}api/dashboard/get-kpi-dashboard-new';
  static const String reportDashboard =
      '${baseUrl}api/dashboard/get-report-dashboard-new';
  static const String entryDashboard =
      '${baseUrl}api/dashboard/get-entry-report-new';
  static const String patientEntryReport =
      '${baseUrl}api/dashboard/get-entry-report-list';
  static const String getInstitutionById =
      '${baseUrl}api/dashboard/get-hospital-by-district';
  static const String getInstitutionList =
      '${baseUrl}api/dashboard/get-hospital-by-district';
  static const String getTaeiReportDashboard =
      '${taeiReportUrl}API108/taei_full_report';
}
