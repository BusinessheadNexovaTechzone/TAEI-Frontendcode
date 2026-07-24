import 'dart:convert';

StrokeDetails hangingDetailsFromJson(String str) =>
    StrokeDetails.fromJson(json.decode(str));

String hangingDetailsToJson(StrokeDetails data) =>
    json.encode(data.toJson());

class StrokeDetails {
  Stroke? stroke;
  Outcome? outcome;

  StrokeDetails({this.stroke, this.outcome});

  StrokeDetails.fromJson(Map<String, dynamic> json) {
    stroke = json['stroke'] != null ? Stroke.fromJson(json['stroke']) : null;
    outcome = json['outcome'] != null ? Outcome.fromJson(json['outcome']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (stroke != null) data['stroke'] = stroke!.toJson();
    if (outcome != null) data['outcome'] = outcome!.toJson();
    return data;
  }
}

class Stroke {
  int? id;
  int? triageId;
  String? dateTimeOfEntry;
  String? arrivalTimeSymptoms;
  String? reasonForDelay;
  String? sceneIft;
  String? referredFrom;
  String? reasonForReferral;
  String? othReasonForReferral;
  String? admitted;
  String? admittedDateTime;
  String? lysisDoneOutside;
  String? lysisDoneOutsideDate;
  String? symptoms;
  String? absoluteContraindication;
  String? othAbsoluteContraindication;
  String? nihsScale;
  String? cbg;
  String? cbgDate;
  String? historyOfAnticoagulant;
  String? bpSbp;
  String? bpDbp;
  String? aspectScore;
  String? ctScan;
  String? ctScanDate;
  String? mriScan;
  String? mriScanDate;
  String? mriScanEligibility;
  String? cathLabProcedure;
  String? cathLabProcedureDate;
  String? procedureDone;
  String? nameOfProcedure;
  String? type;
  String? lysisDone;
  String? lysisDate;
  String? thrombolysisByDrug;
  String? thrombectomy;
  String? thrombectomyDtls;
  String? decompressionCraniectomy;
  String? decompressionCraniectomyDtls;
  String? drugPrescribed;
  int? userId;
  String? insertedDate;
  int? refFormId;
  int? refId;

  Stroke({
    this.id,
    this.triageId,
    this.dateTimeOfEntry,
    this.arrivalTimeSymptoms,
    this.reasonForDelay,
    this.sceneIft,
    this.referredFrom,
    this.reasonForReferral,
    this.othReasonForReferral,
    this.admitted,
    this.admittedDateTime,
    this.lysisDoneOutside,
    this.lysisDoneOutsideDate,
    this.symptoms,
    this.absoluteContraindication,
    this.othAbsoluteContraindication,
    this.nihsScale,
    this.cbg,
    this.cbgDate,
    this.historyOfAnticoagulant,
    this.bpSbp,
    this.bpDbp,
    this.aspectScore,
    this.ctScan,
    this.ctScanDate,
    this.mriScan,
    this.mriScanDate,
    this.mriScanEligibility,
    this.cathLabProcedure,
    this.cathLabProcedureDate,
    this.procedureDone,
    this.nameOfProcedure,
    this.type,
    this.lysisDone,
    this.lysisDate,
    this.thrombolysisByDrug,
    this.thrombectomy,
    this.thrombectomyDtls,
    this.decompressionCraniectomy,
    this.decompressionCraniectomyDtls,
    this.drugPrescribed,
    this.userId,
    this.insertedDate,
    this.refFormId,
    this.refId,
  });

