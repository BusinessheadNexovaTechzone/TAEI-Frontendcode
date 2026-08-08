// To parse this JSON data, do
//
//     final scriptLookupModel = scriptLookupModelFromJson(jsonString);

import 'dart:convert';

import 'package:taei_gov/src/burn/models/burn_lookup_model.dart';

ScriptLookupModel scriptLookupModelFromJson(String str) =>
    ScriptLookupModel.fromJson(json.decode(str));

String scriptLookupModelToJson(ScriptLookupModel data) =>
    json.encode(data.toJson());

class ScriptLookupModel {
  List<ListItem>? arrivalTimeSymptoms;
  List<ListItem>? reasonForDelay;
  List<ListItem>? referredFrom;
  List<ListItem>? strokeReasonForReferral;
  List<ListItem>? symptoms;
  List<ListItem>? absoluteContraindication;
  List<ListItem>? nihsScale;
  List<ListItem>? mriScanWakeupStroke;
  List<ListItem>? type;
  List<ListItem>? thrombolysisByDrug;
  List<ListItem>? outcome;
  List<ListItem>? hospitalType;
  List<ListItem>? destinationHospital;
  List<ListItem>? reasonForReferral;
  List<ListItem>? conditionOfPatient;
  List<ItemList>? sceneIft;

  ScriptLookupModel(
      {this.arrivalTimeSymptoms,
      this.reasonForDelay,
      this.referredFrom,
      this.strokeReasonForReferral,
      this.symptoms,
      this.absoluteContraindication,
      this.nihsScale,
      this.mriScanWakeupStroke,
      this.type,
      this.thrombolysisByDrug,
      this.outcome,
      this.hospitalType,
      this.destinationHospital,
      this.reasonForReferral,
      this.conditionOfPatient,
      this.sceneIft});

  factory ScriptLookupModel.fromJson(Map<String, dynamic> json) => ScriptLookupModel(
      arrivalTimeSymptoms: json["ArrivalTimeSymptoms"] == null
          ? []
          : List<ListItem>.from(
              json["ArrivalTimeSymptoms"]!.map((x) => ListItem.fromJson(x))),
      reasonForDelay: json["ReasonForDelay"] == null
          ? []
          : List<ListItem>.from(
              json["ReasonForDelay"]!.map((x) => ListItem.fromJson(x))),
      referredFrom: json["ReferredFrom"] == null
          ? []
          : List<ListItem>.from(
              json["ReferredFrom"]!.map((x) => ListItem.fromJson(x))),
      strokeReasonForReferral: json["StrokeReasonForReferral"] == null
          ? []
          : List<ListItem>.from(json["StrokeReasonForReferral"]!
              .map((x) => ListItem.fromJson(x))),
      symptoms: json["Symptoms"] == null
          ? []
          : List<ListItem>.from(
              json["Symptoms"]!.map((x) => ListItem.fromJson(x))),
      absoluteContraindication: json["AbsoluteContraindication"] == null
          ? []
          : List<ListItem>.from(json["AbsoluteContraindication"]!.map((x) => ListItem.fromJson(x))),
      nihsScale: json["NihsScale"] == null ? [] : List<ListItem>.from(json["NihsScale"]!.map((x) => ListItem.fromJson(x))),
      mriScanWakeupStroke: json["MriScanWakeupStroke"] == null ? [] : List<ListItem>.from(json["MriScanWakeupStroke"]!.map((x) => ListItem.fromJson(x))),
      type: json["Type"] == null ? [] : List<ListItem>.from(json["Type"]!.map((x) => ListItem.fromJson(x))),
      thrombolysisByDrug: json["ThrombolysisByDrug"] == null ? [] : List<ListItem>.from(json["ThrombolysisByDrug"]!.map((x) => ListItem.fromJson(x))),
      outcome: json["Outcome"] == null ? [] : List<ListItem>.from(json["Outcome"]!.map((x) => ListItem.fromJson(x))),
      hospitalType: json["HospitalType"] == null ? [] : List<ListItem>.from(json["HospitalType"]!.map((x) => ListItem.fromJson(x))),
      destinationHospital: json["DestinationHospital"] == null ? [] : List<ListItem>.from(json["DestinationHospital"]!.map((x) => ListItem.fromJson(x))),
      reasonForReferral: json["ReasonForReferral"] == null ? [] : List<ListItem>.from(json["ReasonForReferral"]!.map((x) => ListItem.fromJson(x))),
      conditionOfPatient: json["ConditionOfPatient"] == null ? [] : List<ListItem>.from(json["ConditionOfPatient"]!.map((x) => ListItem.fromJson(x))),
      sceneIft: json["SceneIft"] == null ? [] : List<ItemList>.from(json["SceneIft"]!.map((x) => ItemList.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "ArrivalTimeSymptoms": arrivalTimeSymptoms == null
            ? []
            : List<dynamic>.from(arrivalTimeSymptoms!.map((x) => x.toJson())),
        "ReasonForDelay": reasonForDelay == null
            ? []
            : List<dynamic>.from(reasonForDelay!.map((x) => x.toJson())),
        "ReferredFrom": referredFrom == null
            ? []
            : List<dynamic>.from(referredFrom!.map((x) => x.toJson())),
        "StrokeReasonForReferral": strokeReasonForReferral == null
            ? []
            : List<dynamic>.from(
                strokeReasonForReferral!.map((x) => x.toJson())),
        "Symptoms": symptoms == null
            ? []
            : List<dynamic>.from(symptoms!.map((x) => x.toJson())),
        "AbsoluteContraindication": absoluteContraindication == null
            ? []
            : List<dynamic>.from(
                absoluteContraindication!.map((x) => x.toJson())),
        "NihsScale": nihsScale == null
            ? []
            : List<dynamic>.from(nihsScale!.map((x) => x.toJson())),
        "MriScanWakeupStroke": mriScanWakeupStroke == null
            ? []
            : List<dynamic>.from(mriScanWakeupStroke!.map((x) => x.toJson())),
        "Type": type == null
            ? []
            : List<dynamic>.from(type!.map((x) => x.toJson())),
        "ThrombolysisByDrug": thrombolysisByDrug == null
            ? []
            : List<dynamic>.from(thrombolysisByDrug!.map((x) => x.toJson())),
        "Outcome": outcome == null
            ? []
            : List<dynamic>.from(outcome!.map((x) => x.toJson())),
        "HospitalType": hospitalType == null
            ? []
            : List<dynamic>.from(hospitalType!.map((x) => x.toJson())),
        "DestinationHospital": destinationHospital == null
            ? []
            : List<dynamic>.from(destinationHospital!.map((x) => x.toJson())),
        "ReasonForReferral": reasonForReferral == null
            ? []
            : List<dynamic>.from(reasonForReferral!.map((x) => x.toJson())),
        "ConditionOfPatient": conditionOfPatient == null
            ? []
            : List<dynamic>.from(conditionOfPatient!.map((x) => x.toJson())),
        "SceneIft": sceneIft == null
            ? []
            : List<dynamic>.from(sceneIft!.map((x) => x.toJson())),
      };
}

class ListItem {
  int? id;
  String? name;

  ListItem({
    this.id,
    this.name,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
