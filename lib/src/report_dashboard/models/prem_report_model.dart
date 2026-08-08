// To parse this JSON data, do
//
//     final premReportModel = premReportModelFromJson(jsonString);

import 'dart:convert';

PremReportModel premReportModelFromJson(String str) =>
    PremReportModel.fromJson(json.decode(str));

String premReportModelToJson(PremReportModel data) =>
    json.encode(data.toJson());

class PremReportModel {
  List<Datum>? data;

  PremReportModel({
    this.data,
  });

  factory PremReportModel.fromJson(Map<String, dynamic> json) =>
      PremReportModel(
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
  String? feverAlc;
  String? focusOfInfection;
  String? cough;
  String? cold;
  String? diarrheaAlc;
  String? vomiting;
  String? alteredLoc;
  String? noisyBreathing;
  String? breathlessness;
  String? unresponsive;
  String? regainedConsciousness;
  String? foreignBody;
  String? snakeBite;
  String? scorpionBite;
  String? insectBite;
  String? dogBite;
  String? bleed;
  String? rash;
  String? acuteAbdomen;
  String? trauma;
  String? burns;
  String? poison;
  String? submersion;
  String? seizures;
  String? others;
  String? oxygenNrbm;
  String? oxygenJr;
  String? oxygenBvm;
  String? oxygenEt;
  String? oxygenCpap;
  String? mdiSpacer;
  String? nebulisation;
  String? airwayManoeuvres;
  String? ivIoAccess;
  String? fluidBolus;
  String? dopamine;
  String? epinephrine;
  String? cprChest;
  String? anticonvulsants;
  String? triagedInQueue;
  String? redFlag;
  String? yellowFlag;
  String? greenFlag;
  String? blackFlag;
  String? treatedAsOp;
  String? discharged;
  String? dischargedOnRequest;
  String? death;
  String? dama;
  String? abscond;
  String? transferred;
  String? caseSheetDocumented;

  Datum({
    this.institutionId,
    this.institutionName,
    this.districtname,
    this.feverAlc,
    this.focusOfInfection,
    this.cough,
    this.cold,
    this.diarrheaAlc,
    this.vomiting,
    this.alteredLoc,
    this.noisyBreathing,
    this.breathlessness,
    this.unresponsive,
    this.regainedConsciousness,
    this.foreignBody,
    this.snakeBite,
    this.scorpionBite,
    this.insectBite,
    this.dogBite,
    this.bleed,
    this.rash,
    this.acuteAbdomen,
    this.trauma,
    this.burns,
    this.poison,
    this.submersion,
    this.seizures,
    this.others,
    this.oxygenNrbm,
    this.oxygenJr,
    this.oxygenBvm,
    this.oxygenEt,
    this.oxygenCpap,
    this.mdiSpacer,
    this.nebulisation,
    this.airwayManoeuvres,
    this.ivIoAccess,
    this.fluidBolus,
    this.dopamine,
    this.epinephrine,
    this.cprChest,
    this.anticonvulsants,
    this.triagedInQueue,
    this.redFlag,
    this.yellowFlag,
    this.greenFlag,
    this.blackFlag,
    this.treatedAsOp,
    this.discharged,
    this.dischargedOnRequest,
    this.death,
    this.dama,
    this.abscond,
    this.transferred,
    this.caseSheetDocumented,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        institutionId: json["institution_id"],
        institutionName: json["institution_name"],
        districtname: json["districtname"],
        feverAlc: json["fever_alc"],
        focusOfInfection: json["focus_of_infection"],
        cough: json["cough"],
        cold: json["cold"],
        diarrheaAlc: json["diarrhea_alc"],
        vomiting: json["vomiting"],
        alteredLoc: json["altered_loc"],
        noisyBreathing: json["noisy_breathing"],
        breathlessness: json["breathlessness"],
        unresponsive: json["unresponsive"],
        regainedConsciousness: json["regained_consciousness"],
        foreignBody: json["foreign_body"],
        snakeBite: json["snake_bite"],
        scorpionBite: json["scorpion_bite"],
        insectBite: json["insect_bite"],
        dogBite: json["dog_bite"],
        bleed: json["bleed"],
        rash: json["rash"],
        acuteAbdomen: json["acute_abdomen"],
        trauma: json["trauma"],
        burns: json["burns"],
        poison: json["poison"],
        submersion: json["submersion"],
        seizures: json["seizures"],
        others: json["others"],
        oxygenNrbm: json["oxygen_nrbm"],
        oxygenJr: json["oxygen_jr"],
        oxygenBvm: json["oxygen_bvm"],
        oxygenEt: json["oxygen_et"],
        oxygenCpap: json["oxygen_cpap"],
        mdiSpacer: json["mdi_spacer"],
        nebulisation: json["nebulisation"],
        airwayManoeuvres: json["airway_manoeuvres"],
        ivIoAccess: json["iv_io_access"],
        fluidBolus: json["fluid_bolus"],
        dopamine: json["dopamine"],
        epinephrine: json["epinephrine"],
        cprChest: json["cpr_chest"],
        anticonvulsants: json["anticonvulsants"],
        triagedInQueue: json["triaged_in_queue"],
        redFlag: json["red_flag"],
        yellowFlag: json["yellow_flag"],
        greenFlag: json["green_flag"],
        blackFlag: json["black_flag"],
        treatedAsOp: json["treated_as_op"],
        discharged: json["discharged"],
        dischargedOnRequest: json["discharged_on_request"],
        death: json["death"],
        dama: json["dama"],
        abscond: json["abscond"],
        transferred: json["transferred"],
        caseSheetDocumented: json["case_sheet_documented"],
      );

  Map<String, dynamic> toJson() => {
        "institution_id": institutionId,
        "institution_name": institutionName,
        "districtname": districtname,
        "fever_alc": feverAlc,
        "focus_of_infection": focusOfInfection,
        "cough": cough,
        "cold": cold,
        "diarrhea_alc": diarrheaAlc,
        "vomiting": vomiting,
        "altered_loc": alteredLoc,
        "noisy_breathing": noisyBreathing,
        "breathlessness": breathlessness,
        "unresponsive": unresponsive,
        "regained_consciousness": regainedConsciousness,
        "foreign_body": foreignBody,
        "snake_bite": snakeBite,
        "scorpion_bite": scorpionBite,
        "insect_bite": insectBite,
        "dog_bite": dogBite,
        "bleed": bleed,
        "rash": rash,
        "acute_abdomen": acuteAbdomen,
        "trauma": trauma,
        "burns": burns,
        "poison": poison,
        "submersion": submersion,
        "seizures": seizures,
        "others": others,
        "oxygen_nrbm": oxygenNrbm,
        "oxygen_jr": oxygenJr,
        "oxygen_bvm": oxygenBvm,
        "oxygen_et": oxygenEt,
        "oxygen_cpap": oxygenCpap,
        "mdi_spacer": mdiSpacer,
        "nebulisation": nebulisation,
        "airway_manoeuvres": airwayManoeuvres,
        "iv_io_access": ivIoAccess,
        "fluid_bolus": fluidBolus,
        "dopamine": dopamine,
        "epinephrine": epinephrine,
        "cpr_chest": cprChest,
        "anticonvulsants": anticonvulsants,
        "triaged_in_queue": triagedInQueue,
        "red_flag": redFlag,
        "yellow_flag": yellowFlag,
        "green_flag": greenFlag,
        "black_flag": blackFlag,
        "treated_as_op": treatedAsOp,
        "discharged": discharged,
        "discharged_on_request": dischargedOnRequest,
        "death": death,
        "dama": dama,
        "abscond": abscond,
        "transferred": transferred,
        "case_sheet_documented": caseSheetDocumented,
      };
}
