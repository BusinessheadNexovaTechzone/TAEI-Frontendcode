import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';

class CaseDetailsViewPage extends StatefulWidget {
  final dynamic caseData;

  const CaseDetailsViewPage({super.key, required this.caseData});

  @override
  State<CaseDetailsViewPage> createState() => _CaseDetailsViewPageState();
}

class _CaseDetailsViewPageState extends State<CaseDetailsViewPage> {
  final NurseTriageController transitController = Get.put(NurseTriageController());

  @override
  Widget build(BuildContext context) {
    final caseData = widget.caseData;

    return Scaffold(
      appBar: CommonAppBar(
        title: "${caseData.patientName ?? ''}",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Download PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await transitController.downloadCaseListPdf(caseData: caseData);
                    },
                  ),
                ),
                _buildRow("Case ID", caseData.caseId.toString()),
                _buildRow("Patient Name", caseData.patientName ?? "-"),
                _buildRow("Age", caseData.age?.toString() ?? "-"),
                _buildRow("District", caseData.districtName ?? "-"),
                _buildRow("Taluk", caseData.talukName ?? "-"),
                _buildRow("City", caseData.cityName ?? "-"),
                _buildRow("Base Location", caseData.baseLocation ?? "-"),
                _buildRow("Hospital Name", caseData.hospitalName ?? "-"),
                _buildRow("Source Hospital", caseData.sourceHospital ?? "-"),
                _buildRow("Vehicle No", caseData.vehicleNumber ?? "-"),
                _buildRow("Call Type", caseData.callType ?? "-"),
                _buildRow("Chief Complaint", caseData.chiefComplaint ?? "-"),
                _buildRow("Emergency Type", caseData.emergencyType ?? "-"),
                _buildRow("Emergency Sub Type", caseData.emergencySubType ?? "-"),
                _buildRow("SPO2", caseData.spo2?.toString() ?? "-"),
                _buildRow("RR", caseData.rr?.toString() ?? "-"),
                _buildRow("Temperature", caseData.temperature?.toString() ?? "-"),
                _buildRow("BP (SBP/DBP)",
                    "${caseData.bpSbp?.toString() ?? '-'}/${caseData.bpDbp?.toString() ?? '-'}"),
                _buildRow("Carotid Pulse", caseData.carotidPulse?.toString() ?? "-"),
                _buildRow("Pupil Left", caseData.pupilSizeLeft ?? "-"),
                _buildRow("Pupil Right", caseData.pupilSizeRight ?? "-"),
                _buildRow(
                    "Condition", caseData.isCritical == true ? "Critical" : "Normal"),
                _buildRow("Vehicle Assigned Time",
                    caseData.vehicleAssignedTime?.toString() ?? "-"),
                _buildRow("Inserted Date", caseData.insertedDate?.toString() ?? "-"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
