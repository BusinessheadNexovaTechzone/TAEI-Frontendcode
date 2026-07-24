class TriageResponse {
  int? totalCount;
  List<TriageRow>? rows;

  TriageResponse({this.totalCount, this.rows});

  factory TriageResponse.fromJson(Map<String, dynamic> json) {
    return TriageResponse(
      totalCount: json['totalCount'],
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => TriageRow.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'rows': rows?.map((e) => e.toJson()).toList(),
    };
  }
}

class TriageRow {
  int? triageId;
  String? nameOfPatient;
  String? modeOfArrival;
  String? sceneIft;
  String? medicalEmergency;
  String? surgicalEmergency;
  int? statusId;
  String? triageFlag;
  int? emoId;

  TriageRow({
    this.triageId,
    this.nameOfPatient,
    this.modeOfArrival,
    this.sceneIft,
    this.medicalEmergency,
    this.surgicalEmergency,
    this.statusId,
    this.triageFlag,
    this.emoId,
  });

  factory TriageRow.fromJson(Map<String, dynamic> json) {
    return TriageRow(
      triageId: json['triage_id'],
      nameOfPatient: json['name_of_patient'],
      modeOfArrival: json['mode_of_arrival'],
      sceneIft: json['scene_ift'],
      medicalEmergency: json['medical_emergency'],
      surgicalEmergency: json['surgical_emergency'],
      statusId: json['statusid'],
      triageFlag: json['triage_flag'],
      emoId: json['emo_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'triage_id': triageId,
      'name_of_patient': nameOfPatient,
      'mode_of_arrival': modeOfArrival,
      'scene_ift': sceneIft,
      'medical_emergency': medicalEmergency,
      'surgical_emergency': surgicalEmergency,
      'statusid': statusId,
      'triage_flag': triageFlag,
      'emo_id': emoId,
    };
  }
}
