// To parse this JSON data, do
//
//     final hangingDashBoard = hangingDashBoardFromJson(jsonString);

import 'dart:convert';

List<HangingDashBoard> hangingDashBoardFromJson(String str) =>
    List<HangingDashBoard>.from(
        json.decode(str).map((x) => HangingDashBoard.fromJson(x)));

String hangingDashBoardToJson(List<HangingDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HangingDashBoard {
  String? total;
  String? ift;
  String? admitted;
  String? pending;
  String? accidental;
  String? homicidal;
  String? suicidal;
  String? completeHanging;
  String? partialHanging;

  HangingDashBoard({
    this.total,
    this.ift,
    this.admitted,
    this.pending,
    this.accidental,
    this.homicidal,
    this.suicidal,
    this.completeHanging,
    this.partialHanging,
  });

  factory HangingDashBoard.fromJson(Map<String, dynamic> json) =>
      HangingDashBoard(
        total: json["total"] ?? '0',
        ift: json["ift"] ?? '0',
        admitted: json["admitted"] ?? '0',
        pending: json["pending"] ?? '0',
        accidental: json["accidental"] ?? '0',
        homicidal: json["homicidal"] ?? '0',
        suicidal: json["suicidal"] ?? '0',
        completeHanging: json["complete_hanging"] ?? '0',
        partialHanging: json["partial_hanging"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "ift": ift,
        "admitted": admitted,
        "pending": pending,
        "accidental": accidental,
        "homicidal": homicidal,
        "suicidal": suicidal,
        "complete_hanging": completeHanging,
        "partial_hanging": partialHanging,
      };
  @override
  String toString() => jsonEncode(toJson());
}
