import 'dart:convert';

import 'package:taei_gov/src/emo_user/model/emo_lookup_model.dart';

TraumaLooksUpModel traumaLooksUpModelFromJson(String str) =>
    TraumaLooksUpModel.fromJson(json.decode(str));

String traumaLooksUpModelToJson(TraumaLooksUpModel data) =>
    json.encode(data.toJson());

class TraumaLooksUpModel {
  List<LooksUpItem>? mechanismOfInjury;
  List<LooksUpItem>? typeOfInjury;
  List<LooksUpItem>? rta;
  List<LooksUpItem>? assault;
  List<LooksUpItem>? workspotInjury;
  List<LooksUpItem>? gcsEye;
  List<LooksUpItem>? gcsVerbal;
  List<LooksUpItem>? gcsMotor;
  List<LooksUpItem>? specialityOpinion;
  List<LooksUpItem>? mechIntubationDtls;
  List<LooksUpItem>? othProcedureDone;
  List<LooksUpItem>? management;
  List<LooksUpItem>? typeOfSurgery;
  List<LooksUpItem>? surgeryDoneUnder;
  List<LooksUpItem>? cpr;
  List<LooksUpItem>? outcome;
  List<LooksUpItem>? hospitalType;
  List<LooksUpItem>? destinationHospital;
  List<LooksUpItem>? reasonForReferral;
  List<LooksUpItem>? conditionOfPatient;
  List<LooksUpItem>? flag;
  List<LooksUpItem>? injuriesIdentified;
  List<LooksUpItem>? partOfTheBodyInjured;
  //SpecialityOpinion

  TraumaLooksUpModel({
    this.mechanismOfInjury,
    this.typeOfInjury,
    this.rta,
    this.assault,
    this.workspotInjury,
    this.gcsEye,
    this.gcsVerbal,
    this.gcsMotor,
    this.specialityOpinion,
    this.mechIntubationDtls,
    this.othProcedureDone,
    this.management,
    this.typeOfSurgery,
    this.surgeryDoneUnder,
    this.cpr,
    this.outcome,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.flag,
    this.injuriesIdentified,
    this.partOfTheBodyInjured,
  });

  factory TraumaLooksUpModel.fromJson(Map<String, dynamic> json) =>
      TraumaLooksUpModel(
        mechanismOfInjury: _mapList(json["MechanismOfInjury"]),
        typeOfInjury: _mapList(json["TypeOfInjury"]),
        rta: _mapList(json["Rta"]),
        assault: _mapList(json["Assault"]),
        workspotInjury: _mapList(json["WorkspotInjury"]),
        gcsEye: _mapList(json["GcsEye"]),
        gcsVerbal: _mapList(json["GcsVerbal"]),
        gcsMotor: _mapList(json["GcsMotor"]),
        specialityOpinion: _mapList(json["SpecialityOpinion"]),
        mechIntubationDtls: _mapList(json["MechIntubationDtls"]),
        othProcedureDone: _mapList(json["OthProcedureDone"]),
        management: _mapList(json["Management"]),
        typeOfSurgery: _mapList(json["TypeOfSurgery"]),
        surgeryDoneUnder: _mapList(json["SurgeryDoneUnder"]),
        cpr: _mapList(json["Cpr"]),
        outcome: _mapList(json["Outcome"]),
        hospitalType: _mapList(json["HospitalType"]),
        destinationHospital: _mapList(json["DestinationHospital"]),
        reasonForReferral: _mapList(json["ReasonForReferral"]),
        conditionOfPatient: _mapList(json["ConditionOfPatient"]),
        flag: _mapList(json["Flag"]),
        injuriesIdentified: _mapList(json["InjuriesIdentified"]),
        partOfTheBodyInjured: _mapList(json["PartOfTheBodyInjured"]),
      );

  Map<String, dynamic> toJson() => {
        "MechanismOfInjury": _toList(mechanismOfInjury),
        "TypeOfInjury": _toList(typeOfInjury),
        "Rta": _toList(rta),
        "Assault": _toList(assault),
        "WorkspotInjury": _toList(workspotInjury),
        "GcsEye": _toList(gcsEye),
        "GcsVerbal": _toList(gcsVerbal),
        "GcsMotor": _toList(gcsMotor),
        "SpecialityOpinion": _toList(specialityOpinion),
        "MechIntubationDtls": _toList(mechIntubationDtls),
        "OthProcedureDone": _toList(othProcedureDone),
        "Management": _toList(management),
        "TypeOfSurgery": _toList(typeOfSurgery),
        "SurgeryDoneUnder": _toList(surgeryDoneUnder),
        "Cpr": _toList(cpr),
        "Outcome": _toList(outcome),
        "HospitalType": _toList(hospitalType),
        "DestinationHospital": _toList(destinationHospital),
        "ReasonForReferral": _toList(reasonForReferral),
        "ConditionOfPatient": _toList(conditionOfPatient),
        "Flag": _toList(flag),
        "InjuriesIdentified": _toList(injuriesIdentified),
        "PartOfTheBodyInjured": _toList(partOfTheBodyInjured),
      };

  /// helper functions
  static List<LooksUpItem>? _mapList(dynamic data) => data == null
      ? []
      : List<LooksUpItem>.from(data.map((x) => LooksUpItem.fromJson(x)));

  static List<dynamic> _toList(List<LooksUpItem>? data) =>
      data == null ? [] : List<dynamic>.from(data.map((x) => x.toJson()));
}
