// // To parse this JSON data, do
// //
// //     final createScriptModel = createScriptModelFromJson(jsonString);

// import 'dart:convert';

// CreateScriptModel createScriptModelFromJson(String str) =>
//     CreateScriptModel.fromJson(json.decode(str));

// String createScriptModelToJson(CreateScriptModel data) =>
//     json.encode(data.toJson());

// class CreateScriptModel {
//   Stroke? stroke;
//   Outcome? outcome;

//   CreateScriptModel({
//     this.stroke,
//     this.outcome,
//   });

//   factory CreateScriptModel.fromJson(Map<String, dynamic> json) =>
//       CreateScriptModel(
//         stroke: json["stroke"] == null ? null : Stroke.fromJson(json["stroke"]),
//         outcome:
//             json["outcome"] == null ? null : Outcome.fromJson(json["outcome"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "stroke": stroke?.toJson(),
//         "outcome": outcome?.toJson(),
//       };

//   @override
//   String toString() => jsonEncode(toJson());
// }

// class Outcome {
//   int? id;
//   int? strokeId;
//   int? outcome;
//   String? dischargeDate;
//   String? dischargeStaticDate;
//   String? damaDate;
//   String? abscondedDate;
//   String? deathDate;
//   String? transferredWardDate;
//   String? transferredIcuDate;
//   dynamic causeOfDeath;
//   int? transferredTo;
//   int? hospitalType;
//   String? destinationHospital;
//   int? destinationTAEIHospitalId;
//   int? reasonForReferral;
//   int? conditionOfPatient;
//   String? referringDoctor;
//   bool? documentedTaeiSheet;
//   String? treatmentGiven;
//   int? durationStay;
//   bool? isDischarged;

//   Outcome({
//     this.id,
//     this.strokeId,
//     this.outcome,
//     this.dischargeDate,
//     this.dischargeStaticDate,
//     this.damaDate,
//     this.abscondedDate,
//     this.deathDate,
//     this.transferredWardDate,
//     this.transferredIcuDate,
//     this.causeOfDeath,
//     this.transferredTo,
//     this.hospitalType,
//     this.destinationHospital,
//     this.destinationTAEIHospitalId,
//     this.reasonForReferral,
//     this.conditionOfPatient,
//     this.referringDoctor,
//     this.documentedTaeiSheet,
//     this.treatmentGiven,
//     this.durationStay,
//     this.isDischarged,
//   });

//   factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
//         id: json["id"],
//         strokeId: json["stroke_id"],
//         outcome: json["outcome"],
//         dischargeDate: json["discharge_date"],
//         dischargeStaticDate: json["discharge_static_date"],
//         damaDate: json["dama_date"],
//         abscondedDate: json["absconded_date"],
//         deathDate: json["death_date"],
//         transferredWardDate: json["transferred_ward_date"],
//         transferredIcuDate: json["transferred_icu_date"],
//         causeOfDeath: json["cause_of_death"],
//         transferredTo: json["transferred_to"],
//         hospitalType: json["hospital_type"],
//         destinationHospital: json["destination_hospital"],
//         destinationTAEIHospitalId: json["destination_taei_hospital"],
//         reasonForReferral: json["reason_for_referral"],
//         conditionOfPatient: json["condition_of_patient"],
//         referringDoctor: json["referring_doctor"],
//         documentedTaeiSheet: json["documented_taei_sheet"],
//         treatmentGiven: json["treatment_given"],
//         durationStay: json["duration_stay"],
//         isDischarged: json["is_discharged"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "stroke_id": strokeId,
//         "outcome": outcome,
//         "discharge_date": dischargeDate,
//         "discharge_static_date": dischargeStaticDate,
//         "dama_date": damaDate,
//         "absconded_date": abscondedDate,
//         "death_date": deathDate,
//         "transferred_ward_date": transferredWardDate,
//         "transferred_icu_date": transferredIcuDate,
//         "cause_of_death": causeOfDeath,
//         "transferred_to": transferredTo,
//         "hospital_type": hospitalType,
//         "destination_hospital": destinationHospital,
//         "destination_taei_hospital": destinationTAEIHospitalId,
//         "reason_for_referral": reasonForReferral,
//         "condition_of_patient": conditionOfPatient,
//         "referring_doctor": referringDoctor,
//         "documented_taei_sheet": documentedTaeiSheet,
//         "treatment_given": treatmentGiven,
//         "duration_stay": durationStay,
//         "is_discharged": isDischarged,
//       };

