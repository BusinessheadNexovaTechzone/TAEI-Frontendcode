// To parse this JSON data, do
//
//     final traumaDetailsModel = traumaDetailsModelFromJson(jsonString);

import 'dart:convert';

TraumaDetailsModel traumaDetailsModelFromJson(String str) =>
    TraumaDetailsModel.fromJson(json.decode(str));

String traumaDetailsModelToJson(TraumaDetailsModel data) =>
    json.encode(data.toJson());

class TraumaDetailsModel {
  TraumaDetails? trauma;
  TraumaValuesDetails? traumaValues;
  TraumaFinalDetails? traumaFinal;
  TraumaOutcomeDetails? traumaOutcome;

  TraumaDetailsModel({
    this.trauma,
    this.traumaValues,
    this.traumaFinal,
    this.traumaOutcome,
  });

  factory TraumaDetailsModel.fromJson(Map<String, dynamic> json) =>
      TraumaDetailsModel(
        trauma: json["trauma"] == null
            ? null
            : TraumaDetails.fromJson(json["trauma"]),
        traumaValues: json["trauma_values"] == null
            ? null
            : TraumaValuesDetails.fromJson(json["trauma_values"]),
        traumaFinal: json["trauma_final"] == null
            ? null
            : TraumaFinalDetails.fromJson(json["trauma_final"]),
        traumaOutcome: json["trauma_outcome"] == null
            ? null
            : TraumaOutcomeDetails.fromJson(json["trauma_outcome"]),
      );

