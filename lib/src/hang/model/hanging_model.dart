// To parse this JSON data, do
//
//     final hangingModel = hangingModelFromJson(jsonString);

import 'dart:convert';

HangingModel hangingModelFromJson(String str) =>
    HangingModel.fromJson(json.decode(str));

String hangingModelToJson(HangingModel data) => json.encode(data.toJson());

class HangingModel {
  Hanging? hanging;
  Outcome? outcome;

  HangingModel({
    this.hanging,
    this.outcome,
  });

  factory HangingModel.fromJson(Map<String, dynamic> json) => HangingModel(
        hanging:
            json["hanging"] == null ? null : Hanging.fromJson(json["hanging"]),
        outcome:
            json["outcome"] == null ? null : Outcome.fromJson(json["outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "hanging": hanging?.toJson(),
        "outcome": outcome?.toJson(),
      };
}

class Hanging {
  int? triageId;
  String? dateTimeOfEntry;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  int? natureOfIncident;
  int? suspensionOfBody;
  int? materialsUsedForHanging;
  List<int>? symptomsAtPresentation;
  int? interventions;
  String? othInterventions;
  int? supportiveCareProvided;
  bool? isCounsellingProvided;
  int? durationOfHospitalStay;
  int? id;
  String? othSupportiveCareProvided;

  Hanging(
      {this.triageId,
      this.dateTimeOfEntry,
      this.patientAdmitted,
      this.nameOfDept,
      this.dateOfAdmit,
      this.natureOfIncident,
      this.suspensionOfBody,
      this.materialsUsedForHanging,
      this.symptomsAtPresentation,
      this.interventions,
      this.othInterventions,
      this.supportiveCareProvided,
      this.isCounsellingProvided,
      this.durationOfHospitalStay,
      this.othSupportiveCareProvided,
      this.id});

  factory Hanging.fromJson(Map<String, dynamic> json) => Hanging(
        triageId: json["triage_id"],
        id: json["id"],
        othSupportiveCareProvided: json["oth_supportive_care_provided"],
        dateTimeOfEntry: json["date_time_of_entry"],
        patientAdmitted: json["patient_admitted"],
        nameOfDept: json["name_of_dept"],
        dateOfAdmit: json["date_of_admit"],
        natureOfIncident: json["nature_of_incident"],
        suspensionOfBody: json["suspension_of_body"],
        materialsUsedForHanging: json["materials_used_for_hanging"],
        symptomsAtPresentation: json["symptoms_at_presentation"] == null
            ? []
            : List<int>.from(json["symptoms_at_presentation"]!.map((x) => x)),
        interventions: json["interventions"],
        othInterventions: json["oth_interventions"],
        supportiveCareProvided: json["supportive_care_provided"],
        isCounsellingProvided: json["is_counselling_provided"],
        durationOfHospitalStay: json["duration_of_hospital_stay"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "date_time_of_entry": dateTimeOfEntry,
        "patient_admitted": patientAdmitted,
        "name_of_dept": nameOfDept,
        "date_of_admit": dateOfAdmit,
        "nature_of_incident": natureOfIncident,
        "suspension_of_body": suspensionOfBody,
        "materials_used_for_hanging": materialsUsedForHanging,
        "symptoms_at_presentation": symptomsAtPresentation == null
            ? []
            : List<dynamic>.from(symptomsAtPresentation!.map((x) => x)),
        "interventions": interventions,
        "oth_interventions": othInterventions,
        "supportive_care_provided": supportiveCareProvided,
        "is_counselling_provided": isCounsellingProvided,
        "duration_of_hospital_stay": durationOfHospitalStay,
        "id": id,
        "oth_supportive_care_provided": othSupportiveCareProvided
      };
}

class Outcome {
  int? outcome;
  String? dischargeDate;
  String? abscondedDate;
  String? deathDate;
  dynamic causeOfDeath;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctor;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTaeiHospital;
  bool? documentedTaeiSheet;
  bool? isDischarged;

  Outcome({
    this.outcome,
    this.dischargeDate,
    this.abscondedDate,
    this.deathDate,
    this.causeOfDeath,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.documentedTaeiSheet,
    this.isDischarged,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
        outcome: json["outcome"],
        dischargeDate: json["discharge_date"],
        abscondedDate: json["absconded_date"],
        deathDate: json["death_date"],
        causeOfDeath: json["cause_of_death"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctor: json["referring_doctor"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        isDischarged: json["is_discharged"],
      );

  Map<String, dynamic> toJson() => {
        "outcome": outcome,
        "discharge_date": dischargeDate,
        "absconded_date": abscondedDate,
        "death_date": deathDate,
        "cause_of_death": causeOfDeath,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor": referringDoctor,
        "documented_taei_sheet": documentedTaeiSheet,
        "is_discharged": isDischarged,
      };
}
