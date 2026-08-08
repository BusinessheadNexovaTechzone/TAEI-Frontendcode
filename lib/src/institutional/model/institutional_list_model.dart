// To parse this JSON data, do
//
//     final institutionalListModel = institutionalListModelFromJson(jsonString);

import 'dart:convert';

List<InstitutionalListModel> institutionalListModelFromJson(String str) =>
    List<InstitutionalListModel>.from(
        json.decode(str).map((x) => InstitutionalListModel.fromJson(x)));

String institutionalListModelToJson(List<InstitutionalListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InstitutionalListModel {
  int? hospitalId;
  String? districtName;
  String? hospitalName;
  int? mainHospitalType;
  String? hospitalType;
  String? hospitalName108;
  String? typeOfHospital;
  String? institutionCode;
  int? stateCode;
  int? districtId;

  InstitutionalListModel({
    this.hospitalId,
    this.districtName,
    this.hospitalName,
    this.mainHospitalType,
    this.hospitalType,
    this.hospitalName108,
    this.typeOfHospital,
    this.institutionCode,
    this.stateCode,
    this.districtId,
  });

  factory InstitutionalListModel.fromJson(Map<String, dynamic> json) =>
      InstitutionalListModel(
        hospitalId: json["hospitalid"],
        districtName: json["districtname"],
        hospitalName: json["hospitalname"],
        mainHospitalType: json["mainhospitaltype"],
        hospitalType: json["hospitaltype"],
        hospitalName108: json["hospitalname108"],
        typeOfHospital: json["type_of_hospital"],
        institutionCode: json["institution_code"],
        stateCode: json["statecode"],
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "hospitalid": hospitalId,
        "districtname": districtName,
        "hospitalname": hospitalName,
        "mainhospitaltype": mainHospitalType,
        "hospitaltype": hospitalType,
        "hospitalname108": hospitalName108,
        "type_of_hospital": typeOfHospital,
        "institution_code": institutionCode,
        "statecode": stateCode,
        "district_id": districtId,
      };
}
