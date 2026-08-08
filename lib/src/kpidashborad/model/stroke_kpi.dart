import 'dart:convert';

StrokeDashboardResponse strokDashboardModelFromJson(String str) =>
    StrokeDashboardResponse.fromJson(json.decode(str));

String strokDashboardModelToJson(StrokeDashboardResponse data) =>
    json.encode(data.toJson());

class StrokeDashboardResponse {
  final StrokeDashboard? strokeDashboard;
  final List<ReferralSummary>? referralSummary;

  StrokeDashboardResponse({
    this.strokeDashboard,
    this.referralSummary,
  });

  factory StrokeDashboardResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StrokeDashboardResponse();

    return StrokeDashboardResponse(
      strokeDashboard: json['stroke_dashboard'] != null
          ? StrokeDashboard.fromJson(json['stroke_dashboard'])
          : null,
      referralSummary: (json['referral_summary'] as List?)
          ?.map((e) => ReferralSummary.fromJson(e ?? {}))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stroke_dashboard': strokeDashboard?.toJson(),
      'referral_summary':
      referralSummary?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class StrokeDashboard {
  final int? pctStrokeAdmitted;
  final double? avgDoorToCtTime;
  final int? pctIschemicThrombolyzed;
  final double? avgDoorToNeedleTime;
  final int? totalIftSpoke;
  final int? strokeMortalityRate;
  final int? pctTransferredOut;

  StrokeDashboard({
    this.pctStrokeAdmitted,
    this.avgDoorToCtTime,
    this.pctIschemicThrombolyzed,
    this.avgDoorToNeedleTime,
    this.totalIftSpoke,
    this.strokeMortalityRate,
    this.pctTransferredOut,
  });

  factory StrokeDashboard.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StrokeDashboard();

    return StrokeDashboard(
      pctStrokeAdmitted: _toInt(json['pct_stroke_admitted']),
      avgDoorToCtTime: _toDouble(json['avg_door_to_ct_time']),
      pctIschemicThrombolyzed: _toInt(json['pct_ischemic_thrombolyzed']),
      avgDoorToNeedleTime: _toDouble(json['avg_door_to_needle_time']),
      totalIftSpoke: _toInt(json['total_ift_spoke']),
      strokeMortalityRate: _toInt(json['stroke_mortality_rate']),
      pctTransferredOut: _toInt(json['pct_transferred_out']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pct_stroke_admitted': pctStrokeAdmitted,
      'avg_door_to_ct_time': avgDoorToCtTime,
      'pct_ischemic_thrombolyzed': pctIschemicThrombolyzed,
      'avg_door_to_needle_time': avgDoorToNeedleTime,
      'total_ift_spoke': totalIftSpoke,
      'stroke_mortality_rate': strokeMortalityRate,
      'pct_transferred_out': pctTransferredOut,
    };
  }
}

class ReferralSummary {
  final String? reasonForReferral;
  final int? totalCases;

  ReferralSummary({
    this.reasonForReferral,
    this.totalCases,
  });

  factory ReferralSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ReferralSummary();

    return ReferralSummary(
      reasonForReferral: json['reason_for_referral']?.toString() ?? '',
      totalCases: _toInt(json['total_cases']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason_for_referral': reasonForReferral,
      'total_cases': totalCases,
    };
  }
}

/// --------------------------
/// Safe Parsing Helper Utils
/// --------------------------

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
