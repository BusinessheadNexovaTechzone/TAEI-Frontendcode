// To parse this JSON data, do
//
//     final drowningModel = drowningModelFromJson(jsonString);

import 'dart:convert';

DrowningModel drowningModelFromJson(String str) =>
    DrowningModel.fromJson(json.decode(str));

String drowningModelToJson(DrowningModel data) => json.encode(data.toJson());

class DrowningModel {
  DrowningCases? drowningCases;
  DrowningOutcome? drowningOutcome;

  DrowningModel({
    this.drowningCases,
    this.drowningOutcome,
  });

  factory DrowningModel.fromJson(Map<String, dynamic> json) => DrowningModel(
        drowningCases: json["drowning_cases"] == null
            ? null
            : DrowningCases.fromJson(json["drowning_cases"]),
        drowningOutcome: json["drowning_outcome"] == null
            ? null
            : DrowningOutcome.fromJson(json["drowning_outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "drowning_cases": drowningCases?.toJson(),
        "drowning_outcome": drowningOutcome?.toJson(),
      };
}

class DrowningCases {
  int? triageId;
  int? id;
  String? dateTimeEntry;
  int? patientAdmittedId;
  String? admittingDepartment;
  String? admissionDatetime;
  int? placeOfIncidentId;
  String? otherPlace;
  int? typeOfWaterId;
  String? otherTypeWater;
  int? activityDuringDrowningId;
  String? otherActivity;
  int? assessmentId;
  int? interventionId;
  String? otherInterventions;
  int? counsellingBeforeDischargeId;
  String? dischargeDatetime;
  int? durationOfHospitalStay;
  String? complicationsAdmission;
  String? otherComplicationAdmitted;
  String? supportiveCare;
  String? otherSupportiveCare;
  String? complicationsDeveloped;
  String? otherComplicationsDeveloped;

  DrowningCases(
      {this.triageId,
      this.dateTimeEntry,
      this.patientAdmittedId,
      this.admittingDepartment,
      this.admissionDatetime,
      this.placeOfIncidentId,
      this.otherPlace,
      this.typeOfWaterId,
      this.otherTypeWater,
      this.activityDuringDrowningId,
      this.otherActivity,
      this.assessmentId,
      this.interventionId,
      this.otherInterventions,
      this.counsellingBeforeDischargeId,
      this.dischargeDatetime,
      this.durationOfHospitalStay,
      this.complicationsAdmission,
      this.otherComplicationAdmitted,
      this.supportiveCare,
      this.otherSupportiveCare,
      this.complicationsDeveloped,
      this.otherComplicationsDeveloped,
      this.id});

  factory DrowningCases.fromJson(Map<String, dynamic> json) => DrowningCases(
        triageId: json["triage_id"],
        id: json["id"],
        dateTimeEntry: json["date_time_entry"],
        patientAdmittedId: json["patient_admitted_id"],
        admittingDepartment: json["admitting_department"],
        admissionDatetime: json["admission_datetime"],
        placeOfIncidentId: json["place_of_incident_id"],
        otherPlace: json["other_place"],
        typeOfWaterId: json["type_of_water_id"],
        otherTypeWater: json["other_type_water"],
        activityDuringDrowningId: json["activity_during_drowning_id"],
        otherActivity: json["other_activity"],
        assessmentId: json["assessment_id"],
        interventionId: json["intervention_id"],
        otherInterventions: json["other_interventions"],
        counsellingBeforeDischargeId: json["counselling_before_discharge_id"],
        dischargeDatetime: json["discharge_datetime"],
        durationOfHospitalStay: json["duration_of_hospital_stay"],
        complicationsAdmission: json["complications_admission"],
        otherComplicationAdmitted: json["other_complication_admitted"],
        supportiveCare: json["supportive_care"],
        otherSupportiveCare: json["other_supportive_care"],
        complicationsDeveloped: json["complications_developed"],
        otherComplicationsDeveloped: json["other_complications_developed"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "date_time_entry": dateTimeEntry,
        "patient_admitted_id": patientAdmittedId,
        "admitting_department": admittingDepartment,
        "admission_datetime": admissionDatetime,
        "place_of_incident_id": placeOfIncidentId,
        "other_place": otherPlace,
        "type_of_water_id": typeOfWaterId,
        "other_type_water": otherTypeWater,
        "activity_during_drowning_id": activityDuringDrowningId,
        "other_activity": otherActivity,
        "assessment_id": assessmentId,
        "intervention_id": interventionId,
        "other_interventions": otherInterventions,
        "counselling_before_discharge_id": counsellingBeforeDischargeId,
        "discharge_datetime": dischargeDatetime,
        "duration_of_hospital_stay": durationOfHospitalStay,
        "complications_admission": complicationsAdmission,
        "other_complication_admitted": otherComplicationAdmitted,
        "supportive_care": supportiveCare,
        "other_supportive_care": otherSupportiveCare,
        "complications_developed": complicationsDeveloped,
        "other_complications_developed": otherComplicationsDeveloped,
        "id": id
      };
}

class DrowningOutcome {
  int? triageId;
  int? id;
  int? outcomeTypeId;
  String? dischargeDatetime;
  dynamic abscondedDatetime;
  dynamic deathDatetime;
  String? causeOfDeath;
  int? hospitalTypeId;
  String? destinationHospital;
  int? destinationTaeiHospital;
  int? referralReasonId;
  String? otherReasonReferral;
  int? patientConditionId;
  String? referringDoctor;
  bool? documentedInTaeiCaseSheet;
  bool?is_discharged;

  DrowningOutcome(
      {this.triageId,
      this.outcomeTypeId,
      this.dischargeDatetime,
      this.abscondedDatetime,
      this.deathDatetime,
      this.causeOfDeath,
      this.hospitalTypeId,
      this.destinationHospital,
      this.destinationTaeiHospital,
      this.referralReasonId,
      this.otherReasonReferral,
      this.patientConditionId,
      this.referringDoctor,
      this.documentedInTaeiCaseSheet,
        this.is_discharged,
      this.id});

  factory DrowningOutcome.fromJson(Map<String, dynamic> json) =>
      DrowningOutcome(
        triageId: json["triage_id"],
        id: json["id"],
        outcomeTypeId: json["outcome_type_id"],
        dischargeDatetime: json["discharge_datetime"],
        abscondedDatetime: json["absconded_datetime"],
        deathDatetime: json["death_datetime"],
        causeOfDeath: json["cause_of_death"],
        hospitalTypeId: json["hospital_type_id"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        referralReasonId: json["referral_reason_id"],
        otherReasonReferral: json["other_reason_referral"],
        patientConditionId: json["patient_condition_id"],
        referringDoctor: json["referring_doctor"],
        documentedInTaeiCaseSheet: json["documented_in_taei_case_sheet"],
          is_discharged:json['is_discharged']
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "outcome_type_id": outcomeTypeId,
        "discharge_datetime": dischargeDatetime,
        "absconded_datetime": abscondedDatetime,
        "death_datetime": deathDatetime,
        "cause_of_death": causeOfDeath,
        "hospital_type_id": hospitalTypeId,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "referral_reason_id": referralReasonId,
        "other_reason_referral": otherReasonReferral,
        "patient_condition_id": patientConditionId,
        "referring_doctor": referringDoctor,
        "is_discharged":is_discharged,
        "documented_in_taei_case_sheet": documentedInTaeiCaseSheet,
        "id": id
      };
}
