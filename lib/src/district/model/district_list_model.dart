// To parse this JSON data, do
//
//     final districtListModel = districtListModelFromJson(jsonString);

import 'dart:convert';

List<DistrictListModel> districtListModelFromJson(String str) =>
    List<DistrictListModel>.from(
        json.decode(str).map((x) => DistrictListModel.fromJson(x)));

String districtListModelToJson(List<DistrictListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DistrictListModel {
  int? id;
  String? name;
  String? code;
  bool? isEnabled;

  DistrictListModel({
    this.id,
    this.name,
    this.code,
    this.isEnabled,
  });

  factory DistrictListModel.fromJson(Map<String, dynamic> json) =>
      DistrictListModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "is_enabled": isEnabled,
      };
}
