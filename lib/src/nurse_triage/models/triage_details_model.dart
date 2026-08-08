// To parse this JSON data, do
//
//     final triageDetailsModel = triageDetailsModelFromJson(jsonString);

import 'dart:convert';

TriageDetailsModel triageDetailsModelFromJson(String str) =>
    TriageDetailsModel.fromJson(json.decode(str));

String triageDetailsModelToJson(TriageDetailsModel data) =>
    json.encode(data.toJson());

class TriageDetailsModel {
  TriageDetails? triageDetails;
  TriageBy108Details? triageBy108Details;
  TriageDtlsDetails? triageDtlsDetails;

  TriageDetailsModel({
    this.triageDetails,
    this.triageBy108Details,
    this.triageDtlsDetails,
  });

  factory TriageDetailsModel.fromJson(Map<String, dynamic> json) =>
      TriageDetailsModel(
        triageDetails: json["triage"] == null
            ? null
            : TriageDetails.fromJson(json["triage"]),
        triageBy108Details: json["triage_by_108"] == null
            ? null
            : TriageBy108Details.fromJson(json["triage_by_108"]),
        triageDtlsDetails: json["triage_dtls"] == null
            ? null
            : TriageDtlsDetails.fromJson(json["triage_dtls"]),
      );

  Map<String, dynamic> toJson() => {
        "triage": triageDetails?.toJson(),
        "triage_by_108": triageBy108Details?.toJson(),
        "triage_dtls": triageDtlsDetails?.toJson(),
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TriageDetails {
  int? id;
  String? dateTimeOfTriage;
  String? typeOfPatient;
  String? nameOfPatient;
  int? ageYear;
  int? ageMonth;
  String? fathername;
  String? mothername;
  String? gender;
  String? maritalStatus;
  String? patientMobileNumber;
  String? education;
  String? employmentStatus;
  String? occupation;
  String? income;
  String? patientEhrId;
  String? cmchisCard;
  String? abhaCard;
  String? phrId;
  String? hmisId;
  String? addressLine;
  String? district;
  String? state;
  String? pincode;
  String? patienrRecievedFrom;
  String? othPatienrRecievedFrom;
  String? modeOfArrival;
  String? sceneIft;
  String? sourceType;
  String? sourceHospital;
  String? destinationHospital;
  String? reasonForReferral;
  String? othReasonForReferral;
  String? referralDoctorName;
  String? conditionOfPatient;
  String? isPatientStableIft;
  String? dateAndTimeOfIncident;
  String? placeOfIncident;
  String? othPlaceOfIncident;

  TriageDetails({
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
    this.othPlaceOfIncident,
  });

  factory TriageDetails.fromJson(Map<String, dynamic> json) => TriageDetails(
    id: json["id"],
    dateTimeOfTriage: json["date_time_of_triage"]?.toString(),
    typeOfPatient: json["type_of_patient"]?.toString(),
    nameOfPatient: json["name_of_patient"]?.toString(),
    ageYear: json["age_year"],
    ageMonth: json["age_month"],
    fathername: json["fathername"]?.toString(),
    mothername: json["mothername"]?.toString(),
    gender: json["gender"]?.toString(),
    maritalStatus: json["marital_status"]?.toString(),
    patientMobileNumber: json["patient_mobile_number"]?.toString(),
    education: json["education"]?.toString(),
    employmentStatus: json["employment_status"]?.toString(),
    occupation: json["occupation"]?.toString(),
    income: json["income"]?.toString(), // already fixed
    patientEhrId: json["patient_ehr_id"]?.toString(),
    cmchisCard: json["cmchis_card"]?.toString(),
    abhaCard: json["abha_card"]?.toString(),
    phrId: json["phr_id"]?.toString(),
    hmisId: json["hmis_id"]?.toString(),
    addressLine: json["address_line"]?.toString(),
    district: json["district"]?.toString(),
    state: json["state"]?.toString(),
    pincode: json["pincode"]?.toString(),
    patienrRecievedFrom: json["patienr_recieved_from"]?.toString(),
    othPatienrRecievedFrom: json["oth_patienr_recieved_from"]?.toString(),
    modeOfArrival: json["mode_of_arrival"]?.toString(),
    sceneIft: json["scene_ift"]?.toString(),
    sourceType: json["source_type"]?.toString(),
    sourceHospital: json["source_hospital"]?.toString(),
    destinationHospital: json["destination_hospital"]?.toString(),
    reasonForReferral: json["reason_for_referral"]?.toString(),
    othReasonForReferral: json["oth_reason_for_referral"]?.toString(),
    referralDoctorName: json["referral_doctor_name"]?.toString(),
    conditionOfPatient: json["condition_of_patient"]?.toString(),
    isPatientStableIft: json["is_patient_stable_ift"]?.toString(),
    dateAndTimeOfIncident: json["date_and_time_of_incident"]?.toString(),
    placeOfIncident: json["place_of_incident"]?.toString(),
    othPlaceOfIncident: json["oth_place_of_incident"]?.toString(),
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
        "education": education,
        "employment_status": employmentStatus,
        "occupation": occupation,
        "income": income.toString(),
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
        "oth_place_of_incident": othPlaceOfIncident,
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TriageBy108Details {
  int? id;
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
  String? isOutArMlcNumber;
  String? outArMlcNumberTx;

  TriageBy108Details({
    this.id,
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

  factory TriageBy108Details.fromJson(Map<String, dynamic> json) =>
      TriageBy108Details(
        id: json["id"],
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

class TriageDtlsDetails {
  int? id;
  String? accompaniedBy;
  String? pcMedicalEmergency;
  String? othPcMedicalEmergency;
  String? pcSurgicalEmergency;
  String? othPcSurgicalEmergency;
  String? presentingComplaintsPrem;
  String? massCasuality;
  dynamic massCasualityTx;
  String? cause;
  String? avpu;
  int? pulse;
  int? bpSystolic;
  int? bpDiastolic;
  int? spo2;
  double? temperature;
  String? broughtDead;
  String? triageFlag;
  String? ifRedTeamCallOut;
  String? isPatientTriagedQueue;
  String? premOpTicketDocs;
  String? triageDoneBy;
  dynamic workSpotInjury;
  dynamic rta;
  String? rtaHelmet;
  dynamic rtaRiderType;

  TriageDtlsDetails({
    this.id,
    this.accompaniedBy,
    this.pcMedicalEmergency,
    this.othPcMedicalEmergency,
    this.pcSurgicalEmergency,
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
    this.workSpotInjury,
    this.rta,
    this.rtaHelmet,
    this.rtaRiderType,
  });

  factory TriageDtlsDetails.fromJson(Map<String, dynamic> json) =>
      TriageDtlsDetails(
        id: json["id"],
        accompaniedBy: json["accompanied_by"],
        pcMedicalEmergency: json["pc_medical_emergency"],
        othPcMedicalEmergency: json["oth_pc_medical_emergency"],
        pcSurgicalEmergency: json["pc_surgical_emergency"],
        othPcSurgicalEmergency: json["oth_pc_surgical_emergency"],
        presentingComplaintsPrem: json["presenting_complaints_prem"],
        massCasuality: json["mass_casuality"],
        massCasualityTx: json["mass_casuality_tx"],
        cause: json["cause"],
        avpu: json["avpu"],
        pulse: json["pulse"],
        bpSystolic: json["bp_systolic"],
        bpDiastolic: json["bp_diastolic"],
        spo2: json["spo2"],
        temperature: json["temperature"]?.toDouble(),
        broughtDead: json["brought_dead"],
        triageFlag: json["triage_flag"],
        ifRedTeamCallOut: json["if_red_team_call_out"],
        isPatientTriagedQueue: json["is_patient_triaged_queue"],
        premOpTicketDocs: json["prem_op_ticket_docs"],
        triageDoneBy: json["triage_done_by"],
        workSpotInjury: json["work_spot_injury"],
        rta: json["rta"],
        rtaHelmet: json["rta_helmet"],
        rtaRiderType: json["rta_rider_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accompanied_by": accompaniedBy,
        "pc_medical_emergency": pcMedicalEmergency,
        "oth_pc_medical_emergency": othPcMedicalEmergency,
        "pc_surgical_emergency": pcSurgicalEmergency,
        "oth_pc_surgical_emergency": othPcSurgicalEmergency,
        "presenting_complaints_prem": presentingComplaintsPrem,
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
        "work_spot_injury": workSpotInjury,
        "rta": rta,
        "rta_helmet": rtaHelmet,
        "rta_rider_type": rtaRiderType,
      };
  @override
  String toString() => jsonEncode(toJson());
}
