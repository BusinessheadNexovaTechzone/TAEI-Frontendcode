// To parse this JSON data, do
//
//     final poisoningInstitutionalDashboardModel = poisoningInstitutionalDashboardModelFromJson(jsonString);

import 'dart:convert';

PoisoningInstitutionalDashboardModel
    poisoningInstitutionalDashboardModelFromJson(String str) =>
        PoisoningInstitutionalDashboardModel.fromJson(json.decode(str));

String poisoningInstitutionalDashboardModelToJson(
        PoisoningInstitutionalDashboardModel data) =>
    json.encode(data.toJson());

class PoisoningInstitutionalDashboardModel {
  Data? data;

  PoisoningInstitutionalDashboardModel({
    this.data,
  });

  factory PoisoningInstitutionalDashboardModel.fromJson(
          Map<String, dynamic> json) =>
      PoisoningInstitutionalDashboardModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  List<Poison>? poison;
  List<Bite>? bites;
  List<Hanging>? hanging;
  int? poisonAdmitted;
  int? bitesAdmitted;
  int? hangingAdmitted;
  int? poisonPlexDone;
  int? iftCount;
  List<PoisonOutcome>? poisonOutcome;
  List<BitesOutcome>? bitesOutcome;
  List<HangingOutcome>? hangingOutcome;
  double? bitesAvgDays;
  double? poisonAvgDays;
  double? hangingAvgDays;
  int? drowningAvgDays;

  Data({
    this.poison,
    this.bites,
    this.hanging,
    this.poisonAdmitted,
    this.bitesAdmitted,
    this.hangingAdmitted,
    this.poisonPlexDone,
    this.iftCount,
    this.poisonOutcome,
    this.bitesOutcome,
    this.hangingOutcome,
    this.bitesAvgDays,
    this.poisonAvgDays,
    this.hangingAvgDays,
    this.drowningAvgDays,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        poison: json["poison"] == null
            ? []
            : List<Poison>.from(json["poison"]!.map((x) => Poison.fromJson(x))),
        bites: json["bites"] == null
            ? []
            : List<Bite>.from(json["bites"]!.map((x) => Bite.fromJson(x))),
        hanging: json["hanging"] == null
            ? []
            : List<Hanging>.from(
                json["hanging"]!.map((x) => Hanging.fromJson(x))),
        poisonAdmitted: json["poison_admitted"],
        bitesAdmitted: json["bites_admitted"],
        hangingAdmitted: json["hanging_admitted"],
        poisonPlexDone: json["poison_plex_done"],
        iftCount: json["ift_count"],
        poisonOutcome: json["poison_outcome"] == null
            ? []
            : List<PoisonOutcome>.from(
                json["poison_outcome"]!.map((x) => PoisonOutcome.fromJson(x))),
        bitesOutcome: json["bites_outcome"] == null
            ? []
            : List<BitesOutcome>.from(
                json["bites_outcome"]!.map((x) => BitesOutcome.fromJson(x))),
        hangingOutcome: json["hanging_outcome"] == null
            ? []
            : List<HangingOutcome>.from(json["hanging_outcome"]!
                .map((x) => HangingOutcome.fromJson(x))),
        bitesAvgDays: json["bites_avg_days"]?.toDouble(),
        poisonAvgDays: json["poison_avg_days"]?.toDouble(),
        hangingAvgDays: json["hanging_avg_days"]?.toDouble(),
        drowningAvgDays: json["drowning_avg_days"],
      );

  Map<String, dynamic> toJson() => {
        "poison": poison == null
            ? []
            : List<dynamic>.from(poison!.map((x) => x.toJson())),
        "bites": bites == null
            ? []
            : List<dynamic>.from(bites!.map((x) => x.toJson())),
        "hanging": hanging == null
            ? []
            : List<dynamic>.from(hanging!.map((x) => x.toJson())),
        "poison_admitted": poisonAdmitted,
        "bites_admitted": bitesAdmitted,
        "hanging_admitted": hangingAdmitted,
        "poison_plex_done": poisonPlexDone,
        "ift_count": iftCount,
        "poison_outcome": poisonOutcome == null
            ? []
            : List<dynamic>.from(poisonOutcome!.map((x) => x.toJson())),
        "bites_outcome": bitesOutcome == null
            ? []
            : List<dynamic>.from(bitesOutcome!.map((x) => x.toJson())),
        "hanging_outcome": hangingOutcome == null
            ? []
            : List<dynamic>.from(hangingOutcome!.map((x) => x.toJson())),
        "bites_avg_days": bitesAvgDays,
        "poison_avg_days": poisonAvgDays,
        "hanging_avg_days": hangingAvgDays,
        "drowning_avg_days": drowningAvgDays,
      };
}

class Bite {
  String? name;
  int? bitesStingsCount;

  Bite({
    this.name,
    this.bitesStingsCount,
  });

  factory Bite.fromJson(Map<String, dynamic> json) => Bite(
        name: json["name"],
        bitesStingsCount: json["bites_stings_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "bites_stings_count": bitesStingsCount,
      };
}

class BitesOutcome {
  int? id;
  String? name;
  int? bitesTotalCount;

  BitesOutcome({
    this.id,
    this.name,
    this.bitesTotalCount,
  });

  factory BitesOutcome.fromJson(Map<String, dynamic> json) => BitesOutcome(
        id: json["id"],
        name: json["name"],
        bitesTotalCount: json["bites_total_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bites_total_count": bitesTotalCount,
      };
}

class Hanging {
  String? name;
  int? hangingCount;

  Hanging({
    this.name,
    this.hangingCount,
  });

  factory Hanging.fromJson(Map<String, dynamic> json) => Hanging(
        name: json["name"],
        hangingCount: json["hanging_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hanging_count": hangingCount,
      };
}

class HangingOutcome {
  int? id;
  String? name;
  int? hangingTotalCount;

  HangingOutcome({
    this.id,
    this.name,
    this.hangingTotalCount,
  });

  factory HangingOutcome.fromJson(Map<String, dynamic> json) => HangingOutcome(
        id: json["id"],
        name: json["name"],
        hangingTotalCount: json["hanging_total_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hanging_total_count": hangingTotalCount,
      };
}

class Poison {
  String? name;
  int? poisonCount;

  Poison({
    this.name,
    this.poisonCount,
  });

  factory Poison.fromJson(Map<String, dynamic> json) => Poison(
        name: json["name"],
        poisonCount: json["poison_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "poison_count": poisonCount,
      };
}

class PoisonOutcome {
  int? id;
  String? name;
  int? poisonTotalCount;

  PoisonOutcome({
    this.id,
    this.name,
    this.poisonTotalCount,
  });

  factory PoisonOutcome.fromJson(Map<String, dynamic> json) => PoisonOutcome(
        id: json["id"],
        name: json["name"],
        poisonTotalCount: json["poison_total_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "poison_total_count": poisonTotalCount,
      };
}
