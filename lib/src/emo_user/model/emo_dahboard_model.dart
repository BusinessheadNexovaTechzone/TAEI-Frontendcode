// To parse this JSON data, do
//
//     final emoDashBoard = emoDashBoardFromJson(jsonString);

import 'dart:convert';

List<EmoDashBoard> emoDashBoardFromJson(String str) => List<EmoDashBoard>.from(
    json.decode(str).map((x) => EmoDashBoard.fromJson(x)));

String emoDashBoardToJson(List<EmoDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmoDashBoard {
  String? the108;
  String? total;
  String? red;
  String? yellow;
  String? green;
  String? black;
  String? pending;

  EmoDashBoard({
    this.the108,
    this.total,
    this.red,
    this.yellow,
    this.green,
    this.black,
    this.pending,
  });

  factory EmoDashBoard.fromJson(Map<String, dynamic> json) => EmoDashBoard(
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
