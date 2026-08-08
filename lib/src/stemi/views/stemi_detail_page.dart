import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import '../controller/stemi_controller.dart';

class StemiDetailPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const StemiDetailPage({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<StemiDetailPage> createState() => _StemiDetailPageState();
}

class _StemiDetailPageState extends State<StemiDetailPage> {
  final controller = Get.put(StemiController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getStemiDetails(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "STEMI Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final model = controller.ListData1.isNotEmpty
            ? controller.ListData1.first
            : null;

        if (model == null) {
          return const Center(child: Text("No Data Found"));
        }

        final stemi = model.stemi;
        final nstemi = model.nstemi;
        final ua = model.unstableAngina;

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
                    await controller.exportStemiFullPdf(model);
                  },
                ),
              ),

              // ====================== STEMI ======================

              _buildSectionHeader('💔 STEMI Admission'),
              _buildCard([
                _info('Is Admitted', stemi?.admission?.isAdmitted),
                _info('Entry Time', stemi?.admission?.dateTimeEntry),
                _info('Department', stemi?.admission?.departmentName),
                _info('Admission Time', stemi?.admission?.dateTimeAdmission),
              ]),
              _buildSectionHeader('📍 Clinical Assessment'),
              _buildCard([
                _info('Symptom Onset', stemi?.clinicalAssessment?.symptomOnsetDatetime),
                _info('Risk Factors', stemi?.clinicalAssessment?.riskFactors),
                _info('Other Risk Factor', stemi?.clinicalAssessment?.otherRiskFactor),
                _info('Signs/Symptoms', stemi?.clinicalAssessment?.signsSymptoms),
                _info('FMC Type', stemi?.clinicalAssessment?.fmcType),
                _info('FMC Datetime', stemi?.clinicalAssessment?.fmcDatetime),
                _info('ECG Datetime', stemi?.clinicalAssessment?.ecgDatetime),
                _info('ECG Location', stemi?.clinicalAssessment?.ecgLocation),
                _info('Diagnosis', stemi?.clinicalAssessment?.diagnosis),
                _info('Other Diagnosis', stemi?.clinicalAssessment?.otherDiagnosis),
              ]),

              _buildSectionHeader('💉 STEMI Treatment'),
              _buildCard([
                _info('STEMI Confirmed At', stemi?.treatment?.stemiConfirmedAt),
                _info('Infarction Location', stemi?.treatment?.infarctionLocation),
                _info('Loading Dose Location', stemi?.treatment?.loadingDoseLocation),
                _info('Loading Dose Drug', stemi?.treatment?.loadingDoseDrug),
                _info('Loading Dose Time', stemi?.treatment?.loadingDoseTime),
                _info('Loading Dose Admin Date', stemi?.treatment?.loadingDoseAdministrationDate),
                _info('Thrombolysis Location', stemi?.treatment?.thrombolysisLocation),
                _info('Thrombolytic Agent', stemi?.treatment?.thrombolyticAgent),
                _info('Thrombolysis Start', stemi?.treatment?.thrombolysisStart),
                _info('Thrombolysis End', stemi?.treatment?.thrombolysisEnd),
                _info('Thrombolysis Outcome', stemi?.treatment?.thrombolysisOutcome),
                _info('Not Done Reason', stemi?.treatment?.thrombolysisNotDoneReason),
                _info('Thrombolysis Date', stemi?.treatment?.thrombolysisDate),
                _info('Treatment Strategy', stemi?.treatment?.treatmentStrategy),
                _info('Conservative Mgmt', stemi?.treatment?.conservativeManagement),
                _info('Killip Score', stemi?.treatment?.killipRiskScore),
                _info('Planned CAG', stemi?.treatment?.plannedCag),
                _info('Cath Lab Arrival', stemi?.treatment?.cathLabArrival),
                _info('Balloon Inflation', stemi?.treatment?.balloonInflation),
                _info('Stent Type', stemi?.treatment?.stentType),
                _info('Complications', stemi?.treatment?.complications),
                _info('Other Complications', stemi?.treatment?.otherComplications),
                _info('Transfer Location', stemi?.treatment?.transferLocation),
                _info('Counselling ID', stemi?.treatment?.counsellingId),
                _info('Symptom To FMC', stemi?.treatment?.symptomToFmc),
                _info('FMC To ECG', stemi?.treatment?.fmcToEcg),
                _info('Door To Needle', stemi?.treatment?.doorToNeedle),
                _info('Door To Balloon', stemi?.treatment?.doorToBalloon),
                _info('Total Ischemic Time', stemi?.treatment?.totalIschemicTime),
                _info('ICU Admission', stemi?.treatment?.icuAdmission),
                _info('Hospital Stay Days', stemi?.treatment?.hospitalStayDays),
                _info('In Hospital Complication', stemi?.treatment?.inHospitalComplication),
                _info('Coronary Angiography', stemi?.treatment?.coronoryAngiography),
              ]),

              _buildSectionHeader('🏥 STEMI Outcome'),
              _buildCard([
                _info('Outcome Type', stemi?.outcome?.outcomeType),
                _info('Discharge Datetime', stemi?.outcome?.dischargeDatetime),
                _info('Absconded Datetime', stemi?.outcome?.abscondedDatetime),
                _info('Death Datetime', stemi?.outcome?.deathDatetime),
                _info('Death Timing', stemi?.outcome?.deathTiming),
                _info('Other Death Timing', stemi?.outcome?.otherDeathTiming),
                _info('Cause Of Death', stemi?.outcome?.causeOfDeath),
                _info('Hospital Type', stemi?.outcome?.hospitalType),
                _info('Destination Hospital', stemi?.outcome?.destinationHospital),
                _info('Referral Reason', stemi?.outcome?.referralReason),
                _info('Other Referral Reason', stemi?.outcome?.otherReferralReason),
                _info('Patient Condition', stemi?.outcome?.patientCondition),
                _info('Referring Doctor', stemi?.outcome?.referringDoctor),
                _info('CaseSheet', stemi?.outcome?.documentedInTaeiCaseSheet),
              ]),

              // ====================== NSTEMI ======================

              if (nstemi != null) ...[
                _buildSectionHeader('🟡 NSTEMI Treatment'),
                _buildCard([
                  _info('NSTEMI Confirmed At', nstemi?.treatment?.nstemiConfirmedAt),
                  _info('Loading Dose Location', nstemi?.treatment?.loadingDoseLocation),
                  _info('Loading Dose Drug', nstemi?.treatment?.loadingDoseDrug),
                  _info('Loading Dose Time', nstemi?.treatment?.loadingDoseTime),
                  _info('Loading Dose Admin', nstemi?.treatment?.loadingDoseAdministrationDate),
                  _info('TIMI Score', nstemi?.treatment?.timiRiskScore),
                  _info('Treatment Strategy', nstemi?.treatment?.treatmentStrategy),
                  _info('Conservative Mgmt', nstemi?.treatment?.conservativeManagement),
                  _info('Planned CAG', nstemi?.treatment?.plannedCag),
                  _info('Cath Lab Arrival', nstemi?.treatment?.cathLabArrival),
                  _info('Balloon Inflation', nstemi?.treatment?.balloonInflation),
                  _info('Stent Type', nstemi?.treatment?.stentType),
                  _info('Complications', nstemi?.treatment?.complications),
                  _info('Other Complications', nstemi?.treatment?.otherComplications),
                  _info('Transfer Location', nstemi?.treatment?.transferLocation),
                  _info('Symptom to FMC', nstemi?.treatment?.symptomToFmc),
                  _info('FMC to ECG', nstemi?.treatment?.fmcToEcg),
                  _info('Door To Balloon', nstemi?.treatment?.doorToBalloon),
                  _info('ICU Admission', nstemi?.treatment?.icuAdmission),
                  _info('Hospital Stay', nstemi?.treatment?.hospitalStayDays),
                  _info('In Hospital Comp', nstemi?.treatment?.inHospitalComplications),
                  _info('Coronary Angio', nstemi?.treatment?.coronoryAngiography),
                ]),

                _buildSectionHeader('🏥 NSTEMI Outcome'),
                _buildCard([
                  _info('Outcome Type', nstemi?.outcome?.outcomeType),
                  _info('Discharge Datetime', nstemi?.outcome?.dischargeDatetime),
                  _info('Death Datetime', nstemi?.outcome?.deathDatetime),
                  _info('Hospital Type', nstemi?.outcome?.hospitalType),
                  _info('Destination', nstemi?.outcome?.destinationHospital),
                  _info('Ref Reason', nstemi?.outcome?.referralReason),
                  _info('Patient Condition', nstemi?.outcome?.patientCondition),
                  _info('Referring Doctor', nstemi?.outcome?.referringDoctor),
                ]),
              ],

              // ====================== Unstable Angina ======================

              if (ua != null) ...[
                _buildSectionHeader('🟠 Unstable Angina Treatment'),
                _buildCard([
                  _info('Confirmed At', ua?.treatment?.uaConfirmedAt),
                  _info('TIMI Score', ua?.treatment?.timiRiskScore),
                  _info('Management Id', ua?.treatment?.managementId),
                  _info('Complications', ua?.treatment?.complications),
                  _info('Other Complications', ua?.treatment?.otherComplications),
                  _info('Counselling Id', ua?.treatment?.counsellingId),
                  _info('ICU Admission', ua?.treatment?.icuAdmission),
                  _info('Hospital Stay', ua?.treatment?.hospitalStayDays),
                  _info('In Hospital Complications', ua?.treatment?.inHospitalComplications),
                  _info('Symptom to FMC', ua?.treatment?.symptomToFmc),
                  _info('FMC to ECG', ua?.treatment?.fmcToEcg),
                  _info('Door To Balloon', ua?.treatment?.doorToBalloon),
                  _info('Coronary Angiography', ua?.treatment?.coronoryAngiography),
                ]),

                _buildSectionHeader('🏥 UA Outcome'),
                _buildCard([
                  _info('Outcome', ua?.outcome?.outcomeType),
                  _info('Discharge', ua?.outcome?.dischargeDatetime),
                  _info('Death', ua?.outcome?.deathDatetime),
                  _info('Hospital Type', ua?.outcome?.hospitalType),
                  _info('Destination', ua?.outcome?.destinationHospital),
                  _info('Referral Reason', ua?.outcome?.referralReason),
                  _info('Referring Doctor', ua?.outcome?.referringDoctor),
                  _info('Patient Condition', ua?.outcome?.patientCondition),
                  _info('CaseSheet', ua?.outcome?.documentedInTaeiCaseSheet),
                ]),
              ],
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
            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.blueAccent)),
  );

  Widget _buildCard(List<Widget> children) => Card(
    color: Colors.green[100],
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children:
        children.where((e) => e != const SizedBox()).toList(),
      ),
    ),
  );

  Widget _info(String label, dynamic value) {
    final display = (value == null || value.toString().trim().isEmpty)
        ? "—"
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
