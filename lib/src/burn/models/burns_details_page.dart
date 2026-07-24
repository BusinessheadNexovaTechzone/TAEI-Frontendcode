// To parse this JSON data, do
//
//     final burnsDetailsModel = burnsDetailsModelFromJson(jsonString);

import 'dart:convert';

BurnsDetailsModel burnsDetailsModelFromJson(String str) =>
    BurnsDetailsModel.fromJson(json.decode(str));

String burnsDetailsModelToJson(BurnsDetailsModel data) =>
    json.encode(data.toJson());

class BurnsDetailsModel {
  BurnsDetails? burns;
  BurnsTbsaDetails? burnsTbsa;
  BurnsValuesDetails? burnsValues;
  List<BurnsSurgeryElectiveDetails>? burnsSurgeryElective;
  BurnsOutcomeDetails? burnsOutcome;

  BurnsDetailsModel({
    this.burns,
    this.burnsTbsa,
    this.burnsValues,
    this.burnsSurgeryElective,
    this.burnsOutcome,
  });

  factory BurnsDetailsModel.fromJson(Map<String, dynamic> json) =>
      BurnsDetailsModel(
        burns:
            json["burns"] == null ? null : BurnsDetails.fromJson(json["burns"]),
        burnsTbsa: json["burns_tbsa"] == null
            ? null
            : BurnsTbsaDetails.fromJson(json["burns_tbsa"]),
        burnsValues: json["burns_values"] == null
            ? null
            : BurnsValuesDetails.fromJson(json["burns_values"]),
        burnsSurgeryElective: json["burns_surgery_elective"] == null
            ? []
            : List<BurnsSurgeryElectiveDetails>.from(
                json["burns_surgery_elective"]!
                    .map((x) => BurnsSurgeryElectiveDetails.fromJson(x))),
        burnsOutcome: json["burns_outcome"] == null
            ? null
            : BurnsOutcomeDetails.fromJson(json["burns_outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "burns": burns?.toJson(),
        "burns_tbsa": burnsTbsa?.toJson(),
        "burns_values": burnsValues?.toJson(),
        "burns_surgery_elective": burnsSurgeryElective == null
            ? []
            : List<dynamic>.from(burnsSurgeryElective!.map((x) => x.toJson())),
        "burns_outcome": burnsOutcome?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsDetails {
  int? id;
  int? triageId;
  bool? admitted;
  String? admissionDate;
  String? typeOfBurn;
  bool? inhalation;
  String? othTypeOfBurn;
  String? modeOfInjury;
  String? placeOfIncident;
  String? othPlaceOfIncident;
  String? tbsa;
  String? tbsaTotalPer;
  String? degreeOfBurn;
  String? associatedInjuries;
  String? coMorbidities;
  bool? isPregnant;
  bool? isFluidResuscitationGiven;
  bool? isMechanicalVentillation;
  int? userId;
  String? insertedDate;
  int? refFormId;
  int? refId;

  BurnsDetails({
    this.id,
    this.triageId,
    this.admitted,
    this.admissionDate,
    this.typeOfBurn,
    this.inhalation,
    this.othTypeOfBurn,
    this.modeOfInjury,
    this.placeOfIncident,
    this.othPlaceOfIncident,
    this.tbsa,
    this.tbsaTotalPer,
    this.degreeOfBurn,
    this.associatedInjuries,
    this.coMorbidities,
    this.isPregnant,
    this.isFluidResuscitationGiven,
    this.isMechanicalVentillation,
    this.userId,
    this.insertedDate,
    this.refFormId,
    this.refId,
  });

  factory BurnsDetails.fromJson(Map<String, dynamic> json) => BurnsDetails(
        id: json["id"],
        triageId: json["triage_id"],
        admitted: json["admitted"],
        admissionDate: json["admission_date"],
        typeOfBurn: json["type_of_burn"],
        inhalation: json["inhalation"],
        othTypeOfBurn: json["oth_type_of_burn"],
        modeOfInjury: json["mode_of_injury"],
        placeOfIncident: json["place_of_incident"],
        othPlaceOfIncident: json["oth_place_of_incident"],
        tbsa: json["tbsa"],
        tbsaTotalPer: json["tbsa_total_per"],
        degreeOfBurn: json["degree_of_burn"],
        associatedInjuries: json["associated_injuries"],
        coMorbidities: json["co_morbidities"],
        isPregnant: json["is_pregnant"],
        isFluidResuscitationGiven: json["is_fluid_resuscitation_given"],
        isMechanicalVentillation: json["is_mechanical_ventillation"],
        userId: json["user_id"],
        insertedDate: json["inserted_date"],
        refFormId: json["ref_form_id"],
        refId: json["ref_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "triage_id": triageId,
        "admitted": admitted,
        "admission_date": admissionDate,
        "type_of_burn": typeOfBurn,
        "inhalation": inhalation,
        "oth_type_of_burn": othTypeOfBurn,
        "mode_of_injury": modeOfInjury,
        "place_of_incident": placeOfIncident,
        "oth_place_of_incident": othPlaceOfIncident,
        "tbsa": tbsa,
        "tbsa_total_per": tbsaTotalPer,
        "degree_of_burn": degreeOfBurn,
        "associated_injuries": associatedInjuries,
        "co_morbidities": coMorbidities,
        "is_pregnant": isPregnant,
        "is_fluid_resuscitation_given": isFluidResuscitationGiven,
        "is_mechanical_ventillation": isMechanicalVentillation,
        "user_id": userId,
        "inserted_date": insertedDate,
        "ref_form_id": refFormId,
        "ref_id": refId,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsOutcomeDetails {
  int? id;
  String? outcome;
  String? dischargeDate;
  dynamic abscondedDate;
  dynamic deathDate;
  dynamic causeofdeath;
  String? transferredTo;
  String? wardDatetime;
  String? wardName;
  String? icuDatetime;
  String? hospitalType;
  String? destinationHospital;
  String? reasonForReferral;
  String? conditionOfPatient;
  String? referringDoctorName;
  bool? documentedTaeiSheet;
  String? patientExitDate;

  BurnsOutcomeDetails({
    this.id,
    this.outcome,
    this.dischargeDate,
    this.abscondedDate,
    this.deathDate,
    this.causeofdeath,
    this.transferredTo,
    this.wardDatetime,
    this.wardName,
    this.icuDatetime,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctorName,
    this.documentedTaeiSheet,
    this.patientExitDate,
  });

  factory BurnsOutcomeDetails.fromJson(Map<String, dynamic> json) =>
      BurnsOutcomeDetails(
        id: json["id"],
        outcome: json["outcome"],
        dischargeDate: json["discharge_date"],
        abscondedDate: json["absconded_date"],
        deathDate: json["death_date"],
        causeofdeath: json["causeofdeath"],
        transferredTo: json["transferred_to"],
        wardDatetime: json["ward_datetime"],
        wardName: json["ward_name"],
        icuDatetime: json["icu_datetime"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctorName: json["referring_doctor_name"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        patientExitDate: json["patient_exit_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "outcome": outcome,
        "discharge_date": dischargeDate,
        "absconded_date": abscondedDate,
        "death_date": deathDate,
        "causeofdeath": causeofdeath,
        "transferred_to": transferredTo,
        "ward_datetime": wardDatetime,
        "ward_name": wardName,
        "icu_datetime": icuDatetime,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor_name": referringDoctorName,
        "documented_taei_sheet": documentedTaeiSheet,
        "patient_exit_date": patientExitDate,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsSurgeryElectiveDetails {
  int? id;
  String? surgeryElective;
  String? surgeryElectiveDate;

  BurnsSurgeryElectiveDetails({
    this.id,
    this.surgeryElective,
    this.surgeryElectiveDate,
  });

  factory BurnsSurgeryElectiveDetails.fromJson(Map<String, dynamic> json) =>
      BurnsSurgeryElectiveDetails(
        id: json["id"],
        surgeryElective: json["surgery_elective"],
        surgeryElectiveDate: json["surgery_elective_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "surgery_elective": surgeryElective,
        "surgery_elective_date": surgeryElectiveDate,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsValuesDetails {
  int? id;
  String? woundManagement;
  String? conservative;
  bool? hyperBaric;
  int? hyperBaricNos;
  String? othConservative;
  String? surgeryEmergency;
  bool? isSurgeryEmergency;
  String? surgeryPerformedDate;
  String? supportiveMeasures;
  String? complicationsHospitalStay;
  String? multidisciplinarySupport;
  String? othMultidisciplinarySupport;
  bool? skinBankAvailable;
  String? skinBankAvailableValue;

  BurnsValuesDetails({
    this.id,
    this.woundManagement,
    this.conservative,
    this.hyperBaric,
    this.hyperBaricNos,
    this.othConservative,
    this.surgeryEmergency,
    this.isSurgeryEmergency,
    this.surgeryPerformedDate,
    this.supportiveMeasures,
    this.complicationsHospitalStay,
    this.multidisciplinarySupport,
    this.othMultidisciplinarySupport,
    this.skinBankAvailable,
    this.skinBankAvailableValue,
  });

  factory BurnsValuesDetails.fromJson(Map<String, dynamic> json) =>
      BurnsValuesDetails(
        id: json["id"],
        woundManagement: json["wound_management"],
        conservative: json["conservative"],
        hyperBaric: json["hyper_baric"],
        hyperBaricNos: json["hyper_baric_nos"],
        othConservative: json["oth_conservative"],
        surgeryEmergency: json["surgery_emergency"],
        isSurgeryEmergency: json["is_surgery_emergency"],
        surgeryPerformedDate: json["surgery_performed_date"],
        supportiveMeasures: json["supportive_measures"],
        complicationsHospitalStay: json["complications_hospital_stay"],
        multidisciplinarySupport: json["multidisciplinary_support"],
        othMultidisciplinarySupport: json["oth_multidisciplinary_support"],
        skinBankAvailable: json["skin_bank_available"],
        skinBankAvailableValue: json["skin_bank_available_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wound_management": woundManagement,
        "conservative": conservative,
        "hyper_baric": hyperBaric,
        "hyper_baric_nos": hyperBaricNos,
        "oth_conservative": othConservative,
        "surgery_emergency": surgeryEmergency,
        "is_surgery_emergency": isSurgeryEmergency,
        "surgery_performed_date": surgeryPerformedDate,
        "supportive_measures": supportiveMeasures,
        "complications_hospital_stay": complicationsHospitalStay,
        "multidisciplinary_support": multidisciplinarySupport,
        "oth_multidisciplinary_support": othMultidisciplinarySupport,
        "skin_bank_available": skinBankAvailable,
        "skin_bank_available_value": skinBankAvailableValue,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsTbsaDetails {
  int? id;
  int? burnsId;
  double? head;
  double? neck;
  double? anteriorTrunk;
  double? posteriorTrunk;
  double? rightGluteal;
  double? leftGluteal;
  double? genital;
  double? rightArm;
  double? leftArm;
  double? rightForearm;
  double? leftForearm;
  double? rightHand;
  double? leftHand;
  double? rightThigh;
  double? leftThigh;
  double? rightLeg;
  double? leftLeg;
  double? rightFoot;
  double? leftFoot;

  BurnsTbsaDetails({
    this.id,
    this.burnsId,
    this.head,
    this.neck,
    this.anteriorTrunk,
    this.posteriorTrunk,
    this.rightGluteal,
    this.leftGluteal,
    this.genital,
    this.rightArm,
    this.leftArm,
    this.rightForearm,
    this.leftForearm,
    this.rightHand,
    this.leftHand,
    this.rightThigh,
    this.leftThigh,
    this.rightLeg,
    this.leftLeg,
    this.rightFoot,
    this.leftFoot,
  });

  factory BurnsTbsaDetails.fromJson(Map<String, dynamic> json) =>
      BurnsTbsaDetails(
        id: json["id"],
        burnsId: json["burns_id"],
        head: json["head"] != null
            ? double.tryParse(json["head"].toString())
            : null,
        neck: json["neck"] != null
            ? double.tryParse(json["neck"].toString())
            : null,
        anteriorTrunk: json["anterior_trunk"] != null
            ? double.tryParse(json["anterior_trunk"].toString())
            : null,
        posteriorTrunk: json["posterior_trunk"] != null
            ? double.tryParse(json["posterior_trunk"].toString())
            : null,
        rightGluteal: json["right_gluteal"] != null
            ? double.tryParse(json["right_gluteal"].toString())
            : null,
        leftGluteal: json["left_gluteal"] != null
            ? double.tryParse(json["left_gluteal"].toString())
            : null,
        genital: json["genital"] != null
            ? double.tryParse(json["genital"].toString())
            : null,
        rightArm: json["right_arm"] != null
            ? double.tryParse(json["right_arm"].toString())
            : null,
        leftArm: json["left_arm"] != null
            ? double.tryParse(json["left_arm"].toString())
            : null,
        rightForearm: json["right_forearm"] != null
            ? double.tryParse(json["right_forearm"].toString())
            : null,
        leftForearm: json["left_forearm"] != null
            ? double.tryParse(json["left_forearm"].toString())
            : null,
        rightHand: json["right_hand"] != null
            ? double.tryParse(json["right_hand"].toString())
            : null,
        leftHand: json["left_hand"] != null
            ? double.tryParse(json["left_hand"].toString())
            : null,
        rightThigh: json["right_thigh"] != null
            ? double.tryParse(json["right_thigh"].toString())
            : null,
        leftThigh: json["left_thigh"] != null
            ? double.tryParse(json["left_thigh"].toString())
            : null,
        rightLeg: json["right_leg"] != null
            ? double.tryParse(json["right_leg"].toString())
            : null,
        leftLeg: json["left_leg"] != null
            ? double.tryParse(json["left_leg"].toString())
            : null,
        rightFoot: json["right_foot"] != null
            ? double.tryParse(json["right_foot"].toString())
            : null,
        leftFoot: json["left_foot"] != null
            ? double.tryParse(json["left_foot"].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "burns_id": burnsId,
        "head": head,
        "neck": neck,
        "anterior_trunk": anteriorTrunk,
        "posterior_trunk": posteriorTrunk,
        "right_gluteal": rightGluteal,
        "left_gluteal": leftGluteal,
        "genital": genital,
        "right_arm": rightArm,
        "left_arm": leftArm,
        "right_forearm": rightForearm,
        "left_forearm": leftForearm,
        "right_hand": rightHand,
        "left_hand": leftHand,
        "right_thigh": rightThigh,
        "left_thigh": leftThigh,
        "right_leg": rightLeg,
        "left_leg": leftLeg,
        "right_foot": rightFoot,
        "left_foot": leftFoot,
      };

  @override
  String toString() => jsonEncode(toJson());
}
