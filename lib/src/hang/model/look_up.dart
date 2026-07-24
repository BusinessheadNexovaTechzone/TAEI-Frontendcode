import 'dart:convert';

HangingLookup hangingLookupFromJson(String str) =>
    HangingLookup.fromJson(json.decode(str));

String hangingLookupToJson(HangingLookup data) => json.encode(data.toJson());

class HangingLookup {
  List<LookupItem>? natureOfIncident;
  List<LookupItem>? suspensionOfBody;
  List<LookupItem>? materialsUsed;
  List<LookupItem>? symptomsPresentation;
  List<LookupItem>? interventions;
  List<LookupItem>? supportiveCareProvided;
  List<LookupItem>? outcome;
  List<LookupItem>? hospitalType;
  List<LookupItem>? destinationHospital;
  List<LookupItem>? reasonForReferral;
  List<LookupItem>? conditionOfPatient;

  HangingLookup({
    this.natureOfIncident,
    this.suspensionOfBody,
    this.materialsUsed,
    this.symptomsPresentation,
    this.interventions,
    this.supportiveCareProvided,
    this.outcome,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
  });

  factory HangingLookup.fromJson(Map<String, dynamic> json) => HangingLookup(
        natureOfIncident: json["NatureOfIncident"] == null
            ? []
            : List<LookupItem>.from(
                json["NatureOfIncident"].map((x) => LookupItem.fromJson(x))),
        suspensionOfBody: json["SuspensionOfBody"] == null
            ? []
            : List<LookupItem>.from(
                json["SuspensionOfBody"].map((x) => LookupItem.fromJson(x))),
        materialsUsed: json["MaterialsUsed"] == null
            ? []
            : List<LookupItem>.from(
                json["MaterialsUsed"].map((x) => LookupItem.fromJson(x))),
        symptomsPresentation: json["SymptomsPresentation"] == null
            ? []
            : List<LookupItem>.from(json["SymptomsPresentation"]
                .map((x) => LookupItem.fromJson(x))),
        interventions: json["Interventions"] == null
            ? []
            : List<LookupItem>.from(
                json["Interventions"].map((x) => LookupItem.fromJson(x))),
        supportiveCareProvided: json["SupportiveCareProvided"] == null
            ? []
            : List<LookupItem>.from(json["SupportiveCareProvided"]
                .map((x) => LookupItem.fromJson(x))),
        outcome: json["Outcome"] == null
            ? []
            : List<LookupItem>.from(
                json["Outcome"].map((x) => LookupItem.fromJson(x))),
        hospitalType: json["HospitalType"] == null
            ? []
            : List<LookupItem>.from(
                json["HospitalType"].map((x) => LookupItem.fromJson(x))),
        destinationHospital: json["DestinationHospital"] == null
            ? []
            : List<LookupItem>.from(
                json["DestinationHospital"].map((x) => LookupItem.fromJson(x))),
        reasonForReferral: json["ReasonForReferral"] == null
            ? []
            : List<LookupItem>.from(
                json["ReasonForReferral"].map((x) => LookupItem.fromJson(x))),
        conditionOfPatient: json["ConditionOfPatient"] == null
            ? []
            : List<LookupItem>.from(
                json["ConditionOfPatient"].map((x) => LookupItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "NatureOfIncident": natureOfIncident == null
            ? []
            : List<dynamic>.from(natureOfIncident!.map((x) => x.toJson())),
        "SuspensionOfBody": suspensionOfBody == null
            ? []
            : List<dynamic>.from(suspensionOfBody!.map((x) => x.toJson())),
        "MaterialsUsed": materialsUsed == null
            ? []
            : List<dynamic>.from(materialsUsed!.map((x) => x.toJson())),
        "SymptomsPresentation": symptomsPresentation == null
            ? []
            : List<dynamic>.from(symptomsPresentation!.map((x) => x.toJson())),
        "Interventions": interventions == null
            ? []
            : List<dynamic>.from(interventions!.map((x) => x.toJson())),
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
      };

  @override
  String toString() => jsonEncode(toJson());
}

class LookupItem {
  int? id;
  String? name;

  LookupItem({
    this.id,
    this.name,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) => LookupItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() => jsonEncode(toJson());
}
