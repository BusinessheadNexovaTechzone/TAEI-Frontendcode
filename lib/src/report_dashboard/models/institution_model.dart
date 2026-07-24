// To parse this JSON data, do
//
//     final institutionModel = institutionModelFromJson(jsonString);

import 'dart:convert';

List<InstitutionModel> institutionModelFromJson(String str) =>
    List<InstitutionModel>.from(
        json.decode(str).map((x) => InstitutionModel.fromJson(x)));

String institutionModelToJson(List<InstitutionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InstitutionModel {
  int? hospitalid;
  String? districtname;
  String? hospitalname;
  int? mainhospitaltype;
  String? hospitaltype;
  String? hospitalname108;
  String? typeOfHospital;
  String? institutionCode;
  int? statecode;
  int? districtId;

  InstitutionModel({
    this.hospitalid,
    this.districtname,
    this.hospitalname,
    this.mainhospitaltype,
    this.hospitaltype,
    this.hospitalname108,
    this.typeOfHospital,
    this.institutionCode,
    this.statecode,
    this.districtId,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) =>
      InstitutionModel(
        hospitalid: json["hospitalid"],
        districtname: json["districtname"],
        hospitalname: json["hospitalname"],
        mainhospitaltype: json["mainhospitaltype"],
        hospitaltype: json["hospitaltype"],
        hospitalname108: json["hospitalname108"],
        typeOfHospital: json["type_of_hospital"],
        institutionCode: json["institution_code"],
        statecode: json["statecode"],
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "hospitalid": hospitalid,
        "districtname": districtname,
        "hospitalname": hospitalname,
        "mainhospitaltype": mainhospitaltype,
        "hospitaltype": hospitaltype,
        "hospitalname108": hospitalname108,
        "type_of_hospital": typeOfHospital,
        "institution_code": institutionCode,
        "statecode": statecode,
        "district_id": districtId,
      };
}
