import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';

import '../../emo_user/controller/emo_controller.dart';
import '../controller/pdf_generative_controller.dart';

class TriageDetailsPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;
  final bool? imman;

  const TriageDetailsPage(
      {super.key, required this.triageId, this.isAppbar = true, this.imman = false});

  @override
  State<TriageDetailsPage> createState() => _TriageDetailsPageState();
}

class _TriageDetailsPageState extends State<TriageDetailsPage> {
  final controller = Get.put(NurseTriageController());
  final controller1 = Get.put(EmoController());
  final controllerpdf = Get.put(pdfController());


  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getTriageDetails(id: widget.triageId);
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

        final data = controller.triageDetails.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- PDF BUTTON ----------
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
                    // if(widget.imman == true){
                    //   await controllerpdf.downloadFullCasePdf(id: widget.triageId);
                    // }else {
                      await controller.downloadTriageDetailsPdf(
                          id: widget.triageId);
                    // }
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ---------- PATIENT DETAILS ----------
              _buildSectionHeader('👤 Patient Details'),
              _buildCard([
                _info('Name', data?.triageDetails?.nameOfPatient),
                _info('Gender', data?.triageDetails?.gender),
                _info(
                  'Age',
                  '${data?.triageDetails?.ageYear ?? ''} yrs ${data?.triageDetails?.ageMonth ?? ''} mths',
                ),
                _info('Marital Status', data?.triageDetails?.maritalStatus),
                _info('Father\'s Name', data?.triageDetails?.fathername),
                _info('Mother\'s Name', data?.triageDetails?.mothername),
                _info('Mobile', data?.triageDetails?.patientMobileNumber),
                _info('Education', data?.triageDetails?.education),
                _info('Occupation', data?.triageDetails?.occupation),
                _info(
                    'Employment Status', data?.triageDetails?.employmentStatus),
                _info('Income', data?.triageDetails?.income),
                _info('Address', data?.triageDetails?.addressLine),
                _info('District', data?.triageDetails?.district),
                _info('State', data?.triageDetails?.state),
                _info('Pincode', data?.triageDetails?.pincode?.toString()),
              ]),

              // ---------- ARRIVAL & INCIDENT DETAILS ----------
              _buildSectionHeader('🚑 Arrival & Incident Details'),
              _buildCard([
                _info('Mode of Arrival', data?.triageDetails?.modeOfArrival),
                _info('Scene IFT', data?.triageDetails?.sceneIft),
                _info('Patient Received From',
                    data?.triageDetails?.patienrRecievedFrom),
                _info('Other Source',
                    data?.triageDetails?.othPatienrRecievedFrom),
                _info('Date & Time of Incident',
                    data?.triageDetails?.dateAndTimeOfIncident),
                _info(
                    'Place of Incident', data?.triageDetails?.placeOfIncident),
                _info('Other Place', data?.triageDetails?.othPlaceOfIncident),
              ]),

              // ---------- HOSPITAL DETAILS ----------
              _buildSectionHeader('🏥 Hospital Details'),
              _buildCard([
                _info('Source Type', data?.triageDetails?.sourceType),
                _info('Source Hospital', data?.triageDetails?.sourceHospital),
                _info('Destination Hospital',
                    data?.triageDetails?.destinationHospital),
                _info(
                    'Referral Reason', data?.triageDetails?.reasonForReferral),
                _info('Other Referral Reason',
                    data?.triageDetails?.othReasonForReferral),
                _info(
                    'Referral Doctor', data?.triageDetails?.referralDoctorName),
                _info('Condition of Patient',
                    data?.triageDetails?.conditionOfPatient),
                _info('Stable (IFT)', data?.triageDetails?.isPatientStableIft),
              ]),

              // ---------- 108 CALL DETAILS ----------
              if (data?.triageBy108Details?.id != null)
                _buildSectionHeader('📞 108 Call Details'),
              if (data?.triageBy108Details?.id != null)
                _buildCard([
                  _info('Call ID', data?.triageBy108Details?.callId),
                  _info('District', data?.triageBy108Details?.districtName),
                  _info('City', data?.triageBy108Details?.cityName),
                  _info('Vehicle Number',
                      data?.triageBy108Details?.vehicleNumber),
                  _info('Chief Complaint',
                      data?.triageBy108Details?.chiefComplaint),
                  _info('Emergency Type',
                      data?.triageBy108Details?.emergencyType),
                  _info('Emergency Subtype',
                      data?.triageBy108Details?.emergencySubType),
                  _info('Pulse', data?.triageBy108Details?.pulse),
                  _info('BP',
                      '${data?.triageBy108Details?.bpSbp ?? ''}/${data?.triageBy108Details?.bpDbp ?? ''}'),
                  _info('Temperature', data?.triageBy108Details?.temperature),
                  _info('LOC', data?.triageBy108Details?.loc),
                  _info('Condition of Patient',
                      data?.triageBy108Details?.conditionOfPatient),
                ]),

