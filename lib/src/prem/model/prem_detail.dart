


import 'dart:convert';

PremDetails PremModelFromJson2(String str) =>
    PremDetails.fromJson(json.decode(str));


class PremDetails {
  Prem? prem;
  Vitals? vitals;
  Outcome? outcome;

  PremDetails({this.prem, this.vitals, this.outcome});

  PremDetails.fromJson(Map<String, dynamic> json) {
    prem = json['prem'] != null ? Prem.fromJson(json['prem']) : null;
    vitals = json['vitals'] != null ? Vitals.fromJson(json['vitals']) : null;
    outcome = json['outcome'] != null ? Outcome.fromJson(json['outcome']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (prem != null) data['prem'] = prem!.toJson();
    if (vitals != null) data['vitals'] = vitals!.toJson();
    if (outcome != null) data['outcome'] = outcome!.toJson();
    return data;
  }
}

class Prem {
  int? id;
  int? triageId;
  String? dateTimeOfEntry;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  bool? isPremCasesheetUsed;
  String? presentingComplaintsPrem;
  String? othPresentingComplaintsPrem;
  double? temperature;
  double? approxWeight;
  int? cbg;
  String? development;
  bool? coMorbidConditions;
  String? triageFlag;
  int? userId;
  String? insertedDate;
  int? refFormId;
  int? refId;

  Prem({
    this.id,
    this.triageId,
    this.dateTimeOfEntry,
    this.patientAdmitted,
    this.nameOfDept,
    this.dateOfAdmit,
    this.isPremCasesheetUsed,
    this.presentingComplaintsPrem,
    this.othPresentingComplaintsPrem,
    this.temperature,
    this.approxWeight,
    this.cbg,
    this.development,
    this.coMorbidConditions,
    this.triageFlag,
    this.userId,
    this.insertedDate,
    this.refFormId,
    this.refId,
  });

  Prem.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    triageId = json['triage_id'] ?? 0;
    dateTimeOfEntry = json['date_time_of_entry'] ?? '';
    patientAdmitted = json['patient_admitted'] ?? false;
    nameOfDept = json['name_of_dept'] ?? '';
    dateOfAdmit = json['date_of_admit'] ?? '';
    isPremCasesheetUsed = json['is_prem_casesheet_used'] ?? false;
    presentingComplaintsPrem = json['presenting_complaints_prem'] ?? '';
    othPresentingComplaintsPrem = json['oth_presenting_complaints_prem'] ?? '';
    temperature = json['temperature'] != null
        ? double.tryParse(json['temperature'].toString()) ?? 0.0
        : 0.0;
    approxWeight = json['approx_weight'] != null
        ? double.tryParse(json['approx_weight'].toString()) ?? 0.0
        : 0.0;
    cbg = json['cbg'] ?? 0;
    development = json['development'] ?? '';
    coMorbidConditions = json['co_morbid_conditions'] ?? false;
    triageFlag = json['triage_flag'] ?? '';
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
    data['is_prem_casesheet_used'] = isPremCasesheetUsed;
    data['presenting_complaints_prem'] = presentingComplaintsPrem;
    data['oth_presenting_complaints_prem'] = othPresentingComplaintsPrem;
    data['temperature'] = temperature;
    data['approx_weight'] = approxWeight;
    data['cbg'] = cbg;
    data['development'] = development;
    data['co_morbid_conditions'] = coMorbidConditions;
    data['triage_flag'] = triageFlag;
    data['user_id'] = userId;
    data['inserted_date'] = insertedDate;
    data['ref_form_id'] = refFormId;
    data['ref_id'] = refId;
    return data;
  }
}

class Vitals {
  int? id;
  String? airway;
  String? breathing;
  String? circulationHr;
  String? perfusion;
  String? liverSpan;
  String? systolicBp;
  String? map;
  String? disability;
  String? tonePosture;
  String? eyePositionMovements;
  String? pupils;
  String? diagnosis;
  String? diagnosisRefvalue;
  String? proceduresDone;
  String? treatmentGiven;

  Vitals({
    this.id,
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
    this.diagnosis,
    this.diagnosisRefvalue,
    this.proceduresDone,
    this.treatmentGiven,
  });

  Vitals.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    airway = json['airway'] ?? '';
    breathing = json['breathing'] ?? '';
    circulationHr = json['circulation_hr'] ?? '';
    perfusion = json['perfusion'] ?? '';
    liverSpan = json['liver_span'] ?? '';
    systolicBp = json['systolic_bp'] ?? '';
    map = json['map'] ?? '';
    disability = json['disability'] ?? '';
    tonePosture = json['tone_posture'] ?? '';
    eyePositionMovements = json['eye_position_movements'] ?? '';
    pupils = json['pupils'] ?? '';
    diagnosis = json['diagnosis'] ?? '';
    diagnosisRefvalue = json['diagnosis_refvalue'] ?? '';
    proceduresDone = json['procedures_done'] ?? '';
    treatmentGiven = json['treatment_given'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['airway'] = airway;
    data['breathing'] = breathing;
    data['circulation_hr'] = circulationHr;
    data['perfusion'] = perfusion;
    data['liver_span'] = liverSpan;
    data['systolic_bp'] = systolicBp;
    data['map'] = map;
    data['disability'] = disability;
    data['tone_posture'] = tonePosture;
    data['eye_position_movements'] = eyePositionMovements;
    data['pupils'] = pupils;
    data['diagnosis'] = diagnosis;
    data['diagnosis_refvalue'] = diagnosisRefvalue;
    data['procedures_done'] = proceduresDone;
    data['treatment_given'] = treatmentGiven;
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
  String? patientExitDate;
  String? hospitalType;
  String? destinationHospital;
  String? destinationTaeiHospital;
  String? reasonForReferral;
  String? conditionOfPatient;
  String? referringDoctor;
  String? patientStabilisedReferral;

  Outcome({
    this.id,
    this.outcome,
    this.dischargeDate,
    this.abscondedDate,
    this.deathDate,
    this.causeOfDeath,
    this.patientExitDate,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.patientStabilisedReferral,
  });

  Outcome.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    outcome = json['outcome'] ?? '';
    dischargeDate = json['discharge_date'];
    abscondedDate = json['absconded_date'];
    deathDate = json['death_date'];
    causeOfDeath = json['cause_of_death'];
    patientExitDate = json['patient_exit_date'];
    hospitalType = json['hospital_type'] ?? '';
    destinationHospital = json['destination_hospital'] ?? '';
    destinationTaeiHospital = json['destination_taei_hospital'];
    reasonForReferral = json['reason_for_referral'] ?? '';
    conditionOfPatient = json['condition_of_patient'] ?? '';
    referringDoctor = json['referring_doctor'] ?? '';
    patientStabilisedReferral = json['patient_stabilised_referral'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['outcome'] = outcome;
    data['discharge_date'] = dischargeDate;
    data['absconded_date'] = abscondedDate;
    data['death_date'] = deathDate;
    data['cause_of_death'] = causeOfDeath;
    data['patient_exit_date'] = patientExitDate;
    data['hospital_type'] = hospitalType;
    data['destination_hospital'] = destinationHospital;
    data['destination_taei_hospital'] = destinationTaeiHospital;
    data['reason_for_referral'] = reasonForReferral;
    data['condition_of_patient'] = conditionOfPatient;
    data['referring_doctor'] = referringDoctor;
    data['patient_stabilised_referral'] = patientStabilisedReferral;
    return data;
  }
}
