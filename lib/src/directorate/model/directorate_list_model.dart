// To parse this JSON data, do
//
//     final directorateListModel = directorateListModelFromJson(jsonString);

import 'dart:convert';

List<DirectorateListModel> directorateListModelFromJson(String str) =>
    List<DirectorateListModel>.from(
        json.decode(str).map((x) => DirectorateListModel.fromJson(x)));

String directorateListModelToJson(List<DirectorateListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DirectorateListModel {
  int? id;
  String? name;
  bool? isEnabled;

  DirectorateListModel({
    this.id,
    this.name,
    this.isEnabled,
  });

  factory DirectorateListModel.fromJson(Map<String, dynamic> json) =>
      DirectorateListModel(
        id: json["id"],
        name: json["name"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_enabled": isEnabled,
      };
}
