// To parse this JSON data, do
//
//     final emoModel = emoModelFromJson(jsonString);

import 'dart:convert';

EmoModel emoModelFromJson(String str) => EmoModel.fromJson(json.decode(str));

String emoModelToJson(EmoModel data) => json.encode(data.toJson());

class EmoModel {
  Emo? emo;
  EmoOutcome? emoOutcome;

  EmoModel({
    this.emo,
    this.emoOutcome,
  });

  factory EmoModel.fromJson(Map<String, dynamic> json) => EmoModel(
        emo: json["emo"] == null ? null : Emo.fromJson(json["emo"]),
        emoOutcome: json["emo_outcome"] == null
            ? null
            : EmoOutcome.fromJson(json["emo_outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "emo": emo?.toJson(),
        "emo_outcome": emoOutcome?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Emo {
  int? id;
  List<int>? pastHistory;
  int? triageId;
  String? diagnosis;
  int? emergencyCategory;
  String? othEmergencyCategory;
  bool? isPatientSmellsAlcohol;
  bool? isAlcoholConsumption;
  bool? isDrunkenDriveHistory;
  String? timeOfExamination;
  int? memory;
  int? selfControl;
  bool? isSmellInBreath;
  bool? isUrineAlcholConcentration;
  int? speech;
  int? generalDisposition;
  int? clothing;
  int? reactionTime;
  int? orientationTime;
  bool? isDrugAbuse;
  bool? isMlc;
  String? arNumber;
  String? mlcDate;
  String? mlcTime;
  String? painScale;
  String? painScore;
  String? treatmentGiven;
  int? emoTraumaTreatment;
  String? nameOfTheEmo;

  Emo({
    this.id,
    this.pastHistory,
    this.triageId,
    this.diagnosis,
    this.emergencyCategory,
    this.othEmergencyCategory,
    this.isPatientSmellsAlcohol,
    this.isAlcoholConsumption,
    this.isDrunkenDriveHistory,
    this.timeOfExamination,
    this.memory,
    this.selfControl,
    this.isSmellInBreath,
    this.isUrineAlcholConcentration,
    this.speech,
    this.generalDisposition,
    this.clothing,
    this.reactionTime,
    this.orientationTime,
    this.isDrugAbuse,
    this.isMlc,
    this.arNumber,
    this.mlcDate,
    this.mlcTime,
    this.painScale,
    this.painScore,
    this.treatmentGiven,
    this.emoTraumaTreatment,
    this.nameOfTheEmo,
  });

  factory Emo.fromJson(Map<String, dynamic> json) => Emo(
        id: json["id"],
        pastHistory: json["past_history"] == null
            ? []
            : List<int>.from(json["past_history"]!.map((x) => x)),
        triageId: json["triage_id"],
        diagnosis: json["diagnosis"],
        emergencyCategory: json["emergency_category"],
        othEmergencyCategory: json["oth_emergency_category"],
        isPatientSmellsAlcohol: json["is_patient_smells_alcohol"],
        isAlcoholConsumption: json["is_alcohol_consumption"],
        isDrunkenDriveHistory: json["is_drunken_drive_history"],
        timeOfExamination: json["time_of_examination"],
        memory: json["memory"],
        selfControl: json["self_control"],
        isSmellInBreath: json["is_smell_in_breath"],
        isUrineAlcholConcentration: json["is_urine_alchol_concentration"],
        speech: json["speech"],
        generalDisposition: json["general_disposition"],
        clothing: json["clothing"],
        reactionTime: json["reaction_time"],
        orientationTime: json["orientation_time"],
        isDrugAbuse: json["is_drug_abuse"],
        isMlc: json["is_mlc"],
        arNumber: json["ar_number"],
        mlcDate: json["mlc_date"],
        mlcTime: json["mlc_time"],
        painScale: json["pain_scale"],
        painScore: json["pain_score"],
        treatmentGiven: json["treatment_given"],
        emoTraumaTreatment: json["emo_trauma_treatment"],
        nameOfTheEmo: json["name_of_the_emo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "past_history": pastHistory == null
            ? []
            : List<dynamic>.from(pastHistory!.map((x) => x)),
        "triage_id": triageId,
        "diagnosis": diagnosis,
        "emergency_category": emergencyCategory,
        "oth_emergency_category": othEmergencyCategory,
        "is_patient_smells_alcohol": isPatientSmellsAlcohol,
        "is_alcohol_consumption": isAlcoholConsumption,
        "is_drunken_drive_history": isDrunkenDriveHistory,
        "time_of_examination": timeOfExamination,
        "memory": memory,
        "self_control": selfControl,
        "is_smell_in_breath": isSmellInBreath,
        "is_urine_alchol_concentration": isUrineAlcholConcentration,
        "speech": speech,
        "general_disposition": generalDisposition,
        "clothing": clothing,
        "reaction_time": reactionTime,
        "orientation_time": orientationTime,
        "is_drug_abuse": isDrugAbuse,
        "is_mlc": isMlc,
        "ar_number": arNumber,
        "mlc_date": mlcDate,
        "mlc_time": mlcTime,
        "pain_scale": painScale,
        "pain_score": painScore,
        "treatment_given": treatmentGiven,
        "emo_trauma_treatment": emoTraumaTreatment,
        "name_of_the_emo": nameOfTheEmo,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class EmoOutcome {
  int? id;
  int? emoId;
  int? outcome;
  String? outcomeDatetime;
  String? sentTo;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTaeiHospital;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctorName;

  EmoOutcome({
    this.id,
    this.emoId,
    this.outcome,
    this.outcomeDatetime,
    this.sentTo,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctorName,
  });

  factory EmoOutcome.fromJson(Map<String, dynamic> json) => EmoOutcome(
        id: json["id"],
        emoId: json["emo_id"],
        outcome: json["outcome"],
        outcomeDatetime: json["outcome_datetime"],
        sentTo: json["sent_to"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctorName: json["referring_doctor_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "emo_id": emoId,
        "outcome": outcome,
        "outcome_datetime": outcomeDatetime,
        "sent_to": sentTo,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor_name": referringDoctorName,
      };

  @override
  String toString() => jsonEncode(toJson());
}

extension EmoModelClean on EmoModel {
  Map<String, dynamic> toCleanJson() {
    final data = toJson();
    if (data['emo'] != null) {
      data['emo'].remove('id');
    }
    if (data['emo_outcome'] != null) {
      data['emo_outcome'].remove('id');
      data['emo_outcome'].remove('emo_id');
    }
    return data;
  }

// Map<String, dynamic> toUpdateJson() {
//   final data = toJson();
//   if (data['emo'] != null) {
//     data['emo'].remove('id');
//   }
//   if (data['emo_outcome'] != null) {
//     data['emo_outcome'].remove('id');
//     data['emo_outcome'].remove('emo_id');
//   }
//   return data;
// }
}
