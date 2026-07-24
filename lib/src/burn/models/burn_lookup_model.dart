// To parse this JSON data, do
//
//     final burnLookupModel = burnLookupModelFromJson(jsonString);

import 'dart:convert';

BurnLookupModel burnLookupModelFromJson(String str) =>
    BurnLookupModel.fromJson(json.decode(str));

String burnLookupModelToJson(BurnLookupModel data) =>
    json.encode(data.toJson());

class BurnLookupModel {
  List<ItemList>? typeOfBurn;
  List<ItemList>? modeOfInjury;
  List<ItemList>? placeOfIncident;
  List<ItemList>? tbsa;
  List<ItemList>? degreeOfBurn;
  List<ItemList>? coMorbidities;
  List<ItemList>? woundManagement;
  List<ItemList>? conservative;
  List<ItemList>? surgeryEmergency;
  List<ItemList>? surgeryElective;
  List<ItemList>? supportiveMeasures;
  List<ItemList>? stayComplications;
  List<ItemList>? multidisciplinarySupport;
  List<ItemList>? noOfHospitalStay;
  List<ItemList>? outcome;
  List<ItemList>? transferredTo;
  List<ItemList>? hospitalType;
  List<ItemList>? destinationHospital;
  List<ItemList>? reasonForReferral;
  List<ItemList>? conditionOfPatient;

  BurnLookupModel({
    this.typeOfBurn,
    this.modeOfInjury,
    this.placeOfIncident,
    this.tbsa,
    this.degreeOfBurn,
    this.coMorbidities,
    this.woundManagement,
    this.conservative,
    this.surgeryEmergency,
    this.surgeryElective,
    this.supportiveMeasures,
    this.stayComplications,
    this.multidisciplinarySupport,
    this.noOfHospitalStay,
    this.outcome,
    this.transferredTo,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
  });

