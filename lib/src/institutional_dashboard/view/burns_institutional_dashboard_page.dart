import 'dart:developer' show log;

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/controller/institutional_dashboard_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_avg_stay_widget.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import 'package:taei_gov/utils/common/outcome_glass_chart.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';

import '../../../utils/common/common_drop_down.dart';
import '../../../utils/helpers/space.dart';
import '../../login/controller/login_controller.dart';

class BurnsInstitutionalDashboardPage extends StatefulWidget {
  const BurnsInstitutionalDashboardPage({Key? key}) : super(key: key);

  @override
  State<BurnsInstitutionalDashboardPage> createState() =>
      _BurnsInstitutionalDashboardPageState();
}

class _BurnsInstitutionalDashboardPageState
    extends State<BurnsInstitutionalDashboardPage> {
  final controller = Get.find<InstitutionalDashboardController>();
  final loginController = Get.find<LoginController>();
  final institutionController = Get.find<InstitutionalController>();

  @override
  Widget build(BuildContext context) {
    print('KKKKKKKKKKKKKK${controller.burnsDashboard.value.data?.avgStay}');
    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      body: SafeArea(
        child: Obx(() {
          // final data = controller.burnsDashboardList.data;
          final data = controller.burnsDashboard.value.data;
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Section: Summary cards + Avg Stay
                      context.isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left side: stats grid
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Total Burns",
                                              value: data?.totalBurns ?? 0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Total Treated",
                                              value: data?.totalTreated ?? 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Total Surgery",
                                              value: data?.totalSurgery ?? 0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "IFT Count",
                                              value: data?.totalIft ?? 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Right side: Avg Stay widget (larger)
                                Expanded(
                                  flex: 2,
                                  child: AvgStaySemiCircleWidget(
                                      avgStay: data?.avgStay ?? 0),
                                ),
                              ],
                            )
                          : Column(
                              // 🔹 Mobile Layout
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Total Burns",
                                        value: data?.totalBurns ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Total Treated",
                                        value: data?.totalTreated ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Total Surgery",
                                        value: data?.totalSurgery ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "IFT Count",
                                        value: data?.totalIft ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                AvgStaySemiCircleWidget(
                                    avgStay: data?.avgStay ?? 0),
                              ],
                            ),

                      const SizedBox(height: 30),

                      // 🔹 Outcome Bar View
                      context.isDesktop
                          ? OutcomeGlassChart(
                              outcomes: (data?.outcome ?? []),
                              getName: (e) => e.name ?? '',
                              getCount: (e) => e.totalCount ?? 0,
                              title: "Burns Outcomes",
                            )
                          : CommonOutcomeBarView(
                              outcomes: (data?.outcome ?? []),
                              getName: (e) => e.name ?? '',
                              getCount: (e) => e.totalCount ?? 0,
                              title: "Burns Outcomes",
                            ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
