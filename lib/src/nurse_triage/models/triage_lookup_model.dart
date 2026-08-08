// To parse this JSON data, do
//
//     final triageLookupModel = triageLookupModelFromJson(jsonString);

import 'dart:convert';

import 'package:taei_gov/src/emo_user/model/emo_lookup_model.dart';

TriageLookupModel triageLookupModelFromJson(String str) =>
    TriageLookupModel.fromJson(json.decode(str));

String triageLookupModelToJson(TriageLookupModel data) =>
    json.encode(data.toJson());

class TriageLookupModel {
  List<LooksUpItem>? genders;
  List<LooksUpItem>? mtSts;
  List<LooksUpItem>? edu;
  List<LooksUpItem>? empSts;
  List<LooksUpItem>? occ;
  List<LooksUpItem>? prf;
  List<LooksUpItem>? arrival;
  List<LooksUpItem>? srctyp;
  List<LooksUpItem>? ror;
  List<LooksUpItem>? cop;
  List<LooksUpItem>? poI;
  List<LooksUpItem>? ab;
  List<LooksUpItem>? burns;
  List<LooksUpItem>? pbsh;
  List<LooksUpItem>? script;
  List<LooksUpItem>? miAcs;
  List<LooksUpItem>? me;
  List<LooksUpItem>? se;
  List<LooksUpItem>? pc;
  List<LooksUpItem>? cause;
  List<LooksUpItem>? avpu;
  List<LooksUpItem>? bs;
  List<LooksUpItem>? tf;
  List<LooksUpItem>? district;
  List<LooksUpItem>? state;
  List<LooksUpItem>? rta;
  List<LooksUpItem>? workspotInjury;
  List<LooksUpItem>? rtaRiderType;

  TriageLookupModel({
    this.genders,
    this.mtSts,
    this.edu,
    this.empSts,
    this.occ,
    this.prf,
    this.arrival,
    this.srctyp,
    this.ror,
    this.cop,
    this.poI,
    this.ab,
    this.burns,
    this.pbsh,
    this.script,
    this.miAcs,
    this.me,
    this.se,
    this.pc,
    this.cause,
    this.avpu,
    this.bs,
    this.tf,
    this.district,
    this.state,
    this.rta,
    this.workspotInjury,
    this.rtaRiderType,
  });

