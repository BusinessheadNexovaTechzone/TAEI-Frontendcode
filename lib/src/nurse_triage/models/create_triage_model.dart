// To parse this JSON data, do
//
//     final triageModel = triageModelFromJson(jsonString);

import 'dart:convert';

TriageModel triageModelFromJson(String str) =>
    TriageModel.fromJson(json.decode(str));

String triageModelToJson(TriageModel data) => json.encode(data.toJson());

class TriageModel {
  Triage? triage;
  TriageBy108? triageBy108;
  TriageDtls? triageDtls;

  TriageModel({
    this.triage,
    this.triageBy108,
    this.triageDtls,
  });

  factory TriageModel.fromJson(Map<String, dynamic> json) => TriageModel(
        triage: json["triage"] == null ? null : Triage.fromJson(json["triage"]),
        triageBy108: json["triage_by_108"] == null
            ? null
            : TriageBy108.fromJson(json["triage_by_108"]),
        triageDtls: json["triage_dtls"] == null
            ? null
            : TriageDtls.fromJson(json["triage_dtls"]),
      );

  Map<String, dynamic> toJson() => {
        "triage": triage?.toJson(),
        "triage_by_108": triageBy108?.toJson(),
        "triage_dtls": triageDtls?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Triage {
  int? id;
  String? dateTimeOfTriage;
  bool? typeOfPatient;
  String? nameOfPatient;
  int? ageYear;
  int? ageMonth;
  dynamic fathername;
  dynamic mothername;
  int? gender;
  int? maritalStatus;
  String? patientMobileNumber;
  String? aadhaar;
  int? education;
  int? employmentStatus;
  int? occupation;
  String? income;
  int? patientEhrId;
  dynamic cmchisCard;
  dynamic abhaCard;
  dynamic phrId;
  dynamic hmisId;
  String? addressLine;
  int? district;
  int? state;
  String? pincode;
  int? patienrRecievedFrom;
  dynamic othPatienrRecievedFrom;
  int? modeOfArrival;
  int? sceneIft;
  dynamic sourceType;
  dynamic sourceHospital;
  dynamic destinationHospital;
  dynamic reasonForReferral;
  dynamic othReasonForReferral;
  dynamic referralDoctorName;
  dynamic conditionOfPatient;
  dynamic isPatientStableIft;
  String? dateAndTimeOfIncident;
  int? placeOfIncident;
  String? otherPlaceOfIncident;
  int? institutionId;
  int? abhaProfileId;

  Triage({
    this.id,
    this.dateTimeOfTriage,
    this.typeOfPatient,
    this.nameOfPatient,
    this.ageYear,
    this.ageMonth,
    this.fathername,
    this.mothername,
    this.gender,
    this.maritalStatus,
    this.patientMobileNumber,
    this.aadhaar,
    this.education,
    this.employmentStatus,
    this.occupation,
    this.income,
    this.patientEhrId,
    this.cmchisCard,
    this.abhaCard,
    this.phrId,
    this.hmisId,
    this.addressLine,
    this.district,
    this.state,
    this.pincode,
    this.patienrRecievedFrom,
    this.othPatienrRecievedFrom,
    this.modeOfArrival,
    this.sceneIft,
    this.sourceType,
    this.sourceHospital,
    this.destinationHospital,
    this.reasonForReferral,
    this.othReasonForReferral,
    this.referralDoctorName,
    this.conditionOfPatient,
    this.isPatientStableIft,
    this.dateAndTimeOfIncident,
    this.placeOfIncident,
    this.otherPlaceOfIncident,
    this.institutionId,
    this.abhaProfileId,
  });

  factory Triage.fromJson(Map<String, dynamic> json) => Triage(
        id: json["id"],
        dateTimeOfTriage: json["date_time_of_triage"],
        typeOfPatient: json["type_of_patient"] ?? true,
        nameOfPatient: json["name_of_patient"],
        ageYear: json["age_year"] != null ? json["age_year"] : 0,
        ageMonth: json["age_month"],
        fathername: json["fathername"],
        mothername: json["mothername"],
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        patientMobileNumber: json["patient_mobile_number"],
        aadhaar: json["aadhaar"],
        education: json["education"],
        employmentStatus: json["employment_status"],
        occupation: json["occupation"],
        income: json["income"],
        patientEhrId: json["patient_ehr_id"],
        cmchisCard: json["cmchis_card"],
        abhaCard: json["abha_card"],
        phrId: json["phr_id"],
        hmisId: json["hmis_id"],
        addressLine: json["address_line"],
        district: json["district"],
        state: json["state"],
        pincode: json["pincode"],
        patienrRecievedFrom: json["patienr_recieved_from"],
        othPatienrRecievedFrom: json["oth_patienr_recieved_from"],
        modeOfArrival: json["mode_of_arrival"],
        sceneIft: json["scene_ift"],
        sourceType: json["source_type"],
        sourceHospital: json["source_hospital"],
        destinationHospital: json["destination_hospital"],
        reasonForReferral: json["reason_for_referral"],
        othReasonForReferral: json["oth_reason_for_referral"],
        referralDoctorName: json["referral_doctor_name"],
        conditionOfPatient: json["condition_of_patient"],
        isPatientStableIft: json["is_patient_stable_ift"],
        dateAndTimeOfIncident: json["date_and_time_of_incident"],
        placeOfIncident: json["place_of_incident"],
        otherPlaceOfIncident: json["oth_place_of_incident"],
        institutionId: json["institution_id"],
        abhaProfileId: json["abha_profile_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_time_of_triage": dateTimeOfTriage,
        "type_of_patient": typeOfPatient,
        "name_of_patient": nameOfPatient,
        "age_year": ageYear,
        "age_month": ageMonth,
        "fathername": fathername,
        "mothername": mothername,
        "gender": gender,
        "marital_status": maritalStatus,
        "patient_mobile_number": patientMobileNumber,
        "aadhaar": aadhaar,
        "education": education,
        "employment_status": employmentStatus,
        "occupation": occupation,
        "income": income,
        "patient_ehr_id": patientEhrId,
        "cmchis_card": cmchisCard,
        "abha_card": abhaCard,
        "phr_id": phrId,
        "hmis_id": hmisId,
        "address_line": addressLine,
        "district": district,
        "state": state,
        "pincode": pincode,
        "patienr_recieved_from": patienrRecievedFrom,
        "oth_patienr_recieved_from": othPatienrRecievedFrom,
        "mode_of_arrival": modeOfArrival,
        "scene_ift": sceneIft,
        "source_type": sourceType,
        "source_hospital": sourceHospital,
        "destination_hospital": destinationHospital,
        "reason_for_referral": reasonForReferral,
        "oth_reason_for_referral": othReasonForReferral,
        "referral_doctor_name": referralDoctorName,
        "condition_of_patient": conditionOfPatient,
        "is_patient_stable_ift": isPatientStableIft,
        "date_and_time_of_incident": dateAndTimeOfIncident,
        "place_of_incident": placeOfIncident,
        "oth_place_of_incident": otherPlaceOfIncident,
        "institution_id": institutionId,
        "abha_profile_id": abhaProfileId,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class TriageBy108 {
  int? id;
  int? triageId;
  String? callId;
  String? districtName;
  String? taluk;
  String? cityName;
  String? baseLocation;
  String? vehicleNumber;
  String? vehicleAssignedDateTime;
  String? chiefComplaint;
  String? emergencyType;
  String? emergencySubType;
  String? temperature;
  String? pulse;
  String? rr;
  String? bpSbp;
  String? bpDbp;
  String? pupilRight;
  String? pupilLeft;
  String? loc;
  String? conditionOfPatient;
  bool? isOutArMlcNumber;
  dynamic outArMlcNumberTx;

  TriageBy108({
    this.id,
    this.triageId,
    this.callId,
    this.districtName,
    this.taluk,
    this.cityName,
    this.baseLocation,
    this.vehicleNumber,
    this.vehicleAssignedDateTime,
    this.chiefComplaint,
    this.emergencyType,
    this.emergencySubType,
    this.temperature,
    this.pulse,
    this.rr,
    this.bpSbp,
    this.bpDbp,
    this.pupilRight,
    this.pupilLeft,
    this.loc,
    this.conditionOfPatient,
    this.isOutArMlcNumber,
    this.outArMlcNumberTx,
  });

  factory TriageBy108.fromJson(Map<String, dynamic> json) => TriageBy108(
        id: json["id"],
        triageId: json["triage_id"],
        callId: json["call_id"],
        districtName: json["district_name"],
        taluk: json["taluk"],
        cityName: json["city_name"],
        baseLocation: json["base_location"],
        vehicleNumber: json["vehicle_number"],
        vehicleAssignedDateTime: json["vehicle_assigned_date_time"],
        chiefComplaint: json["chief_complaint"],
        emergencyType: json["emergency_type"],
        emergencySubType: json["emergency_sub_type"],
        temperature: json["temperature"],
        pulse: json["pulse"],
        rr: json["rr"],
        bpSbp: json["bp_sbp"],
        bpDbp: json["bp_dbp"],
        pupilRight: json["pupil_right"],
        pupilLeft: json["pupil_left"],
        loc: json["loc"],
        conditionOfPatient: json["condition_of_patient"],
        isOutArMlcNumber: json["is_out_ar_mlc_number"],
        outArMlcNumberTx: json["out_ar_mlc_number_tx"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "triage_id": triageId,
        "call_id": callId,
        "district_name": districtName,
        "taluk": taluk,
        "city_name": cityName,
        "base_location": baseLocation,
        "vehicle_number": vehicleNumber,
        "vehicle_assigned_date_time": vehicleAssignedDateTime,
        "chief_complaint": chiefComplaint,
        "emergency_type": emergencyType,
        "emergency_sub_type": emergencySubType,
        "temperature": temperature,
        "pulse": pulse,
        "rr": rr,
        "bp_sbp": bpSbp,
        "bp_dbp": bpDbp,
        "pupil_right": pupilRight,
        "pupil_left": pupilLeft,
        "loc": loc,
        "condition_of_patient": conditionOfPatient,
        "is_out_ar_mlc_number": isOutArMlcNumber,
        "out_ar_mlc_number_tx": outArMlcNumberTx,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class TriageDtls {
  int? id;
  int? triageId;
  int? accompaniedBy;
  List<int>? pcMedicalEmergency;
  dynamic othPcMedicalEmergency;
  int? pcSurgicalEmergency;
  int? rta;
  bool? rtaHelmet;
  int? rtaRiderType;
  int? workspotInjury;
  dynamic othPcSurgicalEmergency;
  List<int>? presentingComplaintsPrem;
  bool? massCasuality;
  dynamic massCasualityTx;
  int? cause;
  int? avpu;
  int? pulse;
  int? bpSystolic;
  dynamic bpDiastolic;
  int? spo2;
  String? temperature;
  bool? broughtDead;
  int? triageFlag;
  dynamic ifRedTeamCallOut;
  dynamic isPatientTriagedQueue;
  dynamic premOpTicketDocs;
  String? triageDoneBy;

  TriageDtls({
    this.id,
    this.triageId,
    this.accompaniedBy,
    this.pcMedicalEmergency,
    this.othPcMedicalEmergency,
    this.pcSurgicalEmergency,
    this.rta,
    this.rtaHelmet,
    this.rtaRiderType,
    this.workspotInjury,
    this.othPcSurgicalEmergency,
    this.presentingComplaintsPrem,
    this.massCasuality,
    this.massCasualityTx,
    this.cause,
    this.avpu,
    this.pulse,
    this.bpSystolic,
    this.bpDiastolic,
    this.spo2,
    this.temperature,
    this.broughtDead,
    this.triageFlag,
    this.ifRedTeamCallOut,
    this.isPatientTriagedQueue,
    this.premOpTicketDocs,
    this.triageDoneBy,
  });

  factory TriageDtls.fromJson(Map<String, dynamic> json) => TriageDtls(
        id: json["id"],
        triageId: json["triage_id"],
        accompaniedBy: json["accompanied_by"],
        pcMedicalEmergency: json["pc_medical_emergency"] == null
            ? []
            : List<int>.from(json["pc_medical_emergency"]!.map((x) => x)),
        othPcMedicalEmergency: json["oth_pc_medical_emergency"],
        pcSurgicalEmergency: json["pc_surgical_emergency"],
        othPcSurgicalEmergency: json["oth_pc_surgical_emergency"],
        presentingComplaintsPrem: json["presenting_complaints_prem"] == null
            ? []
            : List<int>.from(json["presenting_complaints_prem"]!.map((x) => x)),
        massCasuality: json["mass_casuality"],
        massCasualityTx: json["mass_casuality_tx"],
        cause: json["cause"],
        avpu: json["avpu"],
        pulse: json["pulse"],
        bpSystolic: json["bp_systolic"],
        bpDiastolic: json["bp_diastolic"],
        spo2: json["spo2"],
        temperature: json["temperature"],
        broughtDead: json["brought_dead"],
        triageFlag: json["triage_flag"],
        ifRedTeamCallOut: json["if_red_team_call_out"],
        isPatientTriagedQueue: json["is_patient_triaged_queue"],
        premOpTicketDocs: json["prem_op_ticket_docs"],
        triageDoneBy: json["triage_done_by"],
        rta: json["rta"],
        rtaHelmet: json["rta_helmet"],
        rtaRiderType: json["rta_rider_type"],
        workspotInjury: json["work_spot_injury"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "triage_id": triageId,
        "accompanied_by": accompaniedBy,
        "pc_medical_emergency": pcMedicalEmergency == null
            ? []
            : List<dynamic>.from(pcMedicalEmergency!.map((x) => x)),
        "oth_pc_medical_emergency": othPcMedicalEmergency,
        "pc_surgical_emergency": pcSurgicalEmergency,
        "oth_pc_surgical_emergency": othPcSurgicalEmergency,
        "presenting_complaints_prem": presentingComplaintsPrem == null
            ? []
            : List<dynamic>.from(presentingComplaintsPrem!.map((x) => x)),
        "mass_casuality": massCasuality,
        "mass_casuality_tx": massCasualityTx,
        "cause": cause,
        "avpu": avpu,
        "pulse": pulse,
        "bp_systolic": bpSystolic,
        "bp_diastolic": bpDiastolic,
        "spo2": spo2,
        "temperature": temperature,
        "brought_dead": broughtDead,
        "triage_flag": triageFlag,
        "if_red_team_call_out": ifRedTeamCallOut,
        "is_patient_triaged_queue": isPatientTriagedQueue,
        "prem_op_ticket_docs": premOpTicketDocs,
        "triage_done_by": triageDoneBy,
        "rta": rta,
        "rta_helmet": rtaHelmet,
        "rta_rider_type": rtaRiderType,
        "work_spot_injury": workspotInjury,
      };

  @override
  String toString() => jsonEncode(toJson());
}

extension TriageModelCleaner on TriageModel {
  /// Returns a clean JSON without any IDs
  Map<String, dynamic> toCleanJson() {
    final data = toJson();

    // Remove unwanted ids
    if (data['triage'] != null) {
      data['triage'].remove('id');
      data['triage'].remove(
          'institution_id'); // remove institution id if API doesn’t need it
    }
    if (data['triage_by_108'] != null) {
      data['triage_by_108'].remove('id');
      data['triage_by_108'].remove('triage_id');
    }
    if (data['triage_dtls'] != null) {
      data['triage_dtls'].remove('id');
      data['triage_dtls'].remove('triage_id');
    }

    return data;
  }
}
