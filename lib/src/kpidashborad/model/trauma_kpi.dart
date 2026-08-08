import 'dart:convert';

DashboardTraumaData traumaDashboardModelFromJson(String str) =>
    DashboardTraumaData.fromJson(json.decode(str));

String traumaDashboardModelToJson(DashboardTraumaData data) =>
    json.encode(data.toJson());

class DashboardTraumaData {
  int? totalCases108;
  int? totalEdCases;
  int? traumaBy108;
  int? totalTrauma;
  double? avgTransportTime;
  int? traumaAdmitted;
  int? traumaDischarged;
  int? redAdmitted;
  int? redDischarged;
  int? totalTraumaFlags;
  int? totalDeath;
  int? totalCases;
  int? traumaReferredOut;
  int? referredIn;
  double? percentageReferredIn;
  int? definitiveCareWithin6hrs;
  double? averageLengthOfStay;

  DashboardTraumaData(
      {this.totalCases108,
      this.totalEdCases,
      this.traumaBy108,
      this.totalTrauma,
      this.avgTransportTime,
      this.traumaAdmitted,
      this.traumaDischarged,
      this.redAdmitted,
      this.redDischarged,
      this.totalTraumaFlags,
      this.totalDeath,
      this.totalCases,
      this.traumaReferredOut,
      this.referredIn,
      this.percentageReferredIn,
      this.definitiveCareWithin6hrs,
      this.averageLengthOfStay});

  DashboardTraumaData.fromJson(Map<String, dynamic> json) {
    totalCases108 = json['total_cases_108'];
    totalEdCases = json['total_ed_cases'];
    traumaBy108 = json['trauma_by_108'];
    totalTrauma = json['total_trauma'];
    avgTransportTime = json['avg_transport_time'];
    traumaAdmitted = json['trauma_admitted'];
    traumaDischarged = json['trauma_discharged'];
    redAdmitted = json['red_admitted'];
    redDischarged = json['red_discharged'];
    totalTraumaFlags = json['total_trauma_flags'];
    totalDeath = json['total_death'];
    totalCases = json['total_cases'];
    traumaReferredOut = json['trauma_referred_out'];
    referredIn = json['referred_in'];
    percentageReferredIn = json['percentage_referred_in'];
    definitiveCareWithin6hrs = json['definitive_care_within_6hrs'];
    averageLengthOfStay = json['average_length_of_stay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_cases_108'] = this.totalCases108;
    data['total_ed_cases'] = this.totalEdCases;
    data['trauma_by_108'] = this.traumaBy108;
    data['total_trauma'] = this.totalTrauma;
    data['avg_transport_time'] = this.avgTransportTime;
    data['trauma_admitted'] = this.traumaAdmitted;
    data['trauma_discharged'] = this.traumaDischarged;
    data['red_admitted'] = this.redAdmitted;
    data['red_discharged'] = this.redDischarged;
    data['total_trauma_flags'] = this.totalTraumaFlags;
    data['total_death'] = this.totalDeath;
    data['total_cases'] = this.totalCases;
    data['trauma_referred_out'] = this.traumaReferredOut;
    data['referred_in'] = this.referredIn;
    data['percentage_referred_in'] = this.percentageReferredIn;
    data['definitive_care_within_6hrs'] = this.definitiveCareWithin6hrs;
    data['average_length_of_stay'] = this.averageLengthOfStay;
    return data;
  }
}

/// ----------------------------
/// SAFE PARSER HELPER FUNCTIONS
/// ----------------------------

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
