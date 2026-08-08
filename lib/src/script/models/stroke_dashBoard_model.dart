// To parse this JSON data, do
//
//     final strokeDashBoard = strokeDashBoardFromJson(jsonString);

import 'dart:convert';

List<StrokeDashBoard> strokeDashBoardFromJson(String str) =>
    List<StrokeDashBoard>.from(
        json.decode(str).map((x) => StrokeDashBoard.fromJson(x)));

String strokeDashBoardToJson(List<StrokeDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StrokeDashBoard {
  String? total;
  String? ischemic;
  String? hemorrhagic;
  String? ift;
  String? admitted;
  String? pending;

  StrokeDashBoard({
    this.total,
    this.ischemic,
    this.hemorrhagic,
    this.ift,
    this.admitted,
    this.pending,
  });

  factory StrokeDashBoard.fromJson(Map<String, dynamic> json) =>
      StrokeDashBoard(
        total: json["total"],
        ischemic: json["ischemic"],
        hemorrhagic: json["hemorrhagic"],
        ift: json["ift"],
        admitted: json["admitted"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "ischemic": ischemic,
        "hemorrhagic": hemorrhagic,
        "ift": ift,
        "admitted": admitted,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