  Stroke.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    triageId = json['triage_id'] ?? 0;
    dateTimeOfEntry = json['date_time_of_entry'] ?? '';
    arrivalTimeSymptoms = json['arrival_time_symptoms'] ?? '';
    reasonForDelay = json['reason_for_delay'] ?? '';
    sceneIft = json['scene_ift'];
    referredFrom = json['referred_from'] ?? '';
    reasonForReferral = json['reason_for_referral'] ?? '';
    othReasonForReferral = json['oth_reason_for_referral'] ?? '';
    admitted = json['admitted'] ?? '';
    admittedDateTime = json['admitted_date_time'];
    lysisDoneOutside = json['lysis_done_outside'] ?? '';
    lysisDoneOutsideDate = json['lysis_done_outside_date'];
    symptoms = json['symptoms'] ?? '';
    absoluteContraindication = json['absolute_contraindication'] ?? '';
    othAbsoluteContraindication = json['oth_absolute_contraindication'] ?? '';
    nihsScale = json['nihs_scale'] ?? '';
    cbg = json['cbg'] ?? '';
    cbgDate = json['cbg_date'];
    historyOfAnticoagulant = json['history_of_anticoagulant'] ?? '';
    bpSbp = json['bp_sbp'];
    bpDbp = json['bp_dbp'];
    aspectScore = json['aspect_score'];
    ctScan = json['ct_scan'] ?? '';
    ctScanDate = json['ct_scan_date'];
    mriScan = json['mri_scan'] ?? '';
    mriScanDate = json['mri_scan_date'];
    mriScanEligibility = json['mri_scan_eligibility'] ?? '';
    cathLabProcedure = json['cath_lab_procedure'] ?? '';
    cathLabProcedureDate = json['cath_lab_procedure_date'];
    procedureDone = json['procedure_done'] ?? '';
    nameOfProcedure = json['name_of_procedure'] ?? '';
    type = json['type'] ?? '';
    lysisDone = json['lysis_done'] ?? '';
    lysisDate = json['lysis_date'];
    thrombolysisByDrug = json['thrombolysis_by_drug'] ?? '';
    thrombectomy = json['thrombectomy'] ?? '';
    thrombectomyDtls = json['thrombectomy_dtls'] ?? '';
    decompressionCraniectomy = json['decompression_craniectomy'] ?? '';
    decompressionCraniectomyDtls = json['decompression_craniectomy_dtls'];
    drugPrescribed = json['drug_prescribed'];
    userId = json['user_id'];
    insertedDate = json['inserted_date'];
    refFormId = json['ref_form_id'];
    refId = json['ref_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['triage_id'] = triageId;
    data['date_time_of_entry'] = dateTimeOfEntry;
    data['arrival_time_symptoms'] = arrivalTimeSymptoms;
    data['reason_for_delay'] = reasonForDelay;
    data['scene_ift'] = sceneIft;
    data['referred_from'] = referredFrom;
    data['reason_for_referral'] = reasonForReferral;
    data['oth_reason_for_referral'] = othReasonForReferral;
    data['admitted'] = admitted;
    data['admitted_date_time'] = admittedDateTime;
    data['lysis_done_outside'] = lysisDoneOutside;
    data['lysis_done_outside_date'] = lysisDoneOutsideDate;
    data['symptoms'] = symptoms;
    data['absolute_contraindication'] = absoluteContraindication;
    data['oth_absolute_contraindication'] = othAbsoluteContraindication;
    data['nihs_scale'] = nihsScale;
    data['cbg'] = cbg;
    data['cbg_date'] = cbgDate;
    data['history_of_anticoagulant'] = historyOfAnticoagulant;
    data['bp_sbp'] = bpSbp;
    data['bp_dbp'] = bpDbp;
    data['aspect_score'] = aspectScore;
    data['ct_scan'] = ctScan;
    data['ct_scan_date'] = ctScanDate;
    data['mri_scan'] = mriScan;
    data['mri_scan_date'] = mriScanDate;
    data['mri_scan_eligibility'] = mriScanEligibility;
    data['cath_lab_procedure'] = cathLabProcedure;
    data['cath_lab_procedure_date'] = cathLabProcedureDate;
    data['procedure_done'] = procedureDone;
    data['name_of_procedure'] = nameOfProcedure;
    data['type'] = type;
    data['lysis_done'] = lysisDone;
    data['lysis_date'] = lysisDate;
    data['thrombolysis_by_drug'] = thrombolysisByDrug;
    data['thrombectomy'] = thrombectomy;
    data['thrombectomy_dtls'] = thrombectomyDtls;
    data['decompression_craniectomy'] = decompressionCraniectomy;
    data['decompression_craniectomy_dtls'] = decompressionCraniectomyDtls;
    data['drug_prescribed'] = drugPrescribed;
    data['user_id'] = userId;
    data['inserted_date'] = insertedDate;
    data['ref_form_id'] = refFormId;
    data['ref_id'] = refId;
    return data;
  }
}

class Outcome {
  int? id;
  String? outcome;
  String? dischargeDate;
  String? dischargeStaticDate;
  String? damaDate;
  String? abscondedDate;
  String? deathDate;
  String? transferredWardDate;
  String? transferredIcuDate;
  String? causeOfDeath;
  String? transferredTo;
  String? hospitalType;
  String? destinationHospital;
  String? destinationTaeiHospital;
  String? reasonForReferral;
  String? conditionOfPatient;
  String? referringDoctor;
  String? documentedTaeiSheet;
  String? treatmentGiven;
  int? durationStay;
  String? is_discharged;

