// To parse this JSON data, do
//
//     final triageListModel = triageListModelFromJson(jsonString);

import 'dart:convert';

TriageListModel triageListModelFromJson(String str) =>
    TriageListModel.fromJson(json.decode(str));

String triageListModelToJson(TriageListModel data) =>
    json.encode(data.toJson());

class TriageListModel {
  bool? success;
  int? totalCount;
  List<TriageList>? rows;

  TriageListModel({
    this.success,
    this.totalCount,
    this.rows,
  });

  factory TriageListModel.fromJson(Map<String, dynamic> json) =>
      TriageListModel(
        success: json["success"],
        totalCount: json["totalCount"],
        rows: json["rows"] == null
            ? []
            : List<TriageList>.from(
                json["rows"]!.map((x) => TriageList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "totalCount": totalCount,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class TriageList {
  int? triageId;
  String? nameOfPatient;
  String? vehicleNumber;
  String? modeOfArrival;
  String? callId;
  String? chiefComplaint;
  String? sourceHospital;
  String? destinationHospital;
  int? statusid;
  String? triageFlag;

  TriageList({
    this.triageId,
    this.nameOfPatient,
    this.vehicleNumber,
    this.modeOfArrival,
    this.callId,
    this.chiefComplaint,
    this.sourceHospital,
    this.destinationHospital,
    this.statusid,
    this.triageFlag,
  });

  factory TriageList.fromJson(Map<String, dynamic> json) => TriageList(
        triageId: json["triage_id"],
        nameOfPatient: json["name_of_patient"],
        vehicleNumber: json["vehicle_number"],
        modeOfArrival: json["mode_of_arrival"],
        callId: json["caseid"],
        chiefComplaint: json["chief_complaint"],
        sourceHospital: json["source_hospital"],
        destinationHospital: json["destination_hospital"],
        statusid: json["statusid"],
        triageFlag: json["triage_flag"],
      );

  Map<String, dynamic> toJson() => {
        "triage_id": triageId,
        "name_of_patient": nameOfPatient,
        "vehicle_number": vehicleNumber,
        "mode_of_arrival": modeOfArrival,
        "caseid": callId,
        "chief_complaint": chiefComplaint,
        "source_hospital": sourceHospital,
        "destination_hospital": destinationHospital,
        "statusid": statusid,
        "triage_flag": triageFlag,
      };

  @override
  String toString() => jsonEncode(toJson());
}