  Map<String, dynamic> toJson() => {
        "trauma": trauma?.toJson(),
        "trauma_values": traumaValues?.toJson(),
        "trauma_final": traumaFinal?.toJson(),
        "trauma_outcome": traumaOutcome?.toJson(),
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TraumaDetails {
  int? id;
  int? triageId;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateTimeOfEntry;
  String? mechanismOfInjury;
  String? typeOfInjury;
  String? othTypeOfInjury;
  String? rta;
  bool? rtaHelmet;
  bool? iktAvailed;
  String? assault;
  String? workspotInjury;
  String? injuriesIdentified;
  String? othInjuriesIdentified;
  String? partOfTheBodyInjured;
  String? othBodyInjured;
  String? gcsEye;
  String? gcsVerbal;
  String? gcsMotor;
  String? gcsTotal;
  int? userId;
  String? insertedDate;

  TraumaDetails({
    this.id,
    this.triageId,
    this.patientAdmitted,
    this.nameOfDept,
    this.dateTimeOfEntry,
    this.mechanismOfInjury,
    this.typeOfInjury,
    this.othTypeOfInjury,
    this.rta,
    this.rtaHelmet,
    this.iktAvailed,
    this.assault,
    this.workspotInjury,
    this.injuriesIdentified,
    this.othInjuriesIdentified,
    this.partOfTheBodyInjured,
    this.othBodyInjured,
    this.gcsEye,
    this.gcsVerbal,
    this.gcsMotor,
    this.gcsTotal,
    this.userId,
    this.insertedDate,
  });

  factory TraumaDetails.fromJson(Map<String, dynamic> json) => TraumaDetails(
        id: json["id"],
        triageId: json["triage_id"],
        patientAdmitted: json["patient_admitted"],
        nameOfDept: json["name_of_dept"],
        dateTimeOfEntry: json["date_time_of_entry"],
        mechanismOfInjury: json["mechanism_of_injury"],
        typeOfInjury: json["type_of_injury"],
        othTypeOfInjury: json["oth_type_of_injury"],
        rta: json["rta"],
        rtaHelmet: json["rta_helmet"],
        iktAvailed: json["ikt_availed"],
        assault: json["assault"],
        workspotInjury: json["workspot_injury"],
        injuriesIdentified: json["injuries_identified"],
        othInjuriesIdentified: json["oth_injuries_identified"],
        partOfTheBodyInjured: json["part_of_the_body_injured"],
        othBodyInjured: json["oth_body_injured"],
        gcsEye: json["gcs_eye"],
        gcsVerbal: json["gcs_verbal"],
        gcsMotor: json["gcs_motor"],
        gcsTotal: json["gcs_total"],
        userId: json["user_id"],
        insertedDate: json["inserted_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "triage_id": triageId,
        "patient_admitted": patientAdmitted,
        "name_of_dept": nameOfDept,
        "date_time_of_entry": dateTimeOfEntry,
        "mechanism_of_injury": mechanismOfInjury,
        "type_of_injury": typeOfInjury,
        "oth_type_of_injury": othTypeOfInjury,
        "rta": rta,
        "rta_helmet": rtaHelmet,
        "ikt_availed": iktAvailed,
        "assault": assault,
        "workspot_injury": workspotInjury,
        "injuries_identified": injuriesIdentified,
        "oth_injuries_identified": othInjuriesIdentified,
        "part_of_the_body_injured": partOfTheBodyInjured,
        "oth_body_injured": othBodyInjured,
        "gcs_eye": gcsEye,
        "gcs_verbal": gcsVerbal,
        "gcs_motor": gcsMotor,
        "gcs_total": gcsTotal,
        "user_id": userId,
        "inserted_date": insertedDate,
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TraumaFinalDetails {
  int? id;
  String? specialityOpinion;
  bool? iscpr;
  String? cprDone;
  bool? bloodTransfusionDone;
  bool? onArrivalNerveBlocks;
  bool? mechIntubation;
  String? mechIntubationDtls;
  bool? firstPassIntubation;
  String? otherProcedureDone;
  String? othProcedureDone;
  String? finalDiagnosis;
  String? management;
  String? typeOfSurgery;
  String? surgeryType;
  String? surgeryName;
  String? dateTime;
  int? surgeryTakenupFromIncidentDate;
  int? surgeryTakenupFromTriageDate;
  String? nameOfSurgery;
  String? surgeryDoneUnder;
  dynamic surgeryDoneBy;
  bool? rehabilitationRequired;

  TraumaFinalDetails({
    this.id,
    this.specialityOpinion,
    this.iscpr,
    this.cprDone,
    this.bloodTransfusionDone,
    this.onArrivalNerveBlocks,
    this.mechIntubation,
    this.mechIntubationDtls,
    this.firstPassIntubation,
    this.otherProcedureDone,
    this.othProcedureDone,
    this.finalDiagnosis,
    this.management,
    this.typeOfSurgery,
    this.surgeryType,
    this.surgeryName,
    this.dateTime,
    this.surgeryTakenupFromIncidentDate,
    this.surgeryTakenupFromTriageDate,
    this.nameOfSurgery,
    this.surgeryDoneUnder,
    this.surgeryDoneBy,
    this.rehabilitationRequired,
  });

  factory TraumaFinalDetails.fromJson(Map<String, dynamic> json) =>
      TraumaFinalDetails(
        id: json["id"],
        specialityOpinion: json["speciality_opinion"],
        iscpr: json["iscpr"],
        cprDone: json["cpr_done"],
        bloodTransfusionDone: json["blood_transfusion_done"],
        onArrivalNerveBlocks: json["on_arrival_nerve_blocks"],
        mechIntubation: json["mech_intubation"],
        mechIntubationDtls: json["mech_intubation_dtls"],
        firstPassIntubation: json["first_pass_intubation"],
        otherProcedureDone: json["other_procedure_done"],
        othProcedureDone: json["oth_procedure_done"],
        finalDiagnosis: json["final_diagnosis"],
        management: json["management"],
        typeOfSurgery: json["type_of_surgery"],
        surgeryType: json["surgery_type"],
        surgeryName: json["surgery_name"],
        dateTime: json["date_time"],
        surgeryTakenupFromIncidentDate:
            json["surgery_takenup_from_incident_date"],
        surgeryTakenupFromTriageDate: json["surgery_takenup_from_triage_date"],
        nameOfSurgery: json["name_of_surgery"],
        surgeryDoneUnder: json["surgery_done_under"],
        surgeryDoneBy: json["surgery_done_by"],
        rehabilitationRequired: json["rehabilitation_required"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "speciality_opinion": specialityOpinion,
        "iscpr": iscpr,
        "cpr_done": cprDone,
        "blood_transfusion_done": bloodTransfusionDone,
        "on_arrival_nerve_blocks": onArrivalNerveBlocks,
        "mech_intubation": mechIntubation,
        "mech_intubation_dtls": mechIntubationDtls,
        "first_pass_intubation": firstPassIntubation,
        "other_procedure_done": otherProcedureDone,
        "oth_procedure_done": othProcedureDone,
        "final_diagnosis": finalDiagnosis,
        "management": management,
        "type_of_surgery": typeOfSurgery,
        "surgery_type": surgeryType,
        "surgery_name": surgeryName,
        "date_time": dateTime,
        "surgery_takenup_from_incident_date": surgeryTakenupFromIncidentDate,
        "surgery_takenup_from_triage_date": surgeryTakenupFromTriageDate,
        "name_of_surgery": nameOfSurgery,
        "surgery_done_under": surgeryDoneUnder,
        "surgery_done_by": surgeryDoneBy,
        "rehabilitation_required": rehabilitationRequired,
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TraumaOutcomeDetails {
  int? id;
  String? outcome;
  String? dischargeDatetime;
  String? dischargeDetails;
  String? hospitalType;
  String? destinationHospital;
  String? reasonForReferral;
  String? conditionOfPatient;
  String? referringDoctorName;
  bool? taeiCaseDocumented;
  String? nameOfDoctor;
  int? stayedDuration;

  TraumaOutcomeDetails({
    this.id,
    this.outcome,
    this.dischargeDatetime,
    this.dischargeDetails,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctorName,
    this.taeiCaseDocumented,
    this.nameOfDoctor,
    this.stayedDuration,
  });

  factory TraumaOutcomeDetails.fromJson(Map<String, dynamic> json) =>
      TraumaOutcomeDetails(
        id: json["id"],
        outcome: json["outcome"],
        dischargeDatetime: json["discharge_datetime"],
        dischargeDetails: json["discharge_details"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctorName: json["referring_doctor_name"],
        taeiCaseDocumented: json["taei_case_documented"],
        nameOfDoctor: json["name_of_doctor"],
        stayedDuration: json["stayed_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "outcome": outcome,
        "discharge_datetime": dischargeDatetime,
        "discharge_details": dischargeDetails,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor_name": referringDoctorName,
        "taei_case_documented": taeiCaseDocumented,
        "name_of_doctor": nameOfDoctor,
        "stayed_duration": stayedDuration,
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TraumaValuesDetails {
  int? id;
  int? bpSystolic;
  int? bpDiastolic;
  double? rr;
  double? rtsAutogenerate;
  String? traumaFlag;
  bool? admitted;
  bool? ecg;
  String? ecgfindings;
  bool? xray;
  String? xrayDateTime;
  String? xrayfindings;
  bool? efast;
  String? efastDateTime;
  String? efastfindings;
  bool? ct;
  String? ctDateTime;
  String? ctfindings;
  bool? mri;
  String? mriDateTime;
  String? mrifindings;
  bool? abg;
  String? abgDateTime;
  String? abgfindings;
  bool? bloodInvestigation;
  String? bloodDateTime;
  bool? hcg;
  String? hcgDateTime;
  bool? urineTest;
  String? urineDateTime;
  String? othSpecify;
  String? othDateTime;

  TraumaValuesDetails({
    this.id,
    this.bpSystolic,
    this.bpDiastolic,
    this.rr,
    this.rtsAutogenerate,
    this.traumaFlag,
    this.admitted,
    this.ecg,
    this.ecgfindings,
    this.xray,
    this.xrayDateTime,
    this.xrayfindings,
    this.efast,
    this.efastDateTime,
    this.efastfindings,
    this.ct,
    this.ctDateTime,
    this.ctfindings,
    this.mri,
    this.mriDateTime,
    this.mrifindings,
    this.abg,
    this.abgDateTime,
    this.abgfindings,
    this.bloodInvestigation,
    this.bloodDateTime,
    this.hcg,
    this.hcgDateTime,
    this.urineTest,
    this.urineDateTime,
    this.othSpecify,
    this.othDateTime,
  });

  factory TraumaValuesDetails.fromJson(Map<String, dynamic> json) =>
      TraumaValuesDetails(
        id: json["id"],
        bpSystolic: json["bp_systolic"],
        bpDiastolic: json["bp_diastolic"],
        rr: json["rr"]?.toDouble(),
        rtsAutogenerate: json["rts_autogenerate"]?.toDouble(),
        traumaFlag: json["trauma_flag"],
        admitted: json["admitted"],
        ecg: json["ecg"],
        ecgfindings: json["ecgfindings"],
        xray: json["xray"],
        xrayDateTime: json["xray_date_time"],
        xrayfindings: json["xrayfindings"],
        efast: json["efast"],
        efastDateTime: json["efast_date_time"],
        efastfindings: json["efastfindings"],
        ct: json["ct"],
        ctDateTime: json["ct_date_time"],
        ctfindings: json["ctfindings"],
        mri: json["mri"],
        mriDateTime: json["mri_date_time"],
        mrifindings: json["mrifindings"],
        abg: json["abg"],
        abgDateTime: json["abg_date_time"],
        abgfindings: json["abgfindings"],
        bloodInvestigation: json["blood_investigation"],
        bloodDateTime: json["blood_date_time"],
        hcg: json["hcg"],
        hcgDateTime: json["hcg_date_time"],
        urineTest: json["urine_test"],
        urineDateTime: json["urine_date_time"],
        othSpecify: json["oth_specify"],
        othDateTime: json["oth_date_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bp_systolic": bpSystolic,
        "bp_diastolic": bpDiastolic,
        "rr": rr,
        "rts_autogenerate": rtsAutogenerate,
        "trauma_flag": traumaFlag,
        "admitted": admitted,
        "ecg": ecg,
        "ecgfindings": ecgfindings,
        "xray": xray,
        "xray_date_time": xrayDateTime,
        "xrayfindings": xrayfindings,
        "efast": efast,
        "efast_date_time": efastDateTime,
        "efastfindings": efastfindings,
        "ct": ct,
        "ct_date_time": ctDateTime,
        "ctfindings": ctfindings,
        "mri": mri,
        "mri_date_time": mriDateTime,
        "mrifindings": mrifindings,
        "abg": abg,
        "abg_date_time": abgDateTime,
        "abgfindings": abgfindings,
        "blood_investigation": bloodInvestigation,
        "blood_date_time": bloodDateTime,
        "hcg": hcg,
        "hcg_date_time": hcgDateTime,
        "urine_test": urineTest,
        "urine_date_time": urineDateTime,
        "oth_specify": othSpecify,
        "oth_date_time": othDateTime,
      };
  @override
  String toString() => jsonEncode(toJson());
}
