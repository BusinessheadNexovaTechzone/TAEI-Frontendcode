// To parse this JSON data, do
//
//     final entryDashboardModel = entryDashboardModelFromJson(jsonString);

import 'dart:convert';

EntryDashboardModel entryDashboardModelFromJson(String str) =>
    EntryDashboardModel.fromJson(json.decode(str));

String entryDashboardModelToJson(EntryDashboardModel data) =>
    json.encode(data.toJson());

class EntryDashboardModel {
  List<EntryDashboardData>? data;

  EntryDashboardModel({
    this.data,
  });

  factory EntryDashboardModel.fromJson(Map<String, dynamic> json) =>
      EntryDashboardModel(
        data: json["data"] == null
            ? []
            : List<EntryDashboardData>.from(
                json["data"]!.map((x) => EntryDashboardData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EntryDashboardData {
  int? hospitalid;
  String? districtName;
  String? hospitalName;
  String? hospitalName108;
  String? total108;
  String? pending108;
  String? triage;
  String? triageDirect;
  String? triage108;
  String? emo;
  String? totalTrauma;
  String? trauma;
  String? totalBurns;
  String? burns;
  String? totalPoisoning;
  String? poisoning;
  String? totalBitesStings;
  String? bitesStings;
  String? totalHanging;
  String? hanging;
  String? totalDrowning;
  String? drowning;
  String? totalStroke;
  String? stroke;
  String? totalStemi;
  String? stemi;
  String? totalPrem;
  String? prem;

  EntryDashboardData({
    this.hospitalid,
    this.districtName,
    this.hospitalName,
    this.hospitalName108,
    this.total108,
    this.pending108,
    this.triage,
    this.triageDirect,
    this.triage108,
    this.emo,
    this.totalTrauma,
    this.trauma,
    this.totalBurns,
    this.burns,
    this.totalPoisoning,
    this.poisoning,
    this.totalBitesStings,
    this.bitesStings,
    this.totalHanging,
    this.hanging,
    this.totalDrowning,
    this.drowning,
    this.totalStroke,
    this.stroke,
    this.totalStemi,
    this.stemi,
    this.totalPrem,
    this.prem,
  });

  factory EntryDashboardData.fromJson(Map<String, dynamic> json) =>
      EntryDashboardData(
        hospitalid: json["hospitalid"],
        districtName: json["district_name"],
        hospitalName: json["hospital_name"],
        hospitalName108: json["hospital_name_108"],
        total108: json["total_108"],
        pending108: json["pending_108"],
        triage: json["triage"],
        triageDirect: json["triage_direct"],
        triage108: json["triage_108"],
        emo: json["emo"],
        totalTrauma: json["total_trauma"],
        trauma: json["trauma"],
        totalBurns: json["total_burns"],
        burns: json["burns"],
        totalPoisoning: json["total_poisoning"],
        poisoning: json["poisoning"],
        totalBitesStings: json["total_bites_stings"],
        bitesStings: json["bites_stings"],
        totalHanging: json["total_hanging"],
        hanging: json["hanging"],
        totalDrowning: json["total_drowning"],
        drowning: json["drowning"],
        totalStroke: json["total_stroke"],
        stroke: json["stroke"],
        totalStemi: json["total_stemi"],
        stemi: json["stemi"],
        totalPrem: json["total_prem"],
        prem: json["prem"],
      );

  Map<String, dynamic> toJson() => {
        "hospitalid": hospitalid,
        "district_name": districtName,
        "hospital_name": hospitalName,
        "hospital_name_108": hospitalName108,
        "total_108": total108,
        "pending_108": pending108,
        "triage": triage,
        "triage_direct": triageDirect,
        "triage_108": triage108,
        "emo": emo,
        "total_trauma": totalTrauma,
        "trauma": trauma,
        "total_burns": totalBurns,
        "burns": burns,
        "total_poisoning": totalPoisoning,
        "poisoning": poisoning,
        "total_bites_stings": totalBitesStings,
        "bites_stings": bitesStings,
        "total_hanging": totalHanging,
        "hanging": hanging,
        "total_drowning": totalDrowning,
        "drowning": drowning,
        "total_stroke": totalStroke,
        "stroke": stroke,
        "total_stemi": totalStemi,
        "stemi": stemi,
        "total_prem": totalPrem,
        "prem": prem,
      };
}
