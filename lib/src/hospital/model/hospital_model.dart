// To parse this JSON data, do
//
//     final hospitalListModel = hospitalListModelFromJson(jsonString);

import 'dart:convert';

HospitalListModel hospitalListModelFromJson(String str) =>
    HospitalListModel.fromJson(json.decode(str));

String hospitalListModelToJson(HospitalListModel data) =>
    json.encode(data.toJson());

class HospitalListModel {
  List<Hospital>? hospitals;

  HospitalListModel({
    this.hospitals,
  });

  factory HospitalListModel.fromJson(Map<String, dynamic> json) =>
      HospitalListModel(
        hospitals: json["Hospitals"] == null
            ? []
            : List<Hospital>.from(
                json["Hospitals"]!.map((x) => Hospital.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Hospitals": hospitals == null
            ? []
            : List<dynamic>.from(hospitals!.map((x) => x.toJson())),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Hospital {
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

  Hospital({
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

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
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

  @override
  String toString() => jsonEncode(toJson());
}
