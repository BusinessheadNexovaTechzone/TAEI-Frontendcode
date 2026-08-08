import 'dart:convert';

BitesListResponse biteStingModelFromJson1(String str) =>
    BitesListResponse.fromJson(json.decode(str));

class BitesListResponse {
  int? totalCount;
  List<BitesRow>? rows;

  BitesListResponse({this.totalCount, this.rows});

  factory BitesListResponse.fromJson(Map<String, dynamic> json) {
    return BitesListResponse(
      totalCount: json['totalCount'] ?? 0,
      rows: json['rows'] != null
          ? List<BitesRow>.from(
          (json['rows'] as List).map((x) => BitesRow.fromJson(x)))
          : [],
    );
  }
}


class BitesRow {
  int? triageId;
  String? modeOfArrival;
  String? sceneIft;
  String? nameOfPatient;
  String? emergencyCategory;
  String? presentingComplaint;
  String? sourceHospital;
  String? destinationHospital;
  int? statusId;
  String? triageFlag;
  int? bitesStingsId;

  BitesRow({this.triageId, this.modeOfArrival, this.sceneIft, this.nameOfPatient, this.emergencyCategory,
    this.presentingComplaint, this.sourceHospital, this.destinationHospital, this.statusId, this.triageFlag, this.bitesStingsId});

  factory BitesRow.fromJson(Map<String, dynamic> json) {
    return BitesRow(
      triageId: json['triage_id'] ?? 0,
      modeOfArrival: json['mode_of_arrival'] ?? '',
      sceneIft: json['scene_ift'] ?? '',
      nameOfPatient: json['name_of_patient'] ?? '',
      emergencyCategory: json['emergency_category'] ?? '',
      presentingComplaint: json['presenting_complaint'] ?? '',
      sourceHospital: json['source_hospital'] ?? '',
      destinationHospital: json['destination_hospital'] ?? '',
      statusId: json['statusid'] ?? 0,
      triageFlag: json['triage_flag'] ?? '',
      bitesStingsId: json['bites_stings_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'triage_id': triageId ?? 0,
      'mode_of_arrival': modeOfArrival ?? '',
      'scene_ift': sceneIft ?? '',
      'name_of_patient': nameOfPatient ?? '',
      'emergency_category': emergencyCategory ?? '',
      'presenting_complaint': presentingComplaint ?? '',
      'source_hospital': sourceHospital ?? '',
      'destination_hospital': destinationHospital ?? '',
      'statusid': statusId ?? 0,
      'triage_flag': triageFlag ?? '',
      'bites_stings_id': bitesStingsId,
    };
  }
}




