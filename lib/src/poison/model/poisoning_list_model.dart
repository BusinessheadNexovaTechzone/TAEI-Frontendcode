// To parse this JSON data, do
//
//     final poisoningListModel = poisoningListModelFromJson(jsonString);

import 'dart:convert';

PoisoningListModel poisoningListModelFromJson(String str) =>
    PoisoningListModel.fromJson(json.decode(str));

String poisoningListModelToJson(PoisoningListModel data) =>
    json.encode(data.toJson());

class PoisoningListModel {
  int? totalCount;
  List<PoisoningListData>? poisoningData;

  PoisoningListModel({
    this.totalCount,
    this.poisoningData,
  });

  factory PoisoningListModel.fromJson(Map<String, dynamic> json) =>
      PoisoningListModel(
        totalCount: json["totalCount"],
        poisoningData: json["rows"] == null
            ? []
            : List<PoisoningListData>.from(
                json["rows"]!.map((x) => PoisoningListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": poisoningData == null
            ? []
            : List<dynamic>.from(poisoningData!.map((x) => x.toJson())),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class PoisoningListData {
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
  dynamic poisonId;
  String? dateTimeOfTriage;
  String? dateAndTimeOfIncident;

  PoisoningListData({
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
    this.poisonId,
    this.dateTimeOfTriage,
    this.dateAndTimeOfIncident,
  });

  factory PoisoningListData.fromJson(Map<String, dynamic> json) =>
      PoisoningListData(
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
        poisonId: json["poison_id"],
        dateTimeOfTriage: json["date_time_of_triage"],
        dateAndTimeOfIncident: json["date_and_time_of_incident"],
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
        "poison_id": poisonId,
        "date_time_of_triage": dateTimeOfTriage,
        "date_and_time_of_incident": dateAndTimeOfIncident,
      };

  @override
  String toString() => jsonEncode(toJson());
}
