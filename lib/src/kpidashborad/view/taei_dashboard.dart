import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import 'package:taei_gov/utils/common/outcome_glass_chart.dart';
import 'package:taei_gov/utils/common/space.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../controller/controlller.dart';
import '../model/taei_kpi.dart';

class TaeiDashboardPage extends StatefulWidget {
  const TaeiDashboardPage({super.key});

  @override
  State<TaeiDashboardPage> createState() => _TaeiDashboardPageState();
}

class _TaeiDashboardPageState extends State<TaeiDashboardPage> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.taeiDashboard.value;
      int registered = data.totalCasesRegistered ?? 0;
      int documented = data.totalCasesDocumented ?? 0;
      int notDocumented = registered - documented;

      // Point 1 & 3 calculations
      double completenessRate = (documented / registered) * 100;
      double documentationRate = completenessRate; // same calculation

      return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //   title: const Text(
        //     "TAEI Dashboard",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   centerTitle: true,
        // ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(context.isDesktop ? 16 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        "TAEI Dashboard",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTopStats(data),
                    const Space(
                      height: 12,
                    ),
                    _TaiDashBoard(
                      title1: 'Data Completeness Rate',
                      title2: 'Documentation Rate',
                      value: completenessRate,
                      value2: documentationRate,
                    ),
                    // CommonDashboardCard(
                    //   title: 'Completeness Rate',
                    //   value: completenessRate,
                    // ),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Category Wise Case Count"),
                    const SizedBox(height: 12),
                    // _buildCategoryGrid(data),
                    context.isDesktop
                        ? OutcomeGlassChart(
                            outcomes: (data.categoryWiseCount ?? []),
                            getName: (e) => e.category ?? '',
                            getCount: (e) => e.totalCount ?? 0,
                            title: "Category Wise Case Count",
                          )
                        : CommonOutcomeBarView(
                            outcomes: (data.categoryWiseCount ?? []),
                            getName: (e) => e.category ?? '',
                            getCount: (e) => e.totalCount ?? 0,
                            title: "Category Wise Case Count",
                          ),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Top Presenting Complaints"),
                    const SizedBox(height: 16),
                    // _buildBarChart(data),
                    const SizedBox(height: 16),
                    // _buildPresentingList(data),
                    CommonOutcomeBarView(
                      outcomes: (data.top10PresentingComplaints ?? []),
                      getName: (e) => e.presentingComplaint ?? '',
                      getCount: (e) => e.totalCount ?? 0,
                      title: "Top Presenting Complaints",
                    )
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTopStats(DashboardData data) {
    return Row(
      children: [
        Expanded(
          child: CommonDashboardCard(
              title: 'Total Triage Registrations',
              value: data.totalCasesRegistered),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CommonDashboardCard(
              title: 'Documented Triage Cases',
              value: data.totalCasesDocumented),
        ),
      ],
    );
  }

  Widget _TaiDashBoard(
      {required String title1,
      required String title2,
      required double value,
      required double value2}) {
    return Row(
      children: [
        Expanded(
          child: CommonDashboardCard(
              title: title1, value: '${value.toStringAsFixed(3)}%'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CommonDashboardCard(
              title: title2, value: "${value2.toStringAsFixed(3)}%"),
        ),
      ],
    );
  }
}
