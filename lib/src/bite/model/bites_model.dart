import 'dart:convert';

List<BiteStingModel> biteStingModelFromJson(String str) =>
    List<BiteStingModel>.from(
        json.decode(str).map((x) => BiteStingModel.fromJson(x)));

String biteStingModelToJson(List<BiteStingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BiteStingModel {
  int? id;
  int? triageId;
  DateTime? dateTimeOfEntry;
  bool? patientAdmitted;
  String? nameOfDept;
  DateTime? dateOfAdmit;
  int? typeOfBiteSting;
  int? typeOfOrganism;
  int? venomousType;
  int? siteOfBiteSting;
  List<int>? symptomsAtPresentation;
  TimeToReachAfterBiteSting? timeToReachAfterBiteSting;
  String? signsOfEnvenomationAllergicReaction;
  String? investigationsPerformed;
  int? firstAidGiven;
  String? antiVenomOrAllergyTreatmentName;
  String? antiVenomOrAllergyTreatmentDosage;
  String? antiVenomOrAllergyTreatmentTiming;
  int? supportiveCareProvided;
  int? counsellingProvidedBeforeDischarge;
  int? durationOfHospitalStay;
  Outcome? outcome;

  BiteStingModel({
    this.id,
    this.triageId,
    this.dateTimeOfEntry,
    this.patientAdmitted,
    this.nameOfDept,
    this.dateOfAdmit,
    this.typeOfBiteSting,
    this.typeOfOrganism,
    this.venomousType,
    this.siteOfBiteSting,
    this.symptomsAtPresentation,
    this.timeToReachAfterBiteSting,
    this.signsOfEnvenomationAllergicReaction,
    this.investigationsPerformed,
    this.firstAidGiven,
    this.antiVenomOrAllergyTreatmentName,
    this.antiVenomOrAllergyTreatmentDosage,
    this.antiVenomOrAllergyTreatmentTiming,
    this.supportiveCareProvided,
    this.counsellingProvidedBeforeDischarge,
    this.durationOfHospitalStay,
    this.outcome,
  });

  factory BiteStingModel.fromJson(Map<String, dynamic> json) => BiteStingModel(
        id: json["id"],
        triageId: json["triage_id"],
        dateTimeOfEntry: json["date_time_of_entry"] == null
            ? null
            : DateTime.parse(json["date_time_of_entry"]),
        patientAdmitted: json["patient_admitted"],
        nameOfDept: json["name_of_dept"],
        dateOfAdmit: json["date_of_admit"] == null
            ? null
            : DateTime.parse(json["date_of_admit"]),
        typeOfBiteSting: json["type_of_bite_sting"],
        typeOfOrganism: json["type_of_organism"],
        venomousType: json["venomous_type"],
        siteOfBiteSting: json["site_of_bite_sting"],
        symptomsAtPresentation: json["symptoms_at_presentation"] == null
            ? []
            : List<int>.from(json["symptoms_at_presentation"].map((x) => x)),
        timeToReachAfterBiteSting:
            json["time_to_reach_after_bite_sting"] == null
                ? null
                : TimeToReachAfterBiteSting.fromJson(
                    json["time_to_reach_after_bite_sting"]),
        signsOfEnvenomationAllergicReaction:
            json["signs_of_envenomation_allergic_reaction"],
        investigationsPerformed: json["investigations_performed"],
        firstAidGiven: json["first_aid_given"],
        antiVenomOrAllergyTreatmentName:
            json["anti_venom_or_allergy_treatment_name"],
        antiVenomOrAllergyTreatmentDosage:
            json["anti_venom_or_allergy_treatment_dosage"],
        antiVenomOrAllergyTreatmentTiming:
            json["anti_venom_or_allergy_treatment_timing"],
        supportiveCareProvided: json["supportive_care_provided"],
        counsellingProvidedBeforeDischarge:
            json["counselling_provided_before_discharge"],
        durationOfHospitalStay: json["duration_of_hospital_stay"],
        outcome:
            json["outcome"] == null ? null : Outcome.fromJson(json["outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "triage_id": triageId,
        "date_time_of_entry": dateTimeOfEntry?.toIso8601String(),
        "patient_admitted": patientAdmitted,
        "name_of_dept": nameOfDept,
        "date_of_admit": dateOfAdmit?.toIso8601String(),
        "type_of_bite_sting": typeOfBiteSting,
        "type_of_organism": typeOfOrganism,
        "venomous_type": venomousType,
        "site_of_bite_sting": siteOfBiteSting,
        "symptoms_at_presentation": symptomsAtPresentation == null
            ? []
            : List<dynamic>.from(symptomsAtPresentation!.map((x) => x)),
        "time_to_reach_after_bite_sting": timeToReachAfterBiteSting?.toJson(),
        "signs_of_envenomation_allergic_reaction":
            signsOfEnvenomationAllergicReaction,
        "investigations_performed": investigationsPerformed,
        "first_aid_given": firstAidGiven,
        "anti_venom_or_allergy_treatment_name": antiVenomOrAllergyTreatmentName,
        "anti_venom_or_allergy_treatment_dosage":
            antiVenomOrAllergyTreatmentDosage,
        "anti_venom_or_allergy_treatment_timing":
            antiVenomOrAllergyTreatmentTiming,
        "supportive_care_provided": supportiveCareProvided,
        "counselling_provided_before_discharge":
            counsellingProvidedBeforeDischarge,
        "duration_of_hospital_stay": durationOfHospitalStay,
        "outcome": outcome?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class TimeToReachAfterBiteSting {
  int? hours;

  TimeToReachAfterBiteSting({this.hours});

  factory TimeToReachAfterBiteSting.fromJson(Map<String, dynamic> json) =>
      TimeToReachAfterBiteSting(
        hours: json["hours"],
      );

  Map<String, dynamic> toJson() => {
        "hours": hours,
      };
}

// trauma_values
List<Outcome> outcomeValuesFromJson(String str) =>
    List<Outcome>.from(json.decode(str).map((x) => Outcome.fromJson(x)));

String outcomeValuesToJson(List<Outcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Outcome {
  int? id;
  int? bitesStingsId;
  int? outcome;
  DateTime? dischargeDate;
  DateTime? abscondedDate;
  DateTime? deathDate;
  String? causeOfDeath;
  int? hospitalType;
  int? destinationHospital;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctor;
  bool? documentedTaeiSheet;
  DateTime? patientExitDate;
  bool? isDischarged;

  Outcome({
    this.id,
    this.bitesStingsId,
    this.outcome,
    this.dischargeDate,
    this.abscondedDate,
    this.deathDate,
    this.causeOfDeath,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctor,
    this.documentedTaeiSheet,
    this.patientExitDate,
    this.isDischarged,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
        id: json["id"],
        bitesStingsId: json["bites_stings_id"],
        outcome: json["outcome"],
        dischargeDate: json["discharge_date"] == null
            ? null
            : DateTime.parse(json["discharge_date"]),
        abscondedDate: json["absconded_date"] == null
            ? null
            : DateTime.tryParse(json["absconded_date"] ?? ""),
        deathDate: json["death_date"] == null
            ? null
            : DateTime.tryParse(json["death_date"] ?? ""),
        causeOfDeath: json["cause_of_death"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctor: json["referring_doctor"],
        documentedTaeiSheet: json["documented_taei_sheet"],
        patientExitDate: json["patient_exit_date"] == null
            ? null
            : DateTime.parse(json["patient_exit_date"]),
        isDischarged: json["is_discharged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bites_stings_id": bitesStingsId,
        "outcome": outcome,
        "discharge_date": dischargeDate?.toIso8601String(),
        "absconded_date": abscondedDate?.toIso8601String(),
        "death_date": deathDate?.toIso8601String(),
        "cause_of_death": causeOfDeath,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor": referringDoctor,
        "documented_taei_sheet": documentedTaeiSheet,
        "patient_exit_date": patientExitDate?.toIso8601String(),
        "is_discharged": isDischarged,
      };

  @override
  String toString() => jsonEncode(toJson());
}
