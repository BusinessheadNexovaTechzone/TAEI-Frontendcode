// To parse this JSON data, do
//
//     final traumaInstitutionalDashboardModel = traumaInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

TraumaInstitutionalDashboardModel traumaInstitutionalDashboardModelFromJson(
        String str) =>
    TraumaInstitutionalDashboardModel.fromJson(json.decode(str));

String traumaInstitutionalDashboardModelToJson(
        TraumaInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class TraumaInstitutionalDashboardModel {
  Data? data;

  TraumaInstitutionalDashboardModel({
    this.data,
  });

  factory TraumaInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      TraumaInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? totalAdmitted;
  int? totalTreated;
  int? totalSurgery;
  int? totalIft;
  double? avgStay;
  List<TraumaOutcome>? outcome;

  Data({
    this.totalAdmitted,
    this.totalTreated,
    this.totalSurgery,
    this.totalIft,
    this.avgStay,
    this.outcome,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalAdmitted: json["total_admitted"],
        totalTreated: json["total_treated"],
        totalSurgery: json["total_surgery"],
        totalIft: json["total_ift"],
        avgStay: json["avg_stay"]?.toDouble(),
        outcome: json["outcome"] == null
            ? []
            : List<TraumaOutcome>.from(
                json["outcome"]!.map((x) => TraumaOutcome.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_admitted": totalAdmitted,
        "total_treated": totalTreated,
        "total_surgery": totalSurgery,
        "total_ift": totalIft,
        "avg_stay": avgStay,
        "outcome": outcome == null
            ? []
            : List<dynamic>.from(outcome!.map((x) => x.toJson())),
      };
}

class TraumaOutcome {
  int? id;
  String? name;
  int? totalCount;

  TraumaOutcome({
    this.id,
    this.name,
    this.totalCount,
  });

  factory TraumaOutcome.fromJson(Map<String, dynamic> json) => TraumaOutcome(
        id: json["id"],
        name: json["name"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "total_count": totalCount,
      };
}
