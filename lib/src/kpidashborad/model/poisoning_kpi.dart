// To parse this JSON data, do
//
//     final poisoningKpiDashboardModel = poisoningKpiDashboardModelFromJson(jsonString);

import 'dart:convert';

PoisoningKpiDashboardModel poisoningKpiDashboardModelFromJson(String str) =>
    PoisoningKpiDashboardModel.fromJson(json.decode(str));

String poisoningKpiDashboardModelToJson(PoisoningKpiDashboardModel data) =>
    json.encode(data.toJson());

class PoisoningKpiDashboardModel {
  Data? data;

  PoisoningKpiDashboardModel({
    this.data,
  });

  factory PoisoningKpiDashboardModel.fromJson(Map<String, dynamic> json) =>
      PoisoningKpiDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  DateTime? fromDate;
  DateTime? toDate;
  List<int>? institutionId;
  List<TimeFromExposureToArrival>? timeFromExposureToArrival;
  List<HospitalAdmissionRate>? hospitalAdmissionRate;
  PlexOutcomeEffectivenessPoisoning? plexOutcomeEffectivenessPoisoning;
  List<AntidoteAdministrationRate>? antidoteAdministrationRate;
  List<ReferralRate>? referralRate;
  List<Top5CommonType>? top5CommonTypes;
  List<CaseFatalityRateByPillar>? caseFatalityRateByPillar;
  List<AverageLengthOfStay>? averageLengthOfStay;

