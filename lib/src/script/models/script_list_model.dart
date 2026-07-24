// To parse this JSON data, do
//
//     final scriptListModel = scriptListModelFromJson(jsonString);

import 'dart:convert';

ScriptListModel scriptListModelFromJson(String str) =>
    ScriptListModel.fromJson(json.decode(str));

String scriptListModelToJson(ScriptListModel data) =>
    json.encode(data.toJson());

class ScriptListModel {
  int? totalCount;
  List<ScriptListData>? rows;

  ScriptListModel({
    this.totalCount,
    this.rows,
  });

  factory ScriptListModel.fromJson(Map<String, dynamic> json) =>
      ScriptListModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<ScriptListData>.from(
                json["rows"]!.map((x) => ScriptListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class ScriptListData {
  int? triageId;
  String? modeOfArrival;
  String? sceneIft;
  String? nameOfPatient;
  String? emergencyCategory;
  String? presentingComplaint;
  String? sourceHospital;
  String? destinationHospital;
  int? statusid;
  String? triageFlag;
  int? strokeId;

  ScriptListData({
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
    this.strokeId,
  });

  factory ScriptListData.fromJson(Map<String, dynamic> json) => ScriptListData(
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
        strokeId: json["stroke_id"],
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
        "stroke_id": strokeId,
      };
}
