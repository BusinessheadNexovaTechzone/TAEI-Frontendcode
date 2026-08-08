// To parse this JSON data, do
//
//     final emoDetailsModel = emoDetailsModelFromJson(jsonString);

import 'dart:convert';

EmoDetailsModel emoDetailsModelFromJson(String str) =>
    EmoDetailsModel.fromJson(json.decode(str));

String emoDetailsModelToJson(EmoDetailsModel data) =>
    json.encode(data.toJson());

class EmoDetailsModel {
  EmoDetailsDataModel? emo;
  EmoDetailsOutcome? outcome;

  EmoDetailsModel({
    this.emo,
    this.outcome,
  });

  factory EmoDetailsModel.fromJson(Map<String, dynamic> json) =>
      EmoDetailsModel(
        emo: json["emo"] == null
            ? null
            : EmoDetailsDataModel.fromJson(json["emo"]),
        outcome: json["outcome"] == null
            ? null
            : EmoDetailsOutcome.fromJson(json["outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "emo": emo?.toJson(),
        "outcome": outcome?.toJson(),
      };
}

class EmoDetailsDataModel {
  int? id;
  int? triageId;
  String? pastHistory;
  dynamic diagnosis;
  String? emergencyCategory;
  dynamic othEmergencyCategory;
  String? isPatientSmellsAlcohol;
  String? isAlcoholConsumption;
  String? isDrunkenDriveHistory;
  dynamic timeOfExamination;
  dynamic memory;
  dynamic selfControl;
  String? isSmellInBreath;
  String? isUrineAlcholConcentration;
  dynamic speech;
  dynamic generalDisposition;
  dynamic clothing;
  dynamic reactionTime;
  dynamic orientationTime;
  String? isDrugAbuse;
  String? isMlc;
  dynamic arNumber;
  dynamic mlcDate;
  dynamic mlcTime;
  dynamic painScale;
  dynamic painScore;
  dynamic treatmentGiven;
  dynamic emoTraumaTreatment;
  dynamic nameOfTheEmo;

  EmoDetailsDataModel({
    this.id,
    this.triageId,
    this.pastHistory,
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

  factory EmoDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      EmoDetailsDataModel(
        id: json["id"],
        triageId: json["triage_id"],
        pastHistory: json["past_history"],
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
        "triage_id": triageId,
        "past_history": pastHistory,
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

class EmoDetailsOutcome {
  int? id;
  String? outcome;
  dynamic outcomeDatetime;
  dynamic sentTo;
  dynamic hospitalType;
  dynamic destinationHospital;
  dynamic destinationTaeiHospital;
  dynamic reasonForReferral;
  dynamic conditionOfPatient;
  dynamic referringDoctorName;
  String? isDischarged;

  EmoDetailsOutcome({
    this.id,
    this.outcome,
    this.outcomeDatetime,
    this.sentTo,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctorName,
    this.isDischarged,
  });

  factory EmoDetailsOutcome.fromJson(Map<String, dynamic> json) =>
      EmoDetailsOutcome(
        id: json["id"],
        outcome: json["outcome"],
        outcomeDatetime: json["outcome_datetime"],
        sentTo: json["sent_to"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctorName: json["referring_doctor_name"],
        isDischarged: json["is_discharged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "outcome": outcome,
        "outcome_datetime": outcomeDatetime,
        "sent_to": sentTo,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor_name": referringDoctorName,
        "is_discharged": isDischarged,
      };
  @override
  String toString() => jsonEncode(toJson());
}
