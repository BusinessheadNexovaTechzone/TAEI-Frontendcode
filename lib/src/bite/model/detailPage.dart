import 'dart:convert';

BitesStingsDetails burnsDetailsModelFromJson(String str) =>
    BitesStingsDetails.fromJson(json.decode(str));

String burnsDetailsModelToJson(BitesStingsDetails data) =>
    json.encode(data.toJson());

class BitesStingsDetails {
  BitesStings? bitesStings;
  Outcome? outcome;

  BitesStingsDetails({this.bitesStings, this.outcome});

  BitesStingsDetails.fromJson(Map<String, dynamic> json) {
    bitesStings = json['bites_stings'] != null
        ? BitesStings.fromJson(json['bites_stings'])
        : null;
    outcome =
    json['outcome'] != null ? Outcome.fromJson(json['outcome']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (bitesStings != null) data['bites_stings'] = bitesStings!.toJson();
    if (outcome != null) data['outcome'] = outcome!.toJson();
    return data;
  }
}

class BitesStings {
  int? id;
  int? triageId;
  String? dateTimeOfEntry;
  String? patientAdmitted;
  String? nameOfDept;
  String? dateOfAdmit;
  String? typeOfBiteSting;
  String? typeOfOrganism;
  String? venomousType;
  String? othVenomousType;
  String? siteOfBiteSting;
  String? symptomsAtPresentation;
  String? timeToReachAfterBiteSting;
  String? timeInterval;
  String? signsOfEnvenomationAllergicReaction;
  String? investigationsPerformed;
  String? firstAidGiven;
  String? antiVenomOrAllergyTreatmentName;
  String? antiVenomOrAllergyTreatmentDosage;
  String? antiVenomOrAllergyTreatmentTiming;
  String? supportiveCareProvided;
  String? counsellingProvidedBeforeDischarge;
  int? durationOfHospitalStay;
  int? userId;
  String? insertedDate;
  int? refFormId;
  int? refId;

  BitesStings({
    this.id,
    this.triageId,
    this.dateTimeOfEntry,
    this.patientAdmitted,
    this.nameOfDept,
    this.dateOfAdmit,
    this.typeOfBiteSting,
    this.typeOfOrganism,
    this.venomousType,
    this.othVenomousType,
    this.siteOfBiteSting,
    this.symptomsAtPresentation,
    this.timeToReachAfterBiteSting,
    this.timeInterval,
    this.signsOfEnvenomationAllergicReaction,
    this.investigationsPerformed,
    this.firstAidGiven,
    this.antiVenomOrAllergyTreatmentName,
    this.antiVenomOrAllergyTreatmentDosage,
    this.antiVenomOrAllergyTreatmentTiming,
    this.supportiveCareProvided,
    this.counsellingProvidedBeforeDischarge,
    this.durationOfHospitalStay,
    this.userId,
    this.insertedDate,
    this.refFormId,
    this.refId,
  });

  BitesStings.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    triageId = json['triage_id'] ?? 0;
    dateTimeOfEntry = json['date_time_of_entry'] ?? '';
    patientAdmitted = json['patient_admitted'] ?? '';
    nameOfDept = json['name_of_dept'] ?? '';
    dateOfAdmit = json['date_of_admit'] ?? '';
    typeOfBiteSting = json['type_of_bite_sting'] ?? '';
    typeOfOrganism = json['type_of_organism'] ?? '';
    venomousType = json['venomous_type'] ?? '';
    othVenomousType = json['oth_venomous_type'] ?? '';
    siteOfBiteSting = json['site_of_bite_sting'] ?? '';
    symptomsAtPresentation = json['symptoms_at_presentation'] ?? '';
    timeToReachAfterBiteSting = json['time_to_reach_after_bite_sting'] ?? '';
    timeInterval = json['time_interval'] ?? '';
    signsOfEnvenomationAllergicReaction =
        json['signs_of_envenomation_allergic_reaction'] ?? '';
    investigationsPerformed = json['investigations_performed'] ?? '';
    firstAidGiven = json['first_aid_given'] ?? '';
    antiVenomOrAllergyTreatmentName =
        json['anti_venom_or_allergy_treatment_name'] ?? '';
    antiVenomOrAllergyTreatmentDosage =
        json['anti_venom_or_allergy_treatment_dosage'] ?? '';
    antiVenomOrAllergyTreatmentTiming =
        json['anti_venom_or_allergy_treatment_timing'] ?? '';
    supportiveCareProvided = json['supportive_care_provided'] ?? '';
    counsellingProvidedBeforeDischarge =
        json['counselling_provided_before_discharge'] ?? '';
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
    data['type_of_bite_sting'] = typeOfBiteSting;
    data['type_of_organism'] = typeOfOrganism;
    data['venomous_type'] = venomousType;
    data['oth_venomous_type'] = othVenomousType;
    data['site_of_bite_sting'] = siteOfBiteSting;
    data['symptoms_at_presentation'] = symptomsAtPresentation;
    data['time_to_reach_after_bite_sting'] = timeToReachAfterBiteSting;
    data['time_interval'] = timeInterval;
    data['signs_of_envenomation_allergic_reaction'] =
        signsOfEnvenomationAllergicReaction;
    data['investigations_performed'] = investigationsPerformed;
    data['first_aid_given'] = firstAidGiven;
    data['anti_venom_or_allergy_treatment_name'] =
        antiVenomOrAllergyTreatmentName;
    data['anti_venom_or_allergy_treatment_dosage'] =
        antiVenomOrAllergyTreatmentDosage;
    data['anti_venom_or_allergy_treatment_timing'] =
        antiVenomOrAllergyTreatmentTiming;
    data['supportive_care_provided'] = supportiveCareProvided;
    data['counselling_provided_before_discharge'] =
        counsellingProvidedBeforeDischarge;
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
  String? patientExitDate;

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
    this.patientExitDate,
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
    destinationTaeiHospital = json['destination_taei_hospital'];
    reasonForReferral = json['reason_for_referral'] ?? '';
    conditionOfPatient = json['condition_of_patient'] ?? '';
    referringDoctor = json['referring_doctor'] ?? '';
    documentedTaeiSheet = json['documented_taei_sheet'] ?? '';
    patientExitDate = json['patient_exit_date'] ?? '';
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
    data['patient_exit_date'] = patientExitDate;
    return data;
  }
}

