// To parse this JSON data, do
//
//     final poisoningListModel = poisoningListModelFromJson(jsonString);

import 'dart:convert';

PoisoningDetailsModel poisoningListModelFromJson(String str) =>
    PoisoningDetailsModel.fromJson(json.decode(str));

String poisoningListModelToJson(PoisoningDetailsModel data) =>
    json.encode(data.toJson());

class PoisoningDetailsModel {
  PoisonsDetails? poisons;
  PoisonsOutcomeDetails? poisonsOutcome;

  PoisoningDetailsModel({
    this.poisons,
    this.poisonsOutcome,
  });

  factory PoisoningDetailsModel.fromJson(Map<String, dynamic> json) =>
      PoisoningDetailsModel(
        poisons: json["poisons"] == null
            ? null
            : PoisonsDetails.fromJson(json["poisons"]),
        poisonsOutcome: json["poisons_outcome"] == null
            ? null
            : PoisonsOutcomeDetails.fromJson(json["poisons_outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "poisons": poisons?.toJson(),
        "poisons_outcome": poisonsOutcome?.toJson(),
      };
}

class PoisonsDetails {
  int? id;
  int? triageId;
  dynamic dateTimeOfEntry;
  String? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  String? typeOfPoisoning;
  String? routeOfExposure;
  String? substanceInvolved;
  String? substanceInvolvedSub;
  dynamic othSubstanceInvolved;
  String? brandOrProductName;
  String? quantity;
  String? sourceOfSubstance;
  String? symptomsAtPresentation;
  String? timeOfOnsetOfSymptoms;
  String? timeElapsedExposureSymptom;
  String? investigationsPerformed;
  String? severityOfPoisoning;
  dynamic decontamination;
  String? antidoteAdministeredName;
  String? antidoteAdministeredDosage;
  String? antidoteAdministeredTiming;
  String? supportiveCareProvided;
  dynamic noOfCyclesPerformed;
  String? counsellingProvided;
  int? durationOfHospitalStay;
  int? userId;
  String? insertedDate;
  dynamic refFormId;
  dynamic refId;

  PoisonsDetails({
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
    this.userId,
    this.insertedDate,
    this.refFormId,
    this.refId,
  });

  factory PoisonsDetails.fromJson(Map<String, dynamic> json) => PoisonsDetails(
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
        symptomsAtPresentation: json["symptoms_at_presentation"],
        timeOfOnsetOfSymptoms: json["time_of_onset_of_symptoms"],
        timeElapsedExposureSymptom: json["time_elapsed_exposure_symptom"],
        investigationsPerformed: json["investigations_performed"],
        severityOfPoisoning: json["severity_of_poisoning"],
        decontamination: json["decontamination"],
        antidoteAdministeredName: json["antidote_administered_name"],
        antidoteAdministeredDosage: json["antidote_administered_dosage"],
        antidoteAdministeredTiming: json["antidote_administered_timing"],
        supportiveCareProvided: json["supportive_care_provided"],
        noOfCyclesPerformed: json["no_of_cycles_performed"],
        counsellingProvided: json["counselling_provided"],
        durationOfHospitalStay: json["duration_of_hospital_stay"],
        userId: json["user_id"],
        insertedDate: json["inserted_date"],
        refFormId: json["ref_form_id"],
        refId: json["ref_id"],
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
        "symptoms_at_presentation": symptomsAtPresentation,
        "time_of_onset_of_symptoms": timeOfOnsetOfSymptoms,
        "time_elapsed_exposure_symptom": timeElapsedExposureSymptom,
        "investigations_performed": investigationsPerformed,
        "severity_of_poisoning": severityOfPoisoning,
        "decontamination": decontamination,
        "antidote_administered_name": antidoteAdministeredName,
        "antidote_administered_dosage": antidoteAdministeredDosage,
        "antidote_administered_timing": antidoteAdministeredTiming,
        "supportive_care_provided": supportiveCareProvided,
        "no_of_cycles_performed": noOfCyclesPerformed,
        "counselling_provided": counsellingProvided,
        "duration_of_hospital_stay": durationOfHospitalStay,
        "user_id": userId,
        "inserted_date": insertedDate,
        "ref_form_id": refFormId,
        "ref_id": refId,
      };
}

class PoisonsOutcomeDetails {
  int? id;
  String? outcome;
  String? dischargeDate;
  dynamic abscondedDate;
  dynamic deathDate;
  dynamic causeOfDeath;
  dynamic hospitalType;
  dynamic destinationHospital;
  dynamic destinationTaeiHospital;
  dynamic reasonForReferral;
  dynamic othReasonForReferral;
  dynamic conditionOfPatient;
  dynamic referringDoctor;
  String? documentedTaeiSheet;
  dynamic patientExitDate;

  PoisonsOutcomeDetails({
    this.id,
    this.outcome,
    this.dischargeDate,
    this.abscondedDate,
    this.deathDate,
    this.causeOfDeath,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.othReasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.documentedTaeiSheet,
    this.patientExitDate,
  });

  factory PoisonsOutcomeDetails.fromJson(Map<String, dynamic> json) =>
      PoisonsOutcomeDetails(
        id: json["id"],
        outcome: json["outcome"],
        dischargeDate: json["discharge_date"],
        abscondedDate: json["absconded_date"],
        deathDate: json["death_date"],
        causeOfDeath: json["cause_of_death"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        othReasonForReferral: json["oth_reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctor: json["referring_doctor"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        patientExitDate: json["patient_exit_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "outcome": outcome,
        "discharge_date": dischargeDate,
        "absconded_date": abscondedDate,
        "death_date": deathDate,
        "cause_of_death": causeOfDeath,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "oth_reason_for_referral": othReasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor": referringDoctor,
        "documented_taei_sheet": documentedTaeiSheet,
        "patient_exit_date": patientExitDate,
      };
}
