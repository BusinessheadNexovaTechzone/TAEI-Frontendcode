import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/kpidashborad/controller/controlller.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';

import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../../responsive.dart';

class PoisoningKpiDashboardPage extends StatefulWidget {
  const PoisoningKpiDashboardPage({super.key});

  @override
  State<PoisoningKpiDashboardPage> createState() =>
      _PoisoningKpiDashboardPageState();
}

class _PoisoningKpiDashboardPageState extends State<PoisoningKpiDashboardPage> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width > 700;

    final crossAxis = isWeb ? 3 : 2; // auto responsive
    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      // appBar: CommonAppBar(
      //   title: 'Poisoning KPI Dashboard',
      // ),
      body: Obx(() {
        var d = controller.poisoningKpi.value.data;

        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header("1. Time from Exposure to Hospital Arrival"),
                    // CommonDashboardCard(
                    //   title: "Avg Time (Hours)",
                    //   value: d?.timeFromExposureToArrival ?? 0,
                    // ),
                    _buildResponsiveWrap(
                      items: d?.timeFromExposureToArrival
                              ?.map((e) => CommonDashboardCard(
                                    title: e.pillar ?? "",
                                    value: e.avgMinutes ?? 0,
                                    color: Colors.blue,
                                  ))
                              .toList() ??
                          [],
                      crossAxis: crossAxis,
                    ),
                    const SizedBox(height: 20),

                    // ==================== HOSPITAL ADMISSION RATE ====================
                    _header("2. Hospital Admission Rate"),
                    _buildResponsiveWrap(
                      items: d?.hospitalAdmissionRate
                              ?.map((e) => CommonDashboardCard(
                                    title: e.pillar ?? "",
                                    value: e.admissionRatePct ?? 0,
                                    color: Colors.blue,
                                  ))
                              .toList() ??
                          [],
                      crossAxis: crossAxis,
                    ),

                    const SizedBox(height: 20),

                    // ==================== PLEX OUTCOMES ====================
                    _header("3. PLEX Outcome Effectiveness Index (POEI)"),
                    CommonDashboardCard(
                      title: "POEI %",
                      value: d?.plexOutcomeEffectivenessPoisoning?.poeiPct ?? 0,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildResponsiveWrap(
                      items: [
                        CommonDashboardCard(
                          title: "Underwent PLEX",
                          value: d?.plexOutcomeEffectivenessPoisoning
                                  ?.patientsUnderwentPlex ??
                              0,
                        ),
                        CommonDashboardCard(
                          title: "Discharged After PLEX",
                          value: d?.plexOutcomeEffectivenessPoisoning
                                  ?.dischargedAfterPlex ??
                              0,
                        ),
                        CommonDashboardCard(
                          title: "Deaths After PLEX",
                          value: d?.plexOutcomeEffectivenessPoisoning
                                  ?.deathsAfterPlex ??
                              0,
                        ),
                      ],
                      crossAxis: crossAxis,
                    ),

                    const SizedBox(height: 20),

                    // ==================== ANTIDOTE RATE ====================
                    _header("4. Antidote Administration Rate"),
                    _buildResponsiveWrap(
                      items: d?.antidoteAdministrationRate
                              ?.map((item) => CommonDashboardCard(
                                    title: item.pillar ?? "",
                                    value: item.ratePct ?? 0,
                                    color: Colors.orange,
                                  ))
                              .toList() ??
                          [],
                      crossAxis: crossAxis,
                    ),

                    const SizedBox(height: 20),

                    // ==================== REFERRAL RATE ====================
                    _header("5. Referral Rate to Higher Centers"),
                    _buildResponsiveWrap(
                      items: d?.referralRate
                              ?.map((item) => CommonDashboardCard(
                                    title: item.pillar ?? "",
                                    value: item.referralRatePct ?? 0,
                                    color: Colors.redAccent,
                                  ))
                              .toList() ??
                          [],
                      crossAxis: crossAxis,
                    ),

                    const SizedBox(height: 20),

                    // ==================== TOP 5 COMMON TYPES ====================
                    _header("6. Top 5 Common Types"),
                    CommonDashboardCard(
                      title: "Top 5 Types",
                      value: 0,
                    ),

                    const SizedBox(height: 20),

                    // ==================== CFR ====================
                    _header("7. Case Fatality Rate (CFR)"),
                    _buildResponsiveWrap(
                      items: d?.caseFatalityRateByPillar
                              ?.map((item) => CommonDashboardCard(
                                    title: item.pillar ?? "",
                                    value: item.cfrPct ?? 0,
                                    color: Colors.purple,
                                  ))
                              .toList() ??
                          [],
                      crossAxis: crossAxis,
                    ),

                    const SizedBox(height: 20),

                    // ==================== AVERAGE LENGTH OF STAY ====================
                    _header("8. Average Length of Stay (Days)"),
                    _buildResponsiveWrap(
                      items: d?.averageLengthOfStay
                              ?.map((item) => CommonDashboardCard(
                                    title: item.pillar ?? "",
                                    value: item.avgLosDays ?? 0,
                                    color: Colors.teal,
                                  ))
                              .toList() ??
                          [],
                      crossAxis: crossAxis,
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget _buildResponsiveWrap({
    required List<Widget> items,
    required int crossAxis,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth / crossAxis - 12;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              items.map((card) => SizedBox(width: width, child: card)).toList(),
        );
      },
    );
  }
}