  Outcome({
    this.id,
    this.outcome,
    this.dischargeDate,
    this.dischargeStaticDate,
    this.damaDate,
    this.abscondedDate,
    this.deathDate,
    this.transferredWardDate,
    this.transferredIcuDate,
    this.causeOfDeath,
    this.transferredTo,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.documentedTaeiSheet,
    this.treatmentGiven,
    this.durationStay,
    this.is_discharged
  });

  Outcome.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    outcome = json['outcome'] ?? '';
    dischargeDate = json['discharge_date'] ?? '';
    dischargeStaticDate = json['discharge_static_date'];
    damaDate = json['dama_date'];
    abscondedDate = json['absconded_date'];
    deathDate = json['death_date'];
    transferredWardDate = json['transferred_ward_date'];
    transferredIcuDate = json['transferred_icu_date'];
    causeOfDeath = json['cause_of_death'];
    transferredTo = json['transferred_to'] ?? '';
    hospitalType = json['hospital_type'] ?? '';
    destinationHospital = json['destination_hospital'] ?? '';
    destinationTaeiHospital = json['destination_taei_hospital'];
    reasonForReferral = json['reason_for_referral'] ?? '';
    conditionOfPatient = json['condition_of_patient'] ?? '';
    referringDoctor = json['referring_doctor'] ?? '';
    documentedTaeiSheet = json['documented_taei_sheet'] ?? '';
    treatmentGiven = json['treatment_given'] ?? '';
    durationStay = json['duration_stay'] ?? 0;
    is_discharged = json['is_discharged'];

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['outcome'] = outcome;
    data['discharge_date'] = dischargeDate;
    data['discharge_static_date'] = dischargeStaticDate;
    data['dama_date'] = damaDate;
    data['absconded_date'] = abscondedDate;
    data['death_date'] = deathDate;
    data['transferred_ward_date'] = transferredWardDate;
    data['transferred_icu_date'] = transferredIcuDate;
    data['cause_of_death'] = causeOfDeath;
    data['transferred_to'] = transferredTo;
    data['hospital_type'] = hospitalType;
    data['destination_hospital'] = destinationHospital;
    data['destination_taei_hospital'] = destinationTaeiHospital;
    data['reason_for_referral'] = reasonForReferral;
    data['condition_of_patient'] = conditionOfPatient;
    data['referring_doctor'] = referringDoctor;
    data['documented_taei_sheet'] = documentedTaeiSheet;
    data['treatment_given'] = treatmentGiven;
    data['duration_stay'] = durationStay;
    data['is_discharged'] = is_discharged;
    return data;
  }
}
