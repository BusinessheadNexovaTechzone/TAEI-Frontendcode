import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/trauma/controller/trauma_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';

class TraumaDetailsPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const TraumaDetailsPage(
      {super.key, required this.triageId, this.isAppbar = true});

  @override
  State<TraumaDetailsPage> createState() => _TraumaDetailsPageState();
}

class _TraumaDetailsPageState extends State<TraumaDetailsPage> {
  final controller = Get.put(TraumaController());

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getTraumaDetails(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data on init

    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "Patient Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.traumaDetails.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Download PDF"),
                  onPressed: () async {
                    await controller.downloadTraumaDetailsPdf(id: widget.triageId);
                  },
                ),
              ),

              _buildSectionHeader('🩻 Trauma Details'),
              _buildCard([
                _info('Department', data.trauma?.nameOfDept),
                _info('Date & Time of Entry', data.trauma?.dateTimeOfEntry),
                _info('Mechanism of Injury', data.trauma?.mechanismOfInjury),
                _info('Type of Injury', data.trauma?.typeOfInjury),
                _info('Other Type of Injury', data.trauma?.othTypeOfInjury),
                _info('RTA', data.trauma?.rta),
                _info('Helmet Worn',
                    data.trauma?.rtaHelmet == true ? 'Yes' : 'No'),
                _info('IKT Availed',
                    data.trauma?.iktAvailed == true ? 'Yes' : 'No'),
                _info('Assault', data.trauma?.assault),
                _info('Workspot Injury', data.trauma?.workspotInjury),
                _info('Injuries Identified', data.trauma?.injuriesIdentified),
                _info('Other Injuries', data.trauma?.othInjuriesIdentified),
                _info(
                    'Part of Body Injured', data.trauma?.partOfTheBodyInjured),
                _info('Other Body Part', data.trauma?.othBodyInjured),
                _info('GCS Eye', data.trauma?.gcsEye),
                _info('GCS Verbal', data.trauma?.gcsVerbal),
                _info('GCS Motor', data.trauma?.gcsMotor),
                _info('GCS Total', data.trauma?.gcsTotal),
                _info('Inserted Date', data.trauma?.insertedDate),
              ]),
              _buildSectionHeader('🩸 Trauma Values'),
              _buildCard([
                _info('BP',
                    '${data.traumaValues?.bpSystolic}/${data.traumaValues?.bpDiastolic}'),
                _info('RR', data.traumaValues?.rr?.toString()),
                _info('RTS Autogenerate',
                    data.traumaValues?.rtsAutogenerate?.toString()),
                _info('Trauma Flag', data.traumaValues?.traumaFlag),
                _info('Admitted',
                    data.traumaValues?.admitted == true ? 'Yes' : 'No'),
                _info(
                    'ECG Done', data.traumaValues?.ecg == true ? 'Yes' : 'No'),
                _info('ECG Findings', data.traumaValues?.ecgfindings),
                _info('X-Ray Done',
                    data.traumaValues?.xray == true ? 'Yes' : 'No'),
                _info('X-Ray Date', data.traumaValues?.xrayDateTime),
                _info('X-Ray Findings', data.traumaValues?.xrayfindings),
                _info('EFAST Done',
                    data.traumaValues?.efast == true ? 'Yes' : 'No'),
                _info('EFAST Date', data.traumaValues?.efastDateTime),
                _info('EFAST Findings', data.traumaValues?.efastfindings),
                _info('CT Done', data.traumaValues?.ct == true ? 'Yes' : 'No'),
                _info('CT Findings', data.traumaValues?.ctfindings),
                _info(
                    'MRI Done', data.traumaValues?.mri == true ? 'Yes' : 'No'),
                _info('MRI Findings', data.traumaValues?.mrifindings),
                _info(
                    'ABG Done', data.traumaValues?.abg == true ? 'Yes' : 'No'),
                _info('ABG Findings', data.traumaValues?.abgfindings),
                _info(
                    'Blood Investigation',
                    data.traumaValues?.bloodInvestigation == true
                        ? 'Yes'
                        : 'No'),
                _info(
                    'HCG Done', data.traumaValues?.hcg == true ? 'Yes' : 'No'),
                _info('Urine Test',
                    data.traumaValues?.urineTest == true ? 'Yes' : 'No'),
                _info('Other Specify', data.traumaValues?.othSpecify),
              ]),
              _buildSectionHeader('🧠 Trauma Final Management'),
              _buildCard([
                _info(
                    'Speciality Opinion', data.traumaFinal?.specialityOpinion),
                _info(
                    'CPR Done', data.traumaFinal?.iscpr == true ? 'Yes' : 'No'),
                _info('CPR Type', data.traumaFinal?.cprDone),
                _info(
                    'Blood Transfusion',
                    data.traumaFinal?.bloodTransfusionDone == true
                        ? 'Yes'
                        : 'No'),
                _info(
                    'On Arrival Nerve Blocks',
                    data.traumaFinal?.onArrivalNerveBlocks == true
                        ? 'Yes'
                        : 'No'),
                _info('Mechanical Intubation',
                    data.traumaFinal?.mechIntubation == true ? 'Yes' : 'No'),
                _info(
                    'Intubation Details', data.traumaFinal?.mechIntubationDtls),
                _info(
                    'First Pass Intubation',
                    data.traumaFinal?.firstPassIntubation == true
                        ? 'Yes'
                        : 'No'),
                _info('Other Procedures Done',
                    data.traumaFinal?.otherProcedureDone),
                _info('Other Procedure Details',
                    data.traumaFinal?.othProcedureDone),
                _info('Final Diagnosis', data.traumaFinal?.finalDiagnosis),
                _info('Management', data.traumaFinal?.management),
                _info('Type of Surgery', data.traumaFinal?.typeOfSurgery),
                _info('Surgery Type', data.traumaFinal?.surgeryType),
                _info('Surgery Name', data.traumaFinal?.surgeryName),
                _info('Surgery Date', data.traumaFinal?.dateTime),
                _info(
                    'Taken up from Incident (days)',
                    data.traumaFinal?.surgeryTakenupFromIncidentDate
                        ?.toString()),
                _info('Taken up from Triage (days)',
                    data.traumaFinal?.surgeryTakenupFromTriageDate?.toString()),
                _info('Anesthesia Type', data.traumaFinal?.surgeryDoneUnder),
                _info('Surgery Done By', data.traumaFinal?.surgeryDoneBy),
                _info(
                    'Rehabilitation Required',
                    data.traumaFinal?.rehabilitationRequired == true
                        ? 'Yes'
                        : 'No'),
              ]),
              _buildSectionHeader('🏁 Trauma Outcome'),
              _buildCard([
                _info('Outcome', data.traumaOutcome?.outcome),
                _info('Discharge Date & Time',
                    data.traumaOutcome?.dischargeDatetime),
                _info(
                    'Discharge Details', data.traumaOutcome?.dischargeDetails),
                _info('Hospital Type', data.traumaOutcome?.hospitalType),
                _info('Destination Hospital',
                    data.traumaOutcome?.destinationHospital),
                _info('Reason for Referral',
                    data.traumaOutcome?.reasonForReferral),
                _info('Condition of Patient',
                    data.traumaOutcome?.conditionOfPatient),
                _info('Referring Doctor',
                    data.traumaOutcome?.referringDoctorName),
                _info(
                    'TAEI Case Documented',
                    data.traumaOutcome?.taeiCaseDocumented == true
                        ? 'Yes'
                        : 'No'),
                _info('Doctor Name', data.traumaOutcome?.nameOfDoctor),
                _info('Stayed Duration (days)',
                    data.traumaOutcome?.stayedDuration?.toString()),
              ]),
              const SizedBox(height: 30),
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
              .where((w) => w != const SizedBox()) // remove empty rows
              .toList(),
        ),
      ),
    );
  }

  Widget _info(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              )),
          Expanded(
              flex: 6,
              child: Text(
                value,
                style: const TextStyle(color: Colors.black87),
              )),
        ],
      ),
    );
  }
}
