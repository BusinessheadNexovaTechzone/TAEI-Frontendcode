// lib/src/script/screens/script_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/script_detail.dart'; // adjust import path

class ScriptDetailScreen extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const ScriptDetailScreen({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<ScriptDetailScreen> createState() => _ScriptDetailScreenState();
}

class _ScriptDetailScreenState extends State<ScriptDetailScreen> {
  final controller = Get.put(ScriptController1());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getStrokeDetails(id: widget.triageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar
          ? AppBar(
              backgroundColor: Colors.redAccent,
              title: const Text('Stroke Details'))
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.StrokDetails.value;
        if (data == null) {
          return const Center(child: Text("No details found"));
        }

        final stroke = data.stroke;
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
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await controller.generateStrokePdf(data);
                  },
                ),
              ),
              _buildSectionHeader("🧠 Stroke Information"),
              _buildCard([

                // _info('Stroke ID', stroke?.id?.toString()),
                // _info('Triage ID', stroke?.triageId?.toString()),

                _info('Date/Time of Entry', stroke?.dateTimeOfEntry),
                _info('Arrival time (symptoms)', stroke?.arrivalTimeSymptoms),
                _info('Reason for delay', stroke?.reasonForDelay),
                _info('Scene / IFT', stroke?.sceneIft),

                _info('Referred from', stroke?.referredFrom),
                _info('Reason for referral', stroke?.reasonForReferral),
                _info('Other reason for referral', stroke?.othReasonForReferral),

                _info('Admitted', stroke?.admitted),
                _info('Admitted date & time', stroke?.admittedDateTime),

                _info('Lysis done outside', stroke?.lysisDoneOutside),
                _info('Lysis outside date', stroke?.lysisDoneOutsideDate),

                _info('Symptoms', stroke?.symptoms),

                _info('Absolute contraindications',
                    stroke?.absoluteContraindication),
                _info('Other absolute contraindications',
                    stroke?.othAbsoluteContraindication),

                _info('NIHSS scale', stroke?.nihsScale?.toString()),

                _info('CBG', stroke?.cbg),
                _info('CBG Date', stroke?.cbgDate),

                _info('History of anticoagulant',
                    stroke?.historyOfAnticoagulant),

                _info(
                  'Blood Pressure (SBP / DBP)',
                  stroke?.bpSbp != null || stroke?.bpDbp != null
                      ? '${stroke?.bpSbp ?? "-"} / ${stroke?.bpDbp ?? "-"}'
                      : null,
                ),

                _info('ASPECT score', stroke?.aspectScore?.toString()),

                _info('CT scan', stroke?.ctScan),
                _info('CT scan date', stroke?.ctScanDate),

                _info('MRI scan', stroke?.mriScan),
                _info('MRI scan date', stroke?.mriScanDate),
                _info('MRI eligibility', stroke?.mriScanEligibility),

                _info('Cath lab procedure', stroke?.cathLabProcedure),
                _info('Cath lab procedure date',
                    stroke?.cathLabProcedureDate),

                _info('Procedure done', stroke?.procedureDone),
                _info('Name of procedure', stroke?.nameOfProcedure),

                _info('Stroke type', stroke?.type),

                _info('Lysis done', stroke?.lysisDone),
                _info('Lysis date', stroke?.lysisDate),

                _info('Thrombolysis drug', stroke?.thrombolysisByDrug),

                _info('Thrombectomy', stroke?.thrombectomy),
                _info('Thrombectomy details', stroke?.thrombectomyDtls),

                _info('Decompression craniectomy',
                    stroke?.decompressionCraniectomy),
                _info('Decompression craniectomy details',
                    stroke?.decompressionCraniectomyDtls),

                _info('Drug prescribed', stroke?.drugPrescribed),

                _info('User ID', stroke?.userId?.toString()),
                _info('Inserted date', stroke?.insertedDate),
              ]),

              _buildSectionHeader("📋 Outcome"),
              _buildCard([
                _info('Outcome', outcome?.outcome),

                _info('Discharge date', outcome?.dischargeDate),
                _info('Discharge static date',
                    outcome?.dischargeStaticDate),

                _info('DAMA date', outcome?.damaDate),
                _info('Absconded date', outcome?.abscondedDate),

                _info('Death date', outcome?.deathDate),
                _info('Cause of death', outcome?.causeOfDeath),

                _info('Transferred ward date',
                    outcome?.transferredWardDate),
                _info('Transferred ICU date',
                    outcome?.transferredIcuDate),

                _info('Transferred to', outcome?.transferredTo),
                _info('Hospital type', outcome?.hospitalType),

                _info('Destination hospital',
                    outcome?.destinationHospital),
                _info('Destination TAEI hospital',
                    outcome?.destinationTaeiHospital),

                _info('Reason for referral',
                    outcome?.reasonForReferral),

                _info('Condition of patient',
                    outcome?.conditionOfPatient),

                _info('Referring doctor', outcome?.referringDoctor),

                _info('TAEI sheet documented',
                    outcome?.documentedTaeiSheet),

                _info('Treatment given', outcome?.treatmentGiven),

                _info('Duration of stay (days)',
                    outcome?.durationStay?.toString()),

                _info('Is discharged', outcome?.is_discharged.toString()),
              ]),

              const SizedBox(height: 24),
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
            color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      color: Colors.grey[100],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    (value == null || value.trim().isEmpty)
        ? '-' * 2
        : value.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(displayValue),
          ),
        ],
      ),
    );
  }


}
