// To parse this JSON data, do
//
//     final preHospitalInstitutionalDashboardModel = preHospitalInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

PreHospitalInstitutionalDashboardModel
    preHospitalInstitutionalDashboardModelFromJson(String str) =>
        PreHospitalInstitutionalDashboardModel.fromJson(json.decode(str));

String preHospitalInstitutionalDashboardModelToJson(
        PreHospitalInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class PreHospitalInstitutionalDashboardModel {
  Data? data;

  PreHospitalInstitutionalDashboardModel({
    this.data,
  });

  factory PreHospitalInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      PreHospitalInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Summary? summary;
  List<DistrictWiseTotal>? districtWiseTotal;
  List<EmergencyCategoryWise>? emergencyCategoryWise;

  Data({
    this.summary,
    this.districtWiseTotal,
    this.emergencyCategoryWise,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        districtWiseTotal: json["district_wise_total"] == null
            ? []
            : List<DistrictWiseTotal>.from(json["district_wise_total"]!
                .map((x) => DistrictWiseTotal.fromJson(x))),
        emergencyCategoryWise: json["emergency_category_wise"] == null
            ? []
            : List<EmergencyCategoryWise>.from(json["emergency_category_wise"]!
                .map((x) => EmergencyCategoryWise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary?.toJson(),
        "district_wise_total": districtWiseTotal == null
            ? []
            : List<dynamic>.from(districtWiseTotal!.map((x) => x.toJson())),
        "emergency_category_wise": emergencyCategoryWise == null
            ? []
            : List<dynamic>.from(emergencyCategoryWise!.map((x) => x.toJson())),
      };
}

class DistrictWiseTotal {
  String? districtName;
  int? total108Calls;

  DistrictWiseTotal({
    this.districtName,
    this.total108Calls,
  });

  factory DistrictWiseTotal.fromJson(Map<String, dynamic> json) =>
      DistrictWiseTotal(
        districtName: json["district_name"],
        total108Calls: json["total_108_calls"],
      );

  Map<String, dynamic> toJson() => {
        "district_name": districtName,
        "total_108_calls": total108Calls,
      };
}

class EmergencyCategoryWise {
  int? totalCases;
  String? emergencyCategory;

  EmergencyCategoryWise({
    this.totalCases,
    this.emergencyCategory,
  });

  factory EmergencyCategoryWise.fromJson(Map<String, dynamic> json) =>
      EmergencyCategoryWise(
        totalCases: json["total_cases"],
        emergencyCategory: json["emergency_category"],
      );

  Map<String, dynamic> toJson() => {
        "total_cases": totalCases,
        "emergency_category": emergencyCategory,
      };
}

class Summary {
  int? ift;
  int? scene;
  int? critical;
  int? the108Calls;
  int? totalCases;
  int? nonCritical;
  int? traumaCases;
  int? criticalTraumaCases;

  Summary({
    this.ift,
    this.scene,
    this.critical,
    this.the108Calls,
    this.totalCases,
    this.nonCritical,
    this.traumaCases,
    this.criticalTraumaCases,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        ift: json["ift"],
        scene: json["scene"],
        critical: json["critical"],
        the108Calls: json["108_calls"],
        totalCases: json["total_cases"],
        nonCritical: json["non_critical"],
        traumaCases: json["trauma_cases"],
        criticalTraumaCases: json["critical_trauma_cases"],
      );

  Map<String, dynamic> toJson() => {
        "ift": ift,
        "scene": scene,
        "critical": critical,
        "108_calls": the108Calls,
        "total_cases": totalCases,
        "non_critical": nonCritical,
        "trauma_cases": traumaCases,
        "critical_trauma_cases": criticalTraumaCases,
      };
}
