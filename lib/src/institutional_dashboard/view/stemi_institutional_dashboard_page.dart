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

class STEMIInstitutionalDashboardPage extends StatefulWidget {
  const STEMIInstitutionalDashboardPage({Key? key}) : super(key: key);

  @override
  State<STEMIInstitutionalDashboardPage> createState() =>
      _STEMIInstitutionalDashboardPageState();
}

class _STEMIInstitutionalDashboardPageState
    extends State<STEMIInstitutionalDashboardPage> {
  final controller = Get.find<InstitutionalDashboardController>();
  final loginController = Get.find<LoginController>();
  final institutionController = Get.find<InstitutionalController>();

  @override
  void initState() {
    // TODO: implement initState
    // controller.getInstitutionalDashboard(
    //   startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    //   endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    //   // startDate: "2024-10-10",
    //   // endDate: "2025-11-10",
    //   reportType: 10,
    //   institutionId: institutionController.institutionId.value,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('KKKKKKKKKKKKKK${controller.stemiDashboard.value.data}');
    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      body: SafeArea(
        child: Obx(() {
          final data = controller.stemiDashboard.value.data;
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                              value: data?.totalAdmitted ?? 0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Golden Period Hours",
                                              value:
                                                  data?.goldenPeriodHours ?? 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Thrombolysis Done",
                                              value:
                                                  data?.thrombolysisDone ?? 0,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CommonDashboardCard(
                                              title: "Total STEMI Cases",
                                              value: data?.totalSTEMICases ?? 0,
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
                                              value: data?.iftCount ?? 0,
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
                                  child: Column(
                                    children: [
                                      AvgStaySemiCircleWidget(
                                        title: "STEMI Average Stay",
                                        avgStay: data
                                                ?.averageStay?[0].avgStayDays
                                                ?.toDouble() ??
                                            0,
                                      ),
                                      const SizedBox(height: 12),
                                      AvgStaySemiCircleWidget(
                                        title: "NSTEMI Average Stay",
                                        avgStay: data
                                                ?.averageStay?[1].avgStayDays
                                                ?.toDouble() ??
                                            0,
                                      ),
                                    ],
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
                                        value: data?.totalAdmitted ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Golden Period Hours ",
                                        value: data?.goldenPeriodHours ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Thrombolysis Done",
                                        value: data?.thrombolysisDone ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CommonDashboardCard(
                                        title: "Total STEMI Cases",
                                        value: data?.totalSTEMICases ?? 0,
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
                                        value: data?.iftCount ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                AvgStaySemiCircleWidget(
                                    title: "STEMI Average Stay",
                                    avgStay: data?.averageStay?[0].avgStayDays
                                            ?.toDouble() ??
                                        0),
                                AvgStaySemiCircleWidget(
                                    title: "NSTEMI Average Stay",
                                    avgStay: data?.averageStay?[1].avgStayDays
                                            ?.toDouble() ??
                                        0),
                                AvgStaySemiCircleWidget(
                                    title: "Unstable Angina Average Stay",
                                    avgStay: data?.averageStay?[2].avgStayDays
                                            ?.toDouble() ??
                                        0),
                              ],
                            ),
                      Space(
                        height: 30,
                      ),
                      context.isDesktop
                          ? Center(
                              child: AvgStaySemiCircleWidget(
                                title: "Unstable Angina Average Stay",
                                avgStay: data?.averageStay?[2].avgStayDays
                                        ?.toDouble() ??
                                    0,
                              ),
                            )
                          : const SizedBox(),
                      Space(
                        height: 30,
                      ),
                      context.isDesktop
                          ? OutcomeGlassChart(
                              outcomes: (data?.outcomes ?? []),
                              getName: (e) => e.name ?? '',
                              getCount: (e) => e.totalCount ?? 0,
                              title: "STEMI Outcomes",
                            )
                          : CommonOutcomeBarView(
                              outcomes: (data?.outcomes ?? []),
                              getName: (e) => e.name ?? '',
                              getCount: (e) => e.totalCount ?? 0,
                              title: "STEMI Outcomes",
                            ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
