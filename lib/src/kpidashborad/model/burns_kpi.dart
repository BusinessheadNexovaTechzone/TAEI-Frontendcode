import 'dart:convert';

DashboardBurnsResponse DashboardBurnsResponseFromJson(String str) =>
    DashboardBurnsResponse.fromJson(json.decode(str));

String DashboardBurnsResponseModelToJson(DashboardBurnsResponse data) =>
    json.encode(data.toJson());

class DashboardBurnsResponse {
  final BurnsDashboard? burnsDashboard;
  final List<ReferralSummary>? referralSummary;

  DashboardBurnsResponse({
    this.burnsDashboard,
    this.referralSummary,
  });

  factory DashboardBurnsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DashboardBurnsResponse();

    return DashboardBurnsResponse(
      burnsDashboard: json['burns_dashboard'] != null
          ? BurnsDashboard.fromJson(json['burns_dashboard'])
          : null,
      referralSummary: (json['referral_summary'] as List?)
          ?.map((e) => ReferralSummary.fromJson(e ?? {}))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'burns_dashboard': burnsDashboard?.toJson(),
      'referral_summary':
      referralSummary?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class BurnsDashboard {
  final int? pctFluidResuscitationWithin1Hr;
  final int? pctWoundSepsis;
  final int? pctSurvivedTbsaOver40;
  final int? inHospitalMortalityRate;
  final int? pctReferredOut;
  final int? surgicalInterventionRate;
  final int? avgLengthOfStay;

  BurnsDashboard({
    this.pctFluidResuscitationWithin1Hr,
    this.pctWoundSepsis,
    this.pctSurvivedTbsaOver40,
    this.inHospitalMortalityRate,
    this.pctReferredOut,
    this.surgicalInterventionRate,
    this.avgLengthOfStay,
  });

  factory BurnsDashboard.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BurnsDashboard();
    }

    return BurnsDashboard(
      pctFluidResuscitationWithin1Hr:
      _toInt(json['pct_fluid_resuscitation_within_1hr']),
      pctWoundSepsis: _toInt(json['pct_wound_sepsis']),
      pctSurvivedTbsaOver40: _toInt(json['pct_survived_tbsa_over_40']),
      inHospitalMortalityRate: _toInt(json['in_hospital_mortality_rate']),
      pctReferredOut: _toInt(json['pct_referred_out']),
      surgicalInterventionRate: _toInt(json['surgical_intervention_rate']),
      avgLengthOfStay: _toInt(json['avg_length_of_stay']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pct_fluid_resuscitation_within_1hr': pctFluidResuscitationWithin1Hr,
      'pct_wound_sepsis': pctWoundSepsis,
      'pct_survived_tbsa_over_40': pctSurvivedTbsaOver40,
      'in_hospital_mortality_rate': inHospitalMortalityRate,
      'pct_referred_out': pctReferredOut,
      'surgical_intervention_rate': surgicalInterventionRate,
      'avg_length_of_stay': avgLengthOfStay,
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

/// Safe integer parser (handles null, string, double, wrong data types)
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
