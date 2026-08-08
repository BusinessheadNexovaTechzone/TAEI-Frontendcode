// To parse this JSON data, do
//
//     final burnsListModel = burnsListModelFromJson(jsonString);

import 'dart:convert';

BurnsListModel burnsListModelFromJson(String str) =>
    BurnsListModel.fromJson(json.decode(str));

String burnsListModelToJson(BurnsListModel data) => json.encode(data.toJson());

class BurnsListModel {
  int? totalCount;
  List<BurnsListData>? rows;

  BurnsListModel({
    this.totalCount,
    this.rows,
  });

  factory BurnsListModel.fromJson(Map<String, dynamic> json) => BurnsListModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<BurnsListData>.from(
                json["rows"]!.map((x) => BurnsListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class BurnsListData {
  int? triageId;
  String? modeOfArrival;
  String? sceneIft;
  String? nameOfPatient;
  String? emergencyCategory;
  String? presentingComplaint;
  dynamic sourceHospital;
  dynamic destinationHospital;
  int? statusid;
  dynamic triageFlag;
  dynamic burnsId;

  BurnsListData({
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
    this.burnsId,
  });

  factory BurnsListData.fromJson(Map<String, dynamic> json) => BurnsListData(
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
        burnsId: json["burns_id"],
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
        "burns_id": burnsId,
      };
}
