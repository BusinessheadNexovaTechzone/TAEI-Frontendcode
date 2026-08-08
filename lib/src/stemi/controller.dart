import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/stemi/triage_model.dart';
import '../../constants/urls.dart';
import '../../utils/helpers/http_helper.dart';
import '../nurse_triage/models/triage_lookup_model.dart';
import 'emo_triage.dart';
import 'model/lookupmodel.dart';

class TriageGetController extends GetxController {
  Rx<TriageResponseModel> createResponse = TriageResponseModel().obs;
  // Rx<TriageResponse> emoList = TriageResponse().obs;
  Rx<TriageLookupModel> triageLookup1 = TriageLookupModel().obs;

  RxBool isLoading = false.obs;

  static final _client = CustomHttpHelper();

  Future<bool> getTriageById({required String id}) async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.getTriageById + id);
      var response = await _client.get(url);
      log('Triage response: ${response.body}');
      if (response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        createResponse.value = TriageResponseModel.fromJson(d);
        Fluttertoast.showToast(msg: "Data fetched successfully");
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      log("Error: $ex");
      isLoading.value = false;
      return false;
    }
  }

  // Future<bool> getEmoById({required String id}) async {
  //   isLoading.value = true;
  //   try {
  //     log(id.toString());
  //     var url = Uri.parse(Urls.getEmoById + id);
  //     var response = await _client.get(url);
  //     log('getEmoById response: ${response.body}');
  //     if (response.body.isNotEmpty) {
  //       var d = jsonDecode(response.body);
  //       emoList.value = TriageResponse.fromJson(d);
  //       Fluttertoast.showToast(msg: "EMO Data fetched successfully");
  //       isLoading.value = false;
  //       return true;
  //     } else {
  //       isLoading.value = false;
  //       return false;
  //     }
  //   } catch (ex) {
  //     log("Error: $ex");
  //     isLoading.value = false;
  //     return false;
  //   }
  //
  // }

  //
  // static Future<TriageLookupModel?> getLookup() async {
  //   try {
  //     var url = Uri.parse(Urls.getTriageLookup);
  //     var response = await _client.get(
  //       url,
  //     );
  //     log("errr${response.body}");
  //     if (response.statusCode == 200) {
  //       var list = triageLookupModelFromJson(response.body);
  //
  //       triageLookup1.value = list;
  //       return true;
  //     } else {
  //       return null;
  //     }
  //   } catch (ex) {
  //     log(ex.toString());
  //     return null;
  //   }
  // }
  Future<bool> getTriageLookup() async {
    try {
      var url = Uri.parse(Urls.getTriageLookup);
      var response = await _client.get(url);
      log('getEmoLookup response: ${response.body}');
      if (response.body.isNotEmpty) {
        var list = triageLookupModelFromJson(response.body);
        triageLookup1.value = list;
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getEmoLookup error: $ex");
      return false;
    }
  }

  /// Build triage + EMO form
  Widget buildTriageForm() {
    final triage = createResponse.value?.triage;
    final triageBy108 = createResponse.value?.triageBy108;
    final triageDtls = createResponse.value?.triageDtls;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TRIAGE INFO
          if (triage != null)
            _buildSection("Triage Info", [
              _buildField("Patient Name", triage.nameOfPatient),
              _buildField("Father Name", triage.fathername),
              _buildField("Mother Name", triage.mothername),
              _buildField("Age",
                  "${triage.ageYear ?? '-'} years ${triage.ageMonth ?? '-'} months"),
              _buildField("Gender", triage.gender.toString()), //Drop Down
              _buildField("Mobile Number", triage.patientMobileNumber),
              _buildField("Address", triage.addressLine),
              _buildField("District", triage.district.toString()), // drop Down
              _buildField("State", triage.state.toString()),
              _buildField("Pincode", triage.pincode),
              _buildField("Source Hospital", triage.sourceHospital),
              _buildField("Destination Hospital", triage.destinationHospital),
              _buildField("Referral Doctor", triage.referralDoctorName),
              _buildField("Condition", triage.conditionOfPatient.toString()),
            ]),

          /// TRIAGE BY 108
          if (triageBy108 != null)
            _buildSection("Triage by 108", [
              _buildField("Call ID", triageBy108.callId),
              _buildField("District", triageBy108.districtName),
              _buildField("Taluk", triageBy108.taluk),
              _buildField("City", triageBy108.cityName),
              _buildField("Vehicle Number", triageBy108.vehicleNumber),
              _buildField("Assigned Time",
                  triageBy108.vehicleAssignedDateTime.toString()),
              _buildField("Chief Complaint", triageBy108.chiefComplaint),
              _buildField("Emergency Type", triageBy108.emergencyType),
              _buildField("Emergency Sub Type", triageBy108.emergencySubType),
              _buildField("Condition", triageBy108.conditionOfPatient),
              _buildField("Pulse", triageBy108.pulse),
              _buildField("BP", "${triageBy108.bpSbp}/${triageBy108.bpDbp}"),
              _buildField("LOC", triageBy108.loc),
            ]),

          /// TRIAGE DETAILS
          if (triageDtls != null)
            _buildSection("Triage Details", [
              _buildField(
                  "Accompanied By", triageDtls.accompaniedBy?.toString()),
              _buildField("Medical Emergency",
                  triageDtls.pcMedicalEmergency?.join(", ")),
              _buildField(
                  "Other Medical Emergency", triageDtls.othPcMedicalEmergency),
              _buildField("Surgical Emergency",
                  triageDtls.pcSurgicalEmergency?.toString()),
              _buildField("Other Surgical Emergency",
                  triageDtls.othPcSurgicalEmergency),
              _buildField("Cause", triageDtls.cause?.toString()),
              _buildField("Pulse", triageDtls.pulse?.toString()),
              _buildField(
                  "BP", "${triageDtls.bpSystolic}/${triageDtls.bpDiastolic}"),
              _buildField("SPO2", triageDtls.spo2?.toString()),
              _buildField("Temperature", triageDtls.temperature?.toString()),
              _buildField("Triage Done By", triageDtls.triageDoneBy),
            ]),

          /// EMO LIST
          // if (emoList.value.rows != null && emoList.value.rows!.isNotEmpty)
          //   _buildSection("EMO List", emoList.value.rows!.map((row) {
          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         _buildField("Triage ID", row.triageId?.toString()),
          //         _buildField("Patient Name", row.nameOfPatient),
          //         _buildField("Mode of Arrival", row.modeOfArrival),
          //         _buildField("Scene IFT", row.sceneIft),
          //         _buildField("Medical Emergency", row.medicalEmergency),
          //         _buildField("Surgical Emergency", row.surgicalEmergency),
          //         _buildField("Status ID", row.statusId?.toString()),
          //         _buildField("Triage Flag", row.triageFlag),
          //         _buildField("EMO ID", row.emoId?.toString()),
          //         const Divider(),
          //       ],
          //     );
          //   }).toList()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        readOnly: true,
        initialValue: value ?? "-",
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}
