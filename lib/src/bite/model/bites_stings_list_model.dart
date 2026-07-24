// // To parse this JSON data, do
// //
// //     final bitesAndStingsListModel = bitesAndStingsListModelFromJson(jsonString);
//
// import 'dart:convert';
//
// BitesAndStingsListModel bitesAndStingsListModelFromJson(String str) =>
//     BitesAndStingsListModel.fromJson(json.decode(str));
//
// String bitesAndStingsListModelToJson(BitesAndStingsListModel data) =>
//     json.encode(data.toJson());
//
// class BitesAndStingsListModel {
//   int? totalCount;
//   List<BitesAndStingsListData>? bitesAndStingsListData;
//
//   BitesAndStingsListModel({
//     this.totalCount,
//     this.bitesAndStingsListData,
//   });
//
//   factory BitesAndStingsListModel.fromJson(Map<String, dynamic> json) =>
//       BitesAndStingsListModel(
//         totalCount: json["totalCount"],
//         bitesAndStingsListData: json["rows"] == null
//             ? []
//             : List<BitesAndStingsListData>.from(
//                 json["rows"]!.map((x) => BitesAndStingsListData.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "totalCount": totalCount,
//         "rows": bitesAndStingsListData == null
//             ? []
//             : List<dynamic>.from(
//                 bitesAndStingsListData!.map((x) => x.toJson())),
//       };
// }
//
// class BitesAndStingsListData {
//   int? triageId;
//   String? modeOfArrival;
//   String? sceneIft;
//   String? nameOfPatient;
//   String? emergencyCategory;
//   String? presentingComplaint;
//   String? sourceHospital;
//   String? destinationHospital;
//   int? statusid;
//   String? triageFlag;
//   dynamic bitesStingsId;
//
//   BitesAndStingsListData({
//     this.triageId,
//     this.modeOfArrival,
//     this.sceneIft,
//     this.nameOfPatient,
//     this.emergencyCategory,
//     this.presentingComplaint,
//     this.sourceHospital,
//     this.destinationHospital,
//     this.statusid,
//     this.triageFlag,
//     this.bitesStingsId,
//   });
//
//   factory BitesAndStingsListData.fromJson(Map<String, dynamic> json) =>
//       BitesAndStingsListData(
//         triageId: json["triage_id"],
//         modeOfArrival: json["mode_of_arrival"],
//         sceneIft: json["scene_ift"],
//         nameOfPatient: json["name_of_patient"],
//         emergencyCategory: json["emergency_category"],
//         presentingComplaint: json["presenting_complaint"],
//         sourceHospital: json["source_hospital"],
//         destinationHospital: json["destination_hospital"],
//         statusid: json["statusid"],
//         triageFlag: json["triage_flag"],
//         bitesStingsId: json["bites_stings_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "triage_id": triageId,
//         "mode_of_arrival": modeOfArrival,
//         "scene_ift": sceneIft,
//         "name_of_patient": nameOfPatient,
//         "emergency_category": emergencyCategory,
//         "presenting_complaint": presentingComplaint,
//         "source_hospital": sourceHospital,
//         "destination_hospital": destinationHospital,
//         "statusid": statusid,
//         "triage_flag": triageFlag,
//         "bites_stings_id": bitesStingsId,
//       };
// }
