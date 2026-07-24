// To parse this JSON data, do
//
//     final burnsInstitutionalDashboardModel = burnsInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

BurnsInstitutionalDashboardModel burnsInstitutionalDashboardModelFromJson(
        String str) =>
    BurnsInstitutionalDashboardModel.fromJson(json.decode(str));

String burnsInstitutionalDashboardModelToJson(
        BurnsInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class BurnsInstitutionalDashboardModel {
  Data? data;

  BurnsInstitutionalDashboardModel({
    this.data,
  });

  factory BurnsInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      BurnsInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? totalBurns;
  int? totalTreated;
  int? totalSurgery;
  int? totalIft;
  double? avgStay;
  List<BurnsInstitutionOutcome>? outcome;

  Data({
    this.totalBurns,
    this.totalTreated,
    this.totalSurgery,
    this.totalIft,
    this.avgStay,
    this.outcome,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalBurns: json["total_burns"],
        totalTreated: json["total_treated"],
        totalSurgery: json["total_surgery"],
        totalIft: json["total_ift"],
        avgStay: json["avg_stay"]?.toDouble(),
        outcome: json["outcome"] == null
            ? []
            : List<BurnsInstitutionOutcome>.from(json["outcome"]!
                .map((x) => BurnsInstitutionOutcome.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_burns": totalBurns,
        "total_treated": totalTreated,
        "total_surgery": totalSurgery,
        "total_ift": totalIft,
        "avg_stay": avgStay,
        "outcome": outcome == null
            ? []
            : List<dynamic>.from(outcome!.map((x) => x.toJson())),
      };
}

class BurnsInstitutionOutcome {
  int? id;
  String? name;
  int? totalCount;

  BurnsInstitutionOutcome({
    this.id,
    this.name,
    this.totalCount,
  });

  factory BurnsInstitutionOutcome.fromJson(Map<String, dynamic> json) =>
      BurnsInstitutionOutcome(
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
