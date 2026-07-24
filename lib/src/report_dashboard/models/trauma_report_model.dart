// To parse this JSON data, do
//
//     final traumaReportModel = traumaReportModelFromJson(jsonString);

import 'dart:convert';

TraumaReportModel traumaReportModelFromJson(String str) =>
    TraumaReportModel.fromJson(json.decode(str));

String traumaReportModelToJson(TraumaReportModel data) =>
    json.encode(data.toJson());

class TraumaReportModel {
  List<Datum>? data;

  TraumaReportModel({
    this.data,
  });

  factory TraumaReportModel.fromJson(Map<String, dynamic> json) =>
      TraumaReportModel(
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
  int? hospitalId;
  String? institutionName;
  String? districtName;
  String? totalTrauma;
  String? traumaPer100EdAdmissions;
  String? redCases;
  String? yellowCases;
  String? greenCases;
  String? blackCases;
  String? rtaRiderRed;
  String? rtaRiderYellow;
  String? rtaRiderGreen;
  String? rtaRiderBlack;
  String? rtaRiderIktAvailed;
  String? rtaPillionRed;
  String? rtaPillionYellow;
  String? rtaPillionGreen;
  String? rtaPillionBlack;
  String? rtaPillionIktAvailed;
  String? fallFromHeight;
  String? fallSlipFloor;
  String? assaultCases;
  String? selfInflicted;
  String? accidentalInjury;
  String? firearmInjury;
  String? sportInjury;
  String? fallOfObject;
  String? workspotOrganisedEsi;
  String? workspotUnorganisedTn;
  String? workspotOtherStates;
  String? agriculturalMachinery;
  String? trainTrafficInjury;
  String? headWithHelmet;
  String? headWithoutHelmet;
  String? totalAnyProcedureDone;
  String? cprAttempts;
  String? successfulCpr;
  String? cprPer100Trauma;
  String? successfulCprRatePct;
  String? bloodTransfusionCases;
  String? onArrivalNerveBlocks;
  String? mechIntubationCount;
  String? firstPassIntubationCount;
  String? firstPassIntubationRatePct;
  String? majorSurgeries;
  String? minorSurgeries;
  String? totalGaSurgeries;
  String? totalLocalSurgeries;
  String? majorGaWithin6Hrs;
  String? majorGa6To24Hrs;
  String? majorGaWithin6HrsGeneral;
  String? majorGaWithin6HrsNeuro;
  String? majorGaWithin6HrsOrtho;
  String? majorGaWithin6HrsOther;
  String? majorGa6To24HrsGeneral;
  String? majorGa6To24HrsNeuro;
  String? majorGa6To24HrsOrtho;
  String? majorGa6To24HrsOther;
  String? admittedToWard;
  String? admittedToIcu;
  String? deaths;
  String? deathRatePct;
  String? dischargedCases;
  String? damaCases;
  String? damaRatePct;
  String? abscondedCases;
  String? abscondRatePct;
  String? referredInCases;
  String? taeiDocumented;

  Datum({
    this.hospitalId,
    this.institutionName,
    this.districtName,
    this.totalTrauma,
    this.traumaPer100EdAdmissions,
    this.redCases,
    this.yellowCases,
    this.greenCases,
    this.blackCases,
    this.rtaRiderRed,
    this.rtaRiderYellow,
    this.rtaRiderGreen,
    this.rtaRiderBlack,
    this.rtaRiderIktAvailed,
    this.rtaPillionRed,
    this.rtaPillionYellow,
    this.rtaPillionGreen,
    this.rtaPillionBlack,
    this.rtaPillionIktAvailed,
    this.fallFromHeight,
    this.fallSlipFloor,
    this.assaultCases,
    this.selfInflicted,
    this.accidentalInjury,
    this.firearmInjury,
    this.sportInjury,
    this.fallOfObject,
    this.workspotOrganisedEsi,
    this.workspotUnorganisedTn,
    this.workspotOtherStates,
    this.agriculturalMachinery,
    this.trainTrafficInjury,
    this.headWithHelmet,
    this.headWithoutHelmet,
    this.totalAnyProcedureDone,
    this.cprAttempts,
    this.successfulCpr,
    this.cprPer100Trauma,
    this.successfulCprRatePct,
    this.bloodTransfusionCases,
    this.onArrivalNerveBlocks,
    this.mechIntubationCount,
    this.firstPassIntubationCount,
    this.firstPassIntubationRatePct,
    this.majorSurgeries,
    this.minorSurgeries,
    this.totalGaSurgeries,
    this.totalLocalSurgeries,
    this.majorGaWithin6Hrs,
    this.majorGa6To24Hrs,
    this.majorGaWithin6HrsGeneral,
    this.majorGaWithin6HrsNeuro,
    this.majorGaWithin6HrsOrtho,
    this.majorGaWithin6HrsOther,
    this.majorGa6To24HrsGeneral,
    this.majorGa6To24HrsNeuro,
    this.majorGa6To24HrsOrtho,
    this.majorGa6To24HrsOther,
    this.admittedToWard,
    this.admittedToIcu,
    this.deaths,
    this.deathRatePct,
    this.dischargedCases,
    this.damaCases,
    this.damaRatePct,
    this.abscondedCases,
    this.abscondRatePct,
    this.referredInCases,
    this.taeiDocumented,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hospitalId: json["hospital_id"],
        institutionName: json["institution_name"],
        districtName: json["district_name"],
        totalTrauma: json["total_trauma"],
        traumaPer100EdAdmissions: json["trauma_per_100_ed_admissions"],
        redCases: json["red_cases"],
        yellowCases: json["yellow_cases"],
        greenCases: json["green_cases"],
        blackCases: json["black_cases"],
        rtaRiderRed: json["rta_rider_red"],
        rtaRiderYellow: json["rta_rider_yellow"],
        rtaRiderGreen: json["rta_rider_green"],
        rtaRiderBlack: json["rta_rider_black"],
        rtaRiderIktAvailed: json["rta_rider_ikt_availed"],
        rtaPillionRed: json["rta_pillion_red"],
        rtaPillionYellow: json["rta_pillion_yellow"],
        rtaPillionGreen: json["rta_pillion_green"],
        rtaPillionBlack: json["rta_pillion_black"],
        rtaPillionIktAvailed: json["rta_pillion_ikt_availed"],
        fallFromHeight: json["fall_from_height"],
        fallSlipFloor: json["fall_slip_floor"],
        assaultCases: json["assault_cases"],
        selfInflicted: json["self_inflicted"],
        accidentalInjury: json["accidental_injury"],
        firearmInjury: json["firearm_injury"],
        sportInjury: json["sport_injury"],
        fallOfObject: json["fall_of_object"],
        workspotOrganisedEsi: json["workspot_organised_esi"],
        workspotUnorganisedTn: json["workspot_unorganised_tn"],
        workspotOtherStates: json["workspot_other_states"],
        agriculturalMachinery: json["agricultural_machinery"],
        trainTrafficInjury: json["train_traffic_injury"],
        headWithHelmet: json["head_with_helmet"],
        headWithoutHelmet: json["head_without_helmet"],
        totalAnyProcedureDone: json["total_any_procedure_done"],
        cprAttempts: json["cpr_attempts"],
        successfulCpr: json["successful_cpr"],
        cprPer100Trauma: json["cpr_per_100_trauma"],
        successfulCprRatePct: json["successful_cpr_rate_pct"],
        bloodTransfusionCases: json["blood_transfusion_cases"],
        onArrivalNerveBlocks: json["on_arrival_nerve_blocks"],
        mechIntubationCount: json["mech_intubation_count"],
        firstPassIntubationCount: json["first_pass_intubation_count"],
        firstPassIntubationRatePct: json["first_pass_intubation_rate_pct"],
        majorSurgeries: json["major_surgeries"],
        minorSurgeries: json["minor_surgeries"],
        totalGaSurgeries: json["total_ga_surgeries"],
        totalLocalSurgeries: json["total_local_surgeries"],
        majorGaWithin6Hrs: json["major_ga_within_6hrs"],
        majorGa6To24Hrs: json["major_ga_6_to_24hrs"],
        majorGaWithin6HrsGeneral: json["major_ga_within_6hrs_general"],
        majorGaWithin6HrsNeuro: json["major_ga_within_6hrs_neuro"],
        majorGaWithin6HrsOrtho: json["major_ga_within_6hrs_ortho"],
        majorGaWithin6HrsOther: json["major_ga_within_6hrs_other"],
        majorGa6To24HrsGeneral: json["major_ga_6_to_24hrs_general"],
        majorGa6To24HrsNeuro: json["major_ga_6_to_24hrs_neuro"],
        majorGa6To24HrsOrtho: json["major_ga_6_to_24hrs_ortho"],
        majorGa6To24HrsOther: json["major_ga_6_to_24hrs_other"],
        admittedToWard: json["admitted_to_ward"],
        admittedToIcu: json["admitted_to_icu"],
        deaths: json["deaths"],
        deathRatePct: json["death_rate_pct"],
        dischargedCases: json["discharged_cases"],
        damaCases: json["dama_cases"],
        damaRatePct: json["dama_rate_pct"],
        abscondedCases: json["absconded_cases"],
        abscondRatePct: json["abscond_rate_pct"],
        referredInCases: json["referred_in_cases"],
        taeiDocumented: json["taei_documented"],
      );

  Map<String, dynamic> toJson() => {
        "hospital_id": hospitalId,
        "institution_name": institutionName,
        "district_name": districtName,
        "total_trauma": totalTrauma,
        "trauma_per_100_ed_admissions": traumaPer100EdAdmissions,
        "red_cases": redCases,
        "yellow_cases": yellowCases,
        "green_cases": greenCases,
        "black_cases": blackCases,
        "rta_rider_red": rtaRiderRed,
        "rta_rider_yellow": rtaRiderYellow,
        "rta_rider_green": rtaRiderGreen,
        "rta_rider_black": rtaRiderBlack,
        "rta_rider_ikt_availed": rtaRiderIktAvailed,
        "rta_pillion_red": rtaPillionRed,
        "rta_pillion_yellow": rtaPillionYellow,
        "rta_pillion_green": rtaPillionGreen,
        "rta_pillion_black": rtaPillionBlack,
        "rta_pillion_ikt_availed": rtaPillionIktAvailed,
        "fall_from_height": fallFromHeight,
        "fall_slip_floor": fallSlipFloor,
        "assault_cases": assaultCases,
        "self_inflicted": selfInflicted,
        "accidental_injury": accidentalInjury,
        "firearm_injury": firearmInjury,
        "sport_injury": sportInjury,
        "fall_of_object": fallOfObject,
        "workspot_organised_esi": workspotOrganisedEsi,
        "workspot_unorganised_tn": workspotUnorganisedTn,
        "workspot_other_states": workspotOtherStates,
        "agricultural_machinery": agriculturalMachinery,
        "train_traffic_injury": trainTrafficInjury,
        "head_with_helmet": headWithHelmet,
        "head_without_helmet": headWithoutHelmet,
        "total_any_procedure_done": totalAnyProcedureDone,
        "cpr_attempts": cprAttempts,
        "successful_cpr": successfulCpr,
        "cpr_per_100_trauma": cprPer100Trauma,
        "successful_cpr_rate_pct": successfulCprRatePct,
        "blood_transfusion_cases": bloodTransfusionCases,
        "on_arrival_nerve_blocks": onArrivalNerveBlocks,
        "mech_intubation_count": mechIntubationCount,
        "first_pass_intubation_count": firstPassIntubationCount,
        "first_pass_intubation_rate_pct": firstPassIntubationRatePct,
        "major_surgeries": majorSurgeries,
        "minor_surgeries": minorSurgeries,
        "total_ga_surgeries": totalGaSurgeries,
        "total_local_surgeries": totalLocalSurgeries,
        "major_ga_within_6hrs": majorGaWithin6Hrs,
        "major_ga_6_to_24hrs": majorGa6To24Hrs,
        "major_ga_within_6hrs_general": majorGaWithin6HrsGeneral,
        "major_ga_within_6hrs_neuro": majorGaWithin6HrsNeuro,
        "major_ga_within_6hrs_ortho": majorGaWithin6HrsOrtho,
        "major_ga_within_6hrs_other": majorGaWithin6HrsOther,
        "major_ga_6_to_24hrs_general": majorGa6To24HrsGeneral,
        "major_ga_6_to_24hrs_neuro": majorGa6To24HrsNeuro,
        "major_ga_6_to_24hrs_ortho": majorGa6To24HrsOrtho,
        "major_ga_6_to_24hrs_other": majorGa6To24HrsOther,
        "admitted_to_ward": admittedToWard,
        "admitted_to_icu": admittedToIcu,
        "deaths": deaths,
        "death_rate_pct": deathRatePct,
        "discharged_cases": dischargedCases,
        "dama_cases": damaCases,
        "dama_rate_pct": damaRatePct,
        "absconded_cases": abscondedCases,
        "abscond_rate_pct": abscondRatePct,
        "referred_in_cases": referredInCases,
        "taei_documented": taeiDocumented,
      };
}
