import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';

import '../../nurse_triage/controller/nurse_triage_controller.dart';
import '../../nurse_triage/controller/pdf_generative_controller.dart';

class EmoDetailsPage extends StatefulWidget {
  final String id;
  final bool isAppbar;

  const EmoDetailsPage({super.key, required this.id, this.isAppbar = true});

  @override
  State<EmoDetailsPage> createState() => _EmoDetailsPageState();
}

class _EmoDetailsPageState extends State<EmoDetailsPage> {
  final controller = Get.put(EmoController());
  final controller1 = Get.put(NurseTriageController());
  final controllerpdf = Get.put(pdfController());



  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getEmoDetails(id: widget.id);
      controller.isLoading(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "EMO Case Summary") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = controller.emoDetailsModel.value;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                      await controller.downloadEmoDetailsPdf(id: widget.id);
                      // await controllerpdf.downloadFullCasePdf(id: widget.id);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                _sectionTitle("EMO Details"),
                _glassCard([
                  _info("Triage ID", data.emo?.triageId),
                  _info("Past History", data.emo?.pastHistory),
                  _info("Diagnosis", data.emo?.diagnosis),
                  _info("Emergency Category", data.emo?.emergencyCategory),
                  _info("Other Category", data.emo?.othEmergencyCategory),
                  _info("Time of Examination", data.emo?.timeOfExamination),
                  _info("Memory", data.emo?.memory),
                  _info("Self Control", data.emo?.selfControl),
                  _info("Speech", data.emo?.speech),
                  _info("General Disposition", data.emo?.generalDisposition),
                  _info("Clothing", data.emo?.clothing),
                  _info("Reaction Time", data.emo?.reactionTime),
                  _info("Orientation Time", data.emo?.orientationTime),
                  _info("Pain Scale", data.emo?.painScale),
                  _info("Pain Score", data.emo?.painScore),
                  _info("Examined By", data.emo?.nameOfTheEmo),
                ]),

                // ---------- ALCOHOL / DRUG ----------
                _sectionTitle("Alcohol / Drug History"),
                _glassCard([
                  _info("Smells Alcohol", data.emo?.isPatientSmellsAlcohol),
                  _info("Alcohol Consumption", data.emo?.isAlcoholConsumption),
                  _info("Drunken Drive", data.emo?.isDrunkenDriveHistory),
                  _info("Smell in Breath", data.emo?.isSmellInBreath),
                  _info("Urine Alcohol Test",
                      data.emo?.isUrineAlcholConcentration),
                  _info("Drug Abuse", data.emo?.isDrugAbuse),
                ]),

                // ---------- MLC ----------
                _sectionTitle("⚖️ MLC / Legal Details"),
                _glassCard([
                  _info("Is MLC", data.emo?.isMlc),
                  _info("AR Number", data.emo?.arNumber),
                  _info("MLC Date", data.emo?.mlcDate),
                  _info("MLC Time", data.emo?.mlcTime),
                ]),

                // ---------- TREATMENT ----------
                _sectionTitle("Treatment Details"),
                _glassCard([
                  _info("Treatment Given", data.emo?.treatmentGiven),
                  _info("Trauma Treatment", data.emo?.emoTraumaTreatment),
                ]),

                // ---------- OUTCOME ----------
                _sectionTitle("Outcome Details"),
                _glassCard([
                  _info("Outcome", data.outcome?.outcome),
                  _info("Outcome DateTime", data..outcome?.outcomeDatetime),
                  _info("Sent To", data.outcome?.sentTo),
                  _info("Hospital Type", data.outcome?.hospitalType),
                  _info("Destination Hospital",
                      data.outcome?.destinationHospital),
                  _info("TAEI Hospital", data.outcome?.destinationTaeiHospital),
                  _info("Reason For Referral", data.outcome?.reasonForReferral),
                  _info(
                      "Condition Of Patient", data.outcome?.conditionOfPatient),
                  _info("Referring Doctor", data.outcome?.referringDoctorName),
                  _info("Is Discharged", data.outcome?.isDischarged),
                ]),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Widget _glassCard(List<Widget> children) {
  //   return Container(
  //     width: double.infinity,
  //     margin: const EdgeInsets.only(bottom: 16),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: children,
  //     ),
  //   );
  // }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _glassCard(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Card(
        color: Colors.green[100],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.where((w) => w != const SizedBox()).toList(),
          ),
        ),
      ),
    );
  }

  Widget _info(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   width: 160,
          //   child: Text(
          //     "$title:",
          //     style: const TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),
          // Expanded(
          //   child: Text(value?.toString() == "null" ? "-" : value.toString()),
          // ),
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value?.toString() ?? '-'),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String? value, {Color color = Colors.blue}) {
    if (value == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
