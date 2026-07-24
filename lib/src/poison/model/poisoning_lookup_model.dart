// To parse this JSON data, do
//
//     final poisoningLookUpModel = poisoningLookUpModelFromJson(jsonString);

import 'dart:convert';

import 'package:taei_gov/src/emo_user/model/emo_lookup_model.dart';

PoisoningLookUpModel poisoningLookUpModelFromJson(String str) =>
    PoisoningLookUpModel.fromJson(json.decode(str));

String poisoningLookUpModelToJson(PoisoningLookUpModel data) =>
    json.encode(data.toJson());

class PoisoningLookUpModel {
  List<LooksUpItem>? typeOfPoisoning;
  List<LooksUpItem>? routeOfExposure;
  List<LooksUpItem>? substanceInvolved;
  List<LooksUpItem>? substanceInvolvedSub;
  List<LooksUpItem>? sourceOfSubstance;
  List<LooksUpItem>? severityOfPoisoning;
  List<LooksUpItem>? decontamination;
  List<LooksUpItem>? supportiveCareProvided;
  List<LooksUpItem>? outcome;
  List<LooksUpItem>? hospitalType;
  List<LooksUpItem>? destinationHospital;
  List<LooksUpItem>? reasonForReferral;
  List<LooksUpItem>? conditionOfPatient;
  List<LooksUpItem>? symptomsPresentation;

  PoisoningLookUpModel({
    this.typeOfPoisoning,
    this.routeOfExposure,
    this.substanceInvolved,
    this.substanceInvolvedSub,
    this.sourceOfSubstance,
    this.severityOfPoisoning,
    this.decontamination,
    this.supportiveCareProvided,
    this.outcome,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.symptomsPresentation,
  });

  factory PoisoningLookUpModel.fromJson(Map<String, dynamic> json) =>
      PoisoningLookUpModel(
        typeOfPoisoning: json["TypeOfPoisoning"] == null
            ? []
            : List<LooksUpItem>.from(
                json["TypeOfPoisoning"]!.map((x) => LooksUpItem.fromJson(x))),
        routeOfExposure: json["RouteOfExposure"] == null
            ? []
            : List<LooksUpItem>.from(
                json["RouteOfExposure"]!.map((x) => LooksUpItem.fromJson(x))),
        substanceInvolved: json["SubstanceInvolved"] == null
            ? []
            : List<LooksUpItem>.from(
                json["SubstanceInvolved"]!.map((x) => LooksUpItem.fromJson(x))),
        substanceInvolvedSub: json["SubstanceInvolvedSub"] == null
            ? []
            : List<LooksUpItem>.from(json["SubstanceInvolvedSub"]!
                .map((x) => LooksUpItem.fromJson(x))),
        sourceOfSubstance: json["SourceOfSubstance"] == null
            ? []
            : List<LooksUpItem>.from(
                json["SourceOfSubstance"]!.map((x) => LooksUpItem.fromJson(x))),
        severityOfPoisoning: json["SeverityOfPoisoning"] == null
            ? []
            : List<LooksUpItem>.from(json["SeverityOfPoisoning"]!
                .map((x) => LooksUpItem.fromJson(x))),
        decontamination: json["Decontamination"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Decontamination"]!.map((x) => LooksUpItem.fromJson(x))),
        supportiveCareProvided: json["SupportiveCareProvided"] == null
            ? []
            : List<LooksUpItem>.from(json["SupportiveCareProvided"]!
                .map((x) => LooksUpItem.fromJson(x))),
        outcome: json["Outcome"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Outcome"]!.map((x) => LooksUpItem.fromJson(x))),
        hospitalType: json["HospitalType"] == null
            ? []
            : List<LooksUpItem>.from(
                json["HospitalType"]!.map((x) => LooksUpItem.fromJson(x))),
        destinationHospital: json["DestinationHospital"] == null
            ? []
            : List<LooksUpItem>.from(json["DestinationHospital"]!
                .map((x) => LooksUpItem.fromJson(x))),
        reasonForReferral: json["ReasonForReferral"] == null
            ? []
            : List<LooksUpItem>.from(
                json["ReasonForReferral"]!.map((x) => LooksUpItem.fromJson(x))),
        conditionOfPatient: json["ConditionOfPatient"] == null
            ? []
            : List<LooksUpItem>.from(json["ConditionOfPatient"]!
                .map((x) => LooksUpItem.fromJson(x))),
        symptomsPresentation: json["SymptomsPresentation"] == null
            ? []
            : List<LooksUpItem>.from(json["SymptomsPresentation"]!
                .map((x) => LooksUpItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TypeOfPoisoning": typeOfPoisoning == null
            ? []
            : List<dynamic>.from(typeOfPoisoning!.map((x) => x.toJson())),
        "RouteOfExposure": routeOfExposure == null
            ? []
            : List<dynamic>.from(routeOfExposure!.map((x) => x.toJson())),
        "SubstanceInvolved": substanceInvolved == null
            ? []
            : List<dynamic>.from(substanceInvolved!.map((x) => x.toJson())),
        "SubstanceInvolvedSub": substanceInvolvedSub == null
            ? []
            : List<dynamic>.from(substanceInvolvedSub!.map((x) => x.toJson())),
        "SourceOfSubstance": sourceOfSubstance == null
            ? []
            : List<dynamic>.from(sourceOfSubstance!.map((x) => x.toJson())),
        "SeverityOfPoisoning": severityOfPoisoning == null
            ? []
            : List<dynamic>.from(severityOfPoisoning!.map((x) => x.toJson())),
        "Decontamination": decontamination == null
            ? []
            : List<dynamic>.from(decontamination!.map((x) => x.toJson())),
        "SupportiveCareProvided": supportiveCareProvided == null
            ? []
            : List<dynamic>.from(
                supportiveCareProvided!.map((x) => x.toJson())),
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
        "SymptomsPresentation": symptomsPresentation == null
            ? []
            : List<dynamic>.from(symptomsPresentation!.map((x) => x.toJson())),
      };
  @override
  String toString() => jsonEncode(toJson());
}
