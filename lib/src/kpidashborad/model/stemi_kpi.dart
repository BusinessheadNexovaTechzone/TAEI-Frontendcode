// To parse this JSON data, do
//
//     final stemikpiDashboardMidel = stemikpiDashboardMidelFromJson(jsonString);

import 'dart:convert';

StemikpiDashboardModel stemikpiDashboardMidelFromJson(String str) =>
    StemikpiDashboardModel.fromJson(json.decode(str));

String stemikpiDashboardMidelToJson(StemikpiDashboardModel data) =>
    json.encode(data.toJson());

class StemikpiDashboardModel {
  Data? data;

  StemikpiDashboardModel({
    this.data,
  });

  factory StemikpiDashboardModel.fromJson(Map<String, dynamic> json) =>
      StemikpiDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  StemiDashboard? stemiDashboard;
  Dashboard? nstemiDashboard;
  Dashboard? unstableAnginaDashboard;

  Data({
    this.stemiDashboard,
    this.nstemiDashboard,
    this.unstableAnginaDashboard,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stemiDashboard: json["stemi_dashboard"] == null
            ? null
            : StemiDashboard.fromJson(json["stemi_dashboard"]),
        nstemiDashboard: json["nstemi_dashboard"] == null
            ? null
            : Dashboard.fromJson(json["nstemi_dashboard"]),
        unstableAnginaDashboard: json["unstable_angina_dashboard"] == null
            ? null
            : Dashboard.fromJson(json["unstable_angina_dashboard"]),
      );

  Map<String, dynamic> toJson() => {
        "stemi_dashboard": stemiDashboard?.toJson(),
        "nstemi_dashboard": nstemiDashboard?.toJson(),
        "unstable_angina_dashboard": unstableAnginaDashboard?.toJson(),
      };
}

class Dashboard {
  int? referralRatePct;
  double? caseFatalityRatePct;
  int? avgLengthOfStayDays;

  Dashboard({
    this.referralRatePct,
    this.caseFatalityRatePct,
    this.avgLengthOfStayDays,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        referralRatePct: json["referral_rate_pct"],
        caseFatalityRatePct: json["case_fatality_rate_pct"]?.toDouble(),
        avgLengthOfStayDays: json["avg_length_of_stay_days"],
      );

  Map<String, dynamic> toJson() => {
        "referral_rate_pct": referralRatePct,
        "case_fatality_rate_pct": caseFatalityRatePct,
        "avg_length_of_stay_days": avgLengthOfStayDays,
      };
}

class StemiDashboard {
  dynamic doorToNeedleTimeMin;
  dynamic doorToEcgTimeMin;
  dynamic doorToBalloonTimeMin;
  int? thrombolysisRatePct;
  int? thrombolysisFailureRatePct;
  int? referralRatePct;
  double? caseFatalityRatePct;
  dynamic avgLengthOfStayDays;

  StemiDashboard({
    this.doorToNeedleTimeMin,
    this.doorToEcgTimeMin,
    this.doorToBalloonTimeMin,
    this.thrombolysisRatePct,
    this.thrombolysisFailureRatePct,
    this.referralRatePct,
    this.caseFatalityRatePct,
    this.avgLengthOfStayDays,
  });

  factory StemiDashboard.fromJson(Map<String, dynamic> json) => StemiDashboard(
        doorToNeedleTimeMin: json["door_to_needle_time_min"],
        doorToEcgTimeMin: json["door_to_ecg_time_min"],
        doorToBalloonTimeMin: json["door_to_balloon_time_min"],
        thrombolysisRatePct: json["thrombolysis_rate_pct"],
        thrombolysisFailureRatePct: json["thrombolysis_failure_rate_pct"],
        referralRatePct: json["referral_rate_pct"],
        caseFatalityRatePct: json["case_fatality_rate_pct"]?.toDouble(),
        avgLengthOfStayDays: json["avg_length_of_stay_days"],
      );

  Map<String, dynamic> toJson() => {
        "door_to_needle_time_min": doorToNeedleTimeMin,
        "door_to_ecg_time_min": doorToEcgTimeMin,
        "door_to_balloon_time_min": doorToBalloonTimeMin,
        "thrombolysis_rate_pct": thrombolysisRatePct,
        "thrombolysis_failure_rate_pct": thrombolysisFailureRatePct,
        "referral_rate_pct": referralRatePct,
        "case_fatality_rate_pct": caseFatalityRatePct,
        "avg_length_of_stay_days": avgLengthOfStayDays,
      };
}
