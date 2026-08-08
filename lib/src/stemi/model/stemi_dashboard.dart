import 'dart:convert';

List<GetStemiSummaryModel> getStemiSummaryListFromJson(String str) =>
    List<GetStemiSummaryModel>.from(
      json.decode(str).map((x) => GetStemiSummaryModel.fromJson(x)),
    );

class GetStemiSummaryModel {
  final StemiSummary? stemiSummary;

  GetStemiSummaryModel({
    this.stemiSummary,
  });

  factory GetStemiSummaryModel.fromJson(Map<String, dynamic> json) {
    return GetStemiSummaryModel(
      stemiSummary: json["get_stemi_summary"] != null
          ? StemiSummary.fromJson(json["get_stemi_summary"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "get_stemi_summary": stemiSummary?.toJson(),
  };
}

class StemiSummary {
  final int? total;
  final int? stemi;
  final int? nstemi;
  final int? usa; // unstable angina
  final int? admitted;
  final int? pending;

  StemiSummary({
    this.total,
    this.stemi,
    this.nstemi,
    this.usa,
    this.admitted,
    this.pending,
  });

  factory StemiSummary.fromJson(Map<String, dynamic> json) {
    return StemiSummary(
      total: json["total"],
      stemi: json["stemi"],
      nstemi: json["nstemi"],
      usa: json["usa"],
      admitted: json["admitted"],
      pending: json["pending"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "stemi": stemi,
    "nstemi": nstemi,
    "usa": usa,
    "admitted": admitted,
    "pending": pending,
  };
}
