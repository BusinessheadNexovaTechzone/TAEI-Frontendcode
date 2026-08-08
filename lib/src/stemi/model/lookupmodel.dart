// To parse this JSON data, do
//
//     final lookUpModel = lookUpModelFromJson(jsonString);

import 'dart:convert';

lookUpModelnew lookUpModelnewFromJson(String str) => lookUpModelnew.fromJson(json.decode(str));

String lookUpModelnewToJson(lookUpModelnew data) => json.encode(data.toJson());

// medical_data.dart

class lookUpModelnew {
  List<CvRiskFactor>? cvRiskFactor;
  List<Fmc>? fmc;
  List<EcgLocation>? ecgLocation;
  List<Diagnosis>? diagnosis;
  List<SignSymptom>? signSymptom;
  List<InfarctionLocation>? infarctionLocation;
  List<LoadingDoseLocation>? loadingDoseLocation;
  List<LoadingDoseDrug>? loadingDoseDrug;
  List<ThrombolysisLocation>? thrombolysisLocation;
  List<ThrombolyticAgent>? thrombolyticAgent;
  List<ThrombolysisOutcome>? thrombolysisOutcome;
  List<TreatmentStrategy>? treatmentStrategy;
  List<ConservativeManagement>? conservativeManagement;
  List<KillipRiskScore>? killipRiskScore;
  List<TransferLocation>? transferLocation;
  List<PreDischargeCounselling>? preDischargeCounselling;
  List<StentType>? stentType;
  List<StemiComplications>? stemiComplications;
  List<OutcomeType>? outcomeType;
  List<DeathTiming>? deathTiming;
  List<HospitalType>? hospitalType;
  List<ReferralReason>? referralReason;
  List<PatientCondition>? patientCondition;
  List<NstemiLoadingDoseLocation>? nstemiLoadingDoseLocation;
  List<NstemiLoadingDoseDrug>? nstemiLoadingDoseDrug;
  List<TimiRiskScore>? timiRiskScore;
  List<NstemiTreatmentStrategy>? nstemiTreatmentStrategy;
  List<NstemiOutcomeType>? nstemiOutcomeType;
  List<NstemiDeathTiming>? nstemiDeathTiming;
  List<AgeList>? agelist;
  List<EhrId>? ehrId;
  List<StemiCathLabProcedure>? stemiCathLabProcedure;
  List<StemiCoronoryAngiography>? stemiCoronoryAngiography;
  TriageResponse? triageResponse;

  lookUpModelnew({
    this.cvRiskFactor,
    this.fmc,
    this.ecgLocation,
    this.diagnosis,
    this.signSymptom,
    this.infarctionLocation,
    this.loadingDoseLocation,
    this.loadingDoseDrug,
    this.thrombolysisLocation,
    this.thrombolyticAgent,
    this.thrombolysisOutcome,
    this.treatmentStrategy,
    this.conservativeManagement,
    this.killipRiskScore,
    this.transferLocation,
    this.preDischargeCounselling,
    this.stentType,
    this.stemiComplications,
    this.outcomeType,
    this.deathTiming,
    this.hospitalType,
    this.referralReason,
    this.patientCondition,
    this.nstemiLoadingDoseLocation,
    this.nstemiLoadingDoseDrug,
    this.timiRiskScore,
    this.nstemiTreatmentStrategy,
    this.nstemiOutcomeType,
    this.nstemiDeathTiming,
    this.agelist,
    this.ehrId,
    this.stemiCathLabProcedure,
    this.stemiCoronoryAngiography,
    this.triageResponse,
  });

