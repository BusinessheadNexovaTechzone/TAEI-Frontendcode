// To parse this JSON data, do
//
//     final premDashBoard = premDashBoardFromJson(jsonString);

import 'dart:convert';

List<PremDashBoard> premDashBoardFromJson(String str) =>
    List<PremDashBoard>.from(
        json.decode(str).map((x) => PremDashBoard.fromJson(x)));

String premDashBoardToJson(List<PremDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PremDashBoard {
  String? total;
  String? admitted;
  String? male;
  String? female;
  String? ift;
  String? red;
  String? yellow;
  String? green;
  String? pending;

  PremDashBoard({
    this.total,
    this.admitted,
    this.male,
    this.female,
    this.ift,
    this.red,
    this.yellow,
    this.green,
    this.pending,
  });

  factory PremDashBoard.fromJson(Map<String, dynamic> json) => PremDashBoard(
        total: json["total"],
        admitted: json["admitted"],
        male: json["male"],
        female: json["female"],
        ift: json["ift"],
        red: json["red"],
        yellow: json["yellow"],
        green: json["green"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "admitted": admitted,
        "male": male,
        "female": female,
        "ift": ift,
        "red": red,
        "yellow": yellow,
        "green": green,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
