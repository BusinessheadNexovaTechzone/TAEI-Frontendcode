import 'dart:convert';

// List<BitesStingsRequestModel> biteStingModelFromJson(String str) =>
//     List<BitesStingsRequestModel>.from(json.decode(str).map((x) => BitesStingsRequestModel.fromJson(x)));
//
// String biteStingModelToJson(List<BitesStingsRequestModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

BitesStingsRequestModel bitesStingsRequestModelFromJson(String str) =>
    BitesStingsRequestModel.fromJson(json.decode(str));

String bitesStingsRequestModelToJson(BitesStingsRequestModel data) =>
    json.encode(data.toJson());

// import 'dart:convert';
//
// BitesStingsRequestModel bitesStingsRequestModelFromJson(String str) =>
//     BitesStingsRequestModel.fromJson(json.decode(str));
//
// String bitesStingsRequestModelToJson(BitesStingsRequestModel data) =>
//     json.encode(data.toJson());

class BitesStingsRequestModel {
  BitesStings? bitesStings;
  OutcomeModel? outcome;

  BitesStingsRequestModel({this.bitesStings, this.outcome});

  factory BitesStingsRequestModel.fromJson(Map<String, dynamic> json) {
    return BitesStingsRequestModel(
      bitesStings: json['bites_stings'] != null
          ? BitesStings.fromJson(json['bites_stings'])
          : null,
      outcome: json['outcome'] != null
          ? OutcomeModel.fromJson(json['outcome'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bites_stings': bitesStings?.toJson(),
      'outcome': outcome?.toJson(),
    };
  }
}

class BitesStings {
  int? id;
  int? triageId;
  String? dateTimeOfEntry;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  int? typeOfBiteSting;
  int? typeOfOrganism;
  int? venomousType;
  int? siteOfBiteSting;
  List<int>? symptomsAtPresentation;
  String? timeToReachAfterBiteSting;
  int? timeinterval;
  String? signsOfEnvenomationAllergicReaction;
  String? investigationsPerformed;
  int? firstAidGiven;
  String? antiVenomOrAllergyTreatmentName;
  String? antiVenomOrAllergyTreatmentDosage;
  String? antiVenomOrAllergyTreatmentTiming;
  int? supportiveCareProvided;
  int? counsellingProvidedBeforeDischarge;
  int? durationOfHospitalStay;
  int? refFormId;
  int? refId;
  int? userId;
  String? insertedDate;
  String? oth_venomous_type;

  BitesStings(
      {this.triageId,
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
      this.refFormId,
      this.refId,
      this.timeinterval,
      this.oth_venomous_type,
      this.id,
      this.insertedDate,
      this.userId});

  factory BitesStings.fromJson(Map<String, dynamic> json) {
    return BitesStings(
        id: json['id'],
        userId: json['user_id'],
        insertedDate: json['inserted_date'],
        triageId: json['triage_id'],
        dateTimeOfEntry: json['date_time_of_entry'],
        patientAdmitted: json['patient_admitted'],
        nameOfDept: json['name_of_dept'],
        dateOfAdmit: json['date_of_admit'],
        typeOfBiteSting: json['type_of_bite_sting'],
        typeOfOrganism: json['type_of_organism'],
        venomousType: json['venomous_type'],
        siteOfBiteSting: json['site_of_bite_sting'],
        symptomsAtPresentation: json['symptoms_at_presentation'] != null
            ? List<int>.from(json['symptoms_at_presentation'])
            : null,
        timeToReachAfterBiteSting: json['time_to_reach_after_bite_sting'],
        signsOfEnvenomationAllergicReaction:
            json['signs_of_envenomation_allergic_reaction'],
        investigationsPerformed: json['investigations_performed'],
        firstAidGiven: json['first_aid_given'],
        antiVenomOrAllergyTreatmentName:
            json['anti_venom_or_allergy_treatment_name'],
        antiVenomOrAllergyTreatmentDosage:
            json['anti_venom_or_allergy_treatment_dosage'],
        antiVenomOrAllergyTreatmentTiming:
            json['anti_venom_or_allergy_treatment_timing'],
        supportiveCareProvided: json['supportive_care_provided'],
        counsellingProvidedBeforeDischarge:
            json['counselling_provided_before_discharge'],
        durationOfHospitalStay: json['duration_of_hospital_stay'],
        refFormId: json['ref_form_id'],
        refId: json['ref_id'],
        timeinterval: json['time_interval'],
        oth_venomous_type: json['oth_venomous_type']);
  }

  Map<String, dynamic> toJson() {
    return {
      'triage_id': triageId,
      'date_time_of_entry': dateTimeOfEntry,
      'patient_admitted': patientAdmitted,
      'name_of_dept': nameOfDept,
      'date_of_admit': dateOfAdmit,
      'type_of_bite_sting': typeOfBiteSting,
      'type_of_organism': typeOfOrganism,
      'venomous_type': venomousType,
      'site_of_bite_sting': siteOfBiteSting ?? 1,
      'symptoms_at_presentation': symptomsAtPresentation,
      'time_to_reach_after_bite_sting': timeToReachAfterBiteSting,
      'signs_of_envenomation_allergic_reaction':
          signsOfEnvenomationAllergicReaction,
      'investigations_performed': investigationsPerformed,
      'first_aid_given': firstAidGiven,
      'anti_venom_or_allergy_treatment_name': antiVenomOrAllergyTreatmentName,
      'anti_venom_or_allergy_treatment_dosage':
          antiVenomOrAllergyTreatmentDosage,
      'anti_venom_or_allergy_treatment_timing':
          antiVenomOrAllergyTreatmentTiming,
      'supportive_care_provided': supportiveCareProvided,
      'counselling_provided_before_discharge':
          counsellingProvidedBeforeDischarge,
      'duration_of_hospital_stay': durationOfHospitalStay,
      'ref_form_id': refFormId,
      'ref_id': refId,
      'time_interval': timeinterval,
      'oth_venomous_type': oth_venomous_type,
      'inserted_date': insertedDate,
      'id': id,
      'user_id': userId,
    };
  }
}

class OutcomeModel {
  int? id;
  int? outcome;
  String? dischargeDate;
  String? abscondedDate;
  String? deathDate;
  String? causeOfDeath;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTaeiHospital;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctor;
  bool? documentedTaeiSheet;
  String? patientExitDate;
  int? bitesStingsId;
  bool? isDischarged;

  OutcomeModel({
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
    this.patientExitDate,
    this.bitesStingsId,
    this.isDischarged,
  });

  factory OutcomeModel.fromJson(Map<String, dynamic> json) {
    return OutcomeModel(
      id: json['id'],
      outcome: json['outcome'],
      dischargeDate: json['discharge_date'],
      abscondedDate: json['absconded_date'],
      deathDate: json['death_date'],
      causeOfDeath: json['cause_of_death'],
      hospitalType: json['hospital_type'],
      destinationHospital: json['destination_hospital'],
      destinationTaeiHospital: json['destination_taei_hospital'],
      reasonForReferral: json['reason_for_referral'],
      conditionOfPatient: json['condition_of_patient'],
      referringDoctor: json['referring_doctor'],
      documentedTaeiSheet: json['documented_taei_sheet'],
      patientExitDate: json['patient_exit_date'],
      bitesStingsId: json['bites_stings_id'],
      isDischarged: json['is_discharged'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outcome': outcome,
      'discharge_date': dischargeDate,
      'absconded_date': abscondedDate,
      'death_date': deathDate,
      'cause_of_death': causeOfDeath,
      'hospital_type': hospitalType,
      'destination_hospital': destinationHospital,
      'destination_taei_hospital': destinationTaeiHospital,
      'reason_for_referral': reasonForReferral,
      'condition_of_patient': conditionOfPatient,
      'referring_doctor': referringDoctor,
      'documented_taei_sheet': documentedTaeiSheet,
      'patient_exit_date': patientExitDate,
      'bites_stings_id': bitesStingsId,
      'is_discharged': isDischarged,
    };
  }
}
