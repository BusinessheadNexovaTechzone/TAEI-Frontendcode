// To parse this JSON data, do
//
//     final drowningListModel = drowningListModelFromJson(jsonString);

import 'dart:convert';

DrowningListModel drowningListModelFromJson(String str) =>
    DrowningListModel.fromJson(json.decode(str));

String drowningListModelToJson(DrowningListModel data) =>
    json.encode(data.toJson());

class DrowningListModel {
  int? totalCount;
  List<DrowningListData>? rows;

  DrowningListModel({
    this.totalCount,
    this.rows,
  });

  factory DrowningListModel.fromJson(Map<String, dynamic> json) =>
      DrowningListModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<DrowningListData>.from(
                json["rows"]!.map((x) => DrowningListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class DrowningListData {
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
  dynamic drowningId;

  DrowningListData({
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
    this.drowningId,
  });

  factory DrowningListData.fromJson(Map<String, dynamic> json) =>
      DrowningListData(
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
        drowningId: json["drowning_id"],
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
        "drowning_id": drowningId,
      };
}
