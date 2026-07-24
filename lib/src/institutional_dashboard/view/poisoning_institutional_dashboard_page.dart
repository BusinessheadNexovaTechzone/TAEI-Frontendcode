import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/controller/institutional_dashboard_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_avg_stay_widget.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import 'package:taei_gov/utils/common/outcome_glass_chart.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';

import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';

class PoisoningInstitutionalDashboardPage extends StatefulWidget {
  const PoisoningInstitutionalDashboardPage({Key? key}) : super(key: key);

  @override
  State<PoisoningInstitutionalDashboardPage> createState() =>
      _PoisoningInstitutionalDashboardPageState();
}

class _PoisoningInstitutionalDashboardPageState
    extends State<PoisoningInstitutionalDashboardPage> {
  final controller = Get.find<InstitutionalDashboardController>();
  final loginController = Get.find<LoginController>();
  final institutionController = Get.find<InstitutionalController>();

  @override
  Widget build(BuildContext context) {
    print('KKKKKKKKKKKKKK${controller.poisoningDashboard.value.data}');
    return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        body: SafeArea(child: Obx(() {
          final data = controller.poisoningDashboard.value.data;

          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------- DESKTOP LAYOUT -------------------
                      if (context.isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  // 🔹 Top Row: Poison, Bites, Hanging admitted
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonDashboardCard(
                                          title: "Poisoning Admitted",
                                          value: data?.poisonAdmitted ?? 0,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: CommonDashboardCard(
                                          title: "Bites Admitted",
                                          value: data?.bitesAdmitted ?? 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonDashboardCard(
                                          title: "Hanging Admitted",
                                          value: data?.hangingAdmitted ?? 0,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: CommonDashboardCard(
                                          title: "Poisoning PLEX Done",
                                          value: data?.poisonPlexDone ?? 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonDashboardCard(
                                          title: "IFT Count",
                                          value: data?.iftCount ?? 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    child: AvgStaySemiCircleWidget(
                                      title: "Poisoning Average Stay",
                                      avgStay:
                                          data?.poisonAvgDays?.toDouble() ?? 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: AvgStaySemiCircleWidget(
                                      title: "Bites Average Stay",
                                      avgStay:
                                          data?.bitesAvgDays?.toDouble() ?? 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      // ------------------- MOBILE LAYOUT -------------------
                      else
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CommonDashboardCard(
                                    title: "Poisoning Admitted",
                                    value: data?.poisonAdmitted ?? 0,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CommonDashboardCard(
                                    title: "Bites Admitted",
                                    value: data?.bitesAdmitted ?? 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: CommonDashboardCard(
                                    title: "Hanging Admitted",
                                    value: data?.hangingAdmitted ?? 0,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CommonDashboardCard(
                                    title: "Poisoning PLEX Done",
                                    value: data?.poisonPlexDone ?? 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: CommonDashboardCard(
                                    title: "IFT Count",
                                    value: data?.iftCount ?? 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            AvgStaySemiCircleWidget(
                              title: "Poisoning Average Stay",
                              avgStay: data?.poisonAvgDays?.toDouble() ?? 0,
                            ),
                            AvgStaySemiCircleWidget(
                              title: "Bites Average Stay",
                              avgStay: data?.bitesAvgDays?.toDouble() ?? 0,
                            ),
                            AvgStaySemiCircleWidget(
                              title: "Hanging Average Stay",
                              avgStay: data?.hangingAvgDays?.toDouble() ?? 0,
                            ),
                            AvgStaySemiCircleWidget(
                              title: "Drowning Average Stay",
                              avgStay: data?.drowningAvgDays?.toDouble() ?? 0,
                            ),
                          ],
                        ),

                      const SizedBox(height: 30),
                      if (context.isDesktop)
                        Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: AvgStaySemiCircleWidget(
                                title: "Hanging Average Stay",
                                avgStay: data?.hangingAvgDays?.toDouble() ?? 0,
                              ),
                            ),
                            Expanded(
                              child: AvgStaySemiCircleWidget(
                                title: "Drowning Average Stay",
                                avgStay: data?.drowningAvgDays?.toDouble() ?? 0,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      // ------------------- OUTCOME CHARTS -------------------
                      context.isDesktop
                          ? Column(
                              children: [
                                OutcomeGlassChart(
                                  title: "Poisoning Outcomes",
                                  outcomes: data?.poisonOutcome ?? [],
                                  getName: (e) => e.name ?? '',
                                  getCount: (e) => e.poisonTotalCount ?? 0,
                                ),
                                const SizedBox(height: 20),
                                OutcomeGlassChart(
                                  title: "Bites Outcomes",
                                  outcomes: data?.bitesOutcome ?? [],
                                  getName: (e) => e.name ?? '',
                                  getCount: (e) => e.bitesTotalCount ?? 0,
                                ),
                                const SizedBox(height: 20),
                                OutcomeGlassChart(
                                  title: "Hanging Outcomes",
                                  outcomes: data?.hangingOutcome ?? [],
                                  getName: (e) => e.name ?? '',
                                  getCount: (e) => e.hangingTotalCount ?? 0,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                CommonOutcomeBarView(
                                  title: "Poisoning Outcomes",
                                  outcomes: data?.poisonOutcome ?? [],
                                  getName: (e) => e.name ?? '',
                                  getCount: (e) => e.poisonTotalCount ?? 0,
                                ),
                                CommonOutcomeBarView(
                                  title: "Bites Outcomes",
                                  outcomes: data?.bitesOutcome ?? [],
                                  getName: (e) => e.name ?? '',
                                  getCount: (e) => e.bitesTotalCount ?? 0,
                                ),
                                CommonOutcomeBarView(
                                  title: "Hanging Outcomes",
                                  outcomes: data?.hangingOutcome ?? [],
                                  getName: (e) => e.name ?? '',
                                  getCount: (e) => e.hangingTotalCount ?? 0,
                                ),
                              ],
                            ),
                    ],
                  ),
                );
        })));
  }
}
