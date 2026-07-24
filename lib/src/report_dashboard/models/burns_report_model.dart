// To parse this JSON data, do
//
//     final burnsReportModel = burnsReportModelFromJson(jsonString);

import 'dart:convert';

BurnsReportModel burnsReportModelFromJson(String str) =>
    BurnsReportModel.fromJson(json.decode(str));

String burnsReportModelToJson(BurnsReportModel data) =>
    json.encode(data.toJson());

class BurnsReportModel {
  List<Datum>? data;

  BurnsReportModel({
    this.data,
  });

  factory BurnsReportModel.fromJson(Map<String, dynamic> json) =>
      BurnsReportModel(
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
  int? institutionId;
  String? institutionName;
  String? districtName;
  String? totalAdmissions;
  String? adultAdmissions;
  String? pediatricAdmissions;
  String? nearDeathCases;
  String? acidAttackCases;
  String? acidAttackDeaths;
  String? broughtDeadCases;
  String? tbsa020;
  String? tbsa2040;
  String? tbsa4060;
  String? tbsaGt60;
  String? tbsa020Adult;
  String? tbsa2040Adult;
  String? tbsa4060Adult;
  String? tbsaGt60Adult;
  String? tbsa020Ped;
  String? tbsa2040Ped;
  String? tbsa4060Ped;
  String? tbsaGt60Ped;
  String? tbsaReferredIn;
  String? tbsaReferredOut;
  String? tbsaDeaths;
  String? tbsaSurvival;
  String? outcomeDischarged;
  String? outcomeUnderTreatment;
  String? outcomeDeath;
  String? outcomeReferredOut;
  String? outcomeDama;
  String? outcomeAbscond;
  String? surgerySkinGraft;
  String? surgeryEarlyExcision;
  String? surgeryDebridement;
  String? surgeryOther;

  Datum({
    this.institutionId,
    this.institutionName,
    this.districtName,
    this.totalAdmissions,
    this.adultAdmissions,
    this.pediatricAdmissions,
    this.nearDeathCases,
    this.acidAttackCases,
    this.acidAttackDeaths,
    this.broughtDeadCases,
    this.tbsa020,
    this.tbsa2040,
    this.tbsa4060,
    this.tbsaGt60,
    this.tbsa020Adult,
    this.tbsa2040Adult,
    this.tbsa4060Adult,
    this.tbsaGt60Adult,
    this.tbsa020Ped,
    this.tbsa2040Ped,
    this.tbsa4060Ped,
    this.tbsaGt60Ped,
    this.tbsaReferredIn,
    this.tbsaReferredOut,
    this.tbsaDeaths,
    this.tbsaSurvival,
    this.outcomeDischarged,
    this.outcomeUnderTreatment,
    this.outcomeDeath,
    this.outcomeReferredOut,
    this.outcomeDama,
    this.outcomeAbscond,
    this.surgerySkinGraft,
    this.surgeryEarlyExcision,
    this.surgeryDebridement,
    this.surgeryOther,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        institutionId: json["institution_id"],
        institutionName: json["institution_name"],
        districtName: json["district_name"],
        totalAdmissions: json["total_admissions"],
        adultAdmissions: json["adult_admissions"],
        pediatricAdmissions: json["pediatric_admissions"],
        nearDeathCases: json["near_death_cases"],
        acidAttackCases: json["acid_attack_cases"],
        acidAttackDeaths: json["acid_attack_deaths"],
        broughtDeadCases: json["brought_dead_cases"],
        tbsa020: json["tbsa_0_20"],
        tbsa2040: json["tbsa_20_40"],
        tbsa4060: json["tbsa_40_60"],
        tbsaGt60: json["tbsa_gt_60"],
        tbsa020Adult: json["tbsa_0_20_adult"],
        tbsa2040Adult: json["tbsa_20_40_adult"],
        tbsa4060Adult: json["tbsa_40_60_adult"],
        tbsaGt60Adult: json["tbsa_gt_60_adult"],
        tbsa020Ped: json["tbsa_0_20_ped"],
        tbsa2040Ped: json["tbsa_20_40_ped"],
        tbsa4060Ped: json["tbsa_40_60_ped"],
        tbsaGt60Ped: json["tbsa_gt_60_ped"],
        tbsaReferredIn: json["tbsa_referred_in"],
        tbsaReferredOut: json["tbsa_referred_out"],
        tbsaDeaths: json["tbsa_deaths"],
        tbsaSurvival: json["tbsa_survival"],
        outcomeDischarged: json["outcome_discharged"],
        outcomeUnderTreatment: json["outcome_under_treatment"],
        outcomeDeath: json["outcome_death"],
        outcomeReferredOut: json["outcome_referred_out"],
        outcomeDama: json["outcome_dama"],
        outcomeAbscond: json["outcome_abscond"],
        surgerySkinGraft: json["surgery_skin_graft"],
        surgeryEarlyExcision: json["surgery_early_excision"],
        surgeryDebridement: json["surgery_debridement"],
        surgeryOther: json["surgery_other"],
      );

  Map<String, dynamic> toJson() => {
        "institution_id": institutionId,
        "institution_name": institutionName,
        "district_name": districtName,
        "total_admissions": totalAdmissions,
        "adult_admissions": adultAdmissions,
        "pediatric_admissions": pediatricAdmissions,
        "near_death_cases": nearDeathCases,
        "acid_attack_cases": acidAttackCases,
        "acid_attack_deaths": acidAttackDeaths,
        "brought_dead_cases": broughtDeadCases,
        "tbsa_0_20": tbsa020,
        "tbsa_20_40": tbsa2040,
        "tbsa_40_60": tbsa4060,
        "tbsa_gt_60": tbsaGt60,
        "tbsa_0_20_adult": tbsa020Adult,
        "tbsa_20_40_adult": tbsa2040Adult,
        "tbsa_40_60_adult": tbsa4060Adult,
        "tbsa_gt_60_adult": tbsaGt60Adult,
        "tbsa_0_20_ped": tbsa020Ped,
        "tbsa_20_40_ped": tbsa2040Ped,
        "tbsa_40_60_ped": tbsa4060Ped,
        "tbsa_gt_60_ped": tbsaGt60Ped,
        "tbsa_referred_in": tbsaReferredIn,
        "tbsa_referred_out": tbsaReferredOut,
        "tbsa_deaths": tbsaDeaths,
        "tbsa_survival": tbsaSurvival,
        "outcome_discharged": outcomeDischarged,
        "outcome_under_treatment": outcomeUnderTreatment,
        "outcome_death": outcomeDeath,
        "outcome_referred_out": outcomeReferredOut,
        "outcome_dama": outcomeDama,
        "outcome_abscond": outcomeAbscond,
        "surgery_skin_graft": surgerySkinGraft,
        "surgery_early_excision": surgeryEarlyExcision,
        "surgery_debridement": surgeryDebridement,
        "surgery_other": surgeryOther,
      };
}
