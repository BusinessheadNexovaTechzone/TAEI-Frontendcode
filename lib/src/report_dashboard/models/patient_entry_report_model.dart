import 'dart:convert';

PatientEntryReportModel patientEntryReportModelFromJson(String str) =>
    PatientEntryReportModel.fromJson(json.decode(str));

String patientEntryReportModelToJson(PatientEntryReportModel data) =>
    json.encode(data.toJson());

class PatientEntryReportModel {
  List<Datum>? data;

  PatientEntryReportModel({
    this.data,
  });

  factory PatientEntryReportModel.fromJson(Map<String, dynamic> json) =>
      PatientEntryReportModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? triageId;
  String? nameOfPatient;
  String? modeOfArrival;
  String? sceneIft;
  dynamic medicalEmergency;
  String? surgicalEmergency;
  int? statusid;
  String? triageFlag;
  int? emoId;
  int? isadult;
  int? totalCount;

  Datum({
    this.triageId,
    this.nameOfPatient,
    this.modeOfArrival,
    this.sceneIft,
    this.medicalEmergency,
    this.surgicalEmergency,
    this.statusid,
    this.triageFlag,
    this.emoId,
    this.isadult,
    this.totalCount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        triageId: json["triage_id"],
        nameOfPatient: json["name_of_patient"],
        modeOfArrival: json["mode_of_arrival"],
        sceneIft: json["scene_ift"],
        medicalEmergency: json["medical_emergency"],
        surgicalEmergency: json["surgical_emergency"],
        statusid: json["statusid"],
        triageFlag: json["triage_flag"],
        emoId: json["emo_id"],
        isadult: json["isadult"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "name_of_patient": nameOfPatient,
        "mode_of_arrival": modeOfArrival,
        "scene_ift": sceneIft,
        "medical_emergency": medicalEmergency,
        "surgical_emergency": surgicalEmergency,
        "statusid": statusid,
        "triage_flag": triageFlag,
        "emo_id": emoId,
        "isadult": isadult,
        "total_count": totalCount,
      };
}
