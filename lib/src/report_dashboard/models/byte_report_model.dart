// To parse this JSON data, do
//
//     final byteReportModel = byteReportModelFromJson(jsonString);

import 'dart:convert';

List<ByteReportModel> byteReportModelFromJson(String str) =>
    List<ByteReportModel>.from(
        json.decode(str).map((x) => ByteReportModel.fromJson(x)));

String byteReportModelToJson(List<ByteReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ByteReportModel {
  String? outMainCategory;
  String? outSubCategory;
  String? admitted;
  String? deaths;
  String? referralToHigherCenters;

  ByteReportModel({
    this.outMainCategory,
    this.outSubCategory,
    this.admitted,
    this.deaths,
    this.referralToHigherCenters,
  });

  factory ByteReportModel.fromJson(Map<String, dynamic> json) =>
      ByteReportModel(
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
