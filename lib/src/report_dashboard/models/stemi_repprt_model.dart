// To parse this JSON data, do
//
//     final stemiReportModel = stemiReportModelFromJson(jsonString);

import 'dart:convert';

StemiReportModel stemiReportModelFromJson(String str) =>
    StemiReportModel.fromJson(json.decode(str));

String stemiReportModelToJson(StemiReportModel data) =>
    json.encode(data.toJson());

class StemiReportModel {
  List<Datum>? data;

  StemiReportModel({
    this.data,
  });

  factory StemiReportModel.fromJson(Map<String, dynamic> json) =>
      StemiReportModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? hospitalId;
  String? institutionName;
  String? districtName;
  String? admittedAcsTotal;
  String? admittedStemi;
  String? admittedNstemi;
  String? admittedUa;
  String? loadingDoseByReferring;
  String? loadingDose108;
  String? loadingDoseInside;
  String? thrombolysisOutside;
  String? thrombolysisInside;
  String? thrombolysisNotDonePlannedPpci;
  String? successfulThrombolysis;
  String? failedThrombolysis;
  String? rescuePci;
  String? ppciTotal;
  String? medicalManagementTotal;
  String? referredForCabgTotal;
  String? abscondedTotal;
  String? totalDeaths;
  String? deathBeforeTreatment;
  String? deathAfterPpci;
  String? deathAfterThrombolysis;
  String? deathAfterPharmacoInvasive;
  String? deathAfterRescuePci;
  String? deathAfterMedicalManagement;
  String? deathOthers;

  Datum({
    this.hospitalId,
    this.institutionName,
    this.districtName,
    this.admittedAcsTotal,
    this.admittedStemi,
    this.admittedNstemi,
    this.admittedUa,
    this.loadingDoseByReferring,
    this.loadingDose108,
    this.loadingDoseInside,
    this.thrombolysisOutside,
    this.thrombolysisInside,
    this.thrombolysisNotDonePlannedPpci,
    this.successfulThrombolysis,
    this.failedThrombolysis,
    this.rescuePci,
    this.ppciTotal,
    this.medicalManagementTotal,
    this.referredForCabgTotal,
    this.abscondedTotal,
    this.totalDeaths,
    this.deathBeforeTreatment,
    this.deathAfterPpci,
    this.deathAfterThrombolysis,
    this.deathAfterPharmacoInvasive,
    this.deathAfterRescuePci,
    this.deathAfterMedicalManagement,
    this.deathOthers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hospitalId: json["hospital_id"],
        institutionName: json["institution_name"],
        districtName: json["district_name"],
        admittedAcsTotal: json["admitted_acs_total"],
        admittedStemi: json["admitted_stemi"],
        admittedNstemi: json["admitted_nstemi"],
        admittedUa: json["admitted_ua"],
        loadingDoseByReferring: json["loading_dose_by_referring"],
        loadingDose108: json["loading_dose_108"],
        loadingDoseInside: json["loading_dose_inside"],
        thrombolysisOutside: json["thrombolysis_outside"],
        thrombolysisInside: json["thrombolysis_inside"],
        thrombolysisNotDonePlannedPpci:
            json["thrombolysis_not_done_planned_ppci"],
        successfulThrombolysis: json["successful_thrombolysis"],
        failedThrombolysis: json["failed_thrombolysis"],
        rescuePci: json["rescue_pci"],
        ppciTotal: json["ppci_total"],
        medicalManagementTotal: json["medical_management_total"],
        referredForCabgTotal: json["referred_for_cabg_total"],
        abscondedTotal: json["absconded_total"],
        totalDeaths: json["total_deaths"],
        deathBeforeTreatment: json["death_before_treatment"],
        deathAfterPpci: json["death_after_ppci"],
        deathAfterThrombolysis: json["death_after_thrombolysis"],
        deathAfterPharmacoInvasive: json["death_after_pharmaco_invasive"],
        deathAfterRescuePci: json["death_after_rescue_pci"],
        deathAfterMedicalManagement: json["death_after_medical_management"],
        deathOthers: json["death_others"],
      );

  Map<String, dynamic> toJson() => {
        "hospital_id": hospitalId,
        "institution_name": institutionName,
        "district_name": districtName,
        "admitted_acs_total": admittedAcsTotal,
        "admitted_stemi": admittedStemi,
        "admitted_nstemi": admittedNstemi,
        "admitted_ua": admittedUa,
        "loading_dose_by_referring": loadingDoseByReferring,
        "loading_dose_108": loadingDose108,
        "loading_dose_inside": loadingDoseInside,
        "thrombolysis_outside": thrombolysisOutside,
        "thrombolysis_inside": thrombolysisInside,
        "thrombolysis_not_done_planned_ppci": thrombolysisNotDonePlannedPpci,
        "successful_thrombolysis": successfulThrombolysis,
        "failed_thrombolysis": failedThrombolysis,
        "rescue_pci": rescuePci,
        "ppci_total": ppciTotal,
        "medical_management_total": medicalManagementTotal,
        "referred_for_cabg_total": referredForCabgTotal,
        "absconded_total": abscondedTotal,
        "total_deaths": totalDeaths,
        "death_before_treatment": deathBeforeTreatment,
        "death_after_ppci": deathAfterPpci,
        "death_after_thrombolysis": deathAfterThrombolysis,
        "death_after_pharmaco_invasive": deathAfterPharmacoInvasive,
        "death_after_rescue_pci": deathAfterRescuePci,
        "death_after_medical_management": deathAfterMedicalManagement,
        "death_others": deathOthers,
      };
}
