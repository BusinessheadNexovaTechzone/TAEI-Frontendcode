// To parse this JSON data, do
//
//     final poisoningModel = poisoningModelFromJson(jsonString);

import 'dart:convert';

PoisoningModel poisoningModelFromJson(String str) =>
    PoisoningModel.fromJson(json.decode(str));

String poisoningModelToJson(PoisoningModel data) => json.encode(data.toJson());

class PoisoningModel {
  Poison? poison;
  PoisonsOutcome? poisonsOutcome;

  PoisoningModel({
    this.poison,
    this.poisonsOutcome,
  });

  factory PoisoningModel.fromJson(Map<String, dynamic> json) => PoisoningModel(
        poison: json["poison"] == null ? null : Poison.fromJson(json["poison"]),
        poisonsOutcome: json["poisons_outcome"] == null
            ? null
            : PoisonsOutcome.fromJson(json["poisons_outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "poison": poison?.toJson(),
        "poisons_outcome": poisonsOutcome?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Poison {
  int? id;
  int? triageId;
  String? dateTimeOfEntry;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  int? typeOfPoisoning;
  int? routeOfExposure;
  int? substanceInvolved;
  int? substanceInvolvedSub;
  String? othSubstanceInvolved;
  String? brandOrProductName;
  String? quantity;
  int? sourceOfSubstance;
  List<int>? symptomsAtPresentation;
  String? timeOfOnsetOfSymptoms;
  String? timeElapsedExposureSymptom;
  String? investigationsPerformed;
  int? severityOfPoisoning;
  List<int>? decontamination;
  String? antidoteAdministeredName;
  String? antidoteAdministeredDosage;
  String? antidoteAdministeredTiming;
  List<int>? supportiveCareProvided;
  int? noOfCyclesPerformed;
  bool? counsellingProvided;
  int? durationOfHospitalStay;

  //ref_id
  //ref_form_id
  int? refId;
  int? refFormId;

  Poison({
    this.id,
    this.triageId,
    this.dateTimeOfEntry,
    this.patientAdmitted,
    this.nameOfDept,
    this.dateOfAdmit,
    this.typeOfPoisoning,
    this.routeOfExposure,
    this.substanceInvolved,
    this.substanceInvolvedSub,
    this.othSubstanceInvolved,
    this.brandOrProductName,
    this.quantity,
    this.sourceOfSubstance,
    this.symptomsAtPresentation,
    this.timeOfOnsetOfSymptoms,
    this.timeElapsedExposureSymptom,
    this.investigationsPerformed,
    this.severityOfPoisoning,
    this.decontamination,
    this.antidoteAdministeredName,
    this.antidoteAdministeredDosage,
    this.antidoteAdministeredTiming,
    this.supportiveCareProvided,
    this.noOfCyclesPerformed,
    this.counsellingProvided,
    this.durationOfHospitalStay,
    this.refId,
    this.refFormId,
  });

  factory Poison.fromJson(Map<String, dynamic> json) => Poison(
        id: json["id"],
        triageId: json["triage_id"],
        dateTimeOfEntry: json["date_time_of_entry"],
        patientAdmitted: json["patient_admitted"],
        nameOfDept: json["name_of_dept"],
        dateOfAdmit: json["date_of_admit"],
        typeOfPoisoning: json["type_of_poisoning"],
        routeOfExposure: json["route_of_exposure"],
        substanceInvolved: json["substance_involved"],
        substanceInvolvedSub: json["substance_involved_sub"],
        othSubstanceInvolved: json["oth_substance_involved"],
        brandOrProductName: json["brand_or_product_name"],
        quantity: json["quantity"],
        sourceOfSubstance: json["source_of_substance"],
        symptomsAtPresentation: json["symptoms_at_presentation"] == null
            ? []
            : List<int>.from(json["symptoms_at_presentation"]!.map((x) => x)),
        timeOfOnsetOfSymptoms: json["time_of_onset_of_symptoms"],
        timeElapsedExposureSymptom: json["time_elapsed_exposure_symptom"],
        investigationsPerformed: json["investigations_performed"],
        severityOfPoisoning: json["severity_of_poisoning"],
        decontamination: json["decontamination"] == null
            ? []
            : List<int>.from(json["decontamination"]!.map((x) => x)),
        antidoteAdministeredName: json["antidote_administered_name"],
        antidoteAdministeredDosage: json["antidote_administered_dosage"],
        antidoteAdministeredTiming: json["antidote_administered_timing"],
        supportiveCareProvided: json["supportive_care_provided"] == null
            ? []
            : List<int>.from(json["supportive_care_provided"]!.map((x) => x)),
        noOfCyclesPerformed: json["no_of_cycles_performed"],
        counsellingProvided: json["counselling_provided"],
        durationOfHospitalStay: json["duration_of_hospital_stay"],
        refId: json["ref_id"],
        refFormId: json["ref_form_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "triage_id": triageId,
        "date_time_of_entry": dateTimeOfEntry,
        "patient_admitted": patientAdmitted,
        "name_of_dept": nameOfDept,
        "date_of_admit": dateOfAdmit,
        "type_of_poisoning": typeOfPoisoning,
        "route_of_exposure": routeOfExposure,
        "substance_involved": substanceInvolved,
        "substance_involved_sub": substanceInvolvedSub,
        "oth_substance_involved": othSubstanceInvolved,
        "brand_or_product_name": brandOrProductName,
        "quantity": quantity,
        "source_of_substance": sourceOfSubstance,
        "symptoms_at_presentation": symptomsAtPresentation == null
            ? []
            : List<dynamic>.from(symptomsAtPresentation!.map((x) => x)),
        "time_of_onset_of_symptoms": timeOfOnsetOfSymptoms,
        "time_elapsed_exposure_symptom": timeElapsedExposureSymptom,
        "investigations_performed": investigationsPerformed,
        "severity_of_poisoning": severityOfPoisoning,
        "decontamination": decontamination == null
            ? []
            : List<dynamic>.from(decontamination!.map((x) => x)),
        "antidote_administered_name": antidoteAdministeredName,
        "antidote_administered_dosage": antidoteAdministeredDosage,
        "antidote_administered_timing": antidoteAdministeredTiming,
        "supportive_care_provided": supportiveCareProvided == null
            ? []
            : List<dynamic>.from(supportiveCareProvided!.map((x) => x)),
        "no_of_cycles_performed": noOfCyclesPerformed,
        "counselling_provided": counsellingProvided,
        "duration_of_hospital_stay": durationOfHospitalStay,
        "ref_id": refId,
        "ref_form_id": refFormId,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class PoisonsOutcome {
  int? id;
  int? poisonId;
  int? outcome;
  String? dischargeDate;
  dynamic abscondedDate;
  dynamic deathDate;
  dynamic causeOfDeath;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTAEIHospital;
  int? reasonForReferral;
  int? conditionOfPatient;

  String? othReasonForReferral;

  dynamic referringDoctor;
  dynamic documentedTaeiSheet;
  String? patientExitDate;
  bool? isDischarged;

  PoisonsOutcome({
    this.id,
    this.poisonId,
    this.outcome,
    this.dischargeDate,
    this.abscondedDate,
    this.deathDate,
    this.causeOfDeath,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTAEIHospital,
    this.reasonForReferral,
    this.othReasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.documentedTaeiSheet,
    this.patientExitDate,
    this.isDischarged,
  });

  factory PoisonsOutcome.fromJson(Map<String, dynamic> json) => PoisonsOutcome(
        id: json["id"],
        poisonId: json["poison_id"],
        outcome: json["outcome"],
        dischargeDate: json["discharge_date"],
        abscondedDate: json["absconded_date"],
        deathDate: json["death_date"],
        causeOfDeath: json["cause_of_death"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTAEIHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        othReasonForReferral: json["oth_reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctor: json["referring_doctor"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        patientExitDate: json["patient_exit_date"],
        isDischarged: json["is_discharged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poison_id": poisonId,
        "outcome": outcome,
        "discharge_date": dischargeDate,
        "absconded_date": abscondedDate,
        "death_date": deathDate,
        "cause_of_death": causeOfDeath,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTAEIHospital,
        "reason_for_referral": reasonForReferral,
        "oth_reason_for_referral": othReasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor": referringDoctor,
        "documented_taei_sheet": documentedTaeiSheet,
        "patient_exit_date": patientExitDate,
        "is_discharged": isDischarged,
      };

  @override
  String toString() => jsonEncode(toJson());
}

extension PoisonModelClean on PoisoningModel {
  Map<String, dynamic> toCleanJson() {
    final data = toJson();
    if (data['poison'] != null) {
      data['poison'].remove('id');
    }
    if (data['poisons_outcome'] != null) {
      data['poisons_outcome'].remove('id');
      data['poisons_outcome'].remove('poison_id');
    }
    return data;
  }
}
