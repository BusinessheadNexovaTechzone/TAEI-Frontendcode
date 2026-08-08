// To parse this JSON data, do
//
//     final drowninglookupModel = drowninglookupModelFromJson(jsonString);

import 'dart:convert';

DrowninglookupModel drowninglookupModelFromJson(String str) =>
    DrowninglookupModel.fromJson(json.decode(str));

String drowninglookupModelToJson(DrowninglookupModel data) =>
    json.encode(data.toJson());

class DrowninglookupModel {
  List<ItemList>? yesNo;
  List<ItemList>? placeOfIncident;
  List<ItemList>? typeOfWater;
  List<ItemList>? activityDuringDrowning;
  List<ItemList>? assessment;
  List<ItemList>? interventions;
  List<ItemList>? counsellingBeforeDischarge;
  List<ItemList>? complicationsAdmission;
  List<ItemList>? supportiveCare;
  List<ItemList>? complicationsDeveloped;
  List<ItemList>? hospitalType;
  List<ItemList>? destinationHospital;
  List<ItemList>? reasonForReferral;
  List<ItemList>? conditionOfPatient;
  List<ItemList>? outHospitalType;
  List<ItemList>? outcomeType;
  List<ItemList>? referralReason;
  List<ItemList>? patientCondition;
  List<Hospital>? hospitals;

  DrowninglookupModel({
    this.yesNo,
    this.placeOfIncident,
    this.typeOfWater,
    this.activityDuringDrowning,
    this.assessment,
    this.interventions,
    this.counsellingBeforeDischarge,
    this.complicationsAdmission,
    this.supportiveCare,
    this.complicationsDeveloped,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.outHospitalType,
    this.outcomeType,
    this.referralReason,
    this.patientCondition,
    this.hospitals,
  });