//   @override
//   String toString() => jsonEncode(toJson());
// }

// class Stroke {
//   int? id;
//   int? triageId;
//   String? dateTimeOfEntry;
//   int? arrivalTimeSymptoms;
//   int? reasonForDelay;
//   int? sceneIft;
//   int? referredFrom;
//   int? reasonForReferral;
//   String? othReasonForReferral;
//   bool? admitted;
//   String? admittedDateTime;
//   bool? lysisDoneOutside;
//   String? lysisDoneOutsideDate;
//   int? symptoms;
//   List<int>? absoluteContraindication;
//   String? othAbsoluteContraindication;
//   int? nihsScale;
//   bool? cbg;
//   String? cbgDate;

//   // "history_of_anticoagulant": true,
//   //         "bp_sbp": "120  ",
//   //         "bp_dbp": "80",
//   //         "aspect_score": "35",
//   bool? historyOfAnticoagulant;
//   String? bpSbp;
//   String? bpDbp;
//   String? aspectScore;
//   bool? ctScan;
//   String? ctScanDate;
//   bool? mriScan;
//   dynamic mriScanDate;
//   int? mriScanEligibility;
//   bool? cathLabProcedure;
//   String? cathLabProcedureDate;
//   bool? procedureDone;
//   String? nameOfProcedure;
//   int? type;
//   bool? lysisDone;
//   String? lysisDate;
//   int? thrombolysisByDrug;
//   bool? thrombectomy;
//   String? thrombectomyDtls;
//   bool? decompressionCraniectomy;
//   dynamic decompressionCraniectomyDtls;

//   //ref_form_id
//   //ref_id
//   int? refFormId;
//   int? refId;

//   Stroke({
//     this.id,
//     this.triageId,
//     this.dateTimeOfEntry,
//     this.arrivalTimeSymptoms,
//     this.reasonForDelay,
//     this.sceneIft,
//     this.referredFrom,
//     this.reasonForReferral,
//     this.othReasonForReferral,
//     this.admitted,
//     this.admittedDateTime,
//     this.lysisDoneOutside,
//     this.lysisDoneOutsideDate,
//     this.symptoms,
//     this.absoluteContraindication,
//     this.othAbsoluteContraindication,
//     this.nihsScale,
//     this.cbg,
//     this.cbgDate,
//     this.historyOfAnticoagulant,
//     this.bpSbp,
//     this.bpDbp,
//     this.aspectScore,
//     this.ctScan,
//     this.ctScanDate,
//     this.mriScan,
//     this.mriScanDate,
//     this.mriScanEligibility,
//     this.cathLabProcedure,
//     this.cathLabProcedureDate,
//     this.procedureDone,
//     this.nameOfProcedure,
//     this.type,
//     this.lysisDone,
//     this.lysisDate,
//     this.thrombolysisByDrug,
//     this.thrombectomy,
//     this.thrombectomyDtls,
//     this.decompressionCraniectomy,
//     this.decompressionCraniectomyDtls,
//     this.refFormId,
//     this.refId,
//   });

