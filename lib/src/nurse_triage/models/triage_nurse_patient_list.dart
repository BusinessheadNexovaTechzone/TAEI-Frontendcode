// To parse this JSON data, do
//
//     final triageNursePatientList = triageNursePatientListFromJson(jsonString);

import 'dart:convert';

TriageNursePatientList triageNursePatientListFromJson(String str) =>
    TriageNursePatientList.fromJson(json.decode(str));

String triageNursePatientListToJson(TriageNursePatientList data) =>
    json.encode(data.toJson());

class TriageNursePatientList {
  List<List<TriageNurseListData>>? data;
  int? pageCount;

  TriageNursePatientList({
    this.data,
    this.pageCount,
  });

  factory TriageNursePatientList.fromJson(Map<String, dynamic> json) =>
      TriageNursePatientList(
        data: json["data"] == null
            ? []
            : List<List<TriageNurseListData>>.from(json["data"]!.map((x) =>
                List<TriageNurseListData>.from(
                    x.map((x) => TriageNurseListData.fromJson(x))))),
        pageCount: json["Page_Count"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(
                data!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "Page_Count": pageCount,
      };
}

class TriageNurseListData {
  int? rowNum;
  dynamic patientName;
  int? caseId;
  dynamic modelOfArrival;
  int? age;
  dynamic gender;
  int? personalInfoId;
  dynamic patientAttenderMobile;
  DateTime? insertedDate;
  dynamic isLabtest;
  dynamic isImaging;
  dynamic isSpecialistOpinion;
  dynamic isSurgery;
  dynamic rtsColor;
  bool? isCritical;
  String? districtName;
  String? taluk;
  String? cityName;
  String? baseLocation;
  String? vehicleNumber;
  DateTime? vehicleAssignedTime;
  String? chiefComplaint;
  String? callerName;
  String? emergencyType;
  String? emergencySubType;
  String? hospitalName;
  dynamic medicalHistoryCategory;
  String? presentingComplaintsRta;
  String? presentingComplaintsWorkPlace;
  String? presentingComplaintsTrainTrafficInjury;
  String? presentingComplaintsAssault;
  String? presentingComplaintsSelfFall;
  String? presentingComplaintsChestPain;
  String? presentingComplaintsBreathlessness;
  String? presentingComplaintsSeizure;
  String? presentingComplaintsGiddiness;
  String? presentingComplaintsPoisoning;
  String? presentingComplaintsSnakeBite;
  String? presentingComplaintsAbdominalPain;
  String? presentingComplaintsBurns;
  String? presentingComplaintsHanging;
  String? presentingComplaintsUnConsciousness;
  String? presentingComplaintsLimbParesis;
  String? presentingComplaintsOther;
  String? fullHospitalName;
  int? pending;
  int? total;
  int? submitted;
  int? total108;
  int? totalOthers;
  int? totalTrauma;
  int? traumaRed;
  int? traumaGreen;
  int? traumaYellow;
  int? traumaBlack;
  int? nonTrauma;
  int? red;
  int? green;
  int? yellow;
  int? black;
  int? shifted;
  int? notReceived;
  int? totalCount;

  TriageNurseListData({
    this.rowNum,
    this.patientName,
    this.caseId,
    this.modelOfArrival,
    this.age,
    this.gender,
    this.personalInfoId,
    this.patientAttenderMobile,
    this.insertedDate,
    this.isLabtest,
    this.isImaging,
    this.isSpecialistOpinion,
    this.isSurgery,
    this.rtsColor,
    this.isCritical,
    this.districtName,
    this.taluk,
    this.cityName,
    this.baseLocation,
    this.vehicleNumber,
    this.vehicleAssignedTime,
    this.chiefComplaint,
    this.callerName,
    this.emergencyType,
    this.emergencySubType,
    this.hospitalName,
    this.medicalHistoryCategory,
    this.presentingComplaintsRta,
    this.presentingComplaintsWorkPlace,
    this.presentingComplaintsTrainTrafficInjury,
    this.presentingComplaintsAssault,
    this.presentingComplaintsSelfFall,
    this.presentingComplaintsChestPain,
    this.presentingComplaintsBreathlessness,
    this.presentingComplaintsSeizure,
    this.presentingComplaintsGiddiness,
    this.presentingComplaintsPoisoning,
    this.presentingComplaintsSnakeBite,
    this.presentingComplaintsAbdominalPain,
    this.presentingComplaintsBurns,
    this.presentingComplaintsHanging,
    this.presentingComplaintsUnConsciousness,
    this.presentingComplaintsLimbParesis,
    this.presentingComplaintsOther,
    this.fullHospitalName,
    this.pending,
    this.total,
    this.submitted,
    this.total108,
    this.totalOthers,
    this.totalTrauma,
    this.traumaRed,
    this.traumaGreen,
    this.traumaYellow,
    this.traumaBlack,
    this.nonTrauma,
    this.red,
    this.green,
    this.yellow,
    this.black,
    this.shifted,
    this.notReceived,
    this.totalCount,
  });

  factory TriageNurseListData.fromJson(Map<String, dynamic> json) =>
      TriageNurseListData(
        rowNum: json["row_num"],
        patientName: json["PatientName"],
        caseId: json["CaseId"],
        modelOfArrival: json["ModelOfArrival"],
        age: json["Age"],
        gender: json["Gender"],
        personalInfoId: json["PersonalInfoId"],
        patientAttenderMobile: json["Patient_Attender_Mobile"],
        insertedDate: json["InsertedDate"] == null
            ? null
            : DateTime.parse(json["InsertedDate"]),
        isLabtest: json["IsLabtest"],
        isImaging: json["IsImaging"],
        isSpecialistOpinion: json["IsSpecialistOpinion"],
        isSurgery: json["IsSurgery"],
        rtsColor: json["RTS_Color"],
        isCritical: json["IsCritical"],
        districtName: json["DistrictName"],
        taluk: json["Taluk"],
        cityName: json["CityName"],
        baseLocation: json["BaseLocation"],
        vehicleNumber: json["VehicleNumber"],
        vehicleAssignedTime: json["VehicleAssignedTime"] == null
            ? null
            : DateTime.parse(json["VehicleAssignedTime"]),
        chiefComplaint: json["ChiefComplaint"],
        callerName: json["CallerName"],
        emergencyType: json["Emergency_Type"],
        emergencySubType: json["Emergency_Sub_Type"],
        hospitalName: json["HospitalName"],
        medicalHistoryCategory: json["MedicalHistoryCategory"],
        presentingComplaintsRta: json["PresentingComplaints_RTA"],
        presentingComplaintsWorkPlace: json["PresentingComplaints_Work_Place"],
        presentingComplaintsTrainTrafficInjury:
            json["PresentingComplaints_Train_Traffic_injury"],
        presentingComplaintsAssault: json["PresentingComplaints_Assault"],
        presentingComplaintsSelfFall: json["PresentingComplaints_Self_Fall"],
        presentingComplaintsChestPain: json["PresentingComplaints_Chest_Pain"],
        presentingComplaintsBreathlessness:
            json["PresentingComplaints_Breathlessness"],
        presentingComplaintsSeizure: json["PresentingComplaints_Seizure"],
        presentingComplaintsGiddiness: json["PresentingComplaints_Giddiness"],
        presentingComplaintsPoisoning: json["PresentingComplaints_Poisoning"],
        presentingComplaintsSnakeBite: json["PresentingComplaints_Snake_Bite"],
        presentingComplaintsAbdominalPain:
            json["PresentingComplaints_Abdominal_Pain"],
        presentingComplaintsBurns: json["PresentingComplaints_Burns"],
        presentingComplaintsHanging: json["PresentingComplaints_Hanging"],
        presentingComplaintsUnConsciousness:
            json["PresentingComplaints_UnConsciousness"],
        presentingComplaintsLimbParesis:
            json["PresentingComplaints_Limb_Paresis"],
        presentingComplaintsOther: json["PresentingComplaints_Other"],
        fullHospitalName: json["FullHospitalName"],
        pending: json["Pending"],
        total: json["Total"],
        submitted: json["Submitted"],
        total108: json["Total108"],
        totalOthers: json["TotalOthers"],
        totalTrauma: json["TotalTrauma"],
        traumaRed: json["Trauma_Red"],
        traumaGreen: json["Trauma_Green"],
        traumaYellow: json["Trauma_Yellow"],
        traumaBlack: json["Trauma_Black"],
        nonTrauma: json["NonTrauma"],
        red: json["Red"],
        green: json["Green"],
        yellow: json["Yellow"],
        black: json["Black"],
        shifted: json["Shifted"],
        notReceived: json["NotReceived"],
        totalCount: json["TotalCount"],
      );

  Map<String, dynamic> toJson() => {
        "row_num": rowNum,
        "PatientName": patientName,
        "CaseId": caseId,
        "ModelOfArrival": modelOfArrival,
        "Age": age,
        "Gender": gender,
        "PersonalInfoId": personalInfoId,
        "Patient_Attender_Mobile": patientAttenderMobile,
        "InsertedDate": insertedDate?.toIso8601String(),
        "IsLabtest": isLabtest,
        "IsImaging": isImaging,
        "IsSpecialistOpinion": isSpecialistOpinion,
        "IsSurgery": isSurgery,
        "RTS_Color": rtsColor,
        "IsCritical": isCritical,
        "DistrictName": districtName,
        "Taluk": taluk,
        "CityName": cityName,
        "BaseLocation": baseLocation,
        "VehicleNumber": vehicleNumber,
        "VehicleAssignedTime": vehicleAssignedTime?.toIso8601String(),
        "ChiefComplaint": chiefComplaint,
        "CallerName": callerName,
        "Emergency_Type": emergencyType,
        "Emergency_Sub_Type": emergencySubType,
        "HospitalName": hospitalName,
        "MedicalHistoryCategory": medicalHistoryCategory,
        "PresentingComplaints_RTA": presentingComplaintsRta,
        "PresentingComplaints_Work_Place": presentingComplaintsWorkPlace,
        "PresentingComplaints_Train_Traffic_injury":
            presentingComplaintsTrainTrafficInjury,
        "PresentingComplaints_Assault": presentingComplaintsAssault,
        "PresentingComplaints_Self_Fall": presentingComplaintsSelfFall,
        "PresentingComplaints_Chest_Pain": presentingComplaintsChestPain,
        "PresentingComplaints_Breathlessness":
            presentingComplaintsBreathlessness,
        "PresentingComplaints_Seizure": presentingComplaintsSeizure,
        "PresentingComplaints_Giddiness": presentingComplaintsGiddiness,
        "PresentingComplaints_Poisoning": presentingComplaintsPoisoning,
        "PresentingComplaints_Snake_Bite": presentingComplaintsSnakeBite,
        "PresentingComplaints_Abdominal_Pain":
            presentingComplaintsAbdominalPain,
        "PresentingComplaints_Burns": presentingComplaintsBurns,
        "PresentingComplaints_Hanging": presentingComplaintsHanging,
        "PresentingComplaints_UnConsciousness":
            presentingComplaintsUnConsciousness,
        "PresentingComplaints_Limb_Paresis": presentingComplaintsLimbParesis,
        "PresentingComplaints_Other": presentingComplaintsOther,
        "FullHospitalName": fullHospitalName,
        "Pending": pending,
        "Total": total,
        "Submitted": submitted,
        "Total108": total108,
        "TotalOthers": totalOthers,
        "TotalTrauma": totalTrauma,
        "Trauma_Red": traumaRed,
        "Trauma_Green": traumaGreen,
        "Trauma_Yellow": traumaYellow,
        "Trauma_Black": traumaBlack,
        "NonTrauma": nonTrauma,
        "Red": red,
        "Green": green,
        "Yellow": yellow,
        "Black": black,
        "Shifted": shifted,
        "NotReceived": notReceived,
        "TotalCount": totalCount,
      };
}
