// To parse this JSON data, do
//
//     final traumaDashBoard = traumaDashBoardFromJson(jsonString);

import 'dart:convert';

List<TraumaDashBoard> traumaDashBoardFromJson(String str) =>
    List<TraumaDashBoard>.from(
        json.decode(str).map((x) => TraumaDashBoard.fromJson(x)));

String traumaDashBoardToJson(List<TraumaDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TraumaDashBoard {
  GetTraumaSummary? getTraumaSummary;

  TraumaDashBoard({
    this.getTraumaSummary,
  });

  factory TraumaDashBoard.fromJson(Map<String, dynamic> json) =>
      TraumaDashBoard(
        getTraumaSummary: json["get_trauma_summary"] == null
            ? null
            : GetTraumaSummary.fromJson(json["get_trauma_summary"]),
      );

  Map<String, dynamic> toJson() => {
        "get_trauma_summary": getTraumaSummary?.toJson(),
      };
  @override
  String toString() => jsonEncode(toJson());
}

class GetTraumaSummary {
  int? total;
  int? red;
  int? yellow;
  int? green;
  int? rta;
  int? admitted;
  int? pending;

  GetTraumaSummary({
    this.total,
    this.red,
    this.yellow,
    this.green,
    this.rta,
    this.admitted,
    this.pending,
  });

  factory GetTraumaSummary.fromJson(Map<String, dynamic> json) =>
      GetTraumaSummary(
        total: json["total"],
        red: json["red"],
        yellow: json["yellow"],
        green: json["green"],
        rta: json["rta"],
        admitted: json["admitted"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "red": red,
        "yellow": yellow,
        "green": green,
        "rta": rta,
        "admitted": admitted,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
