// To parse this JSON data, do
//
//     final triageDashBoard = triageDashBoardFromJson(jsonString);

import 'dart:convert';

List<TriageDashBoard> triageDashBoardFromJson(String str) =>
    List<TriageDashBoard>.from(
        json.decode(str).map((x) => TriageDashBoard.fromJson(x)));

String triageDashBoardToJson(List<TriageDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TriageDashBoard {
  String? the108;
  String? total;
  String? red;
  String? yellow;
  String? green;
  String? black;
  String? pending;

  TriageDashBoard({
    this.the108,
    this.total,
    this.red,
    this.yellow,
    this.green,
    this.black,
    this.pending,
  });

  factory TriageDashBoard.fromJson(Map<String, dynamic> json) =>
      TriageDashBoard(
        the108: json["108"],
        total: json["total"],
        red: json["red"],
        yellow: json["yellow"],
        green: json["green"],
        black: json["black"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "108": the108,
        "total": total,
        "red": red,
        "yellow": yellow,
        "green": green,
        "black": black,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
