import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/poison/controller/poison_controller.dart';
import 'package:taei_gov/src/poison/model/poisoning_details_model.dart';
import 'package:taei_gov/utils/common/Common_details_page_widgets.dart';
import 'package:taei_gov/utils/common/appbar.dart';

class PoisoningDetailsPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;
  
  const PoisoningDetailsPage({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<PoisoningDetailsPage> createState() => _PoisoningDetailsPageState();
}

class _PoisoningDetailsPageState extends State<PoisoningDetailsPage> {
  final controller = Get.put(PoisonController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPoisoning(triageId: widget.triageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar
          ? CommonAppBar(title: "Poisoning Patient Details")
          : null,
      body: Container(
        color: Colors.white,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final record = controller.poisoningDetails.value;

          // The UI will now always build the sections, displaying keys
          // even if the data record is null.
          return SingleChildScrollView(
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
                      await controller.generatePoisonPdf(record);
                    },
                  ),
                ),
                DetailsPageWidget.title("POISONING DETAILS"),
                DetailsPageWidget.buildSectionView(_buildPoisonData(record)),
                const SizedBox(height: 16),
                DetailsPageWidget.title("POISONING OUTCOME"),
                DetailsPageWidget.buildSectionView(
                    _buildPoisonsOutcomeData(record)),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }

  Map<String, dynamic> _buildPoisonData(PoisoningDetailsModel? data) {
    final p = data?.poisons;
    return {
      "ID": p?.id,
      "Triage ID": p?.triageId,
      "Entry Date/Time": p?.dateTimeOfEntry,
      "Patient Admitted": p?.patientAdmitted,
      "Department": p?.nameOfDept,
      "Date of Admit": p?.dateOfAdmit,
      "Type of Poisoning": p?.typeOfPoisoning,
      "Route of Exposure": p?.routeOfExposure,
      "Substance": p?.substanceInvolved,
      "Substance Sub": p?.substanceInvolvedSub,
      "Other Substance": p?.othSubstanceInvolved,
      "Brand": p?.brandOrProductName,
      "Quantity": p?.quantity,
      "Source": p?.sourceOfSubstance,
      "Symptoms": p?.symptomsAtPresentation,
      "Onset Time": p?.timeOfOnsetOfSymptoms,
      "Time Elapsed": p?.timeElapsedExposureSymptom,
      "Investigations": p?.investigationsPerformed,
      "Severity": p?.severityOfPoisoning,
      "Decontamination": p?.decontamination,
      "Antidote": p?.antidoteAdministeredName,
      "Dosage": p?.antidoteAdministeredDosage,
      "Antidote Timing": p?.antidoteAdministeredTiming,
      "Supportive Care": p?.supportiveCareProvided,
      "Cycles": p?.noOfCyclesPerformed,
      "Counselling": p?.counsellingProvided,
      "Hospital Stay": p?.durationOfHospitalStay,
      "User ID": p?.userId,
      "Inserted Date": p?.insertedDate,
      "Ref Form ID": p?.refFormId,
      "Ref ID": p?.refId,
    };
  }

  Map<String, dynamic> _buildPoisonsOutcomeData(PoisoningDetailsModel? data) {
    final o = data?.poisonsOutcome;
    return {
      "ID": o?.id,
      "Outcome": o?.outcome,
      "Discharge Date": o?.dischargeDate,
      "Absconded Date": o?.abscondedDate,
      "Death Date": o?.deathDate,
      "Cause of Death": o?.causeOfDeath,
      "Hospital Type": o?.hospitalType,
      "Destination Hospital": o?.destinationHospital,
      "Destination TAEI": o?.destinationTaeiHospital,
      "Reason for Referral": o?.reasonForReferral,
      "Other Reason": o?.othReasonForReferral,
      "Patient Condition": o?.conditionOfPatient,
      "Referring Doctor": o?.referringDoctor,
      "TAEI Documented": o?.documentedTaeiSheet,
      "Exit Date": o?.patientExitDate,
    };
  }
}
