
import 'dart:convert';

AcsCaseDataModel stemiNonIndexOp(String str) =>
    AcsCaseDataModel.fromJson(json.decode(str));

class AcsCaseDataModel {
  final OpPatient? opPatient;
  final StemiData? stemi;
  final NstemiData? nstemi;
  final UnstableAnginaData? unstableAngina;

  AcsCaseDataModel({
    this.opPatient,
    this.stemi,
    this.nstemi,
    this.unstableAngina,
  });

  factory AcsCaseDataModel.fromJson(Map<String, dynamic> json) {
    return AcsCaseDataModel(
      opPatient: json['op_patient'] != null
          ? OpPatient.fromJson(json['op_patient'] as Map<String, dynamic>)
          : null,
      stemi: json['stemi'] != null
          ? StemiData.fromJson(json['stemi'] as Map<String, dynamic>)
          : null,
      nstemi: json['nstemi'] != null
          ? NstemiData.fromJson(json['nstemi'] as Map<String, dynamic>)
          : null,
      unstableAngina: json['unstable_angina'] != null
          ? UnstableAnginaData.fromJson(
              json['unstable_angina'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'op_patient': opPatient?.toJson(),
      'stemi': stemi?.toJson(),
      'nstemi': nstemi?.toJson(),
      'unstable_angina': unstableAngina?.toJson(),
    };
  }
}

// -------------------------------------------------------------

class OpPatient {
  final int? patientId;
  final String? patientOpNumber;
  final String? patientAdmitted;
  final String? nameOfPatient;
  final String? gender;
  final String? mobile;
  final String? fathername;
  final String? mothername;
  final String? address;
  final String? pincode;
  final String? maritalStatus;
  final String? education;
  final String? employmentStatus;
  final String? occupation;
  final String? state;
  final String? district;
  final String? dateTimeOfTriage;
  final String? riskFactors;
  final String? otherRiskFactor;
  final String? signsSymptoms;
  final String? ecgDatetime;
  final String? ecgLocation;
  final String? diagnosis;
  final String? otherDiagnosis;

  OpPatient({
    this.patientId,
    this.patientOpNumber,
    this.patientAdmitted,
    this.nameOfPatient,
    this.gender,
    this.mobile,
    this.fathername,
    this.mothername,
    this.address,
    this.pincode,
    this.maritalStatus,
    this.education,
    this.employmentStatus,
    this.occupation,
    this.state,
    this.district,
    this.dateTimeOfTriage,
    this.riskFactors,
    this.otherRiskFactor,
    this.signsSymptoms,
    this.ecgDatetime,
    this.ecgLocation,
    this.diagnosis,
    this.otherDiagnosis,
  });

  factory OpPatient.fromJson(Map<String, dynamic> json) {
    return OpPatient(
      patientId: json['patient_id'] as int?,
      patientOpNumber: json['patient_op_number'] as String?,
      patientAdmitted: json['patient_admitted'] as String?,
      nameOfPatient: json['name_of_patient'] as String?,
      gender: json['gender'] as String?,
      mobile: json['mobile'] as String?,
      fathername: json['fathername'] as String?,
      mothername: json['mothername'] as String?,
      address: json['address'] as String?,
      pincode: json['pincode'] as String?,
      maritalStatus: json['marital_status'] as String?,
      education: json['education'] as String?,
      employmentStatus: json['employment_status'] as String?,
      occupation: json['occupation'] as String?,
      state: json['state'] as String?,
      district: json['district'] as String?,
      dateTimeOfTriage: json['date_time_of_triage'] as String?,
      riskFactors: json['risk_factors'] as String?,
      otherRiskFactor: json['other_risk_factor'] as String?,
      signsSymptoms: json['signs_symptoms'] as String?,
      ecgDatetime: json['ecg_datetime'] as String?,
      ecgLocation: json['ecg_location'] as String?,
      diagnosis: json['diagnosis'] as String?,
      otherDiagnosis: json['other_diagnosis'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'patient_op_number': patientOpNumber,
      'patient_admitted': patientAdmitted,
      'name_of_patient': nameOfPatient,
      'gender': gender,
      'mobile': mobile,
      'fathername': fathername,
      'mothername': mothername,
      'address': address,
      'pincode': pincode,
      'marital_status': maritalStatus,
      'education': education,
      'employment_status': employmentStatus,
      'occupation': occupation,
      'state': state,
      'district': district,
      'date_time_of_triage': dateTimeOfTriage,
      'risk_factors': riskFactors,
      'other_risk_factor': otherRiskFactor,
      'signs_symptoms': signsSymptoms,
      'ecg_datetime': ecgDatetime,
      'ecg_location': ecgLocation,
      'diagnosis': diagnosis,
      'other_diagnosis': otherDiagnosis,
    };
  }
}

// -------------------------------------------------------------

class StemiData {
  final StemiTreatment? treatment;
  final Outcome? outcome;

  StemiData({this.treatment, this.outcome});

  factory StemiData.fromJson(Map<String, dynamic> json) {
    return StemiData(
      treatment: json['treatment'] != null
          ? StemiTreatment.fromJson(json['treatment'] as Map<String, dynamic>)
          : null,
      outcome: json['outcome'] != null
          ? Outcome.fromJson(json['outcome'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment': treatment?.toJson(),
      'outcome': outcome?.toJson(),
    };
  }
}

class StemiTreatment {
  final int? id;
  final String? stemiConfirmedAt;
  final String? infarctionLocation;
  final String? loadingDoseLocation;
  final String? loadingDoseDrug;
  final String? loadingDoseTime;
  final String? loadingDoseAdministrationDate;
  final String? thrombolysisLocation;
  final String? thrombolyticAgent;
  final String? thrombolysisStart;
  final String? thrombolysisEnd;
  final String? thrombolysisOutcome;
  final String? thrombolysisNotDoneReason;
  final String? thrombolysisDate;
  final String? treatmentStrategy;
  final String? conservativeManagement;
  final String? killipRiskScore;
  final bool? plannedCag;
  final String? cathLabArrival;
  final String? balloonInflation;
  final String? stentType;
  final String? complications;
  final String? otherComplications;
  final String? transferLocation;
  final String? counsellingId;
  final String? symptomToFmc;
  final String? fmcToEcg;
  final String? doorToNeedle;
  final String? doorToBalloon;
  final int? totalIschemicTime;
  final bool? icuAdmission;
  final int? hospitalStayDays;
  final String? inHospitalComplication;
  final String? coronoryAngiography;

  StemiTreatment({
    this.id,
    this.stemiConfirmedAt,
    this.infarctionLocation,
    this.loadingDoseLocation,
    this.loadingDoseDrug,
    this.loadingDoseTime,
    this.loadingDoseAdministrationDate,
    this.thrombolysisLocation,
    this.thrombolyticAgent,
    this.thrombolysisStart,
    this.thrombolysisEnd,
    this.thrombolysisOutcome,
    this.thrombolysisNotDoneReason,
    this.thrombolysisDate,
    this.treatmentStrategy,
    this.conservativeManagement,
    this.killipRiskScore,
    this.plannedCag,
    this.cathLabArrival,
    this.balloonInflation,
    this.stentType,
    this.complications,
    this.otherComplications,
    this.transferLocation,
    this.counsellingId,
    this.symptomToFmc,
    this.fmcToEcg,
    this.doorToNeedle,
    this.doorToBalloon,
    this.totalIschemicTime,
    this.icuAdmission,
    this.hospitalStayDays,
    this.inHospitalComplication,
    this.coronoryAngiography,
  });

  factory StemiTreatment.fromJson(Map<String, dynamic> json) {
    return StemiTreatment(
      id: json['id'] as int?,
      stemiConfirmedAt: json['stemi_confirmed_at'] as String?,
      infarctionLocation: json['infarction_location'] as String?,
      loadingDoseLocation: json['loading_dose_location'] as String?,
      loadingDoseDrug: json['loading_dose_drug'] as String?,
      loadingDoseTime: json['loading_dose_time'] as String?,
      loadingDoseAdministrationDate:
          json['loading_dose_administration_date'] as String?,
      thrombolysisLocation: json['thrombolysis_location'] as String?,
      thrombolyticAgent: json['thrombolytic_agent'] as String?,
      thrombolysisStart: json['thrombolysis_start'] as String?,
      thrombolysisEnd: json['thrombolysis_end'] as String?,
      thrombolysisOutcome: json['thrombolysis_outcome'] as String?,
      thrombolysisNotDoneReason:
          json['thrombolysis_not_done_reason'] as String?,
      thrombolysisDate: json['thrombolysis_date'] as String?,
      treatmentStrategy: json['treatment_strategy'] as String?,
      conservativeManagement: json['conservative_management'] as String?,
      killipRiskScore: json['killip_risk_score'] as String?,
      plannedCag: json['planned_cag'] as bool?,
      cathLabArrival: json['cath_lab_arrival'] as String?,
      balloonInflation: json['balloon_inflation'] as String?,
      stentType: json['stent_type'] as String?,
      complications: json['complications'] as String?,
      otherComplications: json['other_complications'] as String?,
      transferLocation: json['transfer_location'] as String?,
      counsellingId: json['counselling_id'] as String?,
      symptomToFmc: json['symptom_to_fmc'] as String?,
      fmcToEcg: json['fmc_to_ecg'] as String?,
      doorToNeedle: json['door_to_needle'] as String?,
      doorToBalloon: json['door_to_balloon'] as String?,
      totalIschemicTime: json['total_ischemic_time'] as int?,
      icuAdmission: json['icu_admission'] as bool?,
      hospitalStayDays: json['hospital_stay_days'] as int?,
      inHospitalComplication: json['in_hospital_complication'] as String?,
      coronoryAngiography: json['coronory_angiography'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stemi_confirmed_at': stemiConfirmedAt,
      'infarction_location': infarctionLocation,
      'loading_dose_location': loadingDoseLocation,
      'loading_dose_drug': loadingDoseDrug,
      'loading_dose_time': loadingDoseTime,
      'loading_dose_administration_date': loadingDoseAdministrationDate,
      'thrombolysis_location': thrombolysisLocation,
      'thrombolytic_agent': thrombolyticAgent,
      'thrombolysis_start': thrombolysisStart,
      'thrombolysis_end': thrombolysisEnd,
      'thrombolysis_outcome': thrombolysisOutcome,
      'thrombolysis_not_done_reason': thrombolysisNotDoneReason,
      'thrombolysis_date': thrombolysisDate,
      'treatment_strategy': treatmentStrategy,
      'conservative_management': conservativeManagement,
      'killip_risk_score': killipRiskScore,
      'planned_cag': plannedCag,
      'cath_lab_arrival': cathLabArrival,
      'balloon_inflation': balloonInflation,
      'stent_type': stentType,
      'complications': complications,
      'other_complications': otherComplications,
      'transfer_location': transferLocation,
      'counselling_id': counsellingId,
      'symptom_to_fmc': symptomToFmc,
      'fmc_to_ecg': fmcToEcg,
      'door_to_needle': doorToNeedle,
      'door_to_balloon': doorToBalloon,
      'total_ischemic_time': totalIschemicTime,
      'icu_admission': icuAdmission,
      'hospital_stay_days': hospitalStayDays,
      'in_hospital_complication': inHospitalComplication,
      'coronory_angiography': coronoryAngiography,
    };
  }
}

// -------------------------------------------------------------

class NstemiData {
  final NstemiTreatment? treatment;
  final Outcome? outcome;

  NstemiData({this.treatment, this.outcome});

  factory NstemiData.fromJson(Map<String, dynamic> json) {
    return NstemiData(
      treatment: json['treatment'] != null
          ? NstemiTreatment.fromJson(json['treatment'] as Map<String, dynamic>)
          : null,
      outcome: json['outcome'] != null
          ? Outcome.fromJson(json['outcome'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment': treatment?.toJson(),
      'outcome': outcome?.toJson(),
    };
  }
}

class NstemiTreatment {
  final int? id;
  final String? nstemiConfirmedAt;
  final String? loadingDoseLocation;
  final String? loadingDoseDrug;
  final String? loadingDoseTime;
  final String? loadingDoseAdministrationDate;
  final String? timiRiskScore;
  final String? treatmentStrategy;
  final String? conservativeManagement;
  final bool? plannedCag;
  final String? cathLabArrival;
  final String? balloonInflation;
  final String? stentType;
  final String? complications;
  final String? otherComplications;
  final String? transferLocation;
  final String? symptomToFmc;
  final String? fmcToEcg;
  final String? doorToBalloon;
  final bool? icuAdmission;
  final int? hospitalStayDays;
  final String? inHospitalComplications;
  final String? coronoryAngiography;

  NstemiTreatment({
    this.id,
    this.nstemiConfirmedAt,
    this.loadingDoseLocation,
    this.loadingDoseDrug,
    this.loadingDoseTime,
    this.loadingDoseAdministrationDate,
    this.timiRiskScore,
    this.treatmentStrategy,
    this.conservativeManagement,
    this.plannedCag,
    this.cathLabArrival,
    this.balloonInflation,
    this.stentType,
    this.complications,
    this.otherComplications,
    this.transferLocation,
    this.symptomToFmc,
    this.fmcToEcg,
    this.doorToBalloon,
    this.icuAdmission,
    this.hospitalStayDays,
    this.inHospitalComplications,
    this.coronoryAngiography,
  });

  factory NstemiTreatment.fromJson(Map<String, dynamic> json) {
    return NstemiTreatment(
      id: json['id'] as int?,
      nstemiConfirmedAt: json['nstemi_confirmed_at'] as String?,
      loadingDoseLocation: json['loading_dose_location'] as String?,
      loadingDoseDrug: json['loading_dose_drug'] as String?,
      loadingDoseTime: json['loading_dose_time'] as String?,
      loadingDoseAdministrationDate:
          json['loading_dose_administration_date'] as String?,
      timiRiskScore: json['timi_risk_score'] as String?,
      treatmentStrategy: json['treatment_strategy'] as String?,
      conservativeManagement: json['conservative_management'] as String?,
      plannedCag: json['planned_cag'] as bool?,
      cathLabArrival: json['cath_lab_arrival'] as String?,
      balloonInflation: json['balloon_inflation'] as String?,
      stentType: json['stent_type'] as String?,
      complications: json['complications'] as String?,
      otherComplications: json['other_complications'] as String?,
      transferLocation: json['transfer_location'] as String?,
      symptomToFmc: json['symptom_to_fmc'] as String?,
      fmcToEcg: json['fmc_to_ecg'] as String?,
      doorToBalloon: json['door_to_balloon'] as String?,
      icuAdmission: json['icu_admission'] as bool?,
      hospitalStayDays: json['hospital_stay_days'] as int?,
      inHospitalComplications: json['in_hospital_complications'] as String?,
      coronoryAngiography: json['coronory_angiography'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nstemi_confirmed_at': nstemiConfirmedAt,
      'loading_dose_location': loadingDoseLocation,
      'loading_dose_drug': loadingDoseDrug,
      'loading_dose_time': loadingDoseTime,
      'loading_dose_administration_date': loadingDoseAdministrationDate,
      'timi_risk_score': timiRiskScore,
      'treatment_strategy': treatmentStrategy,
      'conservative_management': conservativeManagement,
      'planned_cag': plannedCag,
      'cath_lab_arrival': cathLabArrival,
      'balloon_inflation': balloonInflation,
      'stent_type': stentType,
      'complications': complications,
      'other_complications': otherComplications,
      'transfer_location': transferLocation,
      'symptom_to_fmc': symptomToFmc,
      'fmc_to_ecg': fmcToEcg,
      'door_to_balloon': doorToBalloon,
      'icu_admission': icuAdmission,
      'hospital_stay_days': hospitalStayDays,
      'in_hospital_complications': inHospitalComplications,
      'coronory_angiography': coronoryAngiography,
    };
  }
}

// -------------------------------------------------------------

class UnstableAnginaData {
  final UnstableAnginaTreatment? treatment;
  final Outcome? outcome;

  UnstableAnginaData({this.treatment, this.outcome});

  factory UnstableAnginaData.fromJson(Map<String, dynamic> json) {
    return UnstableAnginaData(
      treatment: json['treatment'] != null
          ? UnstableAnginaTreatment.fromJson(
              json['treatment'] as Map<String, dynamic>)
          : null,
      outcome: json['outcome'] != null
          ? Outcome.fromJson(json['outcome'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment': treatment?.toJson(),
      'outcome': outcome?.toJson(),
    };
  }
}

class UnstableAnginaTreatment {
  final int? id;
  final String? uaConfirmedAt;
  final String? loadingDoseLocation;
  final String? loadingDoseDrug;
  final String? loadingDoseTime;
  final String? loadingDoseAdministrationDate;
  final String? timiRiskScore;
  final String? managementId;
  final String? complications;
  final String? otherComplications;
  final String? counsellingId;
  final bool? icuAdmission;
  final int? hospitalStayDays;
  final String? inHospitalComplications;
  final String? symptomToFmc;
  final String? fmcToEcg;
  final String? doorToBalloon;
  final String? coronoryAngiography;

  UnstableAnginaTreatment({
    this.id,
    this.uaConfirmedAt,
    this.loadingDoseLocation,
    this.loadingDoseDrug,
    this.loadingDoseTime,
    this.loadingDoseAdministrationDate,
    this.timiRiskScore,
    this.managementId,
    this.complications,
    this.otherComplications,
    this.counsellingId,
    this.icuAdmission,
    this.hospitalStayDays,
    this.inHospitalComplications,
    this.symptomToFmc,
    this.fmcToEcg,
    this.doorToBalloon,
    this.coronoryAngiography,
  });

  factory UnstableAnginaTreatment.fromJson(Map<String, dynamic> json) {
    return UnstableAnginaTreatment(
      id: json['id'] as int?,
      uaConfirmedAt: json['ua_confirmed_at'] as String?,
      loadingDoseLocation: json['loading_dose_location'] as String?,
      loadingDoseDrug: json['loading_dose_drug'] as String?,
      loadingDoseTime: json['loading_dose_time'] as String?,
      loadingDoseAdministrationDate:
          json['loading_dose_administration_date'] as String?,
      timiRiskScore: json['timi_risk_score'] as String?,
      managementId: json['management_id'] as String?,
      complications: json['complications'] as String?,
      otherComplications: json['other_complications'] as String?,
      counsellingId: json['counselling_id'] as String?,
      icuAdmission: json['icu_admission'] as bool?,
      hospitalStayDays: json['hospital_stay_days'] as int?,
      inHospitalComplications: json['in_hospital_complications'] as String?,
      symptomToFmc: json['symptom_to_fmc'] as String?,
      fmcToEcg: json['fmc_to_ecg'] as String?,
      doorToBalloon: json['door_to_balloon'] as String?,
      coronoryAngiography: json['coronory_angiography'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ua_confirmed_at': uaConfirmedAt,
      'loading_dose_location': loadingDoseLocation,
      'loading_dose_drug': loadingDoseDrug,
      'loading_dose_time': loadingDoseTime,
      'loading_dose_administration_date': loadingDoseAdministrationDate,
      'timi_risk_score': timiRiskScore,
      'management_id': managementId,
      'complications': complications,
      'other_complications': otherComplications,
      'counselling_id': counsellingId,
      'icu_admission': icuAdmission,
      'hospital_stay_days': hospitalStayDays,
      'in_hospital_complications': inHospitalComplications,
      'symptom_to_fmc': symptomToFmc,
      'fmc_to_ecg': fmcToEcg,
      'door_to_balloon': doorToBalloon,
      'coronory_angiography': coronoryAngiography,
    };
  }
}

// -------------------------------------------------------------

class Outcome {
  final int? id;
  final String? outcomeType;
  final String? dischargeDatetime;
  final String? abscondedDatetime;
  final String? deathDatetime;
  final String? deathTiming;
  final String? otherDeathTiming;
  final String? causeOfDeath;
  final String? hospitalType;
  final String? destinationHospital;
  final String? referralReason;
  final String? otherReferralReason;
  final String? patientCondition;
  final String? referringDoctor;
  final String? documentedInTaeiCaseSheet;

  Outcome({
    this.id,
    this.outcomeType,
    this.dischargeDatetime,
    this.abscondedDatetime,
    this.deathDatetime,
    this.deathTiming,
    this.otherDeathTiming,
    this.causeOfDeath,
    this.hospitalType,
    this.destinationHospital,
    this.referralReason,
    this.otherReferralReason,
    this.patientCondition,
    this.referringDoctor,
    this.documentedInTaeiCaseSheet,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      id: json['id'] as int?,
      outcomeType: json['outcome_type'] as String?,
      dischargeDatetime: json['discharge_datetime'] as String?,
      abscondedDatetime: json['absconded_datetime'] as String?,
      deathDatetime: json['death_datetime'] as String?,
      deathTiming: json['death_timing'] as String?,
      otherDeathTiming: json['other_death_timing'] as String?,
      causeOfDeath: json['cause_of_death'] as String?,
      hospitalType: json['hospital_type'] as String?,
      destinationHospital: json['destination_hospital'] as String?,
      referralReason: json['referral_reason'] as String?,
      otherReferralReason: json['other_referral_reason'] as String?,
      patientCondition: json['patient_condition'] as String?,
      referringDoctor: json['referring_doctor'] as String?,
      documentedInTaeiCaseSheet:
          json['documented_in_taei_case_sheet'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outcome_type': outcomeType,
      'discharge_datetime': dischargeDatetime,
      'absconded_datetime': abscondedDatetime,
      'death_datetime': deathDatetime,
      'death_timing': deathTiming,
      'other_death_timing': otherDeathTiming,
      'cause_of_death': causeOfDeath,
      'hospital_type': hospitalType,
      'destination_hospital': destinationHospital,
      'referral_reason': referralReason,
      'other_referral_reason': otherReferralReason,
      'patient_condition': patientCondition,
      'referring_doctor': referringDoctor,
      'documented_in_taei_case_sheet': documentedInTaeiCaseSheet,
    };
  }
}
