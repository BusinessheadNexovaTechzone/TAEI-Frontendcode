import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/utils/common/appbar.dart';

import '../controller/drowning_controller.dart';

class DrowningDetailsPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const DrowningDetailsPage({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<DrowningDetailsPage> createState() => _DrowningDetailsPageState();
}

class _DrowningDetailsPageState extends State<DrowningDetailsPage> {
  final controller = Get.put(DrowningController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getDrowningDetails(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "Drowning Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final model =
            controller.ListData1.isNotEmpty ? controller.ListData1.first : null;

        if (model == null || model.drowning == null) {
          return const Center(child: Text("No Data Found"));
        }

        final drown = model.drowning;
        final caseData = drown?.caseDetails;
        final outcome = drown?.outcome;

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
                  onPressed: () async {
                    await controller.exportDrowningPdf(model);
                  },
                ),
              ),

              // ====================== CASE DETAILS ======================

              _buildSectionHeader('🌊 Case Details'),
              _buildCard([
                _info('Triage ID', caseData?.triageId?.toString()),
                _info('Date Entry', caseData?.dateTimeEntry),
                _info('Patient Admitted', caseData?.patientAdmitted),
                _info('Department', caseData?.admittingDepartment),
                _info('Admission Time', caseData?.admissionDatetime),
                _info('Place Of Incident', caseData?.placeOfIncident),
                _info('Other Place', caseData?.otherPlace),
                _info('Type Of Water', caseData?.typeOfWater),
                _info('Other Type Of Water', caseData?.otherTypeOfWater),
                _info('Activity During Incident',
                    caseData?.activityDuringDrowning),
                _info('Other Activity', caseData?.otherActivity),
                _info('Assessment', caseData?.assessment),
                _info('Intervention', caseData?.intervention),
                _info('Other Interventions', caseData?.otherInterventions),
                _info('Supportive Care', caseData?.supportiveCare),
                _info('Other Supportive Care', caseData?.otherSupportiveCare),
                _info('Complications On Admission',
                    caseData?.complicationsAdmission),
                _info('Other Complication Admit',
                    caseData?.otherComplicationAdmitted),
                _info('Complications Developed',
                    caseData?.complicationsDeveloped),
                _info('Other Comp Developed',
                    caseData?.otherComplicationsDeveloped),
                _info('Counselling Before Discharge',
                    caseData?.counsellingBeforeDischarge),
                _info('Discharge Datetime', caseData?.dischargeDatetime),
                _info('Duration of Hospital Stay',
                    caseData?.durationOfHospitalStay),
              ]),

              // ====================== OUTCOME ======================

              _buildSectionHeader('🏥 Outcome'),
              _buildCard([
                _info('Outcome Type', outcome?.outcomeType),
                _info('Discharged', outcome?.isDischarged),
                _info('Discharge Datetime', outcome?.dischargeDatetime),
                _info('Absconded Datetime', outcome?.abscondedDatetime),
                _info('Death Datetime', outcome?.deathDatetime),
                _info('Cause Of Death', outcome?.causeOfDeath),
                _info('Hospital Type', outcome?.hospitalType),
                _info('Destination Hospital', outcome?.destinationHospital),
                _info('Referral Reason', outcome?.referralReason),
                _info('Other Reason Referral', outcome?.otherReasonReferral),
                _info('Patient Condition', outcome?.patientCondition),
                _info('Referring Doctor', outcome?.referringDoctor),
                _info('Documented', outcome?.documentedInTaeiCaseSheet),
                _info('Created At', outcome?.createdAt),
                _info('Updated At', outcome?.updatedAt),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent)),
      );

  Widget _buildCard(List<Widget> children) => Card(
        color: Colors.green[100],
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: children.where((e) => e != const SizedBox()).toList(),
          ),
        ),
      );

  Widget _info(String label, dynamic value) {
    final display = (value == null || value.toString().trim().isEmpty)
        ? "_"
        : value.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(display),
          ),
        ],
      ),
    );
  }

}
