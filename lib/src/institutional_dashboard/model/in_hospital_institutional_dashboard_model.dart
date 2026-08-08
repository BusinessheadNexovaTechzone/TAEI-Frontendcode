// To parse this JSON data, do
//
//     final inHospitalInstitutionalDashboardModel = inHospitalInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

InHospitalInstitutionalDashboardModel
    inHospitalInstitutionalDashboardModelFromJson(String str) =>
        InHospitalInstitutionalDashboardModel.fromJson(json.decode(str));

String inHospitalInstitutionalDashboardModelToJson(
        InHospitalInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class InHospitalInstitutionalDashboardModel {
  InHospitalInstitutionalDashboardData? data;

  InHospitalInstitutionalDashboardModel({
    this.data,
  });

  factory InHospitalInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      InHospitalInstitutionalDashboardModel(
        data: json["data"] == null
            ? null
            : InHospitalInstitutionalDashboardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class InHospitalInstitutionalDashboardData {
  List<GenderWise>? genderWise;
  List<AgeWise>? ageWise;
  List<OccupationWise>? occupationWise;
  List<EducationWise>? educationWise;
  List<ModeOfArrivalWise>? modeOfArrivalWise;
  List<TriageFlag>? triageFlag;
  List<EmergenncyCategory>? emergenncyCategory;
  List<AccompaniedBy>? accompaniedBy;
  List<AlcoholStatus>? alcoholStatus;
  List<EmoOutcome>? emoOutcome;
  InjuryProfile? injuryProfile;
  List<MedicalComplaint>? medicalComplaints;
  List<SurgeryComplaint>? surgeryComplaints;
  List<PremComplaint>? premComplaints;

  InHospitalInstitutionalDashboardData({
    this.genderWise,
    this.ageWise,
    this.occupationWise,
    this.educationWise,
    this.modeOfArrivalWise,
    this.triageFlag,
    this.emergenncyCategory,
    this.accompaniedBy,
    this.alcoholStatus,
    this.emoOutcome,
    this.injuryProfile,
    this.medicalComplaints,
    this.surgeryComplaints,
    this.premComplaints,
  });

  factory InHospitalInstitutionalDashboardData.fromJson(
          Map<String, dynamic> json) =>
      InHospitalInstitutionalDashboardData(
        genderWise: json["gender_wise"] == null
            ? []
            : List<GenderWise>.from(
                json["gender_wise"]!.map((x) => GenderWise.fromJson(x))),
        ageWise: json["age_wise"] == null
            ? []
            : List<AgeWise>.from(
                json["age_wise"]!.map((x) => AgeWise.fromJson(x))),
        occupationWise: json["occupation_wise"] == null
            ? []
            : List<OccupationWise>.from(json["occupation_wise"]!
                .map((x) => OccupationWise.fromJson(x))),
        educationWise: json["education_wise"] == null
            ? []
            : List<EducationWise>.from(
                json["education_wise"]!.map((x) => EducationWise.fromJson(x))),
        modeOfArrivalWise: json["mode_of_arrival_wise"] == null
            ? []
            : List<ModeOfArrivalWise>.from(json["mode_of_arrival_wise"]!
                .map((x) => ModeOfArrivalWise.fromJson(x))),
        triageFlag: json["triage_flag"] == null
            ? []
            : List<TriageFlag>.from(
                json["triage_flag"]!.map((x) => TriageFlag.fromJson(x))),
        emergenncyCategory: json["emergenncy_category"] == null
            ? []
            : List<EmergenncyCategory>.from(json["emergenncy_category"]!
                .map((x) => EmergenncyCategory.fromJson(x))),
        accompaniedBy: json["accompanied_by"] == null
            ? []
            : List<AccompaniedBy>.from(
                json["accompanied_by"]!.map((x) => AccompaniedBy.fromJson(x))),
        alcoholStatus: json["alcohol_status"] == null
            ? []
            : List<AlcoholStatus>.from(
                json["alcohol_status"]!.map((x) => AlcoholStatus.fromJson(x))),
        emoOutcome: json["emo_outcome"] == null
            ? []
            : List<EmoOutcome>.from(
                json["emo_outcome"]!.map((x) => EmoOutcome.fromJson(x))),
        injuryProfile: json["injury_profile"] == null
            ? null
            : InjuryProfile.fromJson(json["injury_profile"]),
        medicalComplaints: json["medical_complaints"] == null
            ? []
            : List<MedicalComplaint>.from(json["medical_complaints"]!
                .map((x) => MedicalComplaint.fromJson(x))),
        surgeryComplaints: json["surgery_complaints"] == null
            ? []
            : List<SurgeryComplaint>.from(json["surgery_complaints"]!
                .map((x) => SurgeryComplaint.fromJson(x))),
        premComplaints: json["prem_complaints"] == null
            ? []
            : List<PremComplaint>.from(
                json["prem_complaints"]!.map((x) => PremComplaint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gender_wise": genderWise == null
            ? []
            : List<dynamic>.from(genderWise!.map((x) => x.toJson())),
        "age_wise": ageWise == null
            ? []
            : List<dynamic>.from(ageWise!.map((x) => x.toJson())),
        "occupation_wise": occupationWise == null
            ? []
            : List<dynamic>.from(occupationWise!.map((x) => x.toJson())),
        "education_wise": educationWise == null
            ? []
            : List<dynamic>.from(educationWise!.map((x) => x.toJson())),
        "mode_of_arrival_wise": modeOfArrivalWise == null
            ? []
            : List<dynamic>.from(modeOfArrivalWise!.map((x) => x.toJson())),
        "triage_flag": triageFlag == null
            ? []
            : List<dynamic>.from(triageFlag!.map((x) => x.toJson())),
        "emergenncy_category": emergenncyCategory == null
            ? []
            : List<dynamic>.from(emergenncyCategory!.map((x) => x.toJson())),
        "accompanied_by": accompaniedBy == null
            ? []
            : List<dynamic>.from(accompaniedBy!.map((x) => x.toJson())),
        "alcohol_status": alcoholStatus == null
            ? []
            : List<dynamic>.from(alcoholStatus!.map((x) => x.toJson())),
        "emo_outcome": emoOutcome == null
            ? []
            : List<dynamic>.from(emoOutcome!.map((x) => x.toJson())),
        "injury_profile": injuryProfile?.toJson(),
        "medical_complaints": medicalComplaints == null
            ? []
            : List<dynamic>.from(medicalComplaints!.map((x) => x.toJson())),
        "surgery_complaints": surgeryComplaints == null
            ? []
            : List<dynamic>.from(surgeryComplaints!.map((x) => x.toJson())),
        "prem_complaints": premComplaints == null
            ? []
            : List<dynamic>.from(premComplaints!.map((x) => x.toJson())),
      };
}

class AccompaniedBy {
  int? totalCount;
  String? accompaniedBy;

  AccompaniedBy({
    this.totalCount,
    this.accompaniedBy,
  });

  factory AccompaniedBy.fromJson(Map<String, dynamic> json) => AccompaniedBy(
        totalCount: json["total_count"],
        accompaniedBy: json["accompanied_by"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "accompanied_by": accompaniedBy,
      };
}

class AgeWise {
  String? ageGroup;
  int? sortOrder;
  int? totalCount;

  AgeWise({
    this.ageGroup,
    this.sortOrder,
    this.totalCount,
  });

  factory AgeWise.fromJson(Map<String, dynamic> json) => AgeWise(
        ageGroup: json["age_group"],
        sortOrder: json["sort_order"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "age_group": ageGroup,
        "sort_order": sortOrder,
        "total_count": totalCount,
      };
}

class AlcoholStatus {
  int? totalCount;
  String? alcoholStatus;

  AlcoholStatus({
    this.totalCount,
    this.alcoholStatus,
  });

  factory AlcoholStatus.fromJson(Map<String, dynamic> json) => AlcoholStatus(
        totalCount: json["total_count"],
        alcoholStatus: json["alcohol_status"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "alcohol_status": alcoholStatus,
      };
}

class EducationWise {
  String? education;
  int? totalCount;

  EducationWise({
    this.education,
    this.totalCount,
  });

  factory EducationWise.fromJson(Map<String, dynamic> json) => EducationWise(
        education: json["education"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "education": education,
        "total_count": totalCount,
      };
}

class EmergenncyCategory {
  int? totalCount;
  String? emergencyCategory;

  EmergenncyCategory({
    this.totalCount,
    this.emergencyCategory,
  });

  factory EmergenncyCategory.fromJson(Map<String, dynamic> json) =>
      EmergenncyCategory(
        totalCount: json["total_count"],
        emergencyCategory: json["emergency_category"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "emergency_category": emergencyCategory,
      };
}

class EmoOutcome {
  String? outcome;
  int? totalCount;

  EmoOutcome({
    this.outcome,
    this.totalCount,
  });

  factory EmoOutcome.fromJson(Map<String, dynamic> json) => EmoOutcome(
        outcome: json["outcome"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "outcome": outcome,
        "total_count": totalCount,
      };
}

class GenderWise {
  String? gender;
  int? totalCount;

  GenderWise({
    this.gender,
    this.totalCount,
  });

  factory GenderWise.fromJson(Map<String, dynamic> json) => GenderWise(
        gender: json["gender"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "total_count": totalCount,
      };
}

class InjuryProfile {
  int? roadTraffic;
  int? assault;
  int? fallFromHeight;

  InjuryProfile({
    this.roadTraffic,
    this.assault,
    this.fallFromHeight,
  });

  factory InjuryProfile.fromJson(Map<String, dynamic> json) => InjuryProfile(
        roadTraffic: json["road_traffic"],
        assault: json["assault"],
        fallFromHeight: json["fall_from_height"],
      );

  Map<String, dynamic> toJson() => {
        "road_traffic": roadTraffic,
        "assault": assault,
        "fall_from_height": fallFromHeight,
      };
}

class MedicalComplaint {
  int? totalCount;
  String? medicalName;

  MedicalComplaint({
    this.totalCount,
    this.medicalName,
  });

  factory MedicalComplaint.fromJson(Map<String, dynamic> json) =>
      MedicalComplaint(
        totalCount: json["total_count"],
        medicalName: json["medical_name"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "medical_name": medicalName,
      };
}

class ModeOfArrivalWise {
  int? totalCount;
  String? modeOfArrival;

  ModeOfArrivalWise({
    this.totalCount,
    this.modeOfArrival,
  });

  factory ModeOfArrivalWise.fromJson(Map<String, dynamic> json) =>
      ModeOfArrivalWise(
        totalCount: json["total_count"],
        modeOfArrival: json["mode_of_arrival"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "mode_of_arrival": modeOfArrival,
      };
}

class OccupationWise {
  String? occupation;
  int? totalCount;

  OccupationWise({
    this.occupation,
    this.totalCount,
  });

  factory OccupationWise.fromJson(Map<String, dynamic> json) => OccupationWise(
        occupation: json["occupation"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "occupation": occupation,
        "total_count": totalCount,
      };
}

class PremComplaint {
  String? premName;
  int? totalCount;

  PremComplaint({
    this.premName,
    this.totalCount,
  });

  factory PremComplaint.fromJson(Map<String, dynamic> json) => PremComplaint(
        premName: json["prem_name"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "prem_name": premName,
        "total_count": totalCount,
      };
}

class SurgeryComplaint {
  int? totalCount;
  String? surgicalName;

  SurgeryComplaint({
    this.totalCount,
    this.surgicalName,
  });

  factory SurgeryComplaint.fromJson(Map<String, dynamic> json) =>
      SurgeryComplaint(
        totalCount: json["total_count"],
        surgicalName: json["surgical_name"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "surgical_name": surgicalName,
      };
}

class TriageFlag {
  int? totalCount;
  String? triageFlag;

  TriageFlag({
    this.totalCount,
    this.triageFlag,
  });

  factory TriageFlag.fromJson(Map<String, dynamic> json) => TriageFlag(
        totalCount: json["total_count"],
        triageFlag: json["triage_flag"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "triage_flag": triageFlag,
      };
}
