// To parse this JSON data, do
//
//     final emoLooksUpModel = emoLooksUpModelFromJson(jsonString);

import 'dart:convert';

import 'package:taei_gov/utils/common/model/ab_model.dart';

emoLooksUpModelFromJson(String str) =>
    EmoLooksUpModel.fromJson(json.decode(str));

String emoLooksUpModelToJson(EmoLooksUpModel data) =>
    json.encode(data.toJson());

class EmoLooksUpModel {
  List<LooksUpItem>? pastHistory;
  List<LooksUpItem>? emergencyCategory;
  List<LooksUpItem>? traumaTreatment;
  List<LooksUpItem>? recallInfo;
  List<LooksUpItem>? speech;
  List<LooksUpItem>? genDisposition;
  List<LooksUpItem>? clothing;
  List<LooksUpItem>? orientationTime;
  List<LooksUpItem>? emoOutcome;
  List<LooksUpItem>? hospitalType;
  List<LooksUpItem>? reasonForReferral;
  List<LooksUpItem>? conditionOfPatient;

  EmoLooksUpModel({
    this.pastHistory,
    this.emergencyCategory,
    this.traumaTreatment,
    this.recallInfo,
    this.speech,
    this.genDisposition,
    this.clothing,
    this.orientationTime,
    this.emoOutcome,
    this.hospitalType,
    this.reasonForReferral,
    this.conditionOfPatient,
  });

  factory EmoLooksUpModel.fromJson(Map<String, dynamic> json) =>
      EmoLooksUpModel(
        pastHistory: json["PastHistory"] == null
            ? []
            : List<LooksUpItem>.from(
                json["PastHistory"]!.map((x) => LooksUpItem.fromJson(x))),
        emergencyCategory: json["EmergencyCategory"] == null
            ? []
            : List<LooksUpItem>.from(
                json["EmergencyCategory"]!.map((x) => LooksUpItem.fromJson(x))),
        traumaTreatment: json["TraumaTreatment"] == null
            ? []
            : List<LooksUpItem>.from(
                json["TraumaTreatment"]!.map((x) => LooksUpItem.fromJson(x))),
        recallInfo: json["RecallInfo"] == null
            ? []
            : List<LooksUpItem>.from(
                json["RecallInfo"]!.map((x) => LooksUpItem.fromJson(x))),
        speech: json["Speech"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Speech"]!.map((x) => LooksUpItem.fromJson(x))),
        genDisposition: json["GenDisposition"] == null
            ? []
            : List<LooksUpItem>.from(
                json["GenDisposition"]!.map((x) => LooksUpItem.fromJson(x))),
        clothing: json["Clothing"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Clothing"]!.map((x) => LooksUpItem.fromJson(x))),
        orientationTime: json["OrientationTime"] == null
            ? []
            : List<LooksUpItem>.from(
                json["OrientationTime"]!.map((x) => LooksUpItem.fromJson(x))),
        emoOutcome: json["EmoOutcome"] == null
            ? []
            : List<LooksUpItem>.from(
                json["EmoOutcome"]!.map((x) => LooksUpItem.fromJson(x))),
        hospitalType: json["HospitalType"] == null
            ? []
            : List<LooksUpItem>.from(
                json["HospitalType"]!.map((x) => LooksUpItem.fromJson(x))),
        reasonForReferral: json["ReasonForReferral"] == null
            ? []
            : List<LooksUpItem>.from(
                json["ReasonForReferral"]!.map((x) => LooksUpItem.fromJson(x))),
        conditionOfPatient: json["ConditionOfPatient"] == null
            ? []
            : List<LooksUpItem>.from(json["ConditionOfPatient"]!
                .map((x) => LooksUpItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PastHistory": pastHistory == null
            ? []
            : List<dynamic>.from(pastHistory!.map((x) => x.toJson())),
        "EmergencyCategory": emergencyCategory == null
            ? []
            : List<dynamic>.from(emergencyCategory!.map((x) => x.toJson())),
        "TraumaTreatment": traumaTreatment == null
            ? []
            : List<dynamic>.from(traumaTreatment!.map((x) => x.toJson())),
        "RecallInfo": recallInfo == null
            ? []
            : List<dynamic>.from(recallInfo!.map((x) => x.toJson())),
        "Speech": speech == null
            ? []
            : List<dynamic>.from(speech!.map((x) => x.toJson())),
        "GenDisposition": genDisposition == null
            ? []
            : List<dynamic>.from(genDisposition!.map((x) => x.toJson())),
        "Clothing": clothing == null
            ? []
            : List<dynamic>.from(clothing!.map((x) => x.toJson())),
        "OrientationTime": orientationTime == null
            ? []
            : List<dynamic>.from(orientationTime!.map((x) => x.toJson())),
        "EmoOutcome": emoOutcome == null
            ? []
            : List<dynamic>.from(emoOutcome!.map((x) => x.toJson())),
        "HospitalType": hospitalType == null
            ? []
            : List<dynamic>.from(hospitalType!.map((x) => x.toJson())),
        "ReasonForReferral": reasonForReferral == null
            ? []
            : List<dynamic>.from(reasonForReferral!.map((x) => x.toJson())),
        "ConditionOfPatient": conditionOfPatient == null
            ? []
            : List<dynamic>.from(conditionOfPatient!.map((x) => x.toJson())),
      };
}
////

class LooksUpItem {
  int? id;
  String? name;
  bool? isAdult;

  // substance_involved_id
  int? substanceInvolvedId;

  LooksUpItem({
    this.id,
    this.name,
    this.isAdult,
    this.substanceInvolvedId,
  });

  factory LooksUpItem.fromJson(Map<String, dynamic> json) => LooksUpItem(
        id: json["id"],
        name: json["name"],
        isAdult: json["is_adult"],
        substanceInvolvedId: json["substance_involved_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_adult": isAdult,
        "substance_involved_id": substanceInvolvedId,
      };
}
