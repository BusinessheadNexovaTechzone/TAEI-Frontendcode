// To parse this JSON data, do
//
//     final strokeInstitutionalDashboardModel = strokeInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

StrokeInstitutionalDashboardModel strokeInstitutionalDashboardModelFromJson(
        String str) =>
    StrokeInstitutionalDashboardModel.fromJson(json.decode(str));

String strokeInstitutionalDashboardModelToJson(
        StrokeInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class StrokeInstitutionalDashboardModel {
  Data? data;

  StrokeInstitutionalDashboardModel({
    this.data,
  });

  factory StrokeInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      StrokeInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? totalAdmitted;
  int? totalTreated;
  int? totalThrombolysis;
  int? totalSpoke;
  double? avgStay;
  List<StrokeInstitutionOutcome>? outcome;

  Data({
    this.totalAdmitted,
    this.totalTreated,
    this.totalThrombolysis,
    this.totalSpoke,
    this.avgStay,
    this.outcome,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalAdmitted: json["total_admitted"],
        totalTreated: json["total_treated"],
        totalThrombolysis: json["total_thrombolysis"],
        totalSpoke: json["total_spoke"],
        avgStay: json["avg_stay"]?.toDouble(),
        outcome: json["outcome"] == null
            ? []
            : List<StrokeInstitutionOutcome>.from(json["outcome"]!
                .map((x) => StrokeInstitutionOutcome.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_admitted": totalAdmitted,
        "total_treated": totalTreated,
        "total_thrombolysis": totalThrombolysis,
        "total_spoke": totalSpoke,
        "avg_stay": avgStay,
        "outcome": outcome == null
            ? []
            : List<dynamic>.from(outcome!.map((x) => x.toJson())),
      };
}

class StrokeInstitutionOutcome {
  int? id;
  String? name;
  int? totalCount;

  StrokeInstitutionOutcome({
    this.id,
    this.name,
    this.totalCount,
  });

  factory StrokeInstitutionOutcome.fromJson(Map<String, dynamic> json) =>
      StrokeInstitutionOutcome(
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
