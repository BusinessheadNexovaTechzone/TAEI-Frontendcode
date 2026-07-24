// To parse this JSON data, do
//
//     final strokeReportModel = strokeReportModelFromJson(jsonString);

import 'dart:convert';

StrokeReportModel strokeReportModelFromJson(String str) =>
    StrokeReportModel.fromJson(json.decode(str));

String strokeReportModelToJson(StrokeReportModel data) =>
    json.encode(data.toJson());

class StrokeReportModel {
  List<Datum>? data;

  StrokeReportModel({
    this.data,
  });

  factory StrokeReportModel.fromJson(Map<String, dynamic> json) =>
      StrokeReportModel(
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
  int? institutionId;
  String? institutionName;
  String? districtname;
  String? totalStroke;
  String? ischemicStroke;
  String? hemorrhagicStroke;
  String? ctDone;
  String? mriDone;
  String? cathlabDone;
  String? arrivedInWindow;
  String? thrombolysisByAlteplase;
  String? thrombolysisRecovered;
  String? referralFromSpoke;
  String? referralFromHub;
  String? referredToHubAfterScan;
  String? thrombectomyDone;
  String? surgeryDone;
  String? surgeryRecovered;
  String? strokeDeaths;
  String? strokeDama;
  String? strokeAbscond;

  Datum({
    this.institutionId,
    this.institutionName,
    this.districtname,
    this.totalStroke,
    this.ischemicStroke,
    this.hemorrhagicStroke,
    this.ctDone,
    this.mriDone,
    this.cathlabDone,
    this.arrivedInWindow,
    this.thrombolysisByAlteplase,
    this.thrombolysisRecovered,
    this.referralFromSpoke,
    this.referralFromHub,
    this.referredToHubAfterScan,
    this.thrombectomyDone,
    this.surgeryDone,
    this.surgeryRecovered,
    this.strokeDeaths,
    this.strokeDama,
    this.strokeAbscond,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        institutionId: json["institution_id"],
        institutionName: json["institution_name"],
        districtname: json["districtname"],
        totalStroke: json["total_stroke"],
        ischemicStroke: json["ischemic_stroke"],
        hemorrhagicStroke: json["hemorrhagic_stroke"],
        ctDone: json["ct_done"],
        mriDone: json["mri_done"],
        cathlabDone: json["cathlab_done"],
        arrivedInWindow: json["arrived_in_window"],
        thrombolysisByAlteplase: json["thrombolysis_by_alteplase"],
        thrombolysisRecovered: json["thrombolysis_recovered"],
        referralFromSpoke: json["referral_from_spoke"],
        referralFromHub: json["referral_from_hub"],
        referredToHubAfterScan: json["referred_to_hub_after_scan"],
        thrombectomyDone: json["thrombectomy_done"],
        surgeryDone: json["surgery_done"],
        surgeryRecovered: json["surgery_recovered"],
        strokeDeaths: json["stroke_deaths"],
        strokeDama: json["stroke_dama"],
        strokeAbscond: json["stroke_abscond"],
      );

  Map<String, dynamic> toJson() => {
        "institution_id": institutionId,
        "institution_name": institutionName,
        "districtname": districtname,
        "total_stroke": totalStroke,
        "ischemic_stroke": ischemicStroke,
        "hemorrhagic_stroke": hemorrhagicStroke,
        "ct_done": ctDone,
        "mri_done": mriDone,
        "cathlab_done": cathlabDone,
        "arrived_in_window": arrivedInWindow,
        "thrombolysis_by_alteplase": thrombolysisByAlteplase,
        "thrombolysis_recovered": thrombolysisRecovered,
        "referral_from_spoke": referralFromSpoke,
        "referral_from_hub": referralFromHub,
        "referred_to_hub_after_scan": referredToHubAfterScan,
        "thrombectomy_done": thrombectomyDone,
        "surgery_done": surgeryDone,
        "surgery_recovered": surgeryRecovered,
        "stroke_deaths": strokeDeaths,
        "stroke_dama": strokeDama,
        "stroke_abscond": strokeAbscond,
      };
}
