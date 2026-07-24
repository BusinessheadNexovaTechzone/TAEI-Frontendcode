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

class PremInstitutionalDashboardPage extends StatefulWidget {
  const PremInstitutionalDashboardPage({Key? key}) : super(key: key);

  @override
  State<PremInstitutionalDashboardPage> createState() =>
      _PremInstitutionalDashboardPageState();
}

class _PremInstitutionalDashboardPageState
    extends State<PremInstitutionalDashboardPage> {
  final controller = Get.find<InstitutionalDashboardController>();
  final loginController = Get.find<LoginController>();
  final institutionController = Get.find<InstitutionalController>();

  @override
  Widget build(BuildContext context) {
    print('KKKKKKKKKKKKKK${controller.premDashboard.value.data?.avgStay}');
    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      body: SafeArea(
        child: Obx(() {
          final data = controller.premDashboard.value.data;
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                              title: "Total Admitted",
                                              value:
                                                  data?.totalPremAdmitted ?? 0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Total Procedures",
                                              value: data?.totalProcedures ?? 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Scene",
                                              value: data?.sceneIft?[0]
                                                      .totalCount ??
                                                  0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "IFT",
                                              value: data?.sceneIft?[1]
                                                      .totalCount ??
                                                  0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Total IFT",
                                              value: data?.totalIft ?? 0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
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
                                    avgStay: data?.avgStay ?? 0,
                                  ),
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
                                        title: "Total Admitted",
                                        value: data?.totalPremAdmitted ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Total Procedures",
                                        value: data?.totalProcedures ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Scene",
                                        value:
                                            data?.sceneIft?[0].totalCount ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "IFT",
                                        value:
                                            data?.sceneIft?[1].totalCount ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Total IFT",
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
                      Space(
                        height: 30,
                      ),
                      context.isDesktop
                          ? OutcomeGlassChart(
                              outcomes: (data?.outcome ?? []),
                              getName: (e) => e.name ?? '',
                              getCount: (e) => e.totalCount ?? 0,
                              title: "Prem Outcomes",
                            )
                          : CommonOutcomeBarView(
                              outcomes: (data?.outcome ?? []),
                              getName: (e) => e.name ?? '',
                              getCount: (e) => e.totalCount ?? 0,
                              title: "Prem Outcomes",
                            ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
