import 'dart:convert';

HangingDetails hangingDetailsFromJson(String str) =>
    HangingDetails.fromJson(json.decode(str));

String hangingDetailsToJson(HangingDetails data) =>
    json.encode(data.toJson());


class HangingDetails {
  Hanging? hanging;
  Outcome? outcome;

  HangingDetails({this.hanging, this.outcome});

  HangingDetails.fromJson(Map<String, dynamic> json) {
    hanging = json['hanging'] != null
        ? Hanging.fromJson(json['hanging'])
        : null;
    outcome =
    json['outcome'] != null ? Outcome.fromJson(json['outcome']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (hanging != null) data['hanging'] = hanging!.toJson();
    if (outcome != null) data['outcome'] = outcome!.toJson();
    return data;
  }
}

class Hanging {
  int? id;
  int? triageId;
  String? dateTimeOfEntry;
  String? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  String? natureOfIncident;
  String? suspensionOfBody;
  String? materialsUsedForHanging;
  String? symptomsAtPresentation;
  String? interventions;
  String? othInterventions;
  String? supportiveCareProvided;
  String? othSupportiveCareProvided;
  String? isCounsellingProvided;
  int? durationOfHospitalStay;
  int? userId;
  String? insertedDate;
  int? refFormId;
  int? refId;

  Hanging({
    this.id,
    this.triageId,
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
    this.othSupportiveCareProvided,
    this.isCounsellingProvided,
    this.durationOfHospitalStay,
    this.userId,
    this.insertedDate,
    this.refFormId,
    this.refId,
  });

  Hanging.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    triageId = json['triage_id'] ?? 0;
    dateTimeOfEntry = json['date_time_of_entry'] ?? '';
    patientAdmitted = json['patient_admitted'] ?? '';
    nameOfDept = json['name_of_dept'] ?? '';
    dateOfAdmit = json['date_of_admit'] ?? '';
    natureOfIncident = json['nature_of_incident'] ?? '';
    suspensionOfBody = json['suspension_of_body'] ?? '';
    materialsUsedForHanging = json['materials_used_for_hanging'] ?? '';
    symptomsAtPresentation = json['symptoms_at_presentation'] ?? '';
    interventions = json['interventions'] ?? '';
    othInterventions = json['oth_interventions'] ?? '';
    supportiveCareProvided = json['supportive_care_provided'] ?? '';
    othSupportiveCareProvided = json['oth_supportive_care_provided'] ?? '';
    isCounsellingProvided = json['is_counselling_provided'] ?? '';
    durationOfHospitalStay = json['duration_of_hospital_stay'] ?? 0;
    userId = json['user_id'] ?? 0;
    insertedDate = json['inserted_date'] ?? '';
    refFormId = json['ref_form_id'];
    refId = json['ref_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['triage_id'] = triageId;
    data['date_time_of_entry'] = dateTimeOfEntry;
    data['patient_admitted'] = patientAdmitted;
    data['name_of_dept'] = nameOfDept;
    data['date_of_admit'] = dateOfAdmit;
    data['nature_of_incident'] = natureOfIncident;
    data['suspension_of_body'] = suspensionOfBody;
    data['materials_used_for_hanging'] = materialsUsedForHanging;
    data['symptoms_at_presentation'] = symptomsAtPresentation;
    data['interventions'] = interventions;
    data['oth_interventions'] = othInterventions;
    data['supportive_care_provided'] = supportiveCareProvided;
    data['oth_supportive_care_provided'] = othSupportiveCareProvided;
    data['is_counselling_provided'] = isCounsellingProvided;
    data['duration_of_hospital_stay'] = durationOfHospitalStay;
    data['user_id'] = userId;
    data['inserted_date'] = insertedDate;
    data['ref_form_id'] = refFormId;
    data['ref_id'] = refId;
    return data;
  }
}

class Outcome {
  int? id;
  String? outcome;
  String? dischargeDate;
  String? abscondedDate;
  String? deathDate;
  String? causeOfDeath;
  String? hospitalType;
  String? destinationHospital;
  String? destinationTaeiHospital;
  String? reasonForReferral;
  String? conditionOfPatient;
  String? referringDoctor;
  String? documentedTaeiSheet;

  Outcome({
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
    this.conditionOfPatient,
    this.referringDoctor,
    this.documentedTaeiSheet,
  });

  Outcome.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    outcome = json['outcome'] ?? '';
    dischargeDate = json['discharge_date'] ?? '';
    abscondedDate = json['absconded_date'];
    deathDate = json['death_date'];
    causeOfDeath = json['cause_of_death'];
    hospitalType = json['hospital_type'] ?? '';
    destinationHospital = json['destination_hospital'] ?? '';
    destinationTaeiHospital = json['destination_taei_hospital'] ?? '';
    reasonForReferral = json['reason_for_referral'] ?? '';
    conditionOfPatient = json['condition_of_patient'] ?? '';
    referringDoctor = json['referring_doctor'] ?? '';
    documentedTaeiSheet = json['documented_taei_sheet'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['outcome'] = outcome;
    data['discharge_date'] = dischargeDate;
    data['absconded_date'] = abscondedDate;
    data['death_date'] = deathDate;
    data['cause_of_death'] = causeOfDeath;
    data['hospital_type'] = hospitalType;
    data['destination_hospital'] = destinationHospital;
    data['destination_taei_hospital'] = destinationTaeiHospital;
    data['reason_for_referral'] = reasonForReferral;
    data['condition_of_patient'] = conditionOfPatient;
    data['referring_doctor'] = referringDoctor;
    data['documented_taei_sheet'] = documentedTaeiSheet;
    return data;
  }
}
