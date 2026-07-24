// To parse this JSON data, do
//
//     final triage108CaseListModel = triage108CaseListModelFromJson(jsonString);

import 'dart:convert';

Triage108CaseListModel triage108CaseListModelFromJson(String str) =>
    Triage108CaseListModel.fromJson(json.decode(str));

String triage108CaseListModelToJson(Triage108CaseListModel data) =>
    json.encode(data.toJson());

class Triage108CaseListModel {
  int? totalItems;
  int? totalPages;
  int? currentPage;
  List<CaseListData>? data;

  Triage108CaseListModel({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.data,
  });

  factory Triage108CaseListModel.fromJson(Map<String, dynamic> json) =>
      Triage108CaseListModel(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        data: json["data"] == null
            ? []
            : List<CaseListData>.from(
                json["data"]!.map((x) => CaseListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CaseListData {
  int? id;
  int? rowNum;
  dynamic triageId;
  bool? isCritical;
  int? caseId;
  bool? notReceivedCase108;
  String? patientName;
  String? districtName;
  String? baseLocation;
  String? vehicleNumber;
  String? chiefComplaint;
  String? hospitalName;
  int? personalInfoId;
  String? rtsColor;
  String? vehicleAssignedTime;
  int? nurseTriageId;
  int? requestId;
  String? callerName;
  int? age;
  String? emergencyType;
  String? emergencySubType;
  int? spo2;
  int? rr;
  double? temperature;
  int? bpDbp;
  int? bpSbp;
  int? carotidPulse;
  String? callType;
  String? sourceHospital;
  String? insertedDate;
  String? talukName;
  String? cityName;
  String? pupilSizeLeft;
  String? pupilSizeRight;
  String? loc;

  CaseListData({
    this.id,
    this.rowNum,
    this.triageId,
    this.isCritical,
    this.caseId,
    this.notReceivedCase108,
    this.patientName,
    this.districtName,
    this.baseLocation,
    this.vehicleNumber,
    this.chiefComplaint,
    this.hospitalName,
    this.personalInfoId,
    this.rtsColor,
    this.vehicleAssignedTime,
    this.nurseTriageId,
    this.requestId,
    this.callerName,
    this.age,
    this.emergencyType,
    this.emergencySubType,
    this.spo2,
    this.rr,
    this.temperature,
    this.bpDbp,
    this.bpSbp,
    this.carotidPulse,
    this.callType,
    this.sourceHospital,
    this.insertedDate,
    this.talukName,
    this.cityName,
    this.pupilSizeLeft,
    this.pupilSizeRight,
    this.loc,
  });

  factory CaseListData.fromJson(Map<String, dynamic> json) => CaseListData(
        id: json["id"],
        rowNum: json["row_num"],
        triageId: json["TriageId"],
        isCritical: json["IsCritical"],
        caseId: json["CaseId"],
        notReceivedCase108: json["NotReceivedCase108"],
        patientName: json["PatientName"],
        districtName: json["DistrictName"],
        baseLocation: json["BaseLocation"],
        vehicleNumber: json["VehicleNumber"],
        chiefComplaint: json["ChiefComplaint"],
        hospitalName: json["HospitalName"],
        personalInfoId: json["PersonalInfoId"],
        rtsColor: json["RTS_Color"],
        vehicleAssignedTime: json["VehicleAssignedTime"],
        nurseTriageId: json["NurseTriageId"],
        requestId: json["RequestId"],
        callerName: json["CallerName"],
        age: json["Age"],
        emergencyType: json["Emergency_Type"],
        emergencySubType: json["Emergency_Sub_Type"],
        spo2: json["SPO2"],
        rr: json["RR"],
        temperature: json["Temperature"]?.toDouble(),
        bpDbp: json["BP_DBP"],
        bpSbp: json["BP_SBP"],
        carotidPulse: json["CarotidPulse"],
        callType: json["CallType"],
        sourceHospital: json["SourceHospital"],
        insertedDate: json["InsertedDate"],
        talukName: json["taluk_name"],
        cityName: json["city_name"],
        pupilSizeLeft: json["PupilSize_Left"],
        pupilSizeRight: json["PupilSize_Right"],
        loc: json["loc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "row_num": rowNum,
        "TriageId": triageId,
        "IsCritical": isCritical,
        "CaseId": caseId,
        "NotReceivedCase108": notReceivedCase108,
        "PatientName": patientName,
        "DistrictName": districtName,
        "BaseLocation": baseLocation,
        "VehicleNumber": vehicleNumber,
        "ChiefComplaint": chiefComplaint,
        "HospitalName": hospitalName,
        "PersonalInfoId": personalInfoId,
        "RTS_Color": rtsColor,
        "VehicleAssignedTime": vehicleAssignedTime,
        "NurseTriageId": nurseTriageId,
        "RequestId": requestId,
        "CallerName": callerName,
        "Age": age,
        "Emergency_Type": emergencyType,
        "Emergency_Sub_Type": emergencySubType,
        "SPO2": spo2,
        "RR": rr,
        "Temperature": temperature,
        "BP_DBP": bpDbp,
        "BP_SBP": bpSbp,
        "CarotidPulse": carotidPulse,
        "CallType": callType,
        "SourceHospital": sourceHospital,
        "InsertedDate": insertedDate,
        "taluk_name": talukName,
        "city_name": cityName,
        "PupilSize_Left": pupilSizeLeft,
        "PupilSize_Right": pupilSizeRight,
        "loc": loc,
      };
}
