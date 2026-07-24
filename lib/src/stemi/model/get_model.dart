// To parse this JSON data, do
//
//     final stemiListModel = stemiListModelFromJson(jsonString);

import 'dart:convert';

StemiListModel stemiListModelFromJson(String str) =>
    StemiListModel.fromJson(json.decode(str));

String stemiListModelToJson(StemiListModel data) => json.encode(data.toJson());

class StemiListModel {
  int? totalCount;
  List<StemiListData>? rows;

  StemiListModel({
    this.totalCount,
    this.rows,
  });

  factory StemiListModel.fromJson(Map<String, dynamic> json) => StemiListModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<StemiListData>.from(
                json["rows"]!.map((x) => StemiListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class StemiListData {
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
  int? stemiId;
  String? dateTimeOfTriage;

  StemiListData({
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
    this.stemiId,
    this.dateTimeOfTriage,
  });

  factory StemiListData.fromJson(Map<String, dynamic> json) => StemiListData(
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
        stemiId: json["stemi_id"],
        dateTimeOfTriage: json["date_time_of_triage"],
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
        "stemi_id": stemiId,
        "date_time_of_triage": dateTimeOfTriage,
      };
}
