// To parse this JSON data, do
//
//     final premListModel = premListModelFromJson(jsonString);

import 'dart:convert';

PremListModel premListModelFromJson(String str) =>
    PremListModel.fromJson(json.decode(str));

String premListModelToJson(PremListModel data) => json.encode(data.toJson());

class PremListModel {
  int? totalCount;
  List<PremListData>? rows;

  PremListModel({
    this.totalCount,
    this.rows,
  });

  factory PremListModel.fromJson(Map<String, dynamic> json) => PremListModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<PremListData>.from(
                json["rows"]!.map((x) => PremListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class PremListData {
  int? triageId;
  String? modeOfArrival;
  String? sceneIft;
  String? nameOfPatient;
  String? emergencyCategory;
  String? presentingComplaint;
  dynamic sourceHospital;
  dynamic destinationHospital;
  int? statusid;
  String? triageFlag;
  int? premId;

  PremListData({
    this.triageId,
    this.modeOfArrival,
    this.sceneIft,
    this.nameOfPatient,
    this.emergencyCategory,
    this.presentingComplaint,
    this.sourceHospital,
    this.destinationHospital,
    this.statusid,
    this.triageFlag,
    this.premId,
  });

  factory PremListData.fromJson(Map<String, dynamic> json) => PremListData(
        triageId: json["triage_id"],
        modeOfArrival: json["mode_of_arrival"],
        sceneIft: json["scene_ift"],
        nameOfPatient: json["name_of_patient"],
        emergencyCategory: json["emergency_category"],
        presentingComplaint: json["presenting_complaint"],
        sourceHospital: json["source_hospital"],
        destinationHospital: json["destination_hospital"],
        statusid: json["statusid"],
        triageFlag: json["triage_flag"],
        premId: json["prem_id"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "mode_of_arrival": modeOfArrival,
        "scene_ift": sceneIft,
        "name_of_patient": nameOfPatient,
        "emergency_category": emergencyCategory,
        "presenting_complaint": presentingComplaint,
        "source_hospital": sourceHospital,
        "destination_hospital": destinationHospital,
        "statusid": statusid,
        "triage_flag": triageFlag,
        "prem_id": premId,
      };
}
