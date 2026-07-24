// To parse this JSON data, do
//
//     final bitesStingsDashBoard = bitesStingsDashBoardFromJson(jsonString);

import 'dart:convert';

List<BitesStingsDashBoard> bitesStingsDashBoardFromJson(String str) =>
    List<BitesStingsDashBoard>.from(
        json.decode(str).map((x) => BitesStingsDashBoard.fromJson(x)));

String bitesStingsDashBoardToJson(List<BitesStingsDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BitesStingsDashBoard {
  String? total;
  String? venomous;
  String? nonVenomous;
  String? ift;
  String? admitted;
  String? pending;

  BitesStingsDashBoard({
    this.total,
    this.venomous,
    this.nonVenomous,
    this.ift,
    this.admitted,
    this.pending,
  });

  factory BitesStingsDashBoard.fromJson(Map<String, dynamic> json) =>
      BitesStingsDashBoard(
        total: json["total"],
        venomous: json["venomous"],
        nonVenomous: json["non_venomous"],
        ift: json["ift"],
        admitted: json["admitted"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "venomous": venomous,
        "non_venomous": nonVenomous,
        "ift": ift,
        "admitted": admitted,
        "pending": pending,
      };

  @override
  String toString() => jsonEncode(toJson());
}
