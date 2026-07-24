import 'dart:convert';

// === Top-level JSON Helpers ===

List<PremModel1> premModelFromJson1(String str) =>
    List<PremModel1>.from(json.decode(str).map((x) => PremModel1.fromJson(x)));

String premModelToJson1(List<PremModel1> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// === Main Request Model ===

class PremModel1 {
  Prem? prem;
  Vitals? vitals;
  Outcome? outcome;

  PremModel1({
    this.prem,
    this.vitals,
    this.outcome,
  });

  factory PremModel1.fromJson(Map<String, dynamic> json) => PremModel1(
        prem: json["prem"] == null ? null : Prem.fromJson(json["prem"]),
        vitals: json["vitals"] == null ? null : Vitals.fromJson(json["vitals"]),
        outcome:
            json["outcome"] == null ? null : Outcome.fromJson(json["outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "prem": prem?.toJson(),
        "vitals": vitals?.toJson(),
        "outcome": outcome?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

// === Prem Section ===

class Prem {
  int? triageId;
  String? dateTimeOfEntry;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  bool? isPremCasesheetUsed;
  List<int>? presentingComplaintsPrem;
  String? othPresentingComplaintsPrem;
  String? temperature;
  String? approxWeight;
  String? cbg;
  int? development;
  bool? coMorbidConditions;
  int? triageFlag;

  Prem({
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
  });

  factory Prem.fromJson(Map<String, dynamic> json) => Prem(
        triageId: json["triage_id"],
        dateTimeOfEntry: json["date_time_of_entry"],
        patientAdmitted: json["patient_admitted"],
        nameOfDept: json["name_of_dept"],
        dateOfAdmit: json["date_of_admit"],
        isPremCasesheetUsed: json["is_prem_casesheet_used"],
        presentingComplaintsPrem: json["presenting_complaints_prem"] == null
            ? []
            : List<int>.from(json["presenting_complaints_prem"]!.map((x) => x)),
        othPresentingComplaintsPrem: json["oth_presenting_complaints_prem"],
        temperature: json["temperature"]?.toString(),
        approxWeight: json["approx_weight"]?.toString(),
        cbg: json["cbg"]?.toString(),

        development: json["development"],
        coMorbidConditions: json["co_morbid_conditions"],
        triageFlag: json["triage_flag"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "date_time_of_entry": dateTimeOfEntry,
        "patient_admitted": patientAdmitted,
        "name_of_dept": nameOfDept,
        "date_of_admit": dateOfAdmit,
        "is_prem_casesheet_used": isPremCasesheetUsed,
        "presenting_complaints_prem": presentingComplaintsPrem == null
            ? []
            : List<dynamic>.from(presentingComplaintsPrem!.map((x) => x)),
        "oth_presenting_complaints_prem": othPresentingComplaintsPrem,
        "temperature": temperature,
        "approx_weight": approxWeight,
        "cbg": cbg,
        "development": development,
        "co_morbid_conditions": coMorbidConditions,
        "triage_flag": triageFlag,
      };

  @override
  String toString() => jsonEncode(toJson());
}

// === Vitals Section ===

List<Vitals> vitalsListFromJson(String str) =>
    List<Vitals>.from(json.decode(str).map((x) => Vitals.fromJson(x)));

String vitalsListToJson(List<Vitals> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vitals {
  int? airway;
  int? breathing;
  int? circulationHr;
  int? perfusion;
  int? liverSpan;
  int? systolicBp;
  int? map;
  int? disability;
  int? tonePosture;
  int? eyePositionMovements;
  int? pupils;
  int? diagnosis;
  int? diagnosisRefvalue;
  List<int>? proceduresDone;
  String? treatmentGiven;

  Vitals({
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

  factory Vitals.fromJson(Map<String, dynamic> json) => Vitals(
        airway: json["airway"],
        breathing: json["breathing"],
        circulationHr: json["circulation_hr"],
        perfusion: json["perfusion"],
        liverSpan: json["liver_span"],
        systolicBp: json["systolic_bp"],
        map: json["map"],
        disability: json["disability"],
        tonePosture: json["tone_posture"],
        eyePositionMovements: json["eye_position_movements"],
        pupils: json["pupils"],
        diagnosis: json["diagnosis"],
        diagnosisRefvalue: json["diagnosis_refvalue"],
        proceduresDone: json["procedures_done"] == null
            ? []
            : List<int>.from(json["procedures_done"]!.map((x) => x)),
        treatmentGiven: json["treatment_given"],
      );

  Map<String, dynamic> toJson() => {
        "airway": airway,
        "breathing": breathing,
        "circulation_hr": circulationHr,
        "perfusion": perfusion,
        "liver_span": liverSpan,
        "systolic_bp": systolicBp,
        "map": map,
        "disability": disability,
        "tone_posture": tonePosture,
        "eye_position_movements": eyePositionMovements,
        "pupils": pupils,
        "diagnosis": diagnosis,
        "diagnosis_refvalue": diagnosisRefvalue,
        "procedures_done": proceduresDone == null
            ? []
            : List<dynamic>.from(proceduresDone!.map((x) => x)),
        "treatment_given": treatmentGiven,
      };

  @override
  String toString() => jsonEncode(toJson());
}

// === Outcome Section ===

class Outcome {
  int? outcome;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTaeiHospital;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctor;
  int? patientStabilisedReferral;
  String? dischargeDate;
  String? abscondedDate;
  String? deathDate;
  String? causeOfDeath;
  String? patientExitDate;
  bool? isDischarged;
  bool? shifted_to_picu;

  Outcome({
    this.outcome,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.patientStabilisedReferral,
    this.dischargeDate,
    this.causeOfDeath,
    this.patientExitDate,
    this.abscondedDate,
    this.deathDate,
    this.isDischarged,
    this.shifted_to_picu
  });

  factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
        outcome: json["outcome"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctor: json["referring_doctor"],
        patientStabilisedReferral: json["patient_stabilised_referral"],
        dischargeDate: json["discharge_date"],
        deathDate: json['death_date'],
        causeOfDeath: json['cause_of_death'],
        patientExitDate: json['patient_exit_date'],
        abscondedDate: json['absconded_date'],
        isDischarged: json['is_discharged'],
        shifted_to_picu:json['shifted_to_picu']
      );

  Map<String, dynamic> toJson() => {
        "outcome": outcome,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor": referringDoctor,
        "patient_stabilised_referral": patientStabilisedReferral,
        "discharge_date": dischargeDate,
        "patient_exit_date": patientExitDate,
        "absconded_date": abscondedDate,
        "cause_of_death": causeOfDeath,
        "death_date": deathDate,
        "is_discharged": isDischarged,
        "shifted_to_picu":shifted_to_picu,
      };
}
