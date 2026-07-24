// To parse this JSON data, do
//
//     final stemiInstitutionalDashboardModel = stemiInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

STEMIInstitutionalDashboardModel stemiInstitutionalDashboardModelFromJson(
        String str) =>
    STEMIInstitutionalDashboardModel.fromJson(json.decode(str));

String stemiInstitutionalDashboardModelToJson(
        STEMIInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class STEMIInstitutionalDashboardModel {
  Data? data;

  STEMIInstitutionalDashboardModel({
    this.data,
  });

  factory STEMIInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      STEMIInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? totalAdmitted;
  int? goldenPeriodHours;
  int? thrombolysisDone;
  int? totalSTEMICases;
  int? iftCount;
  List<STEMIInstitutionOutcome>? outcomes;
  List<STEMIInstitutionAverageStay>? averageStay;

  Data({
    this.totalAdmitted,
    this.goldenPeriodHours,
    this.thrombolysisDone,
    this.totalSTEMICases,
    this.iftCount,
    this.outcomes,
    this.averageStay,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalAdmitted: json["total_admitted"],
        goldenPeriodHours: json["golden_period_hours"],
        thrombolysisDone: json["thrombolysis_done"],
        totalSTEMICases: json["total_stemi_cases"],
        iftCount: json["ift_count"],
        outcomes: json["outcomes"] == null
            ? []
            : List<STEMIInstitutionOutcome>.from(json["outcomes"]!
                .map((x) => STEMIInstitutionOutcome.fromJson(x))),
        averageStay: json["average_stay"] == null
            ? []
            : List<STEMIInstitutionAverageStay>.from(json["average_stay"]!
                .map((x) => STEMIInstitutionAverageStay.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_admitted": totalAdmitted,
        "golden_period_hours": goldenPeriodHours,
        "thrombolysis_done": thrombolysisDone,
        "total_stemi_cases": totalSTEMICases,
        "ift_count": iftCount,
        "outcomes": outcomes == null
            ? []
            : List<dynamic>.from(outcomes!.map((x) => x.toJson())),
        "average_stay": averageStay == null
            ? []
            : List<dynamic>.from(averageStay!.map((x) => x.toJson())),
      };
}

class STEMIInstitutionAverageStay {
  String? name;
  int? avgStayDays;

  STEMIInstitutionAverageStay({
    this.name,
    this.avgStayDays,
  });

  factory STEMIInstitutionAverageStay.fromJson(Map<String, dynamic> json) =>
      STEMIInstitutionAverageStay(
        name: json["name"],
        avgStayDays: json["avg_stay_days"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "avg_stay_days": avgStayDays,
      };
}

class STEMIInstitutionOutcome {
  String? name;
  int? totalCount;

  STEMIInstitutionOutcome({
    this.name,
    this.totalCount,
  });

  factory STEMIInstitutionOutcome.fromJson(Map<String, dynamic> json) =>
      STEMIInstitutionOutcome(
        name: json["name"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "total_count": totalCount,
      };
}