  factory BurnLookupModel.fromJson(Map<String, dynamic> json) =>
      BurnLookupModel(
        typeOfBurn: json["TypeOfBurn"] == null
            ? []
            : List<ItemList>.from(
                json["TypeOfBurn"]!.map((x) => ItemList.fromJson(x))),
        modeOfInjury: json["ModeOfInjury"] == null
            ? []
            : List<ItemList>.from(
                json["ModeOfInjury"]!.map((x) => ItemList.fromJson(x))),
        placeOfIncident: json["PlaceOfIncident"] == null
            ? []
            : List<ItemList>.from(
                json["PlaceOfIncident"]!.map((x) => ItemList.fromJson(x))),
        tbsa: json["Tbsa"] == null
            ? []
            : List<ItemList>.from(
                json["Tbsa"]!.map((x) => ItemList.fromJson(x))),
        degreeOfBurn: json["DegreeOfBurn"] == null
            ? []
            : List<ItemList>.from(
                json["DegreeOfBurn"]!.map((x) => ItemList.fromJson(x))),
        coMorbidities: json["CoMorbidities"] == null
            ? []
            : List<ItemList>.from(
                json["CoMorbidities"]!.map((x) => ItemList.fromJson(x))),
        woundManagement: json["WoundManagement"] == null
            ? []
            : List<ItemList>.from(
                json["WoundManagement"]!.map((x) => ItemList.fromJson(x))),
        conservative: json["Conservative"] == null
            ? []
            : List<ItemList>.from(
                json["Conservative"]!.map((x) => ItemList.fromJson(x))),
        surgeryEmergency: json["SurgeryEmergency"] == null
            ? []
            : List<ItemList>.from(
                json["SurgeryEmergency"]!.map((x) => ItemList.fromJson(x))),
        surgeryElective: json["SurgeryElective"] == null
            ? []
            : List<ItemList>.from(
                json["SurgeryElective"]!.map((x) => ItemList.fromJson(x))),
        supportiveMeasures: json["SupportiveMeasures"] == null
            ? []
            : List<ItemList>.from(
                json["SupportiveMeasures"]!.map((x) => ItemList.fromJson(x))),
        stayComplications: json["StayComplications"] == null
            ? []
            : List<ItemList>.from(
                json["StayComplications"]!.map((x) => ItemList.fromJson(x))),
        multidisciplinarySupport: json["MultidisciplinarySupport"] == null
            ? []
            : List<ItemList>.from(json["MultidisciplinarySupport"]!
                .map((x) => ItemList.fromJson(x))),
        noOfHospitalStay: json["NoOfHospitalStay"] == null
            ? []
            : List<ItemList>.from(
                json["NoOfHospitalStay"]!.map((x) => ItemList.fromJson(x))),
        outcome: json["Outcome"] == null
            ? []
            : List<ItemList>.from(
                json["Outcome"]!.map((x) => ItemList.fromJson(x))),
        transferredTo: json["TransferredTo"] == null
            ? []
            : List<ItemList>.from(
                json["TransferredTo"]!.map((x) => ItemList.fromJson(x))),
        hospitalType: json["HospitalType"] == null
            ? []
            : List<ItemList>.from(
                json["HospitalType"]!.map((x) => ItemList.fromJson(x))),
        destinationHospital: json["DestinationHospital"] == null
            ? []
            : List<ItemList>.from(
                json["DestinationHospital"]!.map((x) => ItemList.fromJson(x))),
        reasonForReferral: json["ReasonForReferral"] == null
            ? []
            : List<ItemList>.from(
                json["ReasonForReferral"]!.map((x) => ItemList.fromJson(x))),
        conditionOfPatient: json["ConditionOfPatient"] == null
            ? []
            : List<ItemList>.from(
                json["ConditionOfPatient"]!.map((x) => ItemList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TypeOfBurn": typeOfBurn == null
            ? []
            : List<dynamic>.from(typeOfBurn!.map((x) => x.toJson())),
        "ModeOfInjury": modeOfInjury == null
            ? []
            : List<dynamic>.from(modeOfInjury!.map((x) => x.toJson())),
        "PlaceOfIncident": placeOfIncident == null
            ? []
            : List<dynamic>.from(placeOfIncident!.map((x) => x.toJson())),
        "Tbsa": tbsa == null
            ? []
            : List<dynamic>.from(tbsa!.map((x) => x.toJson())),
        "DegreeOfBurn": degreeOfBurn == null
            ? []
            : List<dynamic>.from(degreeOfBurn!.map((x) => x.toJson())),
        "CoMorbidities": coMorbidities == null
            ? []
            : List<dynamic>.from(coMorbidities!.map((x) => x.toJson())),
        "WoundManagement": woundManagement == null
            ? []
            : List<dynamic>.from(woundManagement!.map((x) => x.toJson())),
        "Conservative": conservative == null
            ? []
            : List<dynamic>.from(conservative!.map((x) => x.toJson())),
        "SurgeryEmergency": surgeryEmergency == null
            ? []
            : List<dynamic>.from(surgeryEmergency!.map((x) => x.toJson())),
        "SurgeryElective": surgeryElective == null
            ? []
            : List<dynamic>.from(surgeryElective!.map((x) => x.toJson())),
        "SupportiveMeasures": supportiveMeasures == null
            ? []
            : List<dynamic>.from(supportiveMeasures!.map((x) => x.toJson())),
        "StayComplications": stayComplications == null
            ? []
            : List<dynamic>.from(stayComplications!.map((x) => x.toJson())),
        "MultidisciplinarySupport": multidisciplinarySupport == null
            ? []
            : List<dynamic>.from(
                multidisciplinarySupport!.map((x) => x.toJson())),
        "NoOfHospitalStay": noOfHospitalStay == null
            ? []
            : List<dynamic>.from(noOfHospitalStay!.map((x) => x.toJson())),
        "Outcome": outcome == null
            ? []
            : List<dynamic>.from(outcome!.map((x) => x.toJson())),
        "TransferredTo": transferredTo == null
            ? []
            : List<dynamic>.from(transferredTo!.map((x) => x.toJson())),
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
}

class ItemList {
  int? id;
  String? name;

  ItemList({
    this.id,
    this.name,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
