import 'dart:convert';

List<GetDrowningSummaryModel> getDrowningSummaryListFromJson(String str) =>
    List<GetDrowningSummaryModel>.from(
      json.decode(str).map((x) => GetDrowningSummaryModel.fromJson(x)),
    );

class GetDrowningSummaryModel {
  final DrowningSummary? drowningSummary;

  GetDrowningSummaryModel({
    this.drowningSummary,
  });

  factory GetDrowningSummaryModel.fromJson(Map<String, dynamic> json) {
    return GetDrowningSummaryModel(
      drowningSummary: json["get_drowning_summary"] != null
          ? DrowningSummary.fromJson(json["get_drowning_summary"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "get_drowning_summary": drowningSummary?.toJson(),
  };
}

class DrowningSummary {
  final int? total;
  final int? ift;
  final int? admitted;
  final int? pending;
  final int? mild;
  final int? moderate;
  final int? severe;

  DrowningSummary({
    this.total,
    this.ift,
    this.admitted,
    this.pending,
    this.mild,
    this.moderate,
    this.severe,
  });

  factory DrowningSummary.fromJson(Map<String, dynamic> json) {
    return DrowningSummary(
      total: json["total"],
      ift: json["ift"],
      admitted: json["admitted"],
      pending: json["pending"],
      mild: json["mild"],
      moderate: json["moderate"],
      severe: json["severe"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "ift": ift,
    "admitted": admitted,
    "pending": pending,
    "mild": mild,
    "moderate": moderate,
    "severe": severe,
  };
}