  factory TriageLookupModel.fromJson(Map<String, dynamic> json) =>
      TriageLookupModel(
        genders: json["genders"] == null
            ? []
            : List<LooksUpItem>.from(
                json["genders"]!.map((x) => LooksUpItem.fromJson(x))),
        mtSts: json["MtSts"] == null
            ? []
            : List<LooksUpItem>.from(
                json["MtSts"]!.map((x) => LooksUpItem.fromJson(x))),
        edu: json["Edu"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Edu"]!.map((x) => LooksUpItem.fromJson(x))),
        empSts: json["EmpSts"] == null
            ? []
            : List<LooksUpItem>.from(
                json["EmpSts"]!.map((x) => LooksUpItem.fromJson(x))),
        occ: json["Occ"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Occ"]!.map((x) => LooksUpItem.fromJson(x))),
        prf: json["prf"] == null
            ? []
            : List<LooksUpItem>.from(
                json["prf"]!.map((x) => LooksUpItem.fromJson(x))),
        arrival: json["Arrival"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Arrival"]!.map((x) => LooksUpItem.fromJson(x))),
        srctyp: json["Srctyp"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Srctyp"]!.map((x) => LooksUpItem.fromJson(x))),
        ror: json["Ror"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Ror"]!.map((x) => LooksUpItem.fromJson(x))),
        cop: json["Cop"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Cop"]!.map((x) => LooksUpItem.fromJson(x))),
        poI: json["PoI"] == null
            ? []
            : List<LooksUpItem>.from(
                json["PoI"]!.map((x) => LooksUpItem.fromJson(x))),
        ab: json["Ab"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Ab"]!.map((x) => LooksUpItem.fromJson(x))),
        burns: json["Burns"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Burns"]!.map((x) => LooksUpItem.fromJson(x))),
        pbsh: json["Pbsh"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Pbsh"]!.map((x) => LooksUpItem.fromJson(x))),
        script: json["Script"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Script"]!.map((x) => LooksUpItem.fromJson(x))),
        miAcs: json["MiAcs"] == null
            ? []
            : List<LooksUpItem>.from(
                json["MiAcs"]!.map((x) => LooksUpItem.fromJson(x))),
        me: json["Me"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Me"]!.map((x) => LooksUpItem.fromJson(x))),
        se: json["Se"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Se"]!.map((x) => LooksUpItem.fromJson(x))),
        pc: json["Pc"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Pc"]!.map((x) => LooksUpItem.fromJson(x))),
        cause: json["Cause"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Cause"]!.map((x) => LooksUpItem.fromJson(x))),
        avpu: json["Avpu"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Avpu"]!.map((x) => LooksUpItem.fromJson(x))),
        bs: json["Bs"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Bs"]!.map((x) => LooksUpItem.fromJson(x))),
        tf: json["Tf"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Tf"]!.map((x) => LooksUpItem.fromJson(x))),
        district: json["District"] == null
            ? []
            : List<LooksUpItem>.from(
                json["District"]!.map((x) => LooksUpItem.fromJson(x))),
        state: json["State"] == null
            ? []
            : List<LooksUpItem>.from(
                json["State"]!.map((x) => LooksUpItem.fromJson(x))),
        rta: json["Rta"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Rta"]!.map((x) => LooksUpItem.fromJson(x))),
        workspotInjury: json["Wsi"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Wsi"]!.map((x) => LooksUpItem.fromJson(x))),
        rtaRiderType: json["Rrt"] == null
            ? []
            : List<LooksUpItem>.from(
                json["Rrt"]!.map((x) => LooksUpItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genders": genders == null
            ? []
            : List<dynamic>.from(genders!.map((x) => x.toJson())),
        "MtSts": mtSts == null
            ? []
            : List<dynamic>.from(mtSts!.map((x) => x.toJson())),
        "Edu":
            edu == null ? [] : List<dynamic>.from(edu!.map((x) => x.toJson())),
        "EmpSts": empSts == null
            ? []
            : List<dynamic>.from(empSts!.map((x) => x.toJson())),
        "Occ":
            occ == null ? [] : List<dynamic>.from(occ!.map((x) => x.toJson())),
        "prf":
            prf == null ? [] : List<dynamic>.from(prf!.map((x) => x.toJson())),
        "Arrival": arrival == null
            ? []
            : List<dynamic>.from(arrival!.map((x) => x.toJson())),
        "Srctyp": srctyp == null
            ? []
            : List<dynamic>.from(srctyp!.map((x) => x.toJson())),
        "Ror":
            ror == null ? [] : List<dynamic>.from(ror!.map((x) => x.toJson())),
        "Cop":
            cop == null ? [] : List<dynamic>.from(cop!.map((x) => x.toJson())),
        "PoI":
            poI == null ? [] : List<dynamic>.from(poI!.map((x) => x.toJson())),
        "Ab": ab == null ? [] : List<dynamic>.from(ab!.map((x) => x.toJson())),
        "Burns": burns == null
            ? []
            : List<dynamic>.from(burns!.map((x) => x.toJson())),
        "Pbsh": pbsh == null
            ? []
            : List<dynamic>.from(pbsh!.map((x) => x.toJson())),
        "Script": script == null
            ? []
            : List<dynamic>.from(script!.map((x) => x.toJson())),
        "MiAcs": miAcs == null
            ? []
            : List<dynamic>.from(miAcs!.map((x) => x.toJson())),
        "Me": me == null ? [] : List<dynamic>.from(me!.map((x) => x.toJson())),
        "Se": se == null ? [] : List<dynamic>.from(se!.map((x) => x.toJson())),
        "Pc": pc == null ? [] : List<dynamic>.from(pc!.map((x) => x.toJson())),
        "Cause": cause == null
            ? []
            : List<dynamic>.from(cause!.map((x) => x.toJson())),
        "Avpu": avpu == null
            ? []
            : List<dynamic>.from(avpu!.map((x) => x.toJson())),
        "Bs": bs == null ? [] : List<dynamic>.from(bs!.map((x) => x.toJson())),
        "Tf": tf == null ? [] : List<dynamic>.from(tf!.map((x) => x.toJson())),
        "District": district == null
            ? []
            : List<dynamic>.from(district!.map((x) => x.toJson())),
        "State": state == null
            ? []
            : List<dynamic>.from(state!.map((x) => x.toJson())),
        "rta":
            rta == null ? [] : List<dynamic>.from(rta!.map((x) => x.toJson())),
        "workspotInjury": workspotInjury == null
            ? []
            : List<dynamic>.from(workspotInjury!.map((x) => x.toJson())),
      };

  @override
  String toString() => jsonEncode(toJson());
}
