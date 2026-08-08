import 'dart:convert';

PremDashboardResponse premDashboardModelFromJson(String str) =>
    PremDashboardResponse.fromJson(json.decode(str));

String premDashboardModelToJson(PremDashboardResponse data) =>
    json.encode(data.toJson());

class PremDashboardResponse {
  final PremDashboard? premDashboard;
  final List<PresentingComplaint>? top10PresentingComplaints;
  final List<MonthlyRegistration>? monthlyRegistrations;

  PremDashboardResponse({
    this.premDashboard,
    this.top10PresentingComplaints,
    this.monthlyRegistrations,
  });

  factory PremDashboardResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PremDashboardResponse();

    return PremDashboardResponse(
      premDashboard: json['prem_dashboard'] != null
          ? PremDashboard.fromJson(json['prem_dashboard'])
          : null,
      top10PresentingComplaints:
      (json['top10_presenting_complaints'] as List?)
          ?.map((e) => PresentingComplaint.fromJson(e ?? {}))
          .toList() ??
          [],
      monthlyRegistrations: (json['monthly_registrations'] as List?)
          ?.map((e) => MonthlyRegistration.fromJson(e ?? {}))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prem_dashboard': premDashboard?.toJson(),
      'top10_presenting_complaints':
      top10PresentingComplaints?.map((e) => e.toJson()).toList() ?? [],
      'monthly_registrations':
      monthlyRegistrations?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class PremDashboard {
  final int? pctTriagedInQueue;
  final double? avgTimeToFirstMedicalContactMin;
  final int? pctRedAnyIntervention;
  final int? pctStabilizedAndAdmittedToPicu;
  final int? caseFatalityRate;
  final int? pctResuscitationAmongAdmitted;
  final int? totalRegistered;
  final int? avgLengthOfStayDays;

  PremDashboard({
    this.pctTriagedInQueue,
    this.avgTimeToFirstMedicalContactMin,
    this.pctRedAnyIntervention,
    this.pctStabilizedAndAdmittedToPicu,
    this.caseFatalityRate,
    this.pctResuscitationAmongAdmitted,
    this.totalRegistered,
    this.avgLengthOfStayDays,
  });

  factory PremDashboard.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PremDashboard();

    return PremDashboard(
      pctTriagedInQueue: _toInt(json['pct_triaged_in_queue']),
      avgTimeToFirstMedicalContactMin:
      _toDouble(json['avg_time_to_first_medical_contact_min']),
      pctRedAnyIntervention: _toInt(json['pct_red_any_intervention']),
      pctStabilizedAndAdmittedToPicu:
      _toInt(json['pct_stabilized_and_admitted_to_picu']),
      caseFatalityRate: _toInt(json['case_fatality_rate']),
      pctResuscitationAmongAdmitted:
      _toInt(json['pct_resuscitation_among_admitted']),
      totalRegistered: _toInt(json['total_registered']),
      avgLengthOfStayDays: _toInt(json['avg_length_of_stay_days']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pct_triaged_in_queue': pctTriagedInQueue,
      'avg_time_to_first_medical_contact_min':
      avgTimeToFirstMedicalContactMin,
      'pct_red_any_intervention': pctRedAnyIntervention,
      'pct_stabilized_and_admitted_to_picu':
      pctStabilizedAndAdmittedToPicu,
      'case_fatality_rate': caseFatalityRate,
      'pct_resuscitation_among_admitted':
      pctResuscitationAmongAdmitted,
      'total_registered': totalRegistered,
      'avg_length_of_stay_days': avgLengthOfStayDays,
    };
  }
}

class PresentingComplaint {
  final String? presentingComplaint;
  final int? totalCases;

  PresentingComplaint({
    this.presentingComplaint,
    this.totalCases,
  });

  factory PresentingComplaint.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PresentingComplaint();

    return PresentingComplaint(
      presentingComplaint: json['presenting_complaint']?.toString() ?? '',
      totalCases: _toInt(json['total_cases']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presenting_complaint': presentingComplaint,
      'total_cases': totalCases,
    };
  }
}

class MonthlyRegistration {
  final String? month;
  final int? count;

  MonthlyRegistration({
    this.month,
    this.count,
  });

  factory MonthlyRegistration.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MonthlyRegistration();

    return MonthlyRegistration(
      month: json['month']?.toString() ?? '',
      count: _toInt(json['count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'count': count,
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

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
