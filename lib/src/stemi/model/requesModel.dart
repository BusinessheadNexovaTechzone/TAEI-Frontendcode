// import 'dart:convert';
//
// // Helper function to easily convert the main object to and from a JSON string
// String triageDataToJson(RequestModel data) => json.encode(data.toJson());
// RequestModel triageDataFromJson(String str) => RequestModel.fromJson(json.decode(str));
//
// // Main Class
// // Main Patient Triage Record
// // Main Request Model
// class RequestModel {
//   int? triageId;
//   int? patientId;
//   OpPatient? opPatient;
//   StemiAdmission? stemiAdmission;
//   StemiClinicalAssessment? stemiClinicalAssessment;
//   StemiTreatment? stemiTreatment;
//   StemiOutcome? stemiOutcome;
//   NstemiTreatment? nstemiTreatment;
//   NstemiOutcome? nstemiOutcome;
//   UnstableAnginaTreatment? unstableanginaTreatment;
//   UnstableAnginaOutcome? unstableanginaOutcome;
//   OthersTreatment? othersTreatment;
//
//   RequestModel({
//     this.triageId,
//     this.patientId,
//     this.opPatient,
//     this.stemiAdmission,
//     this.stemiClinicalAssessment,
//     this.stemiTreatment,
//     this.stemiOutcome,
//     this.nstemiTreatment,
//     this.nstemiOutcome,
//     this.unstableanginaTreatment,
//     this.unstableanginaOutcome,
//     this.othersTreatment,
//   });
//
//   factory RequestModel.fromJson(Map<String, dynamic> json) {
//     return RequestModel(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       opPatient: json['op_patient'] == null
//           ? null
//           : OpPatient.fromJson(json['op_patient']),
//       stemiAdmission: json['stemi_admission'] == null
//           ? null
//           : StemiAdmission.fromJson(json['stemi_admission']),
//       stemiClinicalAssessment: json['stemi_clinical_assessment'] == null
//           ? null
//           : StemiClinicalAssessment.fromJson(
//           json['stemi_clinical_assessment']),
//       stemiTreatment: json['stemi_treatment'] == null
//           ? null
//           : StemiTreatment.fromJson(json['stemi_treatment']),
//       stemiOutcome: json['stemi_outcome'] == null
//           ? null
//           : StemiOutcome.fromJson(json['stemi_outcome']),
//       nstemiTreatment: json['nstemi_treatment'] == null
//           ? null
//           : NstemiTreatment.fromJson(json['nstemi_treatment']),
//       nstemiOutcome: json['nstemi_outcome'] == null
//           ? null
//           : NstemiOutcome.fromJson(json['nstemi_outcome']),
//       unstableanginaTreatment: json['unstableangina_treatment'] == null
//           ? null
//           : UnstableAnginaTreatment.fromJson(
//           json['unstableangina_treatment']),
//       unstableanginaOutcome: json['unstableangina_outcome'] == null
//           ? null
//           : UnstableAnginaOutcome.fromJson(json['unstableangina_outcome']),
//       othersTreatment: json['others_treatment'] == null
//           ? null
//           : OthersTreatment.fromJson(json['others_treatment']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'op_patient': opPatient?.toJson(),
//       'stemi_admission': stemiAdmission?.toJson(),
//       'stemi_clinical_assessment': stemiClinicalAssessment?.toJson(),
//       'stemi_treatment': stemiTreatment?.toJson(),
//       'stemi_outcome': stemiOutcome?.toJson(),
//       'nstemi_treatment': nstemiTreatment?.toJson(),
//       'nstemi_outcome': nstemiOutcome?.toJson(),
//       'unstableangina_treatment': unstableanginaTreatment?.toJson(),
//       'unstableangina_outcome': unstableanginaOutcome?.toJson(),
//       'others_treatment': othersTreatment?.toJson(),
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class OpPatient {
//   String? dateTimeOfTriage;
//   String? nameOfPatient;
//   int? age;
//   int? ageYear;
//   int? ageMonth;
//   String? fathername;
//   String? mothername;
//   int? gender;
//   String? patientOpNumber;
//   int? maritalStatus;
//   String? patientMobileNumber;
//   int? education;
//   int? employmentStatus;
//   int? occupation;
//   String? income;
//   bool? patientEhrId;
//   String? cmchisCard;
//   String? abhaCard;
//   String? phrId;
//   String? hmisId;
//   String? addressLine;
//   int? district;
//   int? state;
//   String? pincode;
//   int? institutionId;
//   String? patientAdmitted;
//   String? nameOfDept;
//   String? dateTimeAdmission;
//   String? dateTimeAdmittingDep;
//   String? dateTimeSymptomOnset;
//   String? presentingComplaints;
//   String? knownCardiovascularRisk;
//   String? ecgDatetime;
//   int? ecgPerformedBy;
//   int? dignosisId;
//
//   OpPatient({
//     this.dateTimeOfTriage,
//     this.nameOfPatient,
//     this.age,
//     this.ageYear,
//     this.ageMonth,
//     this.fathername,
//     this.mothername,
//     this.gender,
//     this.patientOpNumber,
//     this.maritalStatus,
//     this.patientMobileNumber,
//     this.education,
//     this.employmentStatus,
//     this.occupation,
//     this.income,
//     this.patientEhrId,
//     this.cmchisCard,
//     this.abhaCard,
//     this.phrId,
//     this.hmisId,
//     this.addressLine,
//     this.district,
//     this.state,
//     this.pincode,
//     this.institutionId,
//     this.patientAdmitted,
//     this.nameOfDept,
//     this.dateTimeAdmission,
//     this.dateTimeAdmittingDep,
//     this.dateTimeSymptomOnset,
//     this.presentingComplaints,
//     this.knownCardiovascularRisk,
//     this.ecgDatetime,
//     this.ecgPerformedBy,
//     this.dignosisId,
//   });
//
//   factory OpPatient.fromJson(Map<String, dynamic> json) {
//     return OpPatient(
//       dateTimeOfTriage: json['date_time_of_triage'] as String?,
//       nameOfPatient: json['name_of_patient'] as String?,
//       age: json['age'] as int?,
//       ageYear: json['age_year'] as int?,
//       ageMonth: json['age_month'] as int?,
//       fathername: json['fathername'] as String?,
//       mothername: json['mothername'] as String?,
//       gender: json['gender'] as int?,
//       patientOpNumber: json['patient_op_number'] as String?,
//       maritalStatus: json['marital_status'] as int?,
//       patientMobileNumber: json['patient_mobile_number'] as String?,
//       education: json['education'] as int?,
//       employmentStatus: json['employment_status'] as int?,
//       occupation: json['occupation'] as int?,
//       income: json['income'] as String?,
//       patientEhrId: json['patient_ehr_id'] as bool?,
//       cmchisCard: json['cmchis_card'] as String?,
//       abhaCard: json['abha_card'] as String?,
//       phrId: json['phr_id'] as String?,
//       hmisId: json['hmis_id'] as String?,
//       addressLine: json['address_line'] as String?,
//       district: json['district'] as int?,
//       state: json['state'] as int?,
//       pincode: json['pincode'] as String?,
//       institutionId: json['institution_id'] as int?,
//       patientAdmitted: json['patient_admitted'] as String?,
//       nameOfDept: json['name_of_dept'] as String?,
//       dateTimeAdmission: json['date_time_admission'] as String?,
//       dateTimeAdmittingDep: json['date_time_admitting_dep'] as String?,
//       dateTimeSymptomOnset: json['date_time_symptom_onset'] as String?,
//       presentingComplaints: json['presenting_complaints'] as String?,
//       knownCardiovascularRisk: json['known_cardiovascular_risk'] as String?,
//       ecgDatetime: json['ecg_datetime'] as String?,
//       ecgPerformedBy: json['ecg_performed_by'] as int?,
//       dignosisId: json['dignosis_id'] as int?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'date_time_of_triage': dateTimeOfTriage,
//       'name_of_patient': nameOfPatient,
//       'age': age,
//       'age_year': ageYear,
//       'age_month': ageMonth,
//       'fathername': fathername,
//       'mothername': mothername,
//       'gender': gender,
//       'patient_op_number': patientOpNumber,
//       'marital_status': maritalStatus,
//       'patient_mobile_number': patientMobileNumber,
//       'education': education,
//       'employment_status': employmentStatus,
//       'occupation': occupation,
//       'income': income,
//       'patient_ehr_id': patientEhrId,
//       'cmchis_card': cmchisCard,
//       'abha_card': abhaCard,
//       'phr_id': phrId,
//       'hmis_id': hmisId,
//       'address_line': addressLine,
//       'district': district,
//       'state': state,
//       'pincode': pincode,
//       'institution_id': institutionId,
//       'patient_admitted': patientAdmitted,
//       'name_of_dept': nameOfDept,
//       'date_time_admission': dateTimeAdmission,
//       'date_time_admitting_dep': dateTimeAdmittingDep,
//       'date_time_symptom_onset': dateTimeSymptomOnset,
//       'presenting_complaints': presentingComplaints,
//       'known_cardiovascular_risk': knownCardiovascularRisk,
//       'ecg_datetime': ecgDatetime,
//       'ecg_performed_by': ecgPerformedBy,
//       'dignosis_id': dignosisId,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class StemiAdmission {
//   int? triageId;
//   bool? isAdmitted;
//   String? dateTimeEntry;
//   String? departmentName;
//   String? dateTimeAdmission;
//
//   StemiAdmission({
//     this.triageId,
//     this.isAdmitted,
//     this.dateTimeEntry,
//     this.departmentName,
//     this.dateTimeAdmission,
//   });
//
//   factory StemiAdmission.fromJson(Map<String, dynamic> json) {
//     return StemiAdmission(
//       triageId: json['triage_id'] as int?,
//       isAdmitted: json['is_admitted'] as bool?,
//       dateTimeEntry: json['date_time_entry'] as String?,
//       departmentName: json['department_name'] as String?,
//       dateTimeAdmission: json['date_time_admission'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'is_admitted': isAdmitted,
//       'date_time_entry': dateTimeEntry,
//       'department_name': departmentName,
//       'date_time_admission': dateTimeAdmission,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class StemiClinicalAssessment {
//   int? triageId;
//   String? symptomOnsetDatetime;
//   int? cvRiskFactors;
//   String? signsSymtoms;
//   String? otherSignsSymtoms;
//   int? fmcType;
//   String? fmcDatetime;
//   String? ecgDatetime;
//   int? ecgLocation;
//   int? diagnosis;
//   String? otherDignosis;
//   String? riskFactors;
//   String? otherRiskFactor;
//
//   StemiClinicalAssessment({
//     this.triageId,
//     this.symptomOnsetDatetime,
//     this.cvRiskFactors,
//     this.signsSymtoms,
//     this.otherSignsSymtoms,
//     this.fmcType,
//     this.fmcDatetime,
//     this.ecgDatetime,
//     this.ecgLocation,
//     this.diagnosis,
//     this.otherDignosis,
//     this.riskFactors,
//     this.otherRiskFactor,
//   });
//
//   factory StemiClinicalAssessment.fromJson(Map<String, dynamic> json) {
//     return StemiClinicalAssessment(
//       triageId: json['triage_id'] as int?,
//       symptomOnsetDatetime: json['symptom_onset_datetime'] as String?,
//       cvRiskFactors: json['cv_risk_factors'] as int?,
//       signsSymtoms: json['signs_symtoms'] as String?,
//       otherSignsSymtoms: json['other_signs_symtoms'] as String?,
//       fmcType: json['fmc_type'] as int?,
//       fmcDatetime: json['fmc_datetime'] as String?,
//       ecgDatetime: json['ecg_datetime'] as String?,
//       ecgLocation: json['ecg_location'] as int?,
//       diagnosis: json['diagnosis'] as int?,
//       otherDignosis: json['other_dignosis'] as String?,
//       riskFactors: json['risk_factors'] as String?,
//       otherRiskFactor: json['other_risk_factor'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'symptom_onset_datetime': symptomOnsetDatetime,
//       'cv_risk_factors': cvRiskFactors,
//       'signs_symtoms': signsSymtoms,
//       'other_signs_symtoms': otherSignsSymtoms,
//       'fmc_type': fmcType,
//       'fmc_datetime': fmcDatetime,
//       'ecg_datetime': ecgDatetime,
//       'ecg_location': ecgLocation,
//       'diagnosis': diagnosis,
//       'other_dignosis': otherDignosis,
//       'risk_factors': riskFactors,
//       'other_risk_factor': otherRiskFactor,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class StemiTreatment {
//   int? triageId;
//   int? patientId;
//   String? stemiConfirmedAt;
//   int? infarctionLocationId;
//   int? loadingDoseLocationId;
//   int? loadingDoseDrugId;
//   String? loadingDoseTime;
//   int? thrombolysisLocationId;
//   int? thrombolyticAgentId;
//   String? thrombolysisStart;
//   String? thrombolysisEnd;
//   int? thrombolysisOutcomeId;
//   int? treatmentStrategyId;
//   String? managementId;
//   int? killipRiskScoreId;
//   bool? plannedCag;
//   String? cathLabArrival;
//   String? balloonInflation;
//   int? stentTypeId;
//   String? complications;
//   int? transferLocationId;
//   String? counsellingId;
//   dynamic? symptomToFmc;
//   dynamic? fmcToEcg;
//   dynamic? doorToNeedle;
//   dynamic? doorToBalloon;
//   int? totalIschemicTime;
//   bool? icuAdmission;
//   int? hospitalStayDays;
//   String? inHospitalComplication;
//   int? coronoryAngiographyId;
//   String? loadingDoseAdministrationDate;
//   String? thrombolysisDate;
//   String? thrombolysisNotDoneReason;
//   String? otherComplications;
//
//   StemiTreatment({
//     this.triageId,
//     this.patientId,
//     this.stemiConfirmedAt,
//     this.infarctionLocationId,
//     this.loadingDoseLocationId,
//     this.loadingDoseDrugId,
//     this.loadingDoseTime,
//     this.thrombolysisLocationId,
//     this.thrombolyticAgentId,
//     this.thrombolysisStart,
//     this.thrombolysisEnd,
//     this.thrombolysisOutcomeId,
//     this.treatmentStrategyId,
//     this.managementId,
//     this.killipRiskScoreId,
//     this.plannedCag,
//     this.cathLabArrival,
//     this.balloonInflation,
//     this.stentTypeId,
//     this.complications,
//     this.transferLocationId,
//     this.counsellingId,
//     this.symptomToFmc,
//     this.fmcToEcg,
//     this.doorToNeedle,
//     this.doorToBalloon,
//     this.totalIschemicTime,
//     this.icuAdmission,
//     this.hospitalStayDays,
//     this.inHospitalComplication,
//     this.coronoryAngiographyId,
//     this.loadingDoseAdministrationDate,
//     this.thrombolysisDate,
//     this.thrombolysisNotDoneReason,
//     this.otherComplications,
//   });
//
//   factory StemiTreatment.fromJson(Map<String, dynamic> json) {
//     return StemiTreatment(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       stemiConfirmedAt: json['stemi_confirmed_at'] as String?,
//       infarctionLocationId: json['infarction_location_id'] as int?,
//       loadingDoseLocationId: json['loading_dose_location_id'] as int?,
//       loadingDoseDrugId: json['loading_dose_drug_id'] as int?,
//       loadingDoseTime: json['loading_dose_time'] as String?,
//       thrombolysisLocationId: json['thrombolysis_location_id'] as int?,
//       thrombolyticAgentId: json['thrombolytic_agent_id'] as int?,
//       thrombolysisStart: json['thrombolysis_start'] as String?,
//       thrombolysisEnd: json['thrombolysis_end'] as String?,
//       thrombolysisOutcomeId: json['thrombolysis_outcome_id'] as int?,
//       treatmentStrategyId: json['treatment_strategy_id'] as int?,
//       managementId: json['management_id'] as String?,
//       killipRiskScoreId: json['killip_risk_score_id'] as int?,
//       plannedCag: json['planned_cag'] as bool?,
//       cathLabArrival: json['cath_lab_arrival'] as String?,
//       balloonInflation: json['balloon_inflation'] as String?,
//       stentTypeId: json['stent_type_id'] as int?,
//       complications: json['complications'] as String?,
//       transferLocationId: json['transfer_location_id'] as int?,
//       counsellingId: json['counselling_id'] as String?,
//       symptomToFmc: json['symptom_to_fmc'] as dynamic?,
//       fmcToEcg: json['fmc_to_ecg'] as dynamic?,
//       doorToNeedle: json['door_to_needle'] as dynamic?,
//       doorToBalloon: json['door_to_balloon'] as dynamic?,
//       totalIschemicTime: json['total_ischemic_time'] as int?,
//       icuAdmission: json['icu_admission'] as bool?,
//       hospitalStayDays: json['hospital_stay_days'] as int?,
//       inHospitalComplication: json['in_hospital_complication'] as String?,
//       coronoryAngiographyId: json['coronory_angiography_id'] as int?,
//       loadingDoseAdministrationDate:
//       json['loading_dose_administration_date'] as String?,
//       thrombolysisDate: json['thrombolysis_date'] as String?,
//       thrombolysisNotDoneReason:
//       json['thrombolysis_not_done_reason'] as String?,
//       otherComplications: json['other_complications'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'stemi_confirmed_at': stemiConfirmedAt,
//       'infarction_location_id': infarctionLocationId,
//       'loading_dose_location_id': loadingDoseLocationId,
//       'loading_dose_drug_id': loadingDoseDrugId,
//       'loading_dose_time': loadingDoseTime,
//       'thrombolysis_location_id': thrombolysisLocationId,
//       'thrombolytic_agent_id': thrombolyticAgentId,
//       'thrombolysis_start': thrombolysisStart,
//       'thrombolysis_end': thrombolysisEnd,
//       'thrombolysis_outcome_id': thrombolysisOutcomeId,
//       'treatment_strategy_id': treatmentStrategyId,
//       'management_id': managementId,
//       'killip_risk_score_id': killipRiskScoreId,
//       'planned_cag': plannedCag,
//       'cath_lab_arrival': cathLabArrival,
//       'balloon_inflation': balloonInflation,
//       'stent_type_id': stentTypeId,
//       'complications': complications,
//       'transfer_location_id': transferLocationId,
//       'counselling_id': counsellingId,
//       'symptom_to_fmc': symptomToFmc,
//       'fmc_to_ecg': fmcToEcg,
//       'door_to_needle': doorToNeedle,
//       'door_to_balloon': doorToBalloon,
//       'total_ischemic_time': totalIschemicTime,
//       'icu_admission': icuAdmission,
//       'hospital_stay_days': hospitalStayDays,
//       'in_hospital_complication': inHospitalComplication,
//       'coronory_angiography_id': coronoryAngiographyId,
//       'loading_dose_administration_date': loadingDoseAdministrationDate,
//       'thrombolysis_date': thrombolysisDate,
//       'thrombolysis_not_done_reason': thrombolysisNotDoneReason,
//       'other_complications': otherComplications,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class StemiOutcome {
//   int? triageId;
//   int? patientId;
//   int? outcomeTypeId;
//   String? dischargeDatetime;
//   String? abscondedDatetime;
//   String? deathDatetime;
//   int? deathTimingId;
//   String? causeOfDeath;
//   int? hospitalTypeId;
//   String? destinationHospital;
//   int? referralReasonId;
//   int? patientConditionId;
//   String? referringDoctor;
//   bool? documentedInTaeiCaseSheet;
//   String? createdAt;
//   String? updatedAt;
//   String? otherDeathTiming;
//   String? otherReferralReason;
//
//   StemiOutcome({
//     this.triageId,
//     this.patientId,
//     this.outcomeTypeId,
//     this.dischargeDatetime,
//     this.abscondedDatetime,
//     this.deathDatetime,
//     this.deathTimingId,
//     this.causeOfDeath,
//     this.hospitalTypeId,
//     this.destinationHospital,
//     this.referralReasonId,
//     this.patientConditionId,
//     this.referringDoctor,
//     this.documentedInTaeiCaseSheet,
//     this.createdAt,
//     this.updatedAt,
//     this.otherDeathTiming,
//     this.otherReferralReason,
//   });
//
//   factory StemiOutcome.fromJson(Map<String, dynamic> json) {
//     return StemiOutcome(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       outcomeTypeId: json['outcome_type_id'] as int?,
//       dischargeDatetime: json['discharge_datetime'] as String?,
//       abscondedDatetime: json['absconded_datetime'] as String?,
//       deathDatetime: json['death_datetime'] as String?,
//       deathTimingId: json['death_timing_id'] as int?,
//       causeOfDeath: json['cause_of_death'] as String?,
//       hospitalTypeId: json['hospital_type_id'] as int?,
//       destinationHospital: json['destination_hospital'] as String?,
//       referralReasonId: json['referral_reason_id'] as int?,
//       patientConditionId: json['patient_condition_id'] as int?,
//       referringDoctor: json['referring_doctor'] as String?,
//       documentedInTaeiCaseSheet:
//       json['documented_in_taei_case_sheet'] as bool?,
//       createdAt: json['created_at'] as String?,
//       updatedAt: json['updated_at'] as String?,
//       otherDeathTiming: json['other_death_timing'] as String?,
//       otherReferralReason: json['other_referral_reason'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'outcome_type_id': outcomeTypeId,
//       'discharge_datetime': dischargeDatetime,
//       'absconded_datetime': abscondedDatetime,
//       'death_datetime': deathDatetime,
//       'death_timing_id': deathTimingId,
//       'cause_of_death': causeOfDeath,
//       'hospital_type_id': hospitalTypeId,
//       'destination_hospital': destinationHospital,
//       'referral_reason_id': referralReasonId,
//       'patient_condition_id': patientConditionId,
//       'referring_doctor': referringDoctor,
//       'documented_in_taei_case_sheet': documentedInTaeiCaseSheet,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'other_death_timing': otherDeathTiming,
//       'other_referral_reason': otherReferralReason,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class NstemiTreatment {
//   int? triageId;
//   int? patientId;
//   String? nstemiConfirmedAt;
//   int? loadingDoseLocationId;
//   int? loadingDoseDrugId;
//   String? loadingDoseTime;
//   int? timiRiskScoreId;
//   int? treatmentStrategyId;
//   String? cathLabArrival;
//   String? balloonInflation;
//   int? stentTypeId;
//   String? complications;
//   int? transferLocationId;
//   dynamic? symptomToFmc;
//   dynamic? fmcToEcg;
//   bool? icuAdmission;
//   int? hospitalStayDays;
//   String? inHospitalComplications;
//   String? managementId;
//   int? coronoryAngiographyId;
//   String? counsellingId;
//   String? otherComplications;
//   String? loadingDoseAdministrationDate;
//   bool? plannedCag;
//
//   NstemiTreatment({
//     this.triageId,
//     this.patientId,
//     this.nstemiConfirmedAt,
//     this.loadingDoseLocationId,
//     this.loadingDoseDrugId,
//     this.loadingDoseTime,
//     this.timiRiskScoreId,
//     this.treatmentStrategyId,
//     this.cathLabArrival,
//     this.balloonInflation,
//     this.stentTypeId,
//     this.complications,
//     this.transferLocationId,
//     this.symptomToFmc,
//     this.fmcToEcg,
//     this.icuAdmission,
//     this.hospitalStayDays,
//     this.inHospitalComplications,
//     this.managementId,
//     this.coronoryAngiographyId,
//     this.counsellingId,
//     this.otherComplications,
//     this.loadingDoseAdministrationDate,
//     this.plannedCag,
//   });
//
//   factory NstemiTreatment.fromJson(Map<String, dynamic> json) {
//     return NstemiTreatment(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       nstemiConfirmedAt: json['nstemi_confirmed_at'] as String?,
//       loadingDoseLocationId: json['loading_dose_location_id'] as int?,
//       loadingDoseDrugId: json['loading_dose_drug_id'] as int?,
//       loadingDoseTime: json['loading_dose_time'] as String?,
//       timiRiskScoreId: json['timi_risk_score_id'] as int?,
//       treatmentStrategyId: json['treatment_strategy_id'] as int?,
//       cathLabArrival: json['cath_lab_arrival'] as String?,
//       balloonInflation: json['balloon_inflation'] as String?,
//       stentTypeId: json['stent_type_id'] as int?,
//       complications: json['complications'] as String?,
//       transferLocationId: json['transfer_location_id'] as int?,
//       symptomToFmc: json['symptom_to_fmc'] as dynamic?,
//       fmcToEcg: json['fmc_to_ecg'] as dynamic?,
//       icuAdmission: json['icu_admission'] as bool?,
//       hospitalStayDays: json['hospital_stay_days'] as int?,
//       inHospitalComplications: json['in_hospital_complications'] as String?,
//       managementId: json['management_id'] as String?,
//       coronoryAngiographyId: json['coronory_angiography_id'] as int?,
//       counsellingId: json['counselling_id'] as String?,
//       otherComplications: json['other_complications'] as String?,
//       loadingDoseAdministrationDate:
//       json['loading_dose_administration_date'] as String?,
//       plannedCag: json['planned_cag'] as bool?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'nstemi_confirmed_at': nstemiConfirmedAt,
//       'loading_dose_location_id': loadingDoseLocationId,
//       'loading_dose_drug_id': loadingDoseDrugId,
//       'loading_dose_time': loadingDoseTime,
//       'timi_risk_score_id': timiRiskScoreId,
//       'treatment_strategy_id': treatmentStrategyId,
//       'cath_lab_arrival': cathLabArrival,
//       'balloon_inflation': balloonInflation,
//       'stent_type_id': stentTypeId,
//       'complications': complications,
//       'transfer_location_id': transferLocationId,
//       'symptom_to_fmc': symptomToFmc,
//       'fmc_to_ecg': fmcToEcg,
//       'icu_admission': icuAdmission,
//       'hospital_stay_days': hospitalStayDays,
//       'in_hospital_complications': inHospitalComplications,
//       'management_id': managementId,
//       'coronory_angiography_id': coronoryAngiographyId,
//       'counselling_id': counsellingId,
//       'other_complications': otherComplications,
//       'loading_dose_administration_date': loadingDoseAdministrationDate,
//       'planned_cag': plannedCag,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class NstemiOutcome {
//   int? triageId;
//   int? patientId;
//   int? outcomeTypeId;
//   String? dischargeDatetime;
//   String? abscondedDatetime;
//   String? deathDatetime;
//   int? deathTimingId;
//   String? causeOfDeath;
//   int? hospitalTypeId;
//   String? destinationHospital;
//   int? referralReasonId;
//   int? patientConditionId;
//   String? referringDoctor;
//   bool? documentedInTaeiCaseSheet;
//   String? otherDeathTiming;
//   String? otherReferralReason;
//
//   NstemiOutcome({
//     this.triageId,
//     this.patientId,
//     this.outcomeTypeId,
//     this.dischargeDatetime,
//     this.abscondedDatetime,
//     this.deathDatetime,
//     this.deathTimingId,
//     this.causeOfDeath,
//     this.hospitalTypeId,
//     this.destinationHospital,
//     this.referralReasonId,
//     this.patientConditionId,
//     this.referringDoctor,
//     this.documentedInTaeiCaseSheet,
//     this.otherDeathTiming,
//     this.otherReferralReason,
//   });
//
//   factory NstemiOutcome.fromJson(Map<String, dynamic> json) {
//     return NstemiOutcome(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       outcomeTypeId: json['outcome_type_id'] as int?,
//       dischargeDatetime: json['discharge_datetime'] as String?,
//       abscondedDatetime: json['absconded_datetime'] as String?,
//       deathDatetime: json['death_datetime'] as String?,
//       deathTimingId: json['death_timing_id'] as int?,
//       causeOfDeath: json['cause_of_death'] as String?,
//       hospitalTypeId: json['hospital_type_id'] as int?,
//       destinationHospital: json['destination_hospital'] as String?,
//       referralReasonId: json['referral_reason_id'] as int?,
//       patientConditionId: json['patient_condition_id'] as int?,
//       referringDoctor: json['referring_doctor'] as String?,
//       documentedInTaeiCaseSheet:
//       json['documented_in_taei_case_sheet'] as bool?,
//       otherDeathTiming: json['other_death_timing'] as String?,
//       otherReferralReason: json['other_referral_reason'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'outcome_type_id': outcomeTypeId,
//       'discharge_datetime': dischargeDatetime,
//       'absconded_datetime': abscondedDatetime,
//       'death_datetime': deathDatetime,
//       'death_timing_id': deathTimingId,
//       'cause_of_death': causeOfDeath,
//       'hospital_type_id': hospitalTypeId,
//       'destination_hospital': destinationHospital,
//       'referral_reason_id': referralReasonId,
//       'patient_condition_id': patientConditionId,
//       'referring_doctor': referringDoctor,
//       'documented_in_taei_case_sheet': documentedInTaeiCaseSheet,
//       'other_death_timing': otherDeathTiming,
//       'other_referral_reason': otherReferralReason,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class UnstableAnginaTreatment {
//   int? triageId;
//   int? patientId;
//   String? nstemiConfirmedAt;
//   int? loadingDoseLocationId;
//   int? loadingDoseDrugId;
//   String? loadingDoseTime;
//   int? timiRiskScoreId;
//   int? treatmentStrategyId;
//   String? cathLabArrival;
//   String? balloonInflation;
//   int? stentTypeId;
//   String? complications;
//   int? transferLocationId;
//
//   dynamic? symptomToFmc;
//   dynamic? fmcToEcg;
//   bool? icuAdmission;
//   int? hospitalStayDays;
//   String? inHospitalComplications;
//   String? managementId;
//   String? counsellingId;
//   int? coronoryAngiographyId;
//   String? otherComplications;
//   String? loadingDoseAdministrationDate;
//   bool? plannedCag;
//
//   UnstableAnginaTreatment({
//     this.triageId,
//     this.patientId,
//     this.nstemiConfirmedAt,
//     this.loadingDoseLocationId,
//     this.loadingDoseDrugId,
//     this.loadingDoseTime,
//     this.timiRiskScoreId,
//     this.treatmentStrategyId,
//     this.cathLabArrival,
//     this.balloonInflation,
//     this.stentTypeId,
//     this.complications,
//     this.transferLocationId,
//     this.symptomToFmc,
//     this.fmcToEcg,
//     this.icuAdmission,
//     this.hospitalStayDays,
//     this.inHospitalComplications,
//     this.managementId,
//     this.counsellingId,
//     this.coronoryAngiographyId,
//     this.otherComplications,
//     this.loadingDoseAdministrationDate,
//     this.plannedCag,
//   });
//
//   factory UnstableAnginaTreatment.fromJson(Map<String, dynamic> json) {
//     return UnstableAnginaTreatment(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       nstemiConfirmedAt: json['nstemi_confirmed_at'] as String?,
//       loadingDoseLocationId: json['loading_dose_location_id'] as int?,
//       loadingDoseDrugId: json['loading_dose_drug_id'] as int?,
//       loadingDoseTime: json['loading_dose_time'] as String?,
//       timiRiskScoreId: json['timi_risk_score_id'] as int?,
//       treatmentStrategyId: json['treatment_strategy_id'] as int?,
//       cathLabArrival: json['cath_lab_arrival'] as String?,
//       balloonInflation: json['balloon_inflation'] as String?,
//       stentTypeId: json['stent_type_id'] as int?,
//       complications: json['complications'] as String?,
//       transferLocationId: json['transfer_location_id'] as int?,
//       symptomToFmc: json['symptom_to_fmc'] as dynamic?,
//       fmcToEcg: json['fmc_to_ecg'] as dynamic?,
//       icuAdmission: json['icu_admission'] as bool?,
//       hospitalStayDays: json['hospital_stay_days'] as int?,
//       inHospitalComplications: json['in_hospital_complications'] as String?,
//       managementId: json['management_id'] as String?,
//       counsellingId: json['counselling_id'] as String?,
//       coronoryAngiographyId: json['coronory_angiography_id'] as int?,
//       otherComplications: json['other_complications'] as String?,
//       loadingDoseAdministrationDate:
//       json['loading_dose_administration_date'] as String?,
//       plannedCag: json['planned_cag'] as bool?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'nstemi_confirmed_at': nstemiConfirmedAt,
//       'loading_dose_location_id': loadingDoseLocationId,
//       'loading_dose_drug_id': loadingDoseDrugId,
//       'loading_dose_time': loadingDoseTime,
//       'timi_risk_score_id': timiRiskScoreId,
//       'treatment_strategy_id': treatmentStrategyId,
//       'cath_lab_arrival': cathLabArrival,
//       'balloon_inflation': balloonInflation,
//       'stent_type_id': stentTypeId,
//       'complications': complications,
//       'transfer_location_id': transferLocationId,
//       'symptom_to_fmc': symptomToFmc,
//       'fmc_to_ecg': fmcToEcg,
//       'icu_admission': icuAdmission,
//       'hospital_stay_days': hospitalStayDays,
//       'in_hospital_complications': inHospitalComplications,
//       'management_id': managementId,
//       'counselling_id': counsellingId,
//       'coronory_angiography_id': coronoryAngiographyId,
//       'other_complications': otherComplications,
//       'loading_dose_administration_date': loadingDoseAdministrationDate,
//       'planned_cag': plannedCag,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class UnstableAnginaOutcome {
//   int? triageId;
//   int? patientId;
//   int? outcomeTypeId;
//   String? dischargeDatetime;
//   String? abscondedDatetime;
//   String? deathDatetime;
//   int? deathTimingId;
//   String? causeOfDeath;
//   int? hospitalTypeId;
//   String? destinationHospital;
//   int? referralReasonId;
//   int? patientConditionId;
//   String? referringDoctor;
//   bool? documentedInTaeiCaseSheet;
//   String? otherDeathTiming;
//   String? otherReferralReason;
//
//   UnstableAnginaOutcome({
//     this.triageId,
//     this.patientId,
//     this.outcomeTypeId,
//     this.dischargeDatetime,
//     this.abscondedDatetime,
//     this.deathDatetime,
//     this.deathTimingId,
//     this.causeOfDeath,
//     this.hospitalTypeId,
//     this.destinationHospital,
//     this.referralReasonId,
//     this.patientConditionId,
//     this.referringDoctor,
//     this.documentedInTaeiCaseSheet,
//     this.otherDeathTiming,
//     this.otherReferralReason,
//   });
//
//   factory UnstableAnginaOutcome.fromJson(Map<String, dynamic> json) {
//     return UnstableAnginaOutcome(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       outcomeTypeId: json['outcome_type_id'] as int?,
//       dischargeDatetime: json['discharge_datetime'] as String?,
//       abscondedDatetime: json['absconded_datetime'] as String?,
//       deathDatetime: json['death_datetime'] as String?,
//       deathTimingId: json['death_timing_id'] as int?,
//       causeOfDeath: json['cause_of_death'] as String?,
//       hospitalTypeId: json['hospital_type_id'] as int?,
//       destinationHospital: json['destination_hospital'] as String?,
//       referralReasonId: json['referral_reason_id'] as int?,
//       patientConditionId: json['patient_condition_id'] as int?,
//       referringDoctor: json['referring_doctor'] as String?,
//       documentedInTaeiCaseSheet:
//       json['documented_in_taei_case_sheet'] as bool?,
//       otherDeathTiming: json['other_death_timing'] as String?,
//       otherReferralReason: json['other_referral_reason'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'outcome_type_id': outcomeTypeId,
//       'discharge_datetime': dischargeDatetime,
//       'absconded_datetime': abscondedDatetime,
//       'death_datetime': deathDatetime,
//       'death_timing_id': deathTimingId,
//       'cause_of_death': causeOfDeath,
//       'hospital_type_id': hospitalTypeId,
//       'destination_hospital': destinationHospital,
//       'referral_reason_id': referralReasonId,
//       'patient_condition_id': patientConditionId,
//       'referring_doctor': referringDoctor,
//       'documented_in_taei_case_sheet': documentedInTaeiCaseSheet,
//       'other_death_timing': otherDeathTiming,
//       'other_referral_reason': otherReferralReason,
//     };
//   }
// }
//
// // --------------------------------------------------
//
// class OthersTreatment {
//   int? triageId;
//   int? patientId;
//   bool? isProcedureDone;
//   String? cathlabArrivalDate;
//   int? procedureId;
//   String? otherProcedure;
//   int? hospitalStay;
//   int? outcomeTypeId;
//   String? dischargeDatetime;
//   String? abscondedDatetime;
//   String? deathDatetime;
//   int? deathTimingId;
//   String? causeOfDeath;
//   int? hospitalTypeId;
//   String? destinationHospital;
//   int? referralReasonId;
//   int? patientConditionId;
//   String? referringDoctor;
//   bool? documentedInTaeiCaseSheet;
//   String? otherReferralReason;
//
//   OthersTreatment({
//     this.triageId,
//     this.patientId,
//     this.isProcedureDone,
//     this.cathlabArrivalDate,
//     this.procedureId,
//     this.otherProcedure,
//     this.hospitalStay,
//     this.outcomeTypeId,
//     this.dischargeDatetime,
//     this.abscondedDatetime,
//     this.deathDatetime,
//     this.deathTimingId,
//     this.causeOfDeath,
//     this.hospitalTypeId,
//     this.destinationHospital,
//     this.referralReasonId,
//     this.patientConditionId,
//     this.referringDoctor,
//     this.documentedInTaeiCaseSheet,
//     this.otherReferralReason,
//   });
//
//   factory OthersTreatment.fromJson(Map<String, dynamic> json) {
//     return OthersTreatment(
//       triageId: json['triage_id'] as int?,
//       patientId: json['patient_id'] as int?,
//       isProcedureDone: json['is_procedure_done'] as bool?,
//       cathlabArrivalDate: json['cathlab_arrival_date'] as String?,
//       procedureId: json['procedure_id'] as int?,
//       otherProcedure: json['other_procedure'] as String?,
//       hospitalStay: json['hospital_stay'] as int?,
//       outcomeTypeId: json['outcome_type_id'] as int?,
//       dischargeDatetime: json['discharge_datetime'] as String?,
//       abscondedDatetime: json['absconded_datetime'] as String?,
//       deathDatetime: json['death_datetime'] as String?,
//       deathTimingId: json['death_timing_id'] as int?,
//       causeOfDeath: json['cause_of_death'] as String?,
//       hospitalTypeId: json['hospital_type_id'] as int?,
//       destinationHospital: json['destination_hospital'] as String?,
//       referralReasonId: json['referral_reason_id'] as int?,
//       patientConditionId: json['patient_condition_id'] as int?,
//       referringDoctor: json['referring_doctor'] as String?,
//       documentedInTaeiCaseSheet:
//       json['documented_in_taei_case_sheet'] as bool?,
//       otherReferralReason: json['other_referral_reason'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'triage_id': triageId,
//       'patient_id': patientId,
//       'is_procedure_done': isProcedureDone,
//       'cathlab_arrival_date': cathlabArrivalDate,
//       'procedure_id': procedureId,
//       'other_procedure': otherProcedure,
//       'hospital_stay': hospitalStay,
//       'outcome_type_id': outcomeTypeId,
//       'discharge_datetime': dischargeDatetime,
//       'absconded_datetime': abscondedDatetime,
//       'death_datetime': deathDatetime,
//       'death_timing_id': deathTimingId,
//       'cause_of_death': causeOfDeath,
//       'hospital_type_id': hospitalTypeId,
//       'destination_hospital': destinationHospital,
//       'referral_reason_id': referralReasonId,
//       'patient_condition_id': patientConditionId,
//       'referring_doctor': referringDoctor,
//       'documented_in_taei_case_sheet': documentedInTaeiCaseSheet,
//       'other_referral_reason': otherReferralReason,
//     };
//   }
// }
//
//
//
//
//
//
//
//
//