  factory DrowninglookupModel.fromJson(Map<String, dynamic> json) =>
      DrowninglookupModel(
        yesNo: json["YesNo"] == null
            ? []
            : List<ItemList>.from(
                json["YesNo"]!.map((x) => ItemList.fromJson(x))),
        placeOfIncident: json["PlaceOfIncident"] == null
            ? []
            : List<ItemList>.from(
                json["PlaceOfIncident"]!.map((x) => ItemList.fromJson(x))),
        typeOfWater: json["TypeOfWater"] == null
            ? []
            : List<ItemList>.from(
                json["TypeOfWater"]!.map((x) => ItemList.fromJson(x))),
        activityDuringDrowning: json["ActivityDuringDrowning"] == null
            ? []
            : List<ItemList>.from(json["ActivityDuringDrowning"]!
                .map((x) => ItemList.fromJson(x))),
        assessment: json["Assessment"] == null
            ? []
            : List<ItemList>.from(
                json["Assessment"]!.map((x) => ItemList.fromJson(x))),
        interventions: json["Interventions"] == null
            ? []
            : List<ItemList>.from(
                json["Interventions"]!.map((x) => ItemList.fromJson(x))),
        counsellingBeforeDischarge: json["counselling_before_discharge"] == null
            ? []
            : List<ItemList>.from(json["counselling_before_discharge"]!
                .map((x) => ItemList.fromJson(x))),
        complicationsAdmission: json["complications_admission"] == null
            ? []
            : List<ItemList>.from(json["complications_admission"]!
                .map((x) => ItemList.fromJson(x))),
        supportiveCare: json["supportive_care"] == null
            ? []
            : List<ItemList>.from(
                json["supportive_care"]!.map((x) => ItemList.fromJson(x))),
        complicationsDeveloped: json["complications_developed"] == null
            ? []
            : List<ItemList>.from(json["complications_developed"]!
                .map((x) => ItemList.fromJson(x))),
        hospitalType: json["HospitalType"] == null
            ? []
            : List<ItemList>.from(
                json["HospitalType"]!.map((x) => ItemList.fromJson(x))),
        destinationHospital: json["DestinationHospital"] == null
            ? []
            : List<ItemList>.from(
                json["DestinationHospital"]!.map((x) => ItemList.fromJson(x))),
        reasonForReferral: json["ReasonForReferral"] == null
            ? []
            : List<ItemList>.from(
                json["ReasonForReferral"]!.map((x) => ItemList.fromJson(x))),
        conditionOfPatient: json["ConditionOfPatient"] == null
            ? []
            : List<ItemList>.from(
                json["ConditionOfPatient"]!.map((x) => ItemList.fromJson(x))),
        outHospitalType: json["Out_HospitalType"] == null
            ? []
            : List<ItemList>.from(
                json["Out_HospitalType"]!.map((x) => ItemList.fromJson(x))),
        outcomeType: json["OutcomeType"] == null
            ? []
            : List<ItemList>.from(
                json["OutcomeType"]!.map((x) => ItemList.fromJson(x))),
        referralReason: json["ReferralReason"] == null
            ? []
            : List<ItemList>.from(
                json["ReferralReason"]!.map((x) => ItemList.fromJson(x))),
        patientCondition: json["PatientCondition"] == null
            ? []
            : List<ItemList>.from(
                json["PatientCondition"]!.map((x) => ItemList.fromJson(x))),
        hospitals: json["Hospitals"] == null
            ? []
            : List<Hospital>.from(
                json["Hospitals"]!.map((x) => Hospital.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "YesNo": yesNo == null
            ? []
            : List<dynamic>.from(yesNo!.map((x) => x.toJson())),
        "PlaceOfIncident": placeOfIncident == null
            ? []
            : List<dynamic>.from(placeOfIncident!.map((x) => x.toJson())),
        "TypeOfWater": typeOfWater == null
            ? []
            : List<dynamic>.from(typeOfWater!.map((x) => x.toJson())),
        "ActivityDuringDrowning": activityDuringDrowning == null
            ? []
            : List<dynamic>.from(
                activityDuringDrowning!.map((x) => x.toJson())),
        "Assessment": assessment == null
            ? []
            : List<dynamic>.from(assessment!.map((x) => x.toJson())),
        "Interventions": interventions == null
            ? []
            : List<dynamic>.from(interventions!.map((x) => x.toJson())),
        "counselling_before_discharge": counsellingBeforeDischarge == null
            ? []
            : List<dynamic>.from(
                counsellingBeforeDischarge!.map((x) => x.toJson())),
        "complications_admission": complicationsAdmission == null
            ? []
            : List<dynamic>.from(
                complicationsAdmission!.map((x) => x.toJson())),
        "supportive_care": supportiveCare == null
            ? []
            : List<dynamic>.from(supportiveCare!.map((x) => x.toJson())),
        "complications_developed": complicationsDeveloped == null
            ? []
            : List<dynamic>.from(
                complicationsDeveloped!.map((x) => x.toJson())),
        "HospitalType": hospitalType == null
            ? []
            : List<dynamic>.from(hospitalType!.map((x) => x.toJson())),
        "DestinationHospital": destinationHospital == null
            ? []
            : List<dynamic>.from(destinationHospital!.map((x) => x.toJson())),
        "ReasonForReferral": reasonForReferral == null
            ? []
            : List<dynamic>.from(reasonForReferral!.map((x) => x.toJson())),
        "ConditionOfPatient": conditionOfPatient == null
            ? []
            : List<dynamic>.from(conditionOfPatient!.map((x) => x.toJson())),
        "Out_HospitalType": outHospitalType == null
            ? []
            : List<dynamic>.from(outHospitalType!.map((x) => x.toJson())),
        "OutcomeType": outcomeType == null
            ? []
            : List<dynamic>.from(outcomeType!.map((x) => x.toJson())),
        "ReferralReason": referralReason == null
            ? []
            : List<dynamic>.from(referralReason!.map((x) => x.toJson())),
        "PatientCondition": patientCondition == null
            ? []
            : List<dynamic>.from(patientCondition!.map((x) => x.toJson())),
        "Hospitals": hospitals == null
            ? []
            : List<dynamic>.from(hospitals!.map((x) => x.toJson())),
      };
}

class ItemList {
  int? id;
  String? name;

  ItemList({
    this.id,
    this.name,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Hospital {
  int? hospitalid;
  String? districtname;
  String? hospitalname;
  int? mainhospitaltype;
  String? hospitaltype;
  String? hospitalname108;
  String? typeOfHospital;
  String? institutionCode;
  int? statecode;
  int? districtId;

  Hospital({
    this.hospitalid,
    this.districtname,
    this.hospitalname,
    this.mainhospitaltype,
    this.hospitaltype,
    this.hospitalname108,
    this.typeOfHospital,
    this.institutionCode,
    this.statecode,
    this.districtId,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        hospitalid: json["hospitalid"],
        districtname: json["districtname"],
        hospitalname: json["hospitalname"],
        mainhospitaltype: json["mainhospitaltype"],
        hospitaltype: json["hospitaltype"],
        hospitalname108: json["hospitalname108"],
        typeOfHospital: json["type_of_hospital"],
        institutionCode: json["institution_code"],
        statecode: json["statecode"],
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "hospitalid": hospitalid,
        "districtname": districtname,
        "hospitalname": hospitalname,
        "mainhospitaltype": mainhospitaltype,
        "hospitaltype": hospitaltype,
        "hospitalname108": hospitalname108,
        "type_of_hospital": typeOfHospital,
        "institution_code": institutionCode,
        "statecode": statecode,
        "district_id": districtId,
      };
}
