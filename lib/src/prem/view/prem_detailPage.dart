import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import '../controller/prem_controller.dart';

class PremDetailPage extends StatefulWidget {
  final String triageId;
  final bool isAppbar;

  const PremDetailPage({
    super.key,
    required this.triageId,
    this.isAppbar = true,
  });

  @override
  State<PremDetailPage> createState() => _PremDetailPageState();
}

class _PremDetailPageState extends State<PremDetailPage> {
  final controller = Get.put(PremController());

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getPremDetails(id: widget.triageId);
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar ? CommonAppBar(title: "PREM Details") : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.ListData1.isNotEmpty
            ? controller.ListData1.first
            : null;

        if (data == null) {
          return const Center(child: Text("No details available"));
        }

        final prem = data.prem;
        final vitals = data.vitals;
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
                  onPressed: () async {
                    await controller.generatePremDetailsPdf();
                  },
                ),
              ),

              /// -------- PREM DETAILS --------
              _buildSectionHeader('PREM Details'),
              _buildCard([
                _info('Department', prem?.nameOfDept),
                _info('Date of Admit', prem?.dateOfAdmit),
                _info('Triage Flag', prem?.triageFlag),
                _info(
                  'Temperature',
                  prem?.temperature != null
                      ? '${prem!.temperature}°F'
                      : null,
                ),
                _info(
                  'CBG',
                  prem?.cbg != null ? prem!.cbg.toString() : null,
                ),
                _info(
                  'Weight',
                  prem?.approxWeight != null
                      ? '${prem!.approxWeight} kg'
                      : null,
                ),
              ]),

              /// -------- VITALS --------
              _buildSectionHeader('💉 Vitals'),
              _buildCard([
                _info('Airway', vitals?.airway),
                _info('Breathing', vitals?.breathing),
                _info('Circulation', vitals?.circulationHr),
                _info('Perfusion', vitals?.perfusion),
                _info('Disability', vitals?.disability),
                _info('Diagnosis', vitals?.diagnosis),
                _info('Treatment Given', vitals?.treatmentGiven),
              ]),

              _buildSectionHeader('🏥 Outcome'),
              _buildCard([
                _info('Outcome', outcome?.outcome),
                _info(
                    'Condition of Patient', outcome?.conditionOfPatient),
                _info('Hospital Type', outcome?.hospitalType),
                _info(
                    'Destination Hospital', outcome?.destinationHospital),
                _info(
                    'Referral Reason', outcome?.reasonForReferral),
                _info(
                    'Referring Doctor', outcome?.referringDoctor),
              ]),
            ],
          ),
        );
      }),
    );
  }

  /// -------- SECTION HEADER --------
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

  /// -------- CARD --------
  Widget _buildCard(List<Widget> children) {
    return Card(
      color: Colors.green[100],
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(children: children),
      ),
    );
  }

  /// -------- INFO ROW (ALWAYS SHOW, '-' IF NO DATA) --------
  Widget _info(String label, dynamic value) {
    final displayValue =
    (value == null || value.toString().trim().isEmpty)
        ? '-'
        : value.toString();

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
