// To parse this JSON data, do
//
//     final poisoningDashBoard = poisoningDashBoardFromJson(jsonString);

import 'dart:convert';

List<PoisoningDashBoard> poisoningDashBoardFromJson(String str) =>
    List<PoisoningDashBoard>.from(
        json.decode(str).map((x) => PoisoningDashBoard.fromJson(x)));

String poisoningDashBoardToJson(List<PoisoningDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PoisoningDashBoard {
  String? total;
  String? mild;
  String? moderate;
  String? severe;
  String? ift;
  String? admitted;
  String? pending;

  PoisoningDashBoard({
    this.total,
    this.mild,
    this.moderate,
    this.severe,
    this.ift,
    this.admitted,
    this.pending,
  });

  factory PoisoningDashBoard.fromJson(Map<String, dynamic> json) =>
      PoisoningDashBoard(
        total: json["total"],
        mild: json["mild"],
        moderate: json["moderate"],
        severe: json["severe"],
        ift: json["ift"],
        admitted: json["admitted"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "mild": mild,
        "moderate": moderate,
        "severe": severe,
        "ift": ift,
        "admitted": admitted,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
