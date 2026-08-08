// To parse this JSON data, do
//
//     final transitCareResponse = transitCareResponseFromJson(jsonString);

import 'dart:convert';

TransitCareResponse transitCareResponseFromJson(String str) =>
    TransitCareResponse.fromJson(json.decode(str));

String transitCareResponseToJson(TransitCareResponse data) =>
    json.encode(data.toJson());

class TransitCareResponse {
  List<TransitCareModel>? data;
  int? pageCount;

  TransitCareResponse({
    this.data,
    this.pageCount,
  });

  factory TransitCareResponse.fromJson(Map<String, dynamic> json) =>
      TransitCareResponse(
        data: json["data"] == null
            ? []
            : List<TransitCareModel>.from(
                json["data"]!.map((x) => TransitCareModel.fromJson(x))),
        pageCount: json["Page_Count"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Page_Count": pageCount,
      };
}

class TransitCareModel {
  int? rowNum;
  String? isCritical;
  int? caseId;
  String? notReceivedCase108;
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
  String? spo2;
  String? rr;
  String? temperature;
  String? bpDbp;
  String? bpSbp;
  String? carotidPulse;
  String? callType;
  String? sourceHospital;
  String? insertedDate;

  TransitCareModel({
    this.rowNum,
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
  });

  factory TransitCareModel.fromJson(Map<String, dynamic> json) =>
      TransitCareModel(
        rowNum: json["row_num"] ?? 0,
        isCritical: json["IsCritical"] ?? "",
        caseId: json["CaseId"] ?? 0,
        notReceivedCase108: json["NotReceivedCase108"] ?? "",
        patientName: json["PatientName"] ?? "",
        districtName: json["DistrictName"] ?? "",
        baseLocation: json["BaseLocation"] ?? "",
        vehicleNumber: json["VehicleNumber"] ?? "",
        chiefComplaint: json["ChiefComplaint"] ?? "",
        hospitalName: json["HospitalName"] ?? "",
        personalInfoId: json["PersonalInfoId"] ?? 0,
        rtsColor: json["RTS_Color"] ?? "",
        vehicleAssignedTime: json["VehicleAssignedTime"],
        nurseTriageId: json["NurseTriageId"],
        requestId: json["RequestId"],
        callerName: json["CallerName"],
        age: json["Age"],
        emergencyType: json["Emergency_Type"],
        emergencySubType: json["Emergency_Sub_Type"],
        spo2: json["SPO2"],
        rr: json["RR"],
        temperature: json["Temperature"],
        bpDbp: json["BP_DBP"],
        bpSbp: json["BP_SBP"],
        carotidPulse: json["CarotidPulse"],
        callType: json["CallType"],
        sourceHospital: json["SourceHospital"],
        insertedDate: json["InsertedDate"],
      );

  Map<String, dynamic> toJson() => {
        "row_num": rowNum,
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
      };
}
