import 'dart:convert';

// Helper function to easily convert the main object to and from a JSON string
String patientResponseModelToJson(PatientResponseModel data) => json.encode(data.toJson());
PatientResponseModel patientResponseModelFromJson(String str) => PatientResponseModel.fromJson(json.decode(str));

class PatientResponseModel {
  int? totalCount;
  List<PatientRow>? rows;

  PatientResponseModel({
    this.totalCount,
    this.rows,
  });

  factory PatientResponseModel.fromJson(Map<String, dynamic> json) => PatientResponseModel(
    totalCount: json["totalCount"],
    rows: json["rows"] == null ? null : List<PatientRow>.from(json["rows"].map((x) => PatientRow.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "rows": rows == null ? null : List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class PatientRow {
  int? patientId;
  String? patientOpNumber;
  String? nameOfPatient;
  String? gender;
  String? patientMobileNumber;
  String? fathername;
  String? mothername;
  String? nameOfDept;

  PatientRow({
    this.patientId,
    this.patientOpNumber,
    this.nameOfPatient,
    this.gender,
    this.patientMobileNumber,
    this.fathername,
    this.mothername,
    this.nameOfDept,
  });

  factory PatientRow.fromJson(Map<String, dynamic> json) => PatientRow(
    patientId: json["patient_id"],
    patientOpNumber: json["patient_op_number"],
    nameOfPatient: json["name_of_patient"],
    gender: json["gender"],
    patientMobileNumber: json["patient_mobile_number"],
    fathername: json["fathername"],
    mothername: json["mothername"],
    nameOfDept: json["name_of_dept"],
  );

  Map<String, dynamic> toJson() => {
    "patient_id": patientId,
    "patient_op_number": patientOpNumber,
    "name_of_patient": nameOfPatient,
    "gender": gender,
    "patient_mobile_number": patientMobileNumber,
    "fathername": fathername,
    "mothername": mothername,
    "name_of_dept": nameOfDept,
  };
}