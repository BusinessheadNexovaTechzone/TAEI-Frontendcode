// To parse this JSON data, do
//
//     final hangingListModel = hangingListModelFromJson(jsonString);

import 'dart:convert';

HangingListModel hangingListModelFromJson(String str) =>
    HangingListModel.fromJson(json.decode(str));

String hangingListModelToJson(HangingListModel data) =>
    json.encode(data.toJson());

class HangingListModel {
  int? totalCount;
  List<HangingListData>? rows;

  HangingListModel({
    this.totalCount,
    this.rows,
  });

  factory HangingListModel.fromJson(Map<String, dynamic> json) =>
      HangingListModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<HangingListData>.from(
                json["rows"]!.map((x) => HangingListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class HangingListData {
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
  dynamic hangingId;

  HangingListData({
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
    this.hangingId,
  });

  factory HangingListData.fromJson(Map<String, dynamic> json) =>
      HangingListData(
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
        hangingId: json["hanging_id"],
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
        "hanging_id": hangingId,
      };
}
