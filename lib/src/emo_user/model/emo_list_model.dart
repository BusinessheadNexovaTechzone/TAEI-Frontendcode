// To parse this JSON data, do
//
//     final emoListDataModel = emoListDataModelFromJson(jsonString);

import 'dart:convert';

EmoListDataModel emoListDataModelFromJson(String str) =>
    EmoListDataModel.fromJson(json.decode(str));

String emoListDataModelToJson(EmoListDataModel data) =>
    json.encode(data.toJson());

class EmoListDataModel {
  int? totalCount;
  List<EmoListData>? rows;

  EmoListDataModel({
    this.totalCount,
    this.rows,
  });

  factory EmoListDataModel.fromJson(Map<String, dynamic> json) =>
      EmoListDataModel(
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<EmoListData>.from(
                json["rows"]!.map((x) => EmoListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class EmoListData {
  int? triageId;
  String? nameOfPatient;
  String? modeOfArrival;
  String? sceneIft;
  String? medicalEmergency;
  String? surgicalEmergency;
  int? statusId;
  String? triageFlag;
  int? emoId;
  int? isAdult;

  EmoListData({
    this.triageId,
    this.nameOfPatient,
    this.modeOfArrival,
    this.sceneIft,
    this.medicalEmergency,
    this.surgicalEmergency,
    this.statusId,
    this.triageFlag,
    this.emoId,
    this.isAdult,
  });

  factory EmoListData.fromJson(Map<String, dynamic> json) => EmoListData(
        triageId: json["triage_id"],
        nameOfPatient: json["name_of_patient"],
        modeOfArrival: json["mode_of_arrival"],
        sceneIft: json["scene_ift"],
        medicalEmergency: json["medical_emergency"],
        surgicalEmergency: json["surgical_emergency"],
        statusId: json["statusid"],
        triageFlag: json["triage_flag"],
        emoId: json["emo_id"],
        isAdult: json["isadult"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "name_of_patient": nameOfPatient,
        "mode_of_arrival": modeOfArrival,
        "scene_ift": sceneIft,
        "medical_emergency": medicalEmergency,
        "surgical_emergency": surgicalEmergency,
        "statusid": statusId,
        "triage_flag": triageFlag,
        "emo_id": emoId,
        "isadult": isAdult,
      };

  @override
  String toString() => jsonEncode(toJson());
}
