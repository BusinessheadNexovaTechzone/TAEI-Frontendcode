// To parse this JSON data, do
//
//     final burnsDashBoard = burnsDashBoardFromJson(jsonString);

import 'dart:convert';

List<BurnsDashBoard> burnsDashBoardFromJson(String str) =>
    List<BurnsDashBoard>.from(
        json.decode(str).map((x) => BurnsDashBoard.fromJson(x)));

String burnsDashBoardToJson(List<BurnsDashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BurnsDashBoard {
  GetBurnsSummary? getBurnsSummary;

  BurnsDashBoard({
    this.getBurnsSummary,
  });

  factory BurnsDashBoard.fromJson(Map<String, dynamic> json) => BurnsDashBoard(
        getBurnsSummary: json["get_burns_summary"] == null
            ? null
            : GetBurnsSummary.fromJson(json["get_burns_summary"]),
      );

  Map<String, dynamic> toJson() => {
        "get_burns_summary": getBurnsSummary?.toJson(),
      };
  @override
  String toString() => jsonEncode(toJson());
}

class GetBurnsSummary {
  int? total;
  int? tabaGt40;
  int? tabaLt40;
  int? pediatrics;
  int? admitted;
  int? pending;

  GetBurnsSummary({
    this.total,
    this.tabaGt40,
    this.tabaLt40,
    this.pediatrics,
    this.admitted,
    this.pending,
  });

  factory GetBurnsSummary.fromJson(Map<String, dynamic> json) =>
      GetBurnsSummary(
        total: json["total"],
        tabaGt40: json["taba_gt_40"],
        tabaLt40: json["taba_lt_40"],
        pediatrics: json["pediatrics"],
        admitted: json["admitted"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "taba_gt_40": tabaGt40,
        "taba_lt_40": tabaLt40,
        "pediatrics": pediatrics,
        "admitted": admitted,
        "pending": pending,
      };
  @override
  String toString() => jsonEncode(toJson());
}
