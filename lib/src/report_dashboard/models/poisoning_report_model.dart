// To parse this JSON data, do
//
//     final poisoningReportModel = poisoningReportModelFromJson(jsonString);

import 'dart:convert';

List<PoisoningReportModel> poisoningReportModelFromJson(String str) =>
    List<PoisoningReportModel>.from(
        json.decode(str).map((x) => PoisoningReportModel.fromJson(x)));

String poisoningReportModelToJson(List<PoisoningReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PoisoningReportModel {
  String? outMainCategory;
  String? outSubCategory;
  String? admitted;
  String? deaths;
  String? referralToHigherCenters;

  PoisoningReportModel({
    this.outMainCategory,
    this.outSubCategory,
    this.admitted,
    this.deaths,
    this.referralToHigherCenters,
  });

  factory PoisoningReportModel.fromJson(Map<String, dynamic> json) =>
      PoisoningReportModel(
        outMainCategory: json["out_main_category"],
        outSubCategory: json["out_sub_category"],
        admitted: json["admitted"],
        deaths: json["deaths"],
        referralToHigherCenters: json["referral_to_higher_centers"],
      );

  Map<String, dynamic> toJson() => {
        "out_main_category": outMainCategory,
        "out_sub_category": outSubCategory,
        "admitted": admitted,
        "deaths": deaths,
        "referral_to_higher_centers": referralToHigherCenters,
      };
}
