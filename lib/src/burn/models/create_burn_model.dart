// To parse this JSON data, do
//
//     final burnsModel = burnsModelFromJson(jsonString);

import 'dart:convert';

BurnsModel burnsModelFromJson(String str) =>
    BurnsModel.fromJson(json.decode(str));

String burnsModelToJson(BurnsModel data) => json.encode(data.toJson());

class BurnsModel {
  Burns? burns;
  BurnsValues? burnsValues;
  BurnsTbsa? burnsTbsa;
  BurnsOutcome? burnsOutcome;
  List<BurnsSurgeryElective>? burnsSurgeryElective;

  BurnsModel({
    this.burns,
    this.burnsValues,
    this.burnsTbsa,
    this.burnsOutcome,
    this.burnsSurgeryElective,
  });

  factory BurnsModel.fromJson(Map<String, dynamic> json) => BurnsModel(
        burns: json["burns"] != null ? Burns.fromJson(json["burns"]) : null,
        burnsValues: json["burns_values"] != null
            ? BurnsValues.fromJson(json["burns_values"])
            : null,
        burnsTbsa: json["burns_tbsa"] != null
            ? BurnsTbsa.fromJson(json["burns_tbsa"])
            : null,
        burnsOutcome: json["burns_outcome"] != null
            ? BurnsOutcome.fromJson(json["burns_outcome"])
            : null,
        burnsSurgeryElective: json["burns_surgery_elective"] != null
            ? List<BurnsSurgeryElective>.from(json["burns_surgery_elective"]
                .map((x) => BurnsSurgeryElective.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "burns": burns?.toJson(),
        "burns_values": burnsValues?.toJson(),
        "burns_tbsa": burnsTbsa?.toJson(),
        "burns_outcome": burnsOutcome?.toJson(),
        "burns_surgery_elective": burnsSurgeryElective == null
            ? []
            : List<dynamic>.from(burnsSurgeryElective!.map((x) => x.toJson())),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Burns {
  int? id;
  int? triageId;
  bool? admitted;
  String? admissionDate;
  int? typeOfBurn;
  bool? inhalation;
  String? othTypeOfBurn;
  int? modeOfInjury;
  String? othModeOfInjury;
  int? placeOfIncident;
  String? othPlaceOfIncident;
  List<int>? tbsa;
  String? tbsaTotalPer;
  int? degreeOfBurn;
  String? associatedInjuries;
  List<int>? coMorbidities;
  bool? isPregnant;
  bool? isFluidResuscitationGiven;
  bool? isMechanicalVentillation;
  int? refId;
  int? refFormId;

  Burns({
    this.id,
    this.triageId,
    this.admitted,
    this.admissionDate,
    this.typeOfBurn,
    this.inhalation,
    this.othTypeOfBurn,
    this.modeOfInjury,
    this.othModeOfInjury,
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
    this.refId,
    this.refFormId,
  });

  factory Burns.fromJson(Map<String, dynamic> json) => Burns(
        id: json["id"],
        triageId: json["triage_id"],
        admitted: json["admitted"],
        admissionDate: json["admission_date"],
        typeOfBurn: json["type_of_burn"],
        inhalation: json["inhalation"],
        othTypeOfBurn: json["oth_type_of_burn"],
        modeOfInjury: json["mode_of_injury"],
        othModeOfInjury: json["oth_mode_of_injury"],
        placeOfIncident: json["place_of_incident"],
        othPlaceOfIncident: json["oth_place_of_incident"],
        // tbsa: json["tbsa"] == null
        //     ? []
        //     : List<int>.from(json["tbsa"]!.map((x) => x)),
        tbsaTotalPer: json["tbsa_total_per"],
        degreeOfBurn: json["degree_of_burn"],
        associatedInjuries: json["associated_injuries"],
        coMorbidities: json["co_morbidities"] == null
            ? []
            : List<int>.from(json["co_morbidities"]!.map((x) => x)),
        isPregnant: json["is_pregnant"],
        isFluidResuscitationGiven: json["is_fluid_resuscitation_given"],
        isMechanicalVentillation: json["is_mechanical_ventillation"],
        refId: json["ref_id"],
        refFormId: json["ref_form_id"],
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
        "oth_mode_of_injury": othModeOfInjury,
        "place_of_incident": placeOfIncident,
        "oth_place_of_incident": othPlaceOfIncident,
        // "tbsa": tbsa == null ? [] : List<dynamic>.from(tbsa!.map((x) => x)),
        "tbsa_total_per": tbsaTotalPer,
        "degree_of_burn": degreeOfBurn,
        "associated_injuries": associatedInjuries,
        "co_morbidities": coMorbidities == null
            ? []
            : List<dynamic>.from(coMorbidities!.map((x) => x)),
        "is_pregnant": isPregnant,
        "is_fluid_resuscitation_given": isFluidResuscitationGiven,
        "is_mechanical_ventillation": isMechanicalVentillation,
        "ref_id": refId,
        "ref_form_id": refFormId,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsOutcome {
  int? id;
  int? burnsId;
  int? outcome;
  String? dischargeDate;
  dynamic abscondedDate;
  dynamic deathDate;
  dynamic causeofdeath;
  int? transferredTo;
  String? wardDatetime;
  String? wardName;
  String? icuDatetime;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTAEIHospitalId;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctorName;
  bool? documentedTaeiSheet;
  String? patientExitDate;
  bool? isDischarged;

  BurnsOutcome({
    this.id,
    this.burnsId,
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
    this.destinationTAEIHospitalId,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctorName,
    this.documentedTaeiSheet,
    this.patientExitDate,
    this.isDischarged,
  });

  factory BurnsOutcome.fromJson(Map<String, dynamic> json) => BurnsOutcome(
        id: json["id"],
        burnsId: json["burns_id"],
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
        destinationTAEIHospitalId: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctorName: json["referring_doctor_name"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        patientExitDate: json["patient_exit_date"],
        isDischarged: json["is_discharged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "burns_id": burnsId,
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
        "destination_taei_hospital": destinationTAEIHospitalId,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor_name": referringDoctorName,
        "documented_taei_sheet": documentedTaeiSheet,
        "patient_exit_date": patientExitDate,
        "is_discharged": isDischarged,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsSurgeryElective {
  int? id;
  int? burnsId;
  int? surgeryElective;
  String? surgeryElectiveDate;

  BurnsSurgeryElective({
    this.id,
    this.burnsId,
    this.surgeryElective,
    this.surgeryElectiveDate,
  });

  factory BurnsSurgeryElective.fromJson(Map<String, dynamic> json) =>
      BurnsSurgeryElective(
        id: json["id"],
        burnsId: json["burns_id"],
        surgeryElective: json["surgery_elective"],
        surgeryElectiveDate: json["surgery_elective_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "burns_id": burnsId,
        "surgery_elective": surgeryElective,
        "surgery_elective_date": surgeryElectiveDate,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsValues {
  int? id;
  int? burnsId;
  int? woundManagement;
  bool? woundManagementConservative;
  int? conservative;
  bool? hyperBaric;
  int? hyperBaricNos;
  String? othConservative;
  int? surgeryEmergency;
  bool? isSurgeryEmergency;
  String? surgeryPerformedDate;

  // "is_surgery_elective_performed": true,
  bool? isSurgeryElectivePerformed;
  List<int>? supportiveMeasures;
  List<int>? complicationsHospitalStay;
  List<int>? multidisciplinarySupport;
  String? othMultidisciplinarySupport;
  bool? skinBankAvailable;
  String? skinBankAvailableValue;

  BurnsValues({
    this.id,
    this.burnsId,
    this.woundManagement,
    this.woundManagementConservative,
    this.conservative,
    this.hyperBaric,
    this.hyperBaricNos,
    this.othConservative,
    this.surgeryEmergency,
    this.isSurgeryEmergency,
    this.isSurgeryElectivePerformed,
    this.surgeryPerformedDate,
    this.supportiveMeasures,
    this.complicationsHospitalStay,
    this.multidisciplinarySupport,
    this.othMultidisciplinarySupport,
    this.skinBankAvailable,
    this.skinBankAvailableValue,
  });

  factory BurnsValues.fromJson(Map<String, dynamic> json) => BurnsValues(
        id: json["id"],
        burnsId: json["burns_id"],
        woundManagement: json["wound_management"],
        woundManagementConservative: json["wound_management_conservative"],
        conservative: json["conservative"],
        hyperBaric: json["hyper_baric"],
        hyperBaricNos: json["hyper_baric_nos"],
        othConservative: json["oth_conservative"],
        surgeryEmergency: json["surgery_emergency"],
        isSurgeryEmergency: json["is_surgery_emergency"],
        surgeryPerformedDate: json["surgery_performed_date"],
        isSurgeryElectivePerformed: json["is_surgery_elective_performed"],
        supportiveMeasures: json["supportive_measures"] == null
            ? []
            : List<int>.from(json["supportive_measures"]!.map((x) => x)),
        complicationsHospitalStay: json["complications_hospital_stay"] == null
            ? []
            : List<int>.from(
                json["complications_hospital_stay"]!.map((x) => x)),
        multidisciplinarySupport: json["multidisciplinary_support"] == null
            ? []
            : List<int>.from(json["multidisciplinary_support"]!.map((x) => x)),
        othMultidisciplinarySupport: json["oth_multidisciplinary_support"],
        skinBankAvailable: json["skin_bank_available"],
        skinBankAvailableValue: json["skin_bank_available_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "burns_id": burnsId,
        "wound_management": woundManagement,
        "wound_management_conservative": woundManagementConservative,
        "conservative": conservative,
        "hyper_baric": hyperBaric,
        "hyper_baric_nos": hyperBaricNos,
        "oth_conservative": othConservative,
        "surgery_emergency": surgeryEmergency,
        "is_surgery_emergency": isSurgeryEmergency,
        "surgery_performed_date": surgeryPerformedDate,
        "is_surgery_elective_performed": isSurgeryElectivePerformed,
        "supportive_measures": supportiveMeasures == null
            ? []
            : List<dynamic>.from(supportiveMeasures!.map((x) => x)),
        "complications_hospital_stay": complicationsHospitalStay == null
            ? []
            : List<dynamic>.from(complicationsHospitalStay!.map((x) => x)),
        "multidisciplinary_support": multidisciplinarySupport == null
            ? []
            : List<dynamic>.from(multidisciplinarySupport!.map((x) => x)),
        "oth_multidisciplinary_support": othMultidisciplinarySupport,
        "skin_bank_available": skinBankAvailable,
        "skin_bank_available_value": skinBankAvailableValue,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class BurnsTbsa {
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

  BurnsTbsa({
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

  factory BurnsTbsa.fromJson(Map<String, dynamic> json) => BurnsTbsa(
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

extension BurnsModelClean on BurnsModel {
  /// Returns a clean JSON without any IDs
  Map<String, dynamic> toCleanJson() {
    final data = toJson();

    // Remove unwanted ids
    if (data['burns'] != null) {
      data['burns'].remove('id');
    }
    if (data['burns_values'] != null) {
      data['burns_values'].remove('id');
      data['burns_values'].remove('burns_id');
    }
    if (data['burns_outcome'] != null) {
      data['burns_outcome'].remove('id');
      data['burns_outcome'].remove('burns_id');
    }
    if (data['burns_tbsa'] != null) {
      data['burns_tbsa'].remove('id');
      data['burns_tbsa'].remove('burns_id');
    }
    // if (data['burns_surgery_elective'] != null) {
    //   data['burns_surgery_elective'].remove('id');
    //   data['burns_surgery_elective'].remove('burns_id');
    // }

    // burns_surgery_elective is a LIST, so loop
    if (data['burns_surgery_elective'] != null) {
      for (var item in data['burns_surgery_elective']) {
        if (item is Map<String, dynamic>) {
          item.remove('id');
          item.remove('burns_id');
          item.remove('surgery_elective');
          item.remove('surgery_elective_date');
        }
      }
    }

    return data;
  }
}
