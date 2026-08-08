// To parse this JSON data, do
//
//     final traumaListDataModel = traumaListDataModelFromJson(jsonString);

import 'dart:convert';

TraumaListDataModel traumaListDataModelFromJson(String str) =>
    TraumaListDataModel.fromJson(json.decode(str));

String traumaListDataModelToJson(TraumaListDataModel data) =>
    json.encode(data.toJson());

class TraumaListDataModel {
  int? totalCount;
  List<TraumaListData>? rows;

  TraumaListDataModel({
    this.totalCount,
    this.rows,
  });

  factory TraumaListDataModel.fromJson(Map<String, dynamic> json) =>
      TraumaListDataModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<TraumaListData>.from(
                json["rows"]!.map((x) => TraumaListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class TraumaListData {
  int? triageId;
  String? ddd;
  String? modeOfArrival;
  String? sceneIft;
  String? nameOfPatient;
  String? emergencyCategory;
  String? presentingComplaint;
  String? sourceHospital;
  String? destinationHospital;
  int? statusid;
  String? triageFlag;
  int? traumaId;
  String? dateTimeOfTriage;
  String? dateAndTimeOfIncident;

  TraumaListData({
    this.triageId,
    this.ddd,
    this.modeOfArrival,
    this.sceneIft,
    this.nameOfPatient,
    this.emergencyCategory,
    this.presentingComplaint,
    this.sourceHospital,
    this.destinationHospital,
    this.statusid,
    this.triageFlag,
    this.traumaId,
    this.dateTimeOfTriage,
    this.dateAndTimeOfIncident,
  });

  factory TraumaListData.fromJson(Map<String, dynamic> json) => TraumaListData(
        triageId: json["triage_id"],
        ddd: json["ddd"],
        modeOfArrival: json["mode_of_arrival"],
        sceneIft: json["scene_ift"],
        nameOfPatient: json["name_of_patient"],
        emergencyCategory: json["emergency_category"],
        presentingComplaint: json["presenting_complaint"],
        sourceHospital: json["source_hospital"],
        destinationHospital: json["destination_hospital"],
        statusid: json["statusid"],
        triageFlag: json["triage_flag"],
        traumaId: json["trauma_id"],
        dateTimeOfTriage: json["date_time_of_triage"],
        dateAndTimeOfIncident: json["date_and_time_of_incident"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "ddd": ddd,
        "mode_of_arrival": modeOfArrival,
        "scene_ift": sceneIft,
        "name_of_patient": nameOfPatient,
        "emergency_category": emergencyCategory,
        "presenting_complaint": presentingComplaint,
        "source_hospital": sourceHospital,
        "destination_hospital": destinationHospital,
        "statusid": statusid,
        "triage_flag": triageFlag,
        "trauma_id": traumaId,
        "date_time_of_triage": dateTimeOfTriage,
        "date_and_time_of_incident": dateAndTimeOfIncident,
      };

  @override
  String toString() => jsonEncode(toJson());
}
