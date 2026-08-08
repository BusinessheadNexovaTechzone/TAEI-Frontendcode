// To parse this JSON data, do
//
//     final traumaModel = traumaModelFromJson(jsonString);

import 'dart:convert';

TraumaModel traumaModelFromJson(String str) =>
    TraumaModel.fromJson(json.decode(str));

String traumaModelToJson(TraumaModel data) => json.encode(data.toJson());

class TraumaModel {
  Trauma? trauma;
  TraumaValues? traumaValues;
  TraumaFinal? traumaFinal;
  TraumaOutcome? traumaOutcome;

  TraumaModel({
    this.trauma,
    this.traumaValues,
    this.traumaFinal,
    this.traumaOutcome,
  });

  factory TraumaModel.fromJson(Map<String, dynamic> json) => TraumaModel(
        trauma: json["trauma"] == null ? null : Trauma.fromJson(json["trauma"]),
        traumaValues: json["trauma_values"] == null
            ? null
            : TraumaValues.fromJson(json["trauma_values"]),
        traumaFinal: json["trauma_final"] == null
            ? null
            : TraumaFinal.fromJson(json["trauma_final"]),
        traumaOutcome: json["trauma_outcome"] == null
            ? null
            : TraumaOutcome.fromJson(json["trauma_outcome"]),
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

class Trauma {
  int? id;
  int? triageId;
  bool? patientAdmitted;
  String? nameOfDept;
  String? dateTimeOfEntry;
  int? mechanismOfInjury;
  int? typeOfInjury;
  dynamic othTypeOfInjury;
  dynamic rta;
  dynamic rtaHelmet;
  dynamic iktAvailed;
  dynamic assault;
  dynamic workspotInjury;
  List<int>? injuriesIdentified;
  dynamic othInjuriesIdentified;
  List<int>? partOfTheBodyInjured;
  dynamic othBodyInjured;
  int? gcsEye;
  int? gcsVerbal;
  int? gcsMotor;
  dynamic gcsTotal;

  Trauma({
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
  });

  factory Trauma.fromJson(Map<String, dynamic> json) => Trauma(
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
        injuriesIdentified: json["injuries_identified"] == null
            ? []
            : List<int>.from(json["injuries_identified"]!.map((x) => x)),
        othInjuriesIdentified: json["oth_injuries_identified"],
        partOfTheBodyInjured: json["part_of_the_body_injured"] == null
            ? []
            : List<int>.from(json["part_of_the_body_injured"]!.map((x) => x)),
        othBodyInjured: json["oth_body_injured"],
        gcsEye: json["gcs_eye"],
        gcsVerbal: json["gcs_verbal"],
        gcsMotor: json["gcs_motor"],
        gcsTotal: json["gcs_total"],
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
        "injuries_identified": injuriesIdentified == null
            ? []
            : List<dynamic>.from(injuriesIdentified!.map((x) => x)),
        "oth_injuries_identified": othInjuriesIdentified,
        "part_of_the_body_injured": partOfTheBodyInjured == null
            ? []
            : List<dynamic>.from(partOfTheBodyInjured!.map((x) => x)),
        "oth_body_injured": othBodyInjured,
        "gcs_eye": gcsEye,
        "gcs_verbal": gcsVerbal,
        "gcs_motor": gcsMotor,
        "gcs_total": gcsTotal,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class TraumaFinal {
  int? id;
  int? traumaId;
  List<int>? specialityOpinion;
  dynamic iscpr;
  dynamic cprDone;
  dynamic bloodTransfusionDone;
  dynamic onArrivalNerveBlocks;
  dynamic mechIntubation;
  dynamic mechIntubationDtls;
  dynamic firstPassIntubation;
  int? otherProcedureDone;
  dynamic othProcedureDone;
  String? finalDiagnosis;
  int? management;
  dynamic typeOfSurgery;

  //"surgery_type": 1,
  //"surgery_name": "test surgery name",
  // "date_time": "2025-09-17T14:00:00Z",
  //"surgery_takenup_from_incident_date": 2,
  //"surgery_takenup_from_triage_date": 3,
  //"name_of_surgery": "surgery name",
  int? surgeryType;
  String? surgeryName;
  String? dateTime;
  int? surgeryTakenupFromIncidentDate;
  int? surgeryTakenupFromTriageDate;
  int? nameOfSpeciality;
  String? doneBy;
  String? nameOfSurgery;
  dynamic surgeryDoneUnder;
  dynamic rehabilitationRequired;

  TraumaFinal({
    this.id,
    this.traumaId,
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
    this.doneBy,
    this.nameOfSpeciality,
    this.surgeryDoneUnder,
    this.rehabilitationRequired,
  });

  factory TraumaFinal.fromJson(Map<String, dynamic> json) => TraumaFinal(
        id: json["id"],
        traumaId: json["trauma_id"],
        specialityOpinion: json["speciality_opinion"] == null
            ? []
            : List<int>.from(json["speciality_opinion"]!.map((x) => x)),
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
        doneBy: json["surgery_done_by"],
        nameOfSpeciality: json["name_of_speciality"],
        surgeryDoneUnder: json["surgery_done_under"],
        rehabilitationRequired: json["rehabilitation_required"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trauma_id": traumaId,
        "speciality_opinion": specialityOpinion == null
            ? []
            : List<dynamic>.from(specialityOpinion!.map((x) => x)),
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
        "surgery_done_by": doneBy,
        "name_of_speciality": nameOfSpeciality,
        "name_of_surgery": nameOfSurgery,
        "surgery_done_under": surgeryDoneUnder,
        "rehabilitation_required": rehabilitationRequired,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class TraumaOutcome {
  int? id;
  int? traumaId;

  /// "outcome": 1,
  //         "is_discharged": false,
  //         "discharge_datetime": "2025-08-17T14:00:00Z",
  //         "discharge_details": "Stable at discharge",
  //         "hospital_type": 2,
  //         "destination_hospital": "Free text 256 char",
  //         "destination_taei_hospital": 1,
  //         "reason_for_referral": 1,
  //         "condition_of_patient": 2,
  //         "referring_doctor_name": "Dr. Smith",
  //         "taei_case_documented": true,
  //         "name_of_doctor": "Dr. Adams",
  //         "stayed_duration": 0
  int? outcome;
  String? dischargeDatetime;
  String? dischargeDetails;
  int? hospitalType;
  String? destinationHospital;
  int? destinationTaeiHospital;
  int? reasonForReferral;
  int? conditionOfPatient;
  String? referringDoctorName;
  dynamic taeiCaseDocumented;
  dynamic nameOfDoctor;
  dynamic stayedDuration;
  bool? isDischarged;

  TraumaOutcome({
    this.id,
    this.traumaId,
    this.outcome,
    this.dischargeDatetime,
    this.dischargeDetails,
    this.hospitalType,
    this.destinationHospital,
    this.destinationTaeiHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
    this.referringDoctorName,
    this.taeiCaseDocumented,
    this.nameOfDoctor,
    this.stayedDuration,
    this.isDischarged,
  });

  factory TraumaOutcome.fromJson(Map<String, dynamic> json) => TraumaOutcome(
        id: json["id"],
        traumaId: json["trauma_id"],
        outcome: json["outcome"],
        dischargeDatetime: json["discharge_datetime"],
        dischargeDetails: json["discharge_details"],
        hospitalType: json["hospital_type"],
        destinationHospital: json["destination_hospital"],
        destinationTaeiHospital: json["destination_taei_hospital"],
        reasonForReferral: json["reason_for_referral"],
        conditionOfPatient: json["condition_of_patient"],
        referringDoctorName: json["referring_doctor_name"],
        taeiCaseDocumented: json["taei_case_documented"],
        nameOfDoctor: json["name_of_doctor"],
        stayedDuration: json["stayed_duration"],
        isDischarged: json["is_discharged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trauma_id": traumaId,
        "outcome": outcome,
        "discharge_datetime": dischargeDatetime,
        "discharge_details": dischargeDetails,
        "hospital_type": hospitalType,
        "destination_hospital": destinationHospital,
        "destination_taei_hospital": destinationTaeiHospital,
        "reason_for_referral": reasonForReferral,
        "condition_of_patient": conditionOfPatient,
        "referring_doctor_name": referringDoctorName,
        "taei_case_documented": taeiCaseDocumented,
        "name_of_doctor": nameOfDoctor,
        "stayed_duration": stayedDuration,
        "is_discharged": isDischarged,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class TraumaValues {
  int? id;
  int? traumaId;
  int? bpSystolic;
  int? bpDiastolic;
  String? rr;
  dynamic rtsAutogenerate;
  int? traumaFlag;
  dynamic admitted;
  dynamic ecg;
  dynamic ecgfindings;
  dynamic xray;
  String? xrayDateTime;
  dynamic xrayfindings;
  dynamic efast;
  String? efastDateTime;
  dynamic efastfindings;
  dynamic ct;
  String? ctDateTime;
  dynamic ctfindings;
  dynamic mri;
  String? mriDateTime;
  dynamic mrifindings;
  dynamic abg;
  String? abgDateTime;
  dynamic abgfindings;
  dynamic bloodInvestigation;
  String? bloodDateTime;
  dynamic hcg;
  String? hcgDateTime;
  bool? urineTest;
  String? urineDateTime;
  String? othSpecify;
  String? othDateTime;

  TraumaValues({
    this.id,
    this.traumaId,
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

  factory TraumaValues.fromJson(Map<String, dynamic> json) => TraumaValues(
        id: json["id"],
        traumaId: json["trauma_id"],
        bpSystolic: json["bp_systolic"],
        bpDiastolic: json["bp_diastolic"],
        rr: json["rr"],
        rtsAutogenerate: json["rts_autogenerate"],
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
        "trauma_id": traumaId,
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

extension TraumaModelClean on TraumaModel {
  /// Returns a clean JSON without any IDs
  Map<String, dynamic> toCleanJson() {
    final data = toJson();

    // Remove unwanted ids
    if (data['trauma'] != null) {
      data['trauma'].remove('id');
    }
    if (data['trauma_values'] != null) {
      data['trauma_values'].remove('id');
      data['trauma_values'].remove('trauma_id');
    }
    if (data['trauma_final'] != null) {
      data['trauma_final'].remove('id');
      data['trauma_final'].remove('trauma_id');
    }
    if (data['trauma_outcome'] != null) {
      data['trauma_outcome'].remove('id');
      data['trauma_outcome'].remove('trauma_id');
    }

    return data;
  }
}
