// To parse this JSON data, do
//
//     final premInstitutionalDashboardModel = premInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

PremInstitutionalDashboardModel premInstitutionalDashboardModelFromJson(
        String str) =>
    PremInstitutionalDashboardModel.fromJson(json.decode(str));

String premInstitutionalDashboardModelToJson(
        PremInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class PremInstitutionalDashboardModel {
  Data? data;

  PremInstitutionalDashboardModel({
    this.data,
  });

  factory PremInstitutionalDashboardModel.fromJson(Map<String, dynamic> json) =>
      PremInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? totalPremAdmitted;
  List<PremInstitutionalDashboardOutcome>? sceneIft;
  int? totalProcedures;
  int? totalIft;
  double? avgStay;
  List<PremInstitutionalDashboardOutcome>? outcome;

  Data({
    this.totalPremAdmitted,
    this.sceneIft,
    this.totalProcedures,
    this.totalIft,
    this.avgStay,
    this.outcome,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPremAdmitted: json["total_prem_admitted"],
        sceneIft: json["scene_ift"] == null
            ? []
            : List<PremInstitutionalDashboardOutcome>.from(json["scene_ift"]!
                .map((x) => PremInstitutionalDashboardOutcome.fromJson(x))),
        totalProcedures: json["total_procedures"],
        totalIft: json["total_ift"],
        avgStay: json["avg_stay"],
        outcome: json["outcome"] == null
            ? []
            : List<PremInstitutionalDashboardOutcome>.from(json["outcome"]!
                .map((x) => PremInstitutionalDashboardOutcome.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_prem_admitted": totalPremAdmitted,
        "scene_ift": sceneIft == null
            ? []
            : List<dynamic>.from(sceneIft!.map((x) => x.toJson())),
        "total_procedures": totalProcedures,
        "total_ift": totalIft,
        "avg_stay": avgStay,
        "outcome": outcome == null
            ? []
            : List<dynamic>.from(outcome!.map((x) => x.toJson())),
      };
}

class PremInstitutionalDashboardOutcome {
  int? id;
  String? name;
  int? totalCount;

  PremInstitutionalDashboardOutcome({
    this.id,
    this.name,
    this.totalCount,
  });

  factory PremInstitutionalDashboardOutcome.fromJson(
          Map<String, dynamic> json) =>
      PremInstitutionalDashboardOutcome(
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