//   factory Stroke.fromJson(Map<String, dynamic> json) => Stroke(
//         id: json["id"],
//         triageId: json["triage_id"],
//         dateTimeOfEntry: json["date_time_of_entry"],
//         arrivalTimeSymptoms: json["arrival_time_symptoms"],
//         reasonForDelay: json["reason_for_delay"],
//         sceneIft: json["scene_ift"],
//         referredFrom: json["referred_from"],
//         reasonForReferral: json["reason_for_referral"],
//         othReasonForReferral: json["oth_reason_for_referral"],
//         admitted: json["admitted"],
//         admittedDateTime: json["admitted_date_time"],
//         lysisDoneOutside: json["lysis_done_outside"],
//         lysisDoneOutsideDate: json["lysis_done_outside_date"],
//         symptoms: json["symptoms"],
//         absoluteContraindication: json["absolute_contraindication"] == null
//             ? []
//             : List<int>.from(json["absolute_contraindication"]!.map((x) => x)),
//         othAbsoluteContraindication: json["oth_absolute_contraindication"],
//         nihsScale: json["nihs_scale"],
//         cbg: json["cbg"],
//         cbgDate: json["cbg_date"],
//         historyOfAnticoagulant: json["history_of_anticoagulant"],
//         bpSbp: json["bp_sbp"],
//         bpDbp: json["bp_dbp"],
//         aspectScore: json["aspect_score"],
//         ctScan: json["ct_scan"],
//         ctScanDate: json["ct_scan_date"],
//         mriScan: json["mri_scan"],
//         mriScanDate: json["mri_scan_date"],
//         mriScanEligibility: json["mri_scan_eligibility"],
//         cathLabProcedure: json["cath_lab_procedure"],
//         cathLabProcedureDate: json["cath_lab_procedure_date"],
//         procedureDone: json["procedure_done"],
//         nameOfProcedure: json["name_of_procedure"],
//         type: json["type"],
//         lysisDone: json["lysis_done"],
//         lysisDate: json["lysis_date"],
//         thrombolysisByDrug: json["thrombolysis_by_drug"],
//         thrombectomy: json["thrombectomy"],
//         thrombectomyDtls: json["thrombectomy_dtls"],
//         decompressionCraniectomy: json["decompression_craniectomy"],
//         decompressionCraniectomyDtls: json["decompression_craniectomy_dtls"],
//         refFormId: json["ref_form_id"],
//         refId: json["ref_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "triage_id": triageId,
//         "date_time_of_entry": dateTimeOfEntry,
//         "arrival_time_symptoms": arrivalTimeSymptoms,
//         "reason_for_delay": reasonForDelay,
//         "scene_ift": sceneIft,
//         "referred_from": referredFrom,
//         "reason_for_referral": reasonForReferral,
//         "oth_reason_for_referral": othReasonForReferral,
//         "admitted": admitted,
//         "admitted_date_time": admittedDateTime,
//         "lysis_done_outside": lysisDoneOutside,
//         "lysis_done_outside_date": lysisDoneOutsideDate,
//         "symptoms": symptoms,
//         "absolute_contraindication": absoluteContraindication == null
//             ? []
//             : List<dynamic>.from(absoluteContraindication!.map((x) => x)),
//         "oth_absolute_contraindication": othAbsoluteContraindication,
//         "nihs_scale": nihsScale,
//         "cbg": cbg,
//         "cbg_date": cbgDate,
//         "history_of_anticoagulant": historyOfAnticoagulant,
//         "bp_sbp": bpSbp,
//         "bp_dbp": bpDbp,
//         "aspect_score": aspectScore,
//         "ct_scan": ctScan,
//         "ct_scan_date": ctScanDate,
//         "mri_scan": mriScan,
//         "mri_scan_date": mriScanDate,
//         "mri_scan_eligibility": mriScanEligibility,
//         "cath_lab_procedure": cathLabProcedure,
//         "cath_lab_procedure_date": cathLabProcedureDate,
//         "procedure_done": procedureDone,
//         "name_of_procedure": nameOfProcedure,
//         "type": type,
//         "lysis_done": lysisDone,
//         "lysis_date": lysisDate,
//         "thrombolysis_by_drug": thrombolysisByDrug,
//         "thrombectomy": thrombectomy,
//         "thrombectomy_dtls": thrombectomyDtls,
//         "decompression_craniectomy": decompressionCraniectomy,
//         "decompression_craniectomy_dtls": decompressionCraniectomyDtls,
//         "ref_form_id": refFormId,
//         "ref_id": refId,
//       };

//   @override
//   String toString() => jsonEncode(toJson());
// }
// //extension PoisonModelClean on PoisoningModel {
// //   Map<String, dynamic> toCleanJson() {
// //     final data = toJson();
// //     if (data['poison'] != null) {
// //       data['poison'].remove('id');
// //     }
// //     if (data['poisons_outcome'] != null) {
// //       data['poisons_outcome'].remove('id');
// //       data['poisons_outcome'].remove('poison_id');
// //     }
// //     return data;
// //   }
// // }

