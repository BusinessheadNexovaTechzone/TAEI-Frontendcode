import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../controller/controlller.dart';
import '../model/burns_kpi.dart';

class BurnsDashboardUi extends StatefulWidget {
  const BurnsDashboardUi({Key? key}) : super(key: key);

  @override
  State<BurnsDashboardUi> createState() => _BurnsDashboardUiState();
}

class _BurnsDashboardUiState extends State<BurnsDashboardUi> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final burns = controller.burns.value.burnsDashboard;

      return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(context.isDesktop ? 8 : 8),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CommonDashboardCard(
                            title: "Fluid Resuscitation within 1 hr",
                            value:
                                burns?.pctFluidResuscitationWithin1Hr ?? "0 %",
                          ),
                        ),
                        Expanded(
                          child: CommonDashboardCard(
                            title: "Wound Sepsis",
                            value: burns?.pctWoundSepsis?.toDouble() ?? "0 %",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CommonDashboardCard(
                            title: "Survived TBSA ≥40%",
                            value: burns?.pctSurvivedTbsaOver40?.toDouble() ??
                                "0 %",
                          ),
                        ),
                        Expanded(
                          child: CommonDashboardCard(
                            title: "Mortality Rate",
                            value: burns?.inHospitalMortalityRate?.toDouble() ??
                                "0 %",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CommonDashboardCard(
                            title: "Referred Out",
                            value: burns?.pctReferredOut?.toDouble() ?? "0 %",
                          ),
                        ),
                        Expanded(
                          child: CommonDashboardCard(
                            title: "Surgical Intervention",
                            value:
                                burns?.surgicalInterventionRate?.toDouble() ??
                                    "0 %",
                          ),
                        ),
                      ],
                    ),
                    CommonDashboardCard(
                      title: "Avg Length of Stay (days)",
                      value: burns?.avgLengthOfStay?.toDouble() ?? "0",
                    ),
                  ],
                ),
              ),
      );
    });
  }

  Widget _title(String text) => Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );

  // 🔥 MAIN GRID UI
  Widget _buildBurnsKpiGrid(BurnsDashboard data) {
    final items = [
      (
        "Fluid Resuscitation <1hr (%)",
        data.pctFluidResuscitationWithin1Hr ?? 0
      ),
      ("Wound Sepsis (%)", data.pctWoundSepsis ?? 0),
      ("Survived TBSA > 40 (%)", data.pctSurvivedTbsaOver40 ?? 0),
      ("Mortality Rate (%)", data.inHospitalMortalityRate ?? 0),
      ("Referred Out (%)", data.pctReferredOut ?? 0),
      ("Surgical Interventions (%)", data.surgicalInterventionRate ?? 0),
      ("Avg. Length of Stay", data.avgLengthOfStay ?? 0),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: context.isDesktop ? 7 : 1.4,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: items
          .map((e) => _kpiCard(title: e.$1, value: e.$2.toString()))
          .toList(),
    );
  }

  Widget _kpiCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3), // optional, gives soft drop shadow
          ),
        ],
      ),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
        ],
      ),
    );
  }

  // 🔥 Referral summary card

  Widget _referralList(List<ReferralSummary> list) {
    return Column(
      children: list
          .map((item) => Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3), // optional, gives soft drop shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.reasonForReferral ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text("${item.totalCases} cases",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