              // ---------- MEDICAL DETAILS ----------
              _buildSectionHeader('🩺 Medical Details'),
              _buildCard([
                _info('Accompanied By', data?.triageDtlsDetails?.accompaniedBy),
                _info('Primary Medical Emergency',
                    data?.triageDtlsDetails?.pcMedicalEmergency),
                _info('Other Medical Emergency',
                    data?.triageDtlsDetails?.othPcMedicalEmergency),
                _info('Primary Surgical Emergency',
                    data?.triageDtlsDetails?.pcSurgicalEmergency),
                _info('Other Surgical Emergency',
                    data?.triageDtlsDetails?.othPcSurgicalEmergency),
                _info('Cause', data?.triageDtlsDetails?.cause),
                _info('AVPU', data?.triageDtlsDetails?.avpu),
                _info('Pulse', data?.triageDtlsDetails?.pulse?.toString()),
                _info('BP',
                    '${data?.triageDtlsDetails?.bpSystolic}/${data?.triageDtlsDetails?.bpDiastolic}'),
                _info('SpO₂', data?.triageDtlsDetails?.spo2?.toString()),
                _info('Temperature',
                    data?.triageDtlsDetails?.temperature?.toString()),
                _info('Triage Flag', data?.triageDtlsDetails?.triageFlag),
                _info('Triage Done By', data?.triageDtlsDetails?.triageDoneBy),
                _info('Mass Casuality', data?.triageDtlsDetails?.massCasuality),
                _info('Brought Dead', data?.triageDtlsDetails?.broughtDead),
                _info('RTA', data?.triageDtlsDetails?.rta),
                _info('Helmet Used', data?.triageDtlsDetails?.rtaHelmet),
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
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      color: Colors.green[100],
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(children: children),
      ),
    );
  }

  Widget _info(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
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
}

/*class TriageProfileView extends StatelessWidget {
  final String triageId;
  const TriageProfileView({super.key, required this.triageId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NurseTriageController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTriageDetails(id: triageId);
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final data = controller.triageDetails.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final triage = data.triageDetails;
        final dtls = data.triageDtlsDetails;
        final by108 = data.triageBy108Details;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: Colors.deepPurple,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(triage?.nameOfPatient ?? 'Triage Case'),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            (triage?.nameOfPatient ?? "U")[0],
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              triage?.nameOfPatient ?? "Unknown",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Condition: ${triage?.conditionOfPatient ?? 'N/A'}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _vitalChip("BP",
                                    "${dtls?.bpSystolic ?? '-'}/${dtls?.bpDiastolic ?? '-'}"),
                                const SizedBox(width: 6),
                                _vitalChip("SpO₂", "${dtls?.spo2 ?? '-'}%"),
                                const SizedBox(width: 6),
                                _vitalChip("Pulse", "${dtls?.pulse ?? '-'}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _sectionCard(
                      icon: Icons.person,
                      title: "Patient Details",
                      data: {
                        "Gender": triage?.gender,
                        "Age": "${triage?.ageYear ?? ''} yrs",
                        "Type": triage?.typeOfPatient,
                        "Scene IFT": triage?.sceneIft,
                        "Triage Flag": dtls?.triageFlag,
                      },
                    ),
                    _sectionCard(
                      icon: Icons.local_hospital,
                      title: "Referral Details",
                      data: {
                        "Source Hospital": triage?.sourceHospital,
                        "Destination": triage?.destinationHospital,
                        "Doctor": triage?.referralDoctorName,
                        "Reason": triage?.reasonForReferral,
                      },
                    ),
                    _sectionCard(
                      icon: Icons.phone,
                      title: "108 Call Details",
                      data: {
                        "Call ID": by108?.callId,
                        "Vehicle": by108?.vehicleNumber,
                        "District": by108?.districtName,
                        "Condition": by108?.conditionOfPatient,
                        "Emergency Type": by108?.emergencyType,
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _vitalChip(String label, String value) {
    return Chip(
      backgroundColor: Colors.white.withOpacity(0.2),
      label: Text(
        "$label: $value",
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Map<String, String?> data,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20),
            ...data.entries
                .where((e) => e.value != null && e.value!.isNotEmpty)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text("${e.key}:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(e.value!,
                              style: const TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}*/
