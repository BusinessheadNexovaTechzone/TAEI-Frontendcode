

import 'dart:convert';

NonIndexDrowningDataModel drowningNonIndex(String str) =>
    NonIndexDrowningDataModel.fromJson(json.decode(str));


class NonIndexDrowningDataModel {
  final Drowning? drowning;

  NonIndexDrowningDataModel({
    this.drowning,
  });

  factory NonIndexDrowningDataModel.fromJson(Map<String, dynamic> json) {
    return NonIndexDrowningDataModel(
      drowning: json['drowning'] != null
          ? Drowning.fromJson(json['drowning'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drowning': drowning?.toJson(),
    };
  }
}

// ---
// Nested Class for Drowning Event
// ---

class Drowning {
  final CaseDetails? caseDetails;
  final Outcome? outcome;

  Drowning({
    this.caseDetails,
    this.outcome,
  });

  factory Drowning.fromJson(Map<String, dynamic> json) {
    return Drowning(
      caseDetails: json['case_details'] != null
          ? CaseDetails.fromJson(json['case_details'] as Map<String, dynamic>)
          : null,
      outcome: json['outcome'] != null
          ? Outcome.fromJson(json['outcome'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'case_details': caseDetails?.toJson(),
      'outcome': outcome?.toJson(),
    };
  }
}

// ---
// Nested Class for Case Details
// ---

class CaseDetails {
  final int? id;
  final int? triageId;
  final String? dateTimeEntry;
  final String? patientAdmitted;
  final String? admittingDepartment;
  final String? admissionDatetime;
  final String? placeOfIncident;
  final String? otherPlace;
  final String? typeOfWater;
  final String? otherTypeOfWater;
  final String? activityDuringDrowning;
  final String? otherActivity;
  final String? assessment;
  final String? intervention;
  final String? otherInterventions;
  final String? supportiveCare;
  final String? otherSupportiveCare;
  final String? complicationsAdmission;
  final String? otherComplicationAdmitted;
  final String? complicationsDeveloped;
  final String? otherComplicationsDeveloped;
  final String? counsellingBeforeDischarge;
  final String? dischargeDatetime;
  final String? durationOfHospitalStay;

  CaseDetails({
    this.id,
    this.triageId,
    this.dateTimeEntry,
    this.patientAdmitted,
    this.admittingDepartment,
    this.admissionDatetime,
    this.placeOfIncident,
    this.otherPlace,
    this.typeOfWater,
    this.otherTypeOfWater,
    this.activityDuringDrowning,
    this.otherActivity,
    this.assessment,
    this.intervention,
    this.otherInterventions,
    this.supportiveCare,
    this.otherSupportiveCare,
    this.complicationsAdmission,
    this.otherComplicationAdmitted,
    this.complicationsDeveloped,
    this.otherComplicationsDeveloped,
    this.counsellingBeforeDischarge,
    this.dischargeDatetime,
    this.durationOfHospitalStay,
  });

  factory CaseDetails.fromJson(Map<String, dynamic> json) {
    return CaseDetails(
      id: json['id'] as int?,
      triageId: json['triage_id'] as int?,
      dateTimeEntry: json['date_time_entry'] as String?,
      patientAdmitted: json['patient_admitted'] as String?,
      admittingDepartment: json['admitting_department'] as String?,
      admissionDatetime: json['admission_datetime'] as String?,
      placeOfIncident: json['place_of_incident'] as String?,
      otherPlace: json['other_place'] as String?,
      typeOfWater: json['type_of_water'] as String?,
      otherTypeOfWater: json['other_type_of_water'] as String?,
      activityDuringDrowning: json['activity_during_drowning'] as String?,
      otherActivity: json['other_activity'] as String?,
      assessment: json['assessment'] as String?,
      intervention: json['intervention'] as String?,
      otherInterventions: json['other_interventions'] as String?,
      supportiveCare: json['supportive_care'] as String?,
      otherSupportiveCare: json['other_supportive_care'] as String?,
      complicationsAdmission: json['complications_admission'] as String?,
      otherComplicationAdmitted:
      json['other_complication_admitted'] as String?,
      complicationsDeveloped: json['complications_developed'] as String?,
      otherComplicationsDeveloped:
      json['other_complications_developed'] as String?,
      counsellingBeforeDischarge:
      json['counselling_before_discharge'] as String?,
      dischargeDatetime: json['discharge_datetime'] as String?,
      durationOfHospitalStay: json['duration_of_hospital_stay'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'triage_id': triageId,
      'date_time_entry': dateTimeEntry,
      'patient_admitted': patientAdmitted,
      'admitting_department': admittingDepartment,
      'admission_datetime': admissionDatetime,
      'place_of_incident': placeOfIncident,
      'other_place': otherPlace,
      'type_of_water': typeOfWater,
      'other_type_of_water': otherTypeOfWater,
      'activity_during_drowning': activityDuringDrowning,
      'other_activity': otherActivity,
      'assessment': assessment,
      'intervention': intervention,
      'other_interventions': otherInterventions,
      'supportive_care': supportiveCare,
      'other_supportive_care': otherSupportiveCare,
      'complications_admission': complicationsAdmission,
      'other_complication_admitted': otherComplicationAdmitted,
      'complications_developed': complicationsDeveloped,
      'other_complications_developed': otherComplicationsDeveloped,
      'counselling_before_discharge': counsellingBeforeDischarge,
      'discharge_datetime': dischargeDatetime,
      'duration_of_hospital_stay': durationOfHospitalStay,
    };
  }
}

// ---
// Nested Class for Outcome
// ---

class Outcome {
  final int? id;
  final String? outcomeType;
  final String? isDischarged;
  final String? dischargeDatetime;
  final String? abscondedDatetime;
  final String? deathDatetime;
  final String? causeOfDeath;
  final String? hospitalType;
  final String? destinationHospital;
  final String? referralReason;
  final String? otherReasonReferral;
  final String? patientCondition;
  final String? referringDoctor;
  final String? documentedInTaeiCaseSheet;
  final String? createdAt;
  final String? updatedAt;

  Outcome({
    this.id,
    this.outcomeType,
    this.isDischarged,
    this.dischargeDatetime,
    this.abscondedDatetime,
    this.deathDatetime,
    this.causeOfDeath,
    this.hospitalType,
    this.destinationHospital,
    this.referralReason,
    this.otherReasonReferral,
    this.patientCondition,
    this.referringDoctor,
    this.documentedInTaeiCaseSheet,
    this.createdAt,
    this.updatedAt,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      id: json['id'] as int?,
      outcomeType: json['outcome_type'] as String?,
      isDischarged: json['is_discharged'] as String?,
      dischargeDatetime: json['discharge_datetime'] as String?,
      abscondedDatetime: json['absconded_datetime'] as String?,
      deathDatetime: json['death_datetime'] as String?,
      causeOfDeath: json['cause_of_death'] as String?,
      hospitalType: json['hospital_type'] as String?,
      destinationHospital: json['destination_hospital'] as String?,
      referralReason: json['referral_reason'] as String?,
      otherReasonReferral: json['other_reason_referral'] as String?,
      patientCondition: json['patient_condition'] as String?,
      referringDoctor: json['referring_doctor'] as String?,
      documentedInTaeiCaseSheet:
      json['documented_in_taei_case_sheet'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outcome_type': outcomeType,
      'is_discharged': isDischarged,
      'discharge_datetime': dischargeDatetime,
      'absconded_datetime': abscondedDatetime,
      'death_datetime': deathDatetime,
      'cause_of_death': causeOfDeath,
      'hospital_type': hospitalType,
      'destination_hospital': destinationHospital,
      'referral_reason': referralReason,
      'other_reason_referral': otherReasonReferral,
      'patient_condition': patientCondition,
      'referring_doctor': referringDoctor,
      'documented_in_taei_case_sheet': documentedInTaeiCaseSheet,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}