import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/utils/common/appbar.dart';

import '../controller/hang_controller.dart';
import '../controller/hang_test.dart';

class HangingDetailPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const HangingDetailPage({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<HangingDetailPage> createState() => _HangingDetailPageState();
}

class _HangingDetailPageState extends State<HangingDetailPage> {
  final controller = Get.put(HangController1());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getHangDetails(id: widget.triageId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "Hanging Case Details") : null,
      body: Obx(() {
        // SHOW LOADING WHILE FETCHING
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // SAFELY READ DETAILS (Rxn<HangingDetails>)
        final data = controller.hangingDetails.value;
        if (data == null) {
          return const Center(child: Text("No details found"));
        }

        final hanging = data.hanging;
        final outcome = data.outcome;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Download PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    await controller.generateHangDetailsPdf();
                  },
                ),
              ),
              _buildSectionHeader("Hanging Case Information"),
              _buildCard([
                _info("Nature of Incident", hanging?.natureOfIncident),
                _info("Suspension Type", hanging?.suspensionOfBody),
                _info("Materials Used", hanging?.materialsUsedForHanging),
                _info("Symptoms at Presentation", hanging?.symptomsAtPresentation),
              ]),

              _buildSectionHeader("💉 Interventions & Supportive Care"),
              _buildCard([
                _info("Interventions", hanging?.interventions),
                _info("Other Interventions", hanging?.othInterventions),
                _info("Supportive Care Provided", hanging?.supportiveCareProvided),
                _info("Other Supportive Care", hanging?.othSupportiveCareProvided),
                _info("Counselling Provided", hanging?.isCounsellingProvided),
                _info("Duration of Stay (days)", hanging?.durationOfHospitalStay?.toString()),
              ]),

              _buildSectionHeader("🏥 Admission Details"),
              _buildCard([
                _info("Department", hanging?.nameOfDept),
                _info("Patient Admitted", hanging?.patientAdmitted),
                _info("Admission Date", hanging?.dateOfAdmit),
                _info("User ID", hanging?.userId?.toString()),
                _info("Inserted Date", hanging?.insertedDate),
              ]),

              _buildSectionHeader("📋 Outcome Details"),
              _buildCard([
                _info("Outcome", outcome?.outcome),
                _info("Discharge Date", outcome?.dischargeDate),
                _info("Condition of Patient", outcome?.conditionOfPatient),
                _info("Hospital Type", outcome?.hospitalType),
                _info("Destination Hospital", outcome?.destinationHospital),
                _info("Destination TAEI Hospital", outcome?.destinationTaeiHospital),
                _info("Referring Doctor", outcome?.referringDoctor),
                _info("TAEI Sheet Documented", outcome?.documentedTaeiSheet),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      color: Colors.green[100],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: children.where((w) => w != const SizedBox()).toList(),
        ),
      ),
    );
  }

  Widget _info(String label, String? value) {
    final displayValue =
    (value == null || value.trim().isEmpty) ? '-' : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              displayValue,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