  Data({
    this.fromDate,
    this.toDate,
    this.institutionId,
    this.timeFromExposureToArrival,
    this.hospitalAdmissionRate,
    this.plexOutcomeEffectivenessPoisoning,
    this.antidoteAdministrationRate,
    this.referralRate,
    this.top5CommonTypes,
    this.caseFatalityRateByPillar,
    this.averageLengthOfStay,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        fromDate: json["from_date"] == null
            ? null
            : DateTime.parse(json["from_date"]),
        toDate:
            json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
        institutionId: json["institution_id"] == null
            ? []
            : List<int>.from(json["institution_id"]!.map((x) => x)),
        timeFromExposureToArrival: json["time_from_exposure_to_arrival"] == null
            ? []
            : List<TimeFromExposureToArrival>.from(
                json["time_from_exposure_to_arrival"]!
                    .map((x) => TimeFromExposureToArrival.fromJson(x))),
        hospitalAdmissionRate: json["hospital_admission_rate"] == null
            ? []
            : List<HospitalAdmissionRate>.from(json["hospital_admission_rate"]!
                .map((x) => HospitalAdmissionRate.fromJson(x))),
        plexOutcomeEffectivenessPoisoning:
            json["plex_outcome_effectiveness_poisoning"] == null
                ? null
                : PlexOutcomeEffectivenessPoisoning.fromJson(
                    json["plex_outcome_effectiveness_poisoning"]),
        antidoteAdministrationRate: json["antidote_administration_rate"] == null
            ? []
            : List<AntidoteAdministrationRate>.from(
                json["antidote_administration_rate"]!
                    .map((x) => AntidoteAdministrationRate.fromJson(x))),
        referralRate: json["referral_rate"] == null
            ? []
            : List<ReferralRate>.from(
                json["referral_rate"]!.map((x) => ReferralRate.fromJson(x))),
        top5CommonTypes: json["top_5_common_types"] == null
            ? []
            : List<Top5CommonType>.from(json["top_5_common_types"]!
                .map((x) => Top5CommonType.fromJson(x))),
        caseFatalityRateByPillar: json["case_fatality_rate_by_pillar"] == null
            ? []
            : List<CaseFatalityRateByPillar>.from(
                json["case_fatality_rate_by_pillar"]!
                    .map((x) => CaseFatalityRateByPillar.fromJson(x))),
        averageLengthOfStay: json["average_length_of_stay"] == null
            ? []
            : List<AverageLengthOfStay>.from(json["average_length_of_stay"]!
                .map((x) => AverageLengthOfStay.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "from_date":
            "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
        "to_date":
            "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
        "institution_id": institutionId == null
            ? []
            : List<dynamic>.from(institutionId!.map((x) => x)),
        "time_from_exposure_to_arrival": timeFromExposureToArrival == null
            ? []
            : List<dynamic>.from(
                timeFromExposureToArrival!.map((x) => x.toJson())),
        "hospital_admission_rate": hospitalAdmissionRate == null
            ? []
            : List<dynamic>.from(hospitalAdmissionRate!.map((x) => x.toJson())),
        "plex_outcome_effectiveness_poisoning":
            plexOutcomeEffectivenessPoisoning?.toJson(),
        "antidote_administration_rate": antidoteAdministrationRate == null
            ? []
            : List<dynamic>.from(
                antidoteAdministrationRate!.map((x) => x.toJson())),
        "referral_rate": referralRate == null
            ? []
            : List<dynamic>.from(referralRate!.map((x) => x.toJson())),
        "top_5_common_types": top5CommonTypes == null
            ? []
            : List<dynamic>.from(top5CommonTypes!.map((x) => x.toJson())),
        "case_fatality_rate_by_pillar": caseFatalityRateByPillar == null
            ? []
            : List<dynamic>.from(
                caseFatalityRateByPillar!.map((x) => x.toJson())),
        "average_length_of_stay": averageLengthOfStay == null
            ? []
            : List<dynamic>.from(averageLengthOfStay!.map((x) => x.toJson())),
      };
}

class AntidoteAdministrationRate {
  String? pillar;
  int? antidoteGiven;
  int? eligibleCases;
  int? ratePct;

  AntidoteAdministrationRate({
    this.pillar,
    this.antidoteGiven,
    this.eligibleCases,
    this.ratePct,
  });

  factory AntidoteAdministrationRate.fromJson(Map<String, dynamic> json) =>
      AntidoteAdministrationRate(
        pillar: json["pillar"],
        antidoteGiven: json["antidote_given"],
        eligibleCases: json["eligible_cases"],
        ratePct: json["rate_pct"],
      );

  Map<String, dynamic> toJson() => {
        "pillar": pillar,
        "antidote_given": antidoteGiven,
        "eligible_cases": eligibleCases,
        "rate_pct": ratePct,
      };
}

class AverageLengthOfStay {
  String? pillar;
  dynamic avgLosDays;

  AverageLengthOfStay({
    this.pillar,
    this.avgLosDays,
  });

  factory AverageLengthOfStay.fromJson(Map<String, dynamic> json) =>
      AverageLengthOfStay(
        pillar: json["pillar"],
        avgLosDays: json["avg_los_days"],
      );

  Map<String, dynamic> toJson() => {
        "pillar": pillar,
        "avg_los_days": avgLosDays,
      };
}

class CaseFatalityRateByPillar {
  String? pillar;
  int? deaths;
  int? confirmedCases;
  int? cfrPct;

  CaseFatalityRateByPillar({
    this.pillar,
    this.deaths,
    this.confirmedCases,
    this.cfrPct,
  });

  factory CaseFatalityRateByPillar.fromJson(Map<String, dynamic> json) =>
      CaseFatalityRateByPillar(
        pillar: json["pillar"],
        deaths: json["deaths"],
        confirmedCases: json["confirmed_cases"],
        cfrPct: json["cfr_pct"],
      );

  Map<String, dynamic> toJson() => {
        "pillar": pillar,
        "deaths": deaths,
        "confirmed_cases": confirmedCases,
        "cfr_pct": cfrPct,
      };
}

class HospitalAdmissionRate {
  String? pillar;
  int? admittedCases;
  int? totalCases;
  double? admissionRatePct;

  HospitalAdmissionRate({
    this.pillar,
    this.admittedCases,
    this.totalCases,
    this.admissionRatePct,
  });

  factory HospitalAdmissionRate.fromJson(Map<String, dynamic> json) =>
      HospitalAdmissionRate(
        pillar: json["pillar"],
        admittedCases: json["admitted_cases"],
        totalCases: json["total_cases"],
        admissionRatePct: json["admission_rate_pct"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "pillar": pillar,
        "admitted_cases": admittedCases,
        "total_cases": totalCases,
        "admission_rate_pct": admissionRatePct,
      };
}

class PlexOutcomeEffectivenessPoisoning {
  int? patientsUnderwentPlex;
  int? dischargedAfterPlex;
  int? deathsAfterPlex;
  int? poeiPct;

  PlexOutcomeEffectivenessPoisoning({
    this.patientsUnderwentPlex,
    this.dischargedAfterPlex,
    this.deathsAfterPlex,
    this.poeiPct,
  });

  factory PlexOutcomeEffectivenessPoisoning.fromJson(
          Map<String, dynamic> json) =>
      PlexOutcomeEffectivenessPoisoning(
        patientsUnderwentPlex: json["patients_underwent_plex"],
        dischargedAfterPlex: json["discharged_after_plex"],
        deathsAfterPlex: json["deaths_after_plex"],
        poeiPct: json["poei_pct"],
      );

  Map<String, dynamic> toJson() => {
        "patients_underwent_plex": patientsUnderwentPlex,
        "discharged_after_plex": dischargedAfterPlex,
        "deaths_after_plex": deathsAfterPlex,
        "poei_pct": poeiPct,
      };
}

class ReferralRate {
  String? pillar;
  int? referredCount;
  int? totalCases;
  int? referralRatePct;

  ReferralRate({
    this.pillar,
    this.referredCount,
    this.totalCases,
    this.referralRatePct,
  });

  factory ReferralRate.fromJson(Map<String, dynamic> json) => ReferralRate(
        pillar: json["pillar"],
        referredCount: json["referred_count"],
        totalCases: json["total_cases"],
        referralRatePct: json["referral_rate_pct"],
      );

  Map<String, dynamic> toJson() => {
        "pillar": pillar,
        "referred_count": referredCount,
        "total_cases": totalCases,
        "referral_rate_pct": referralRatePct,
      };
}

class TimeFromExposureToArrival {
  String? pillar;
  double? avgMinutes;

  TimeFromExposureToArrival({
    this.pillar,
    this.avgMinutes,
  });

  factory TimeFromExposureToArrival.fromJson(Map<String, dynamic> json) =>
      TimeFromExposureToArrival(
        pillar: json["pillar"],
        avgMinutes: json["avg_minutes"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "pillar": pillar,
        "avg_minutes": avgMinutes,
      };
}

class Top5CommonType {
  String? type;
  int? count;

  Top5CommonType({
    this.type,
    this.count,
  });

  factory Top5CommonType.fromJson(Map<String, dynamic> json) => Top5CommonType(
        type: json["type"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "count": count,
      };
}