  factory lookUpModelnew.fromJson(Map<String, dynamic> json) {
    return lookUpModelnew(
      cvRiskFactor: json['CvRiskFactor'] != null
          ? (json['CvRiskFactor'] as List)
          .map((e) => CvRiskFactor.fromJson(e))
          .toList()
          : null,
      fmc: json['Fmc'] != null
          ? (json['Fmc'] as List).map((e) => Fmc.fromJson(e)).toList()
          : null,
      ecgLocation: json['EcgLocation'] != null
          ? (json['EcgLocation'] as List)
          .map((e) => EcgLocation.fromJson(e))
          .toList()
          : null,
      diagnosis: json['Diagnosis'] != null
          ? (json['Diagnosis'] as List)
          .map((e) => Diagnosis.fromJson(e))
          .toList()
          : null,
      signSymptom: json['SignSymptom'] != null
          ? (json['SignSymptom'] as List)
          .map((e) => SignSymptom.fromJson(e))
          .toList()
          : null,
      infarctionLocation: json['InfarctionLocation'] != null
          ? (json['InfarctionLocation'] as List)
          .map((e) => InfarctionLocation.fromJson(e))
          .toList()
          : null,
      loadingDoseLocation: json['LoadingDoseLocation'] != null
          ? (json['LoadingDoseLocation'] as List)
          .map((e) => LoadingDoseLocation.fromJson(e))
          .toList()
          : null,
      loadingDoseDrug: json['LoadingDoseDrug'] != null
          ? (json['LoadingDoseDrug'] as List)
          .map((e) => LoadingDoseDrug.fromJson(e))
          .toList()
          : null,
      thrombolysisLocation: json['ThrombolysisLocation'] != null
          ? (json['ThrombolysisLocation'] as List)
          .map((e) => ThrombolysisLocation.fromJson(e))
          .toList()
          : null,
      thrombolyticAgent: json['ThrombolyticAgent'] != null
          ? (json['ThrombolyticAgent'] as List)
          .map((e) => ThrombolyticAgent.fromJson(e))
          .toList()
          : null,
      thrombolysisOutcome: json['ThrombolysisOutcome'] != null
          ? (json['ThrombolysisOutcome'] as List)
          .map((e) => ThrombolysisOutcome.fromJson(e))
          .toList()
          : null,
      treatmentStrategy: json['TreatmentStrategy'] != null
          ? (json['TreatmentStrategy'] as List)
          .map((e) => TreatmentStrategy.fromJson(e))
          .toList()
          : null,
      conservativeManagement: json['ConservativeManagement'] != null
          ? (json['ConservativeManagement'] as List)
          .map((e) => ConservativeManagement.fromJson(e))
          .toList()
          : null,
      killipRiskScore: json['KillipRiskScore'] != null
          ? (json['KillipRiskScore'] as List)
          .map((e) => KillipRiskScore.fromJson(e))
          .toList()
          : null,
      transferLocation: json['TransferLocation'] != null
          ? (json['TransferLocation'] as List)
          .map((e) => TransferLocation.fromJson(e))
          .toList()
          : null,
      preDischargeCounselling: json['PreDischargeCounselling'] != null
          ? (json['PreDischargeCounselling'] as List)
          .map((e) => PreDischargeCounselling.fromJson(e))
          .toList()
          : null,
      stentType: json['StentType'] != null
          ? (json['StentType'] as List)
          .map((e) => StentType.fromJson(e))
          .toList()
          : null,
      stemiComplications: json['StemiComplications'] != null
          ? (json['StemiComplications'] as List)
          .map((e) => StemiComplications.fromJson(e))
          .toList()
          : null,
      outcomeType: json['OutcomeType'] != null
          ? (json['OutcomeType'] as List)
          .map((e) => OutcomeType.fromJson(e))
          .toList()
          : null,
      deathTiming: json['DeathTiming'] != null
          ? (json['DeathTiming'] as List)
          .map((e) => DeathTiming.fromJson(e))
          .toList()
          : null,
      hospitalType: json['HospitalType'] != null
          ? (json['HospitalType'] as List)
          .map((e) => HospitalType.fromJson(e))
          .toList()
          : null,
      referralReason: json['ReferralReason'] != null
          ? (json['ReferralReason'] as List)
          .map((e) => ReferralReason.fromJson(e))
          .toList()
          : null,
      patientCondition: json['PatientCondition'] != null
          ? (json['PatientCondition'] as List)
          .map((e) => PatientCondition.fromJson(e))
          .toList()
          : null,
      nstemiLoadingDoseLocation: json['NstemiLoadingDoseLocation'] != null
          ? (json['NstemiLoadingDoseLocation'] as List)
          .map((e) => NstemiLoadingDoseLocation.fromJson(e))
          .toList()
          : null,
      nstemiLoadingDoseDrug: json['NstemiLoadingDoseDrug'] != null
          ? (json['NstemiLoadingDoseDrug'] as List)
          .map((e) => NstemiLoadingDoseDrug.fromJson(e))
          .toList()
          : null,
      timiRiskScore: json['TimiRiskScore'] != null
          ? (json['TimiRiskScore'] as List)
          .map((e) => TimiRiskScore.fromJson(e))
          .toList()
          : null,
      nstemiTreatmentStrategy: json['NstemiTreatmentStrategy'] != null
          ? (json['NstemiTreatmentStrategy'] as List)
          .map((e) => NstemiTreatmentStrategy.fromJson(e))
          .toList()
          : null,
      nstemiOutcomeType: json['NstemiOutcomeType'] != null
          ? (json['NstemiOutcomeType'] as List)
          .map((e) => NstemiOutcomeType.fromJson(e))
          .toList()
          : null,
      nstemiDeathTiming: json['NstemiDeathTiming'] != null
          ? (json['NstemiDeathTiming'] as List)
          .map((e) => NstemiDeathTiming.fromJson(e))
          .toList()
          : null,
      agelist: json['agelist'] != null
          ? (json['agelist'] as List)
          .map((e) => AgeList.fromJson(e))
          .toList()
          : null,
      ehrId: json['ehr_id'] != null
          ? (json['ehr_id'] as List)
          .map((e) => EhrId.fromJson(e))
          .toList()
          : null,
      stemiCathLabProcedure: json['StemiCathLabProcedure'] != null
          ? (json['StemiCathLabProcedure'] as List)
          .map((e) => StemiCathLabProcedure.fromJson(e))
          .toList()
          : null,
      stemiCoronoryAngiography: json['StemiCoronoryAngiograpy'] != null
          ? (json['StemiCoronoryAngiograpy'] as List)
          .map((e) => StemiCoronoryAngiography.fromJson(e))
          .toList()
          : null,
      triageResponse: json['triage_response'] != null
          ? TriageResponse.fromJson(json['triage_response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CvRiskFactor': cvRiskFactor?.map((e) => e.toJson()).toList(),
      'Fmc': fmc?.map((e) => e.toJson()).toList(),
      'EcgLocation': ecgLocation?.map((e) => e.toJson()).toList(),
      'Diagnosis': diagnosis?.map((e) => e.toJson()).toList(),
      'SignSymptom': signSymptom?.map((e) => e.toJson()).toList(),
      'InfarctionLocation': infarctionLocation?.map((e) => e.toJson()).toList(),
      'LoadingDoseLocation': loadingDoseLocation?.map((e) => e.toJson()).toList(),
      'LoadingDoseDrug': loadingDoseDrug?.map((e) => e.toJson()).toList(),
      'ThrombolysisLocation': thrombolysisLocation?.map((e) => e.toJson()).toList(),
      'ThrombolyticAgent': thrombolyticAgent?.map((e) => e.toJson()).toList(),
      'ThrombolysisOutcome': thrombolysisOutcome?.map((e) => e.toJson()).toList(),
      'TreatmentStrategy': treatmentStrategy?.map((e) => e.toJson()).toList(),
      'ConservativeManagement': conservativeManagement?.map((e) => e.toJson()).toList(),
      'KillipRiskScore': killipRiskScore?.map((e) => e.toJson()).toList(),
      'TransferLocation': transferLocation?.map((e) => e.toJson()).toList(),
      'PreDischargeCounselling': preDischargeCounselling?.map((e) => e.toJson()).toList(),
      'StentType': stentType?.map((e) => e.toJson()).toList(),
      'StemiComplications': stemiComplications?.map((e) => e.toJson()).toList(),
      'OutcomeType': outcomeType?.map((e) => e.toJson()).toList(),
      'DeathTiming': deathTiming?.map((e) => e.toJson()).toList(),
      'HospitalType': hospitalType?.map((e) => e.toJson()).toList(),
      'ReferralReason': referralReason?.map((e) => e.toJson()).toList(),
      'PatientCondition': patientCondition?.map((e) => e.toJson()).toList(),
      'NstemiLoadingDoseLocation': nstemiLoadingDoseLocation?.map((e) => e.toJson()).toList(),
      'NstemiLoadingDoseDrug': nstemiLoadingDoseDrug?.map((e) => e.toJson()).toList(),
      'TimiRiskScore': timiRiskScore?.map((e) => e.toJson()).toList(),
      'NstemiTreatmentStrategy': nstemiTreatmentStrategy?.map((e) => e.toJson()).toList(),
      'NstemiOutcomeType': nstemiOutcomeType?.map((e) => e.toJson()).toList(),
      'NstemiDeathTiming': nstemiDeathTiming?.map((e) => e.toJson()).toList(),
      'agelist': agelist?.map((e) => e.toJson()).toList(),
      'ehr_id': ehrId?.map((e) => e.toJson()).toList(),
      'StemiCathLabProcedure': stemiCathLabProcedure?.map((e) => e.toJson()).toList(),
      'StemiCoronoryAngiograpy': stemiCoronoryAngiography?.map((e) => e.toJson()).toList(),
      'triage_response': triageResponse?.toJson(),
    };
  }
}

class CvRiskFactor {
  int? id;
  String? name;

  CvRiskFactor({this.id, this.name});

  factory CvRiskFactor.fromJson(Map<String, dynamic> json) {
    return CvRiskFactor(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Fmc {
  int? id;
  String? name;

  Fmc({this.id, this.name});

  factory Fmc.fromJson(Map<String, dynamic> json) {
    return Fmc(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class EcgLocation {
  int? id;
  String? name;

  EcgLocation({this.id, this.name});

  factory EcgLocation.fromJson(Map<String, dynamic> json) {
    return EcgLocation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Diagnosis {
  int? id;
  String? name;

  Diagnosis({this.id, this.name});

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SignSymptom {
  int? id;
  String? name;

  SignSymptom({this.id, this.name});

  factory SignSymptom.fromJson(Map<String, dynamic> json) {
    return SignSymptom(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class InfarctionLocation {
  int? id;
  String? name;

  InfarctionLocation({this.id, this.name});

  factory InfarctionLocation.fromJson(Map<String, dynamic> json) {
    return InfarctionLocation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LoadingDoseLocation {
  int? id;
  String? name;

  LoadingDoseLocation({this.id, this.name});

  factory LoadingDoseLocation.fromJson(Map<String, dynamic> json) {
    return LoadingDoseLocation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LoadingDoseDrug {
  int? id;
  String? name;

  LoadingDoseDrug({this.id, this.name});

  factory LoadingDoseDrug.fromJson(Map<String, dynamic> json) {
    return LoadingDoseDrug(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ThrombolysisLocation {
  int? id;
  String? name;

  ThrombolysisLocation({this.id, this.name});

  factory ThrombolysisLocation.fromJson(Map<String, dynamic> json) {
    return ThrombolysisLocation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ThrombolyticAgent {
  int? id;
  String? name;

  ThrombolyticAgent({this.id, this.name});

  factory ThrombolyticAgent.fromJson(Map<String, dynamic> json) {
    return ThrombolyticAgent(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ThrombolysisOutcome {
  int? id;
  String? name;

  ThrombolysisOutcome({this.id, this.name});

  factory ThrombolysisOutcome.fromJson(Map<String, dynamic> json) {
    return ThrombolysisOutcome(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TreatmentStrategy {
  int? id;
  String? name;

  TreatmentStrategy({this.id, this.name});

  factory TreatmentStrategy.fromJson(Map<String, dynamic> json) {
    return TreatmentStrategy(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ConservativeManagement {
  int? id;
  String? name;

  ConservativeManagement({this.id, this.name});

  factory ConservativeManagement.fromJson(Map<String, dynamic> json) {
    return ConservativeManagement(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class KillipRiskScore {
  int? id;
  String? name;

  KillipRiskScore({this.id, this.name});

  factory KillipRiskScore.fromJson(Map<String, dynamic> json) {
    return KillipRiskScore(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TransferLocation {
  int? id;
  String? name;

  TransferLocation({this.id, this.name});

  factory TransferLocation.fromJson(Map<String, dynamic> json) {
    return TransferLocation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PreDischargeCounselling {
  int? id;
  String? name;

  PreDischargeCounselling({this.id, this.name});

  factory PreDischargeCounselling.fromJson(Map<String, dynamic> json) {
    return PreDischargeCounselling(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StentType {
  int? id;
  String? name;

  StentType({this.id, this.name});

  factory StentType.fromJson(Map<String, dynamic> json) {
    return StentType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StemiComplications {
  int? id;
  String? name;

  StemiComplications({this.id, this.name});

  factory StemiComplications.fromJson(Map<String, dynamic> json) {
    return StemiComplications(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class OutcomeType {
  int? id;
  String? name;

  OutcomeType({this.id, this.name});

  factory OutcomeType.fromJson(Map<String, dynamic> json) {
    return OutcomeType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DeathTiming {
  int? id;
  String? name;

  DeathTiming({this.id, this.name});

  factory DeathTiming.fromJson(Map<String, dynamic> json) {
    return DeathTiming(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class HospitalType {
  int? id;
  String? name;

  HospitalType({this.id, this.name});

  factory HospitalType.fromJson(Map<String, dynamic> json) {
    return HospitalType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ReferralReason {
  int? id;
  String? name;

  ReferralReason({this.id, this.name});

  factory ReferralReason.fromJson(Map<String, dynamic> json) {
    return ReferralReason(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PatientCondition {
  int? id;
  String? name;

  PatientCondition({this.id, this.name});

  factory PatientCondition.fromJson(Map<String, dynamic> json) {
    return PatientCondition(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NstemiLoadingDoseLocation {
  int? id;
  String? name;

  NstemiLoadingDoseLocation({this.id, this.name});

  factory NstemiLoadingDoseLocation.fromJson(Map<String, dynamic> json) {
    return NstemiLoadingDoseLocation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NstemiLoadingDoseDrug {
  int? id;
  String? name;

  NstemiLoadingDoseDrug({this.id, this.name});

  factory NstemiLoadingDoseDrug.fromJson(Map<String, dynamic> json) {
    return NstemiLoadingDoseDrug(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TimiRiskScore {
  int? id;
  String? name;

  TimiRiskScore({this.id, this.name});

  factory TimiRiskScore.fromJson(Map<String, dynamic> json) {
    return TimiRiskScore(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NstemiTreatmentStrategy {
  int? id;
  String? name;

  NstemiTreatmentStrategy({this.id, this.name});

  factory NstemiTreatmentStrategy.fromJson(Map<String, dynamic> json) {
    return NstemiTreatmentStrategy(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NstemiOutcomeType {
  int? id;
  String? name;

  NstemiOutcomeType({this.id, this.name});

  factory NstemiOutcomeType.fromJson(Map<String, dynamic> json) {
    return NstemiOutcomeType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class NstemiDeathTiming {
  int? id;
  String? name;

  NstemiDeathTiming({this.id, this.name});

  factory NstemiDeathTiming.fromJson(Map<String, dynamic> json) {
    return NstemiDeathTiming(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AgeList {
  int? id;
  String? name;

  AgeList({this.id, this.name});

  factory AgeList.fromJson(Map<String, dynamic> json) {
    return AgeList(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class EhrId {
  bool? id;
  String? name;

  EhrId({this.id, this.name});

  factory EhrId.fromJson(Map<String, dynamic> json) {
    return EhrId(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StemiCathLabProcedure {
  int? id;
  String? name;

  StemiCathLabProcedure({this.id, this.name});

  factory StemiCathLabProcedure.fromJson(Map<String, dynamic> json) {
    return StemiCathLabProcedure(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StemiCoronoryAngiography {
  int? id;
  String? name;

  StemiCoronoryAngiography({this.id, this.name});

  factory StemiCoronoryAngiography.fromJson(Map<String, dynamic> json) {
    return StemiCoronoryAngiography(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TriageResponse {
  List<Gender>? genders;
  List<MtSts>? mtSts;
  List<Edu>? edu;
  List<EmpSts>? empSts;
  List<Occ>? occ;
  List<Prf>? prf;
  List<Arrival>? arrival;
  List<SceneIft>? sceneIft;
  List<Srctyp>? srctyp;
  List<Ror>? ror;
  List<Cop>? cop;
  List<PoI>? poI;
  List<Ab>? ab;
  List<Burns>? burns;
  List<Pbsh>? pbsh;
  List<Script>? script;
  List<MiAcs>? miAcs;
  List<Me>? me;
  List<Se>? se;
  List<Pc>? pc;
  List<Cause>? cause;
  List<Avpu>? avpu;
  List<Bs>? bs;
  List<Tf>? tf;
  List<District>? district;
  List<State>? state;
  List<Wsi>? wsi;
  List<Rta>? rta;
  List<Rrt>? rrt;

  TriageResponse({
    this.genders,
    this.mtSts,
    this.edu,
    this.empSts,
    this.occ,
    this.prf,
    this.arrival,
    this.sceneIft,
    this.srctyp,
    this.ror,
    this.cop,
    this.poI,
    this.ab,
    this.burns,
    this.pbsh,
    this.script,
    this.miAcs,
    this.me,
    this.se,
    this.pc,
    this.cause,
    this.avpu,
    this.bs,
    this.tf,
    this.district,
    this.state,
    this.wsi,
    this.rta,
    this.rrt,
  });

  factory TriageResponse.fromJson(Map<String, dynamic> json) {
    return TriageResponse(
      genders: json['genders'] != null
          ? (json['genders'] as List)
          .map((e) => Gender.fromJson(e))
          .toList()
          : null,
      mtSts: json['MtSts'] != null
          ? (json['MtSts'] as List)
          .map((e) => MtSts.fromJson(e))
          .toList()
          : null,
      edu: json['Edu'] != null
          ? (json['Edu'] as List)
          .map((e) => Edu.fromJson(e))
          .toList()
          : null,
      empSts: json['EmpSts'] != null
          ? (json['EmpSts'] as List)
          .map((e) => EmpSts.fromJson(e))
          .toList()
          : null,
      occ: json['Occ'] != null
          ? (json['Occ'] as List)
          .map((e) => Occ.fromJson(e))
          .toList()
          : null,
      prf: json['prf'] != null
          ? (json['prf'] as List)
          .map((e) => Prf.fromJson(e))
          .toList()
          : null,
      arrival: json['Arrival'] != null
          ? (json['Arrival'] as List)
          .map((e) => Arrival.fromJson(e))
          .toList()
          : null,
      sceneIft: json['SceneIft'] != null
          ? (json['SceneIft'] as List)
          .map((e) => SceneIft.fromJson(e))
          .toList()
          : null,
      srctyp: json['Srctyp'] != null
          ? (json['Srctyp'] as List)
          .map((e) => Srctyp.fromJson(e))
          .toList()
          : null,
      ror: json['Ror'] != null
          ? (json['Ror'] as List)
          .map((e) => Ror.fromJson(e))
          .toList()
          : null,
      cop: json['Cop'] != null
          ? (json['Cop'] as List)
          .map((e) => Cop.fromJson(e))
          .toList()
          : null,
      poI: json['PoI'] != null
          ? (json['PoI'] as List)
          .map((e) => PoI.fromJson(e))
          .toList()
          : null,
      ab: json['Ab'] != null
          ? (json['Ab'] as List)
          .map((e) => Ab.fromJson(e))
          .toList()
          : null,
      burns: json['Burns'] != null
          ? (json['Burns'] as List)
          .map((e) => Burns.fromJson(e))
          .toList()
          : null,
      pbsh: json['Pbsh'] != null
          ? (json['Pbsh'] as List)
          .map((e) => Pbsh.fromJson(e))
          .toList()
          : null,
      script: json['Script'] != null
          ? (json['Script'] as List)
          .map((e) => Script.fromJson(e))
          .toList()
          : null,
      miAcs: json['MiAcs'] != null
          ? (json['MiAcs'] as List)
          .map((e) => MiAcs.fromJson(e))
          .toList()
          : null,
      me: json['Me'] != null
          ? (json['Me'] as List)
          .map((e) => Me.fromJson(e))
          .toList()
          : null,
      se: json['Se'] != null
          ? (json['Se'] as List)
          .map((e) => Se.fromJson(e))
          .toList()
          : null,
      pc: json['Pc'] != null
          ? (json['Pc'] as List)
          .map((e) => Pc.fromJson(e))
          .toList()
          : null,
      cause: json['Cause'] != null
          ? (json['Cause'] as List)
          .map((e) => Cause.fromJson(e))
          .toList()
          : null,
      avpu: json['Avpu'] != null
          ? (json['Avpu'] as List)
          .map((e) => Avpu.fromJson(e))
          .toList()
          : null,
      bs: json['Bs'] != null
          ? (json['Bs'] as List)
          .map((e) => Bs.fromJson(e))
          .toList()
          : null,
      tf: json['Tf'] != null
          ? (json['Tf'] as List)
          .map((e) => Tf.fromJson(e))
          .toList()
          : null,
      district: json['District'] != null
          ? (json['District'] as List)
          .map((e) => District.fromJson(e))
          .toList()
          : null,
      state: json['State'] != null
          ? (json['State'] as List)
          .map((e) => State.fromJson(e))
          .toList()
          : null,
      wsi: json['Wsi'] != null
          ? (json['Wsi'] as List)
          .map((e) => Wsi.fromJson(e))
          .toList()
          : null,
      rta: json['Rta'] != null
          ? (json['Rta'] as List)
          .map((e) => Rta.fromJson(e))
          .toList()
          : null,
      rrt: json['Rrt'] != null
          ? (json['Rrt'] as List)
          .map((e) => Rrt.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genders': genders?.map((e) => e.toJson()).toList(),
      'MtSts': mtSts?.map((e) => e.toJson()).toList(),
      'Edu': edu?.map((e) => e.toJson()).toList(),
      'EmpSts': empSts?.map((e) => e.toJson()).toList(),
      'Occ': occ?.map((e) => e.toJson()).toList(),
      'prf': prf?.map((e) => e.toJson()).toList(),
      'Arrival': arrival?.map((e) => e.toJson()).toList(),
      'SceneIft': sceneIft?.map((e) => e.toJson()).toList(),
      'Srctyp': srctyp?.map((e) => e.toJson()).toList(),
      'Ror': ror?.map((e) => e.toJson()).toList(),
      'Cop': cop?.map((e) => e.toJson()).toList(),
      'PoI': poI?.map((e) => e.toJson()).toList(),
      'Ab': ab?.map((e) => e.toJson()).toList(),
      'Burns': burns?.map((e) => e.toJson()).toList(),
      'Pbsh': pbsh?.map((e) => e.toJson()).toList(),
      'Script': script?.map((e) => e.toJson()).toList(),
      'MiAcs': miAcs?.map((e) => e.toJson()).toList(),
      'Me': me?.map((e) => e.toJson()).toList(),
      'Se': se?.map((e) => e.toJson()).toList(),
      'Pc': pc?.map((e) => e.toJson()).toList(),
      'Cause': cause?.map((e) => e.toJson()).toList(),
      'Avpu': avpu?.map((e) => e.toJson()).toList(),
      'Bs': bs?.map((e) => e.toJson()).toList(),
      'Tf': tf?.map((e) => e.toJson()).toList(),
      'District': district?.map((e) => e.toJson()).toList(),
      'State': state?.map((e) => e.toJson()).toList(),
      'Wsi': wsi?.map((e) => e.toJson()).toList(),
      'Rta': rta?.map((e) => e.toJson()).toList(),
      'Rrt': rrt?.map((e) => e.toJson()).toList(),
    };
  }
}

class Gender {
  int? id;
  String? name;

  Gender({this.id, this.name});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class MtSts {
  int? id;
  String? name;

  MtSts({this.id, this.name});

  factory MtSts.fromJson(Map<String, dynamic> json) {
    return MtSts(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Edu {
  int? id;
  String? name;

  Edu({this.id, this.name});

  factory Edu.fromJson(Map<String, dynamic> json) {
    return Edu(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class EmpSts {
  int? id;
  String? name;

  EmpSts({this.id, this.name});

  factory EmpSts.fromJson(Map<String, dynamic> json) {
    return EmpSts(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Occ {
  int? id;
  String? name;

  Occ({this.id, this.name});

  factory Occ.fromJson(Map<String, dynamic> json) {
    return Occ(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Prf {
  int? id;
  String? name;

  Prf({this.id, this.name});

  factory Prf.fromJson(Map<String, dynamic> json) {
    return Prf(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Arrival {
  int? id;
  String? name;

  Arrival({this.id, this.name});

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SceneIft {
  int? id;
  String? name;

  SceneIft({this.id, this.name});

  factory SceneIft.fromJson(Map<String, dynamic> json) {
    return SceneIft(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Srctyp {
  int? id;
  String? name;

  Srctyp({this.id, this.name});

  factory Srctyp.fromJson(Map<String, dynamic> json) {
    return Srctyp(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Ror {
  int? id;
  String? name;

  Ror({this.id, this.name});

  factory Ror.fromJson(Map<String, dynamic> json) {
    return Ror(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Cop {
  int? id;
  String? name;

  Cop({this.id, this.name});

  factory Cop.fromJson(Map<String, dynamic> json) {
    return Cop(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PoI {
  int? id;
  String? name;

  PoI({this.id, this.name});

  factory PoI.fromJson(Map<String, dynamic> json) {
    return PoI(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Ab {
  int? id;
  String? name;

  Ab({this.id, this.name});

  factory Ab.fromJson(Map<String, dynamic> json) {
    return Ab(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Burns {
  int? id;
  String? name;

  Burns({this.id, this.name});

  factory Burns.fromJson(Map<String, dynamic> json) {
    return Burns(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Pbsh {
  int? id;
  String? name;

  Pbsh({this.id, this.name});

  factory Pbsh.fromJson(Map<String, dynamic> json) {
    return Pbsh(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Script {
  int? id;
  String? name;

  Script({this.id, this.name});

  factory Script.fromJson(Map<String, dynamic> json) {
    return Script(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class MiAcs {
  int? id;
  String? name;

  MiAcs({this.id, this.name});

  factory MiAcs.fromJson(Map<String, dynamic> json) {
    return MiAcs(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Me {
  int? id;
  String? name;

  Me({this.id, this.name});

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Se {
  int? id;
  String? name;

  Se({this.id, this.name});

  factory Se.fromJson(Map<String, dynamic> json) {
    return Se(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Pc {
  int? id;
  String? name;

  Pc({this.id, this.name});

  factory Pc.fromJson(Map<String, dynamic> json) {
    return Pc(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Cause {
  int? id;
  String? name;

  Cause({this.id, this.name});

  factory Cause.fromJson(Map<String, dynamic> json) {
    return Cause(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Avpu {
  int? id;
  String? name;

  Avpu({this.id, this.name});

  factory Avpu.fromJson(Map<String, dynamic> json) {
    return Avpu(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Bs {
  int? id;
  String? name;

  Bs({this.id, this.name});

  factory Bs.fromJson(Map<String, dynamic> json) {
    return Bs(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Tf {
  int? id;
  String? name;

  Tf({this.id, this.name});

  factory Tf.fromJson(Map<String, dynamic> json) {
    return Tf(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class District {
  int? id;
  String? name;
  String? code;

  District({this.id, this.name, this.code});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

class State {
  int? id;
  String? name;
  String? code;

  State({this.id, this.name, this.code});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

class Wsi {
  int? id;
  String? name;

  Wsi({this.id, this.name});

  factory Wsi.fromJson(Map<String, dynamic> json) {
    return Wsi(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Rta {
  int? id;
  String? name;

  Rta({this.id, this.name});

  factory Rta.fromJson(Map<String, dynamic> json) {
    return Rta(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Rrt {
  int? id;
  String? name;

  Rrt({this.id, this.name});

  factory Rrt.fromJson(Map<String, dynamic> json) {
    return Rrt(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
