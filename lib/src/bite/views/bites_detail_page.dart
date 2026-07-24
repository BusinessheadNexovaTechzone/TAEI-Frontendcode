import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import '../controller/bites_controller.dart';

class BitesDetailPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const BitesDetailPage({super.key, required this.triageId, this.isAppbar = true});

  @override
  State<BitesDetailPage> createState() => _BitesDetailPageState();
}

class _BitesDetailPageState extends State<BitesDetailPage> {
  final controller = Get.put(BitesController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getBitesDetails(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "Bites & Stings Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.bitesDetails.value;
        if (data == null) {
          return const Center(child: Text("No details found"));
        }

        final bites = data.bitesStings;
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
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    await controller.generateBitesDetailsPdf();
                  },
                ),
              ),
              _buildSectionHeader("🐍 Bite / Sting Information"),
              _buildCard([
                _info("Type of Bite / Sting", bites?.typeOfBiteSting),
                _info("Type of Organism", bites?.typeOfOrganism),
                _info("Venomous Type", bites?.venomousType),
                _info("Other Venomous Type", bites?.othVenomousType),
                _info("Site of Bite / Sting", bites?.siteOfBiteSting),
                _info("Symptoms", bites?.symptomsAtPresentation),
                _info("Signs of Envenomation", bites?.signsOfEnvenomationAllergicReaction),
                _info("Time to Reach After Bite", bites?.timeToReachAfterBiteSting),
                _info("Investigations", bites?.investigationsPerformed),
              ]),

              _buildSectionHeader("💉 Treatment & Management"),
              _buildCard([
                _info("First Aid Given", bites?.firstAidGiven),
                _info("Anti-Venom / Allergy Treatment", bites?.antiVenomOrAllergyTreatmentName),
                _info("Dosage", bites?.antiVenomOrAllergyTreatmentDosage),
                _info("Timing", bites?.antiVenomOrAllergyTreatmentTiming),
                _info("Supportive Care", bites?.supportiveCareProvided),
                _info("Counselling Before Discharge", bites?.counsellingProvidedBeforeDischarge),
                _info("Duration of Stay (days)", bites?.durationOfHospitalStay?.toString()),
              ]),

              _buildSectionHeader("🏥 Admission Details"),
              _buildCard([
                _info("Department", bites?.nameOfDept),
                _info("Admitted", bites?.patientAdmitted),
                _info("Admission Date", bites?.dateOfAdmit),
                _info("User ID", bites?.userId?.toString()),
              ]),

              _buildSectionHeader("📋 Outcome Details"),
              _buildCard([
                _info("Outcome", outcome?.outcome),
                _info("Discharge Date", outcome?.dischargeDate),
                _info("Condition", outcome?.conditionOfPatient),
                _info("Hospital Type", outcome?.hospitalType),
                _info("Destination Hospital", outcome?.destinationHospital),
                _info("Referring Doctor", outcome?.referringDoctor),
                _info("TAEI Sheet Documented", outcome?.documentedTaeiSheet),
                _info("Exit Date", outcome?.patientExitDate),
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
          children: children
              .where((w) => w != const SizedBox()) // Remove empty rows
              .toList(),
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