// extension StrokeModelClean on CreateScriptModel {
//   Map<String, dynamic> toCleanJson() {
//     final data = toJson();
//     if (data['stroke'] != null) {
//       data['stroke'].remove('id');
//     }
//     if (data['outcome'] != null) {
//       data['outcome'].remove('id');
//       data['outcome'].remove('stroke_id');
//     }
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final createScriptModel = createScriptModelFromJson(jsonString);

import 'dart:convert';

CreateScriptModel createScriptModelFromJson(String str) =>
    CreateScriptModel.fromJson(json.decode(str));

String createScriptModelToJson(CreateScriptModel data) =>
    json.encode(data.toJson());

class CreateScriptModel {
  Stroke? stroke;
  Outcome? outcome;

  CreateScriptModel({
    this.stroke,
    this.outcome,
  });

  factory CreateScriptModel.fromJson(Map<String, dynamic> json) =>
      CreateScriptModel(
        stroke: json["stroke"] == null ? null : Stroke.fromJson(json["stroke"]),
        outcome:
            json["outcome"] == null ? null : Outcome.fromJson(json["outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "stroke": stroke?.toJson(),
        "outcome": outcome?.toJson(),
      };
}

class Outcome {
  int? outcome;
  bool? isDischarged;
  String? dischargeDate;
  String? dischargeStaticDate;
  String? damaDate;
  String? abscondedDate;
  String? deathDate;
  String? transferredWardDate;
  String? transferredIcuDate;
  dynamic causeOfDeath;
  int? transferredTo;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTaeiHospital;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctor;
  bool? documentedTaeiSheet;
  String? treatmentGiven;
  String? drugPrescribed;
  int? durationStay;

  Outcome({
    this.outcome,
    this.isDischarged,
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
    this.drugPrescribed,
    this.durationStay,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
        outcome: json["outcome"],
        isDischarged: json["is_discharged"],
        dischargeDate: json["discharge_date"],
        dischargeStaticDate: json["discharge_static_date"],
        damaDate: json["dama_date"],
        abscondedDate: json["absconded_date"],
        deathDate: json["death_date"],
        transferredWardDate: json["transferred_ward_date"],
        transferredIcuDate: json["transferred_icu_date"],
        causeOfDeath: json["cause_of_death"],
        transferredTo: json["transferred_to"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctor: json["referring_doctor"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        treatmentGiven: json["treatment_given"],
        drugPrescribed: json["drug_prescribed"],
        durationStay: json["duration_stay"],
      );

  Map<String, dynamic> toJson() => {
        "outcome": outcome,
        "is_discharged": isDischarged,
        "discharge_date": dischargeDate,
        "discharge_static_date": dischargeStaticDate,
        "dama_date": damaDate,
        "absconded_date": abscondedDate,
        "death_date": deathDate,
        "transferred_ward_date": transferredWardDate,
        "transferred_icu_date": transferredIcuDate,
        "cause_of_death": causeOfDeath,
        "transferred_to": transferredTo,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor": referringDoctor,
        "documented_taei_sheet": documentedTaeiSheet,
        "treatment_given": treatmentGiven,
        "drug_prescribed": drugPrescribed,
        "duration_stay": durationStay,
      };
}

class Stroke {
  int? triageId;
  String? dateTimeOfEntry;
  int? arrivalTimeSymptoms;
  int? reasonForDelay;
  String? othReasonForDelay;
  int? sceneIft;
  int? referredFrom;
  int? reasonForReferral;
  String? othReasonForReferral;
  bool? admitted;
  String? admittedDateTime;
  bool? lysisDoneOutside;
  String? lysisDoneOutsideDate;
  List<int>? symptoms;
  List<int>? riskFactors;
  String? othRiskFactors;
  String? nihsScale;
  String? preMorbitScroe;
  bool? isAbsoluteContraindication;
  String? othAbsoluteContraindication;
  bool? cbg;
  String? cbgDate;
  String? cbgTxt;
  bool? historyOfAnticoagulant;
  String? bpSbp;
  String? bpDbp;
  String? aspectScore;
  bool? ctScan;
  String? ctScanDate;
  String? ctScanFindings;
  bool? mriScan;
  String? mriScanDate;
  int? mriScanEligibility;
  String? mriScanEligilityStatus;
  bool? cathLabProcedure;
  String? cathLabProcedureDate;
  String? cathLabFindings;
  bool? procedureDone;
  String? nameOfProcedure;
  int? type;
  String? hemorrhagicSpecify;
  bool? lysisDone;
  String? lysisDate;
  int? thrombolysisByDrug;
  bool? thrombectomy;
  String? thrombectomyDtls;
  bool? decompressionCraniectomy;
  dynamic decompressionCraniectomyDtls;
  String? drugPrescribed;
  int? refFormId;
  int? refId;

  Stroke({
    this.triageId,
    this.dateTimeOfEntry,
    this.arrivalTimeSymptoms,
    this.reasonForDelay,
    this.othReasonForDelay,
    this.sceneIft,
    this.referredFrom,
    this.reasonForReferral,
    this.othReasonForReferral,
    this.admitted,
    this.admittedDateTime,
    this.lysisDoneOutside,
    this.lysisDoneOutsideDate,
    this.symptoms,
    this.riskFactors,
    this.othRiskFactors,
    this.nihsScale,
    this.preMorbitScroe,
    this.isAbsoluteContraindication,
    this.othAbsoluteContraindication,
    this.cbg,
    this.cbgDate,
    this.cbgTxt,
    this.historyOfAnticoagulant,
    this.bpSbp,
    this.bpDbp,
    this.aspectScore,
    this.ctScan,
    this.ctScanDate,
    this.ctScanFindings,
    this.mriScan,
    this.mriScanDate,
    this.mriScanEligibility,
    this.mriScanEligilityStatus,
    this.cathLabProcedure,
    this.cathLabProcedureDate,
    this.cathLabFindings,
    this.procedureDone,
    this.nameOfProcedure,
    this.type,
    this.hemorrhagicSpecify,
    this.lysisDone,
    this.lysisDate,
    this.thrombolysisByDrug,
    this.thrombectomy,
    this.thrombectomyDtls,
    this.decompressionCraniectomy,
    this.decompressionCraniectomyDtls,
    this.drugPrescribed,
    this.refFormId,
    this.refId,
  });

  factory Stroke.fromJson(Map<String, dynamic> json) => Stroke(
        triageId: json["triage_id"],
        dateTimeOfEntry: json["date_time_of_entry"],
        arrivalTimeSymptoms: json["arrival_time_symptoms"],
        reasonForDelay: json["reason_for_delay"],
        othReasonForDelay: json["oth_reason_for_delay"],
        sceneIft: json["scene_ift"],
        referredFrom: json["referred_from"],
        reasonForReferral: json["reason_for_referral"],
        othReasonForReferral: json["oth_reason_for_referral"],
        admitted: json["admitted"],
        admittedDateTime: json["admitted_date_time"],
        lysisDoneOutside: json["lysis_done_outside"],
        lysisDoneOutsideDate: json["lysis_done_outside_date"],
        symptoms: json["symptoms"],
        riskFactors: json["risk_factors"] == null
            ? []
            : List<int>.from(json["risk_factors"]!.map((x) => x)),
        othRiskFactors: json["oth_risk_factors"],
        nihsScale: json["nihs_scale"],
        preMorbitScroe: json["pre_morbit_scroe"],
        isAbsoluteContraindication: json["is_absolute_contraindication"],
        othAbsoluteContraindication: json["oth_absolute_contraindication"],
        cbg: json["cbg"],
        cbgDate: json["cbg_date"],
        cbgTxt: json["cbg_txt"],
        historyOfAnticoagulant: json["history_of_anticoagulant"],
        bpSbp: json["bp_sbp"],
        bpDbp: json["bp_dbp"],
        aspectScore: json["aspect_score"],
        ctScan: json["ct_scan"],
        ctScanDate: json["ct_scan_date"],
        ctScanFindings: json["ct_scan_findings"],
        mriScan: json["mri_scan"],
        mriScanDate: json["mri_scan_date"],
        mriScanEligibility: json["mri_scan_eligibility"],
        mriScanEligilityStatus: json["mri_scan_eligility_status"],
        cathLabProcedure: json["cath_lab_procedure"],
        cathLabProcedureDate: json["cath_lab_procedure_date"],
        cathLabFindings: json["cath_lab_findings"],
        procedureDone: json["procedure_done"],
        nameOfProcedure: json["name_of_procedure"],
        type: json["type"],
        hemorrhagicSpecify: json["hemorrhagic_specify"],
        lysisDone: json["lysis_done"],
        lysisDate: json["lysis_date"],
        thrombolysisByDrug: json["thrombolysis_by_drug"],
        thrombectomy: json["thrombectomy"],
        thrombectomyDtls: json["thrombectomy_dtls"],
        decompressionCraniectomy: json["decompression_craniectomy"],
        decompressionCraniectomyDtls: json["decompression_craniectomy_dtls"],
        drugPrescribed: json["drug_prescribed"],
        refFormId: json["ref_form_id"],
        refId: json["ref_id"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "date_time_of_entry": dateTimeOfEntry,
        "arrival_time_symptoms": arrivalTimeSymptoms,
        "reason_for_delay": reasonForDelay,
        "oth_reason_for_delay": othReasonForDelay,
        "scene_ift": sceneIft,
        "referred_from": referredFrom,
        "reason_for_referral": reasonForReferral,
        "oth_reason_for_referral": othReasonForReferral,
        "admitted": admitted,
        "admitted_date_time": admittedDateTime,
        "lysis_done_outside": lysisDoneOutside,
        "lysis_done_outside_date": lysisDoneOutsideDate,
        "symptoms":
            symptoms == null ? [] : List<dynamic>.from(symptoms!.map((x) => x)),
        "risk_factors": riskFactors == null
            ? []
            : List<dynamic>.from(riskFactors!.map((x) => x)),
        "oth_risk_factors": othRiskFactors,
        "nihs_scale": nihsScale,
        "pre_morbit_scroe": preMorbitScroe,
        "is_absolute_contraindication": isAbsoluteContraindication,
        "oth_absolute_contraindication": othAbsoluteContraindication,
        "cbg": cbg,
        "cbg_date": cbgDate,
        "cbg_txt": cbgTxt,
        "history_of_anticoagulant": historyOfAnticoagulant,
        "bp_sbp": bpSbp,
        "bp_dbp": bpDbp,
        "aspect_score": aspectScore,
        "ct_scan": ctScan,
        "ct_scan_date": ctScanDate,
        "ct_scan_findings": ctScanFindings,
        "mri_scan": mriScan,
        "mri_scan_date": mriScanDate,
        "mri_scan_eligibility": mriScanEligibility,
        "mri_scan_eligility_status": mriScanEligilityStatus,
        "cath_lab_procedure": cathLabProcedure,
        "cath_lab_procedure_date": cathLabProcedureDate,
        "cath_lab_findings": cathLabFindings,
        "procedure_done": procedureDone,
        "name_of_procedure": nameOfProcedure,
        "type": type,
        "hemorrhagic_specify": hemorrhagicSpecify,
        "lysis_done": lysisDone,
        "lysis_date": lysisDate,
        "thrombolysis_by_drug": thrombolysisByDrug,
        "thrombectomy": thrombectomy,
        "thrombectomy_dtls": thrombectomyDtls,
        "decompression_craniectomy": decompressionCraniectomy,
        "decompression_craniectomy_dtls": decompressionCraniectomyDtls,
        "drug_prescribed": drugPrescribed,
        "ref_form_id": refFormId,
        "ref_id": refId,
      };
}

extension StrokeModelClean on CreateScriptModel {
  Map<String, dynamic> toCleanJson() {
    final data = toJson();
    if (data['stroke'] != null) {
      data['stroke'].remove('id');
    }
    if (data['outcome'] != null) {
      data['outcome'].remove('id');
      data['outcome'].remove('stroke_id');
    }
    return data;
  }
}
