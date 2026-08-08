import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/burn/controller/burn_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';

class BurnsDetailsPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const BurnsDetailsPage({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<BurnsDetailsPage> createState() => _BurnsDetailsPageState();
}

class _BurnsDetailsPageState extends State<BurnsDetailsPage> {
  final controller = Get.put(BurnController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getBurnsDetails(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "Burns Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.burnsDetails.value;

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
                    await controller.downloadBurnsDetailsPdf(
                        id: widget.triageId);
                  },
                ),
              ),

              // 🔥 BURNS DETAILS
              _buildSectionHeader('Burns Details'),
              _buildCard([
                _info('Admitted', yesNo(data.burns?.admitted)),
                _info('Admission Date', data.burns?.admissionDate),
                _info('Type of Burn', data.burns?.typeOfBurn),
                _info('Other Type of Burn', data.burns?.othTypeOfBurn),
                _info('Inhalation', yesNo(data.burns?.inhalation)),
                _info('Mode of Injury', data.burns?.modeOfInjury),
                _info('Place of Incident', data.burns?.placeOfIncident),
                _info('Other Place of Incident',
                    data.burns?.othPlaceOfIncident),
                _info('TBSA Area', data.burns?.tbsa),
                _info('TBSA Total %', data.burns?.tbsaTotalPer),
                _info('Degree of Burn', data.burns?.degreeOfBurn),
                _info('Associated Injuries', data.burns?.associatedInjuries),
                _info('Co-morbidities', data.burns?.coMorbidities),
                _info('Pregnant', yesNo(data.burns?.isPregnant)),
                _info(
                    'Fluid Resuscitation Given',
                    yesNo(
                        data.burns?.isFluidResuscitationGiven)),
                _info(
                    'Mechanical Ventilation',
                    yesNo(
                        data.burns?.isMechanicalVentillation)),
                _info('Inserted Date', data.burns?.insertedDate),
              ]),

              // 🔢 TBSA BREAKDOWN
              _buildSectionHeader('TBSA Breakdown'),
              _buildCard([
                _info('Head', toStr(data.burnsTbsa?.head)),
                _info('Neck', toStr(data.burnsTbsa?.neck)),
                _info('Anterior Trunk',
                    toStr(data.burnsTbsa?.anteriorTrunk)),
                _info('Posterior Trunk',
                    toStr(data.burnsTbsa?.posteriorTrunk)),
                _info('Right Gluteal',
                    toStr(data.burnsTbsa?.rightGluteal)),
                _info('Left Gluteal',
                    toStr(data.burnsTbsa?.leftGluteal)),
                _info('Genital', toStr(data.burnsTbsa?.genital)),
                _info('Right Arm', toStr(data.burnsTbsa?.rightArm)),
                _info('Left Arm', toStr(data.burnsTbsa?.leftArm)),
                _info('Right Forearm',
                    toStr(data.burnsTbsa?.rightForearm)),
                _info('Left Forearm',
                    toStr(data.burnsTbsa?.leftForearm)),
                _info('Right Hand',
                    toStr(data.burnsTbsa?.rightHand)),
                _info('Left Hand',
                    toStr(data.burnsTbsa?.leftHand)),
                _info('Right Thigh',
                    toStr(data.burnsTbsa?.rightThigh)),
                _info('Left Thigh',
                    toStr(data.burnsTbsa?.leftThigh)),
                _info('Right Leg', toStr(data.burnsTbsa?.rightLeg)),
                _info('Left Leg', toStr(data.burnsTbsa?.leftLeg)),
                _info('Right Foot',
                    toStr(data.burnsTbsa?.rightFoot)),
                _info('Left Foot',
                    toStr(data.burnsTbsa?.leftFoot)),
              ]),

              // 🛠 BURNS MANAGEMENT
              _buildSectionHeader('Burns Management & Values'),
              _buildCard([
                _info('Wound Management',
                    data.burnsValues?.woundManagement),
                _info('Conservative Method',
                    data.burnsValues?.conservative),
                _info('Other Conservative',
                    data.burnsValues?.othConservative),
                _info('Hyper Baric',
                    yesNo(data.burnsValues?.hyperBaric)),
                _info('Hyper Baric Nos',
                    toStr(data.burnsValues?.hyperBaricNos)),
                _info('Surgery Emergency',
                    data.burnsValues?.surgeryEmergency),
                _info(
                    'Is Surgery Emergency',
                    yesNo(
                        data.burnsValues?.isSurgeryEmergency)),
                _info('Surgery Performed Date',
                    data.burnsValues?.surgeryPerformedDate),
                _info('Supportive Measures',
                    data.burnsValues?.supportiveMeasures),
                _info(
                    'Complications During Stay',
                    data.burnsValues
                        ?.complicationsHospitalStay),
                _info('Multidisciplinary Support',
                    data.burnsValues?.multidisciplinarySupport),
                _info('Other Multidisciplinary Support',
                    data.burnsValues?.othMultidisciplinarySupport),
                _info('Skin Bank Available',
                    yesNo(data.burnsValues?.skinBankAvailable)),
                _info('Skin Bank Details',
                    data.burnsValues?.skinBankAvailableValue),
              ]),

              // 🗂 ELECTIVE SURGERY
              _buildSectionHeader('Elective Surgery Details'),
              if (data.burnsSurgeryElective != null &&
                  data.burnsSurgeryElective!.isNotEmpty)
                ...data.burnsSurgeryElective!.map(
                      (s) => _buildCard([
                    _info('Surgery Elective', s.surgeryElective),
                    _info('Surgery Date', s.surgeryElectiveDate),
                  ]),
                )
              else
                _buildCard([_info('Elective Surgery', '-')]),

              // 🏁 OUTCOME
              _buildSectionHeader('Burns Outcome'),
              _buildCard([
                _info('Outcome', data.burnsOutcome?.outcome),
                _info('Discharge Date',
                    data.burnsOutcome?.dischargeDate),
                _info('Absconded Date',
                    data.burnsOutcome?.abscondedDate),
                _info('Death Date',
                    data.burnsOutcome?.deathDate),
                _info('Cause of Death',
                    data.burnsOutcome?.causeofdeath),
                _info('Transferred To',
                    data.burnsOutcome?.transferredTo),
                _info('Ward Name',
                    data.burnsOutcome?.wardName),
                _info('Ward Date & Time',
                    data.burnsOutcome?.wardDatetime),
                _info('ICU Date & Time',
                    data.burnsOutcome?.icuDatetime),
                _info('Hospital Type',
                    data.burnsOutcome?.hospitalType),
                _info('Destination Hospital',
                    data.burnsOutcome?.destinationHospital),
                _info('Reason for Referral',
                    data.burnsOutcome?.reasonForReferral),
                _info('Condition of Patient',
                    data.burnsOutcome?.conditionOfPatient),
                _info('Referring Doctor',
                    data.burnsOutcome?.referringDoctorName),
                _info(
                    'TAEI Sheet Documented',
                    yesNo(
                        data.burnsOutcome?.documentedTaeiSheet)),
                _info('Patient Exit Date',
                    data.burnsOutcome?.patientExitDate),
              ]),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // ---------------- UTILITIES ----------------

  String yesNo(bool? v) => v == true ? 'Yes' : 'No';
  String? toStr(dynamic v) => v?.toString();

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
        child: Column(children: children),
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
              '$label:',
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
