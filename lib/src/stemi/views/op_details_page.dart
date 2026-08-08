import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/appbar.dart';

import '../controller/stemi_controller.dart';

class StemiDetailPageOp extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const StemiDetailPageOp({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<StemiDetailPageOp> createState() => _StemiDetailPageOpState();
}

class _StemiDetailPageOpState extends State<StemiDetailPageOp> {
  final controller = Get.put(StemiController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getStemiDetailsOp(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "STEMI OP Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final model = controller.ListDataOp1.isNotEmpty
            ? controller.ListDataOp1.first
            : null;

        if (model == null) {
          return const Center(child: Text("No Data Found"));
        }

        final op = model.opPatient;
        final stemi = model.stemi;
        final nstemi = model.nstemi;
        final ua = model.unstableAngina;

        return SingleChildScrollView(
          padding:  EdgeInsets.only(top: 16,bottom: 16,left: context.isDesktop? 150:16,right: context.isDesktop? 150:16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Download PDF"),
                  onPressed: () async {
                    await controller.exportStemiOpPdf(model);
                  },
                ),
              ),

              // =============== OP PATIENT DETAILS ===============
              _buildSectionHeader("Patient Details (OP)"),
              _buildCard([
                _info("Patient ID", op?.patientId),
                _info("OP Number", op?.patientOpNumber),
                _info("Patient Admitted", op?.patientAdmitted),
                _info("Name", op?.nameOfPatient),
                _info("Gender", op?.gender),
                _info("Mobile", op?.mobile),
                _info("Father Name", op?.fathername),
                _info("Mother Name", op?.mothername),
                _info("Address", op?.address),
                _info("Pincode", op?.pincode),
                _info("Marital Status", op?.maritalStatus),
                _info("Education", op?.education),
                _info("Employment Status", op?.employmentStatus),
                _info("Occupation", op?.occupation),
                _info("State", op?.state),
                _info("District", op?.district),
                _info("Triage Datetime", op?.dateTimeOfTriage),
                _info("Risk Factors", op?.riskFactors),
                _info("Other Risk Factor", op?.otherRiskFactor),
                _info("Signs / Symptoms", op?.signsSymptoms),
                _info("ECG Datetime", op?.ecgDatetime),
                _info("ECG Location", op?.ecgLocation),
                _info("Diagnosis", op?.diagnosis),
                _info("Other Diagnosis", op?.otherDiagnosis),
              ]),

              // =============== STEMI ===============
              if (stemi != null) ...[
                _buildSectionHeader("STEMI Treatment"),
                _buildCard([
                  _info("STEMI Confirmed At", stemi.treatment?.stemiConfirmedAt),
                  _info("Infarction Location", stemi.treatment?.infarctionLocation),
                  _info("Loading Dose Location", stemi.treatment?.loadingDoseLocation),
                  _info("Loading Dose Drug", stemi.treatment?.loadingDoseDrug),
                  _info("Loading Dose Time", stemi.treatment?.loadingDoseTime),
                  _info("Loading Dose Admin Date", stemi.treatment?.loadingDoseAdministrationDate),
                  _info("Thrombolysis Location", stemi.treatment?.thrombolysisLocation),
                  _info("Thrombolytic Agent", stemi.treatment?.thrombolyticAgent),
                  _info("Thrombolysis Start", stemi.treatment?.thrombolysisStart),
                  _info("Thrombolysis End", stemi.treatment?.thrombolysisEnd),
                  _info("Thrombolysis Outcome", stemi.treatment?.thrombolysisOutcome),
                  _info("Reason Not Done", stemi.treatment?.thrombolysisNotDoneReason),
                  _info("Thrombolysis Date", stemi.treatment?.thrombolysisDate),
                  _info("Treatment Strategy", stemi.treatment?.treatmentStrategy),
                  _info("Conservative Management", stemi.treatment?.conservativeManagement),
                  _info("Killip Risk Score", stemi.treatment?.killipRiskScore),
                  _info("Planned CAG", stemi.treatment?.plannedCag),
                  _info("Cath Lab Arrival", stemi.treatment?.cathLabArrival),
                  _info("Balloon Inflation", stemi.treatment?.balloonInflation),
                  _info("Stent Type", stemi.treatment?.stentType),
                  _info("Complications", stemi.treatment?.complications),
                  _info("Other Complications", stemi.treatment?.otherComplications),
                  _info("Transfer Location", stemi.treatment?.transferLocation),
                  _info("Counselling ID", stemi.treatment?.counsellingId),
                  _info("Symptom to FMC", stemi.treatment?.symptomToFmc),
                  _info("FMC to ECG", stemi.treatment?.fmcToEcg),
                  _info("Door to Needle", stemi.treatment?.doorToNeedle),
                  _info("Door to Balloon", stemi.treatment?.doorToBalloon),
                  _info("Total Ischemic Time", stemi.treatment?.totalIschemicTime),
                  _info("ICU Admission", stemi.treatment?.icuAdmission),
                  _info("Hospital Stay Days", stemi.treatment?.hospitalStayDays),
                  _info("In-Hospital Complication", stemi.treatment?.inHospitalComplication),
                  _info("Coronary Angiography", stemi.treatment?.coronoryAngiography),
                ]),

                _buildSectionHeader("STEMI Outcome"),
                _buildCard([
                  _info("Outcome Type", stemi.outcome?.outcomeType),
                  _info("Discharge Datetime", stemi.outcome?.dischargeDatetime),
                  _info("Absconded Datetime", stemi.outcome?.abscondedDatetime),
                  _info("Death Datetime", stemi.outcome?.deathDatetime),
                  _info("Death Timing", stemi.outcome?.deathTiming),
                  _info("Other Death Timing", stemi.outcome?.otherDeathTiming),
                  _info("Cause of Death", stemi.outcome?.causeOfDeath),
                  _info("Hospital Type", stemi.outcome?.hospitalType),
                  _info("Destination Hospital", stemi.outcome?.destinationHospital),
                  _info("Referral Reason", stemi.outcome?.referralReason),
                  _info("Other Referral Reason", stemi.outcome?.otherReferralReason),
                  _info("Patient Condition", stemi.outcome?.patientCondition),
                  _info("Referring Doctor", stemi.outcome?.referringDoctor),
                  _info("Documented in TAEI Case Sheet", stemi.outcome?.documentedInTaeiCaseSheet),
                ]),
              ],

              // =============== NSTEMI ===============
              if (nstemi != null) ...[
                _buildSectionHeader("NSTEMI Treatment"),
                _buildCard([
                  _info("NSTEMI Confirmed At", nstemi.treatment?.nstemiConfirmedAt),
                  _info("Loading Dose Location", nstemi.treatment?.loadingDoseLocation),
                  _info("Loading Dose Drug", nstemi.treatment?.loadingDoseDrug),
                  _info("Loading Dose Time", nstemi.treatment?.loadingDoseTime),
                  _info("Loading Dose Admin Date", nstemi.treatment?.loadingDoseAdministrationDate),
                  _info("TIMI Risk Score", nstemi.treatment?.timiRiskScore),
                  _info("Treatment Strategy", nstemi.treatment?.treatmentStrategy),
                  _info("Conservative Management", nstemi.treatment?.conservativeManagement),
                  _info("Planned CAG", nstemi.treatment?.plannedCag),
                  _info("Cath Lab Arrival", nstemi.treatment?.cathLabArrival),
                  _info("Balloon Inflation", nstemi.treatment?.balloonInflation),
                  _info("Stent Type", nstemi.treatment?.stentType),
                  _info("Complications", nstemi.treatment?.complications),
                  _info("Other Complications", nstemi.treatment?.otherComplications),
                  _info("Transfer Location", nstemi.treatment?.transferLocation),
                  _info("Symptom to FMC", nstemi.treatment?.symptomToFmc),
                  _info("FMC to ECG", nstemi.treatment?.fmcToEcg),
                  _info("Door To Balloon", nstemi.treatment?.doorToBalloon),
                  _info("ICU Admission", nstemi.treatment?.icuAdmission),
                  _info("Hospital Stay Days", nstemi.treatment?.hospitalStayDays),
                  _info("In-Hospital Complications", nstemi.treatment?.inHospitalComplications),
                  _info("Coronary Angiography", nstemi.treatment?.coronoryAngiography),
                ]),

                _buildSectionHeader("NSTEMI Outcome"),
                _buildCard([
                  _info("Outcome Type", nstemi.outcome?.outcomeType),
                  _info("Discharge Datetime", nstemi.outcome?.dischargeDatetime),
                  _info("Absconded Datetime", nstemi.outcome?.abscondedDatetime),
                  _info("Death Datetime", nstemi.outcome?.deathDatetime),
                  _info("Hospital Type", nstemi.outcome?.hospitalType),
                  _info("Destination Hospital", nstemi.outcome?.destinationHospital),
                  _info("Referral Reason", nstemi.outcome?.referralReason),
                  _info("Other Referral Reason", nstemi.outcome?.otherReferralReason),
                  _info("Patient Condition", nstemi.outcome?.patientCondition),
                  _info("Referring Doctor", nstemi.outcome?.referringDoctor),
                  _info("Documented in TAEI Case Sheet", nstemi.outcome?.documentedInTaeiCaseSheet),
                ]),
              ],

              // =============== UNSTABLE ANGINA ===============
              if (ua != null) ...[
                _buildSectionHeader("Unstable Angina Treatment"),
                _buildCard([
                  _info("UA Confirmed At", ua.treatment?.uaConfirmedAt),
                  _info("TIMI Risk Score", ua.treatment?.timiRiskScore),
                  _info("Management ID", ua.treatment?.managementId),
                  _info("Complications", ua.treatment?.complications),
                  _info("Other Complications", ua.treatment?.otherComplications),
                  _info("Counselling ID", ua.treatment?.counsellingId),
                  _info("ICU Admission", ua.treatment?.icuAdmission),
                  _info("Hospital Stay Days", ua.treatment?.hospitalStayDays),
                  _info("In-Hospital Complications", ua.treatment?.inHospitalComplications),
                  _info("Symptom to FMC", ua.treatment?.symptomToFmc),
                  _info("FMC to ECG", ua.treatment?.fmcToEcg),
                  _info("Door To Balloon", ua.treatment?.doorToBalloon),
                  _info("Coronary Angiography", ua.treatment?.coronoryAngiography),
                ]),

                _buildSectionHeader("Unstable Angina Outcome"),
                _buildCard([
                  _info("Outcome Type", ua.outcome?.outcomeType),
                  _info("Discharge Datetime", ua.outcome?.dischargeDatetime),
                  _info("Absconded Datetime", ua.outcome?.abscondedDatetime),
                  _info("Death Datetime", ua.outcome?.deathDatetime),
                  _info("Death Timing", ua.outcome?.deathTiming),
                  _info("Other Death Timing", ua.outcome?.otherDeathTiming),
                  _info("Hospital Type", ua.outcome?.hospitalType),
                  _info("Destination Hospital", ua.outcome?.destinationHospital),
                  _info("Referral Reason", ua.outcome?.referralReason),
                  _info("Other Referral Reason", ua.outcome?.otherReferralReason),
                  _info("Patient Condition", ua.outcome?.patientCondition),
                  _info("Referring Doctor", ua.outcome?.referringDoctor),
                  _info("Documented in TAEI Case Sheet", ua.outcome?.documentedInTaeiCaseSheet),
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
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.blueAccent,
      ),
    ),
  );

  Widget _buildCard(List<Widget> children) => Card(
    color: Colors.green[100],
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: children,
      ),
    ),
  );

  /// value is `dynamic` so it supports int, bool, etc.
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
