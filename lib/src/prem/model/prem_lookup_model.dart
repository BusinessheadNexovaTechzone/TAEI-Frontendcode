// To parse this JSON data:
//
//     final premLooksUpModel = premLooksUpModelFromJson(jsonString);

import 'dart:convert';

PremLooksUpModel premLooksUpModelFromJson(String str) =>
    PremLooksUpModel.fromJson(json.decode(str));

String premLooksUpModelToJson(PremLooksUpModel data) =>
    json.encode(data.toJson());


// PremLookupModel premLookupModelFromJson(String str) =>
//     PremLookupModel.fromJson(json.decode(str));
//
// String premLookupModelToJson(PremLookupModel data) =>
//     json.encode(data.toJson());

class PremLooksUpModel {
  List<LookupItem>? presentingComplaints;
  List<LookupItem>? airway;
  List<LookupItem>? breathing;
  List<LookupItem>? circulationHr;
  List<LookupItem>? perfusion;
  List<LookupItem>? liverSpan;
  List<LookupItem>? systolicBp;
  List<LookupItem>? map;
  List<LookupItem>? disability;
  List<LookupItem>? tonePosture;
  List<LookupItem>? eyePositionMovements;
  List<LookupItem>? pupils;
  List<LookupItem>? development;
  List<LookupItem>? diagnosis;
  List<DiagnosisRefItem>? diagnosisRef;
  List<LookupItem>? triageFlag;
  List<LookupItem>? proceduresDone;
  List<LookupItem>? outcome;
  List<LookupItem>? stabilisedReferral;
  List<LookupItem>? hospitalType;
  List<LookupItem>? reasonForReferral;
  List<LookupItem>? conditionOfPatient;

  PremLooksUpModel({
    this.presentingComplaints,
    this.airway,
    this.breathing,
    this.circulationHr,
    this.perfusion,
    this.liverSpan,
    this.systolicBp,
    this.map,
    this.disability,
    this.tonePosture,
    this.eyePositionMovements,
    this.pupils,
    this.development,
    this.diagnosis,
    this.diagnosisRef,
    this.triageFlag,
    this.proceduresDone,
    this.outcome,
    this.stabilisedReferral,
    this.hospitalType,
    this.reasonForReferral,
    this.conditionOfPatient,
  });

  factory PremLooksUpModel.fromJson(Map<String, dynamic> json) => PremLooksUpModel(
    presentingComplaints: (json["PresentingComplaints"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    airway:
    (json["Airway"] as List?)?.map((x) => LookupItem.fromJson(x)).toList(),
    breathing: (json["Breathing"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    circulationHr: (json["CirculationHr"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    perfusion: (json["Perfusion"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    liverSpan: (json["LiverSpan"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    systolicBp: (json["SystolicBp"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    map: (json["Map"] as List?)?.map((x) => LookupItem.fromJson(x)).toList(),
    disability: (json["Disability"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    tonePosture: (json["TonePosture"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    eyePositionMovements: (json["EyePositionMovements"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    pupils: (json["Pupils"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    development: (json["Development"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    diagnosis: (json["Diagnosis"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    diagnosisRef: (json["DiagnosisRef"] as List?)
        ?.map((x) => DiagnosisRefItem.fromJson(x))
        .toList(),
    triageFlag: (json["TriageFlag"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    proceduresDone: (json["ProceduresDone"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    outcome: (json["Outcome"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    stabilisedReferral: (json["StabilisedReferral"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    hospitalType: (json["HospitalType"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    reasonForReferral: (json["ReasonForReferral"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
    conditionOfPatient: (json["ConditionOfPatient"] as List?)
        ?.map((x) => LookupItem.fromJson(x))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "PresentingComplaints":
    presentingComplaints?.map((x) => x.toJson()).toList(),
    "Airway": airway?.map((x) => x.toJson()).toList(),
    "Breathing": breathing?.map((x) => x.toJson()).toList(),
    "CirculationHr": circulationHr?.map((x) => x.toJson()).toList(),
    "Perfusion": perfusion?.map((x) => x.toJson()).toList(),
    "LiverSpan": liverSpan?.map((x) => x.toJson()).toList(),
    "SystolicBp": systolicBp?.map((x) => x.toJson()).toList(),
    "Map": map?.map((x) => x.toJson()).toList(),
    "Disability": disability?.map((x) => x.toJson()).toList(),
    "TonePosture": tonePosture?.map((x) => x.toJson()).toList(),
    "EyePositionMovements":
    eyePositionMovements?.map((x) => x.toJson()).toList(),
    "Pupils": pupils?.map((x) => x.toJson()).toList(),
    "Development": development?.map((x) => x.toJson()).toList(),
    "Diagnosis": diagnosis?.map((x) => x.toJson()).toList(),
    "DiagnosisRef": diagnosisRef?.map((x) => x.toJson()).toList(),
    "TriageFlag": triageFlag?.map((x) => x.toJson()).toList(),
    "ProceduresDone": proceduresDone?.map((x) => x.toJson()).toList(),
    "Outcome": outcome?.map((x) => x.toJson()).toList(),
    "StabilisedReferral":
    stabilisedReferral?.map((x) => x.toJson()).toList(),
    "HospitalType": hospitalType?.map((x) => x.toJson()).toList(),
    "ReasonForReferral":
    reasonForReferral?.map((x) => x.toJson()).toList(),
    "ConditionOfPatient":
    conditionOfPatient?.map((x) => x.toJson()).toList(),
  };
}

class LookupItem {
  int? id;
  String? name;

  LookupItem({this.id, this.name});

  factory LookupItem.fromJson(Map<String, dynamic> json) => LookupItem(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class DiagnosisRefItem {
  int? id;
  String? name;
  int? diagnosisId;

  DiagnosisRefItem({this.id, this.name, this.diagnosisId});

  factory DiagnosisRefItem.fromJson(Map<String, dynamic> json) =>
      DiagnosisRefItem(
        id: json["id"],
        name: json["name"],
        diagnosisId: json["diagnosis_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "diagnosis_id": diagnosisId,
  };
}

