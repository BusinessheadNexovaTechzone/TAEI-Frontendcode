import 'dart:convert';

DashboardData taeiDashboardModelFromJson(String str) =>
    DashboardData.fromJson(json.decode(str));

String taeiDashboardModelToJson(DashboardData data) =>
    json.encode(data.toJson());

class DashboardData {
  final int? totalCasesRegistered;
  final int? totalCasesDocumented;
  final List<CategoryCount>? categoryWiseCount;
  final List<PresentingComplaint>? top10PresentingComplaints;

  DashboardData({
    this.totalCasesRegistered,
    this.totalCasesDocumented,
    this.categoryWiseCount,
    this.top10PresentingComplaints,
  });

  factory DashboardData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DashboardData();

    return DashboardData(
      totalCasesRegistered: _toInt(json['total_cases_registered']),
      totalCasesDocumented: _toInt(json['total_cases_documented']),
      categoryWiseCount: (json['category_wise_count'] as List?)
          ?.map((e) => CategoryCount.fromJson(e ?? {}))
          .toList() ??
          [],
      top10PresentingComplaints:
      (json['top10_presenting_complaints'] as List?)
          ?.map((e) => PresentingComplaint.fromJson(e ?? {}))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_cases_registered': totalCasesRegistered,
      'total_cases_documented': totalCasesDocumented,
      'category_wise_count':
      categoryWiseCount?.map((e) => e.toJson()).toList() ?? [],
      'top10_presenting_complaints':
      top10PresentingComplaints?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class CategoryCount {
  final String? category;
  final int? totalCount;

  CategoryCount({
    this.category,
    this.totalCount,
  });

  factory CategoryCount.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CategoryCount();

    return CategoryCount(
      category: json['category']?.toString() ?? '',
      totalCount: _toInt(json['total_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'total_count': totalCount,
    };
  }
}

class PresentingComplaint {
  final String? presentingComplaint;
  final int? totalCount;

  PresentingComplaint({
    this.presentingComplaint,
    this.totalCount,
  });

  factory PresentingComplaint.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PresentingComplaint();

    return PresentingComplaint(
      presentingComplaint: json['presenting_complaint']?.toString() ?? '',
      totalCount: _toInt(json['total_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presenting_complaint': presentingComplaint,
      'total_count': totalCount,
    };
  }
}

/// ----------------------
/// SAFE PARSER HELPERS
/// ----------------------

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
