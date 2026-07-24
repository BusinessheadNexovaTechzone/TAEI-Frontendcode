// To parse this JSON data, do
//
//     final transitCareDashboardModel = transitCareDashboardModelFromJson(jsonString);

import 'dart:convert';

List<TransitCareDashboardModel> transitCareDashboardModelFromJson(String str) =>
    List<TransitCareDashboardModel>.from(
        json.decode(str).map((x) => TransitCareDashboardModel.fromJson(x)));

String transitCareDashboardModelToJson(List<TransitCareDashboardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransitCareDashboardModel {
  String? total;
  String? critical;
  String? nonCritical;
  String? ift;
  String? scene;
  String? emergency;
  String? admitted;
  String? pending;

  TransitCareDashboardModel({
    this.total,
    this.critical,
    this.nonCritical,
    this.ift,
    this.scene,
    this.emergency,
    this.admitted,
    this.pending,
  });

  factory TransitCareDashboardModel.fromJson(Map<String, dynamic> json) =>
      TransitCareDashboardModel(
        total: json["total"],
        critical: json["critical"],
        nonCritical: json["non_critical"],
        ift: json["ift"],
        scene: json["scene"],
        emergency: json["emergency"],
        admitted: json["admitted"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "critical": critical,
        "non_critical": nonCritical,
        "ift": ift,
        "scene": scene,
        "emergency": emergency,
        "admitted": admitted,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
