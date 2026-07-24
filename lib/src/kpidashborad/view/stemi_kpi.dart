import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../controller/controlller.dart';

class StemiDashboardUi extends StatefulWidget {
  const StemiDashboardUi({super.key});

  @override
  State<StemiDashboardUi> createState() => _StemiDashboardUiState();
}

class _StemiDashboardUiState extends State<StemiDashboardUi> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stemi = controller.stemi.value.data?.stemiDashboard;
      final nstemi = controller.stemi.value.data?.nstemiDashboard;
      final ua = controller.stemi.value.data?.unstableAnginaDashboard;

      return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(context.isDesktop ? 16 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    // ---------- STEMI Section ----------
                    Text("STEMI Dashboard",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: context.isDesktop ? 4 : 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                      children: [
                        CommonDashboardCard(
                            title: "Door-to-Needle Time",
                            value: stemi?.doorToNeedleTimeMin != null
                                ? "${stemi?.doorToNeedleTimeMin.toStringAsFixed(2)} min"
                                : "0"),
                        CommonDashboardCard(
                            title: "Door-to-ECG Time",
                            value: stemi?.doorToEcgTimeMin != null
                                ? "${stemi?.doorToEcgTimeMin.toStringAsFixed(2)} min"
                                : "0"),
                        CommonDashboardCard(
                            title: "Door-to-Balloon Time",
                            value: stemi?.doorToBalloonTimeMin != null
                                ? "${stemi?.doorToBalloonTimeMin.toStringAsFixed(2)} min"
                                : "0"),
                        CommonDashboardCard(
                            title: "Thrombolysis Rate",
                            value: stemi?.thrombolysisRatePct != null
                                ? "${stemi?.thrombolysisRatePct?.toStringAsFixed(2)} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Thrombolysis Failure Rate",
                            value: stemi?.thrombolysisFailureRatePct != null
                                ? "${stemi?.thrombolysisFailureRatePct?.toStringAsFixed(2)} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Referral Rate",
                            value: stemi?.referralRatePct != null
                                ? "${stemi?.referralRatePct?.toStringAsFixed(2)} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Case Fatality Rate",
                            value: stemi?.caseFatalityRatePct != null
                                ? "${stemi?.caseFatalityRatePct?.toStringAsFixed(2)} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Average Length of Stay",
                            value: stemi?.avgLengthOfStayDays != null
                                ? "${stemi?.avgLengthOfStayDays!.toStringAsFixed(2)} days"
                                : "0 days"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ---------- NSTEMI Section ----------
                    Text("NSTEMI Dashboard",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: context.isDesktop ? 4 : 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                      children: [
                        CommonDashboardCard(
                            title: "Referral Rate",
                            value: nstemi?.referralRatePct != null
                                ? "${nstemi?.referralRatePct?.toStringAsFixed(2) ?? '-'} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Case Fatality Rate",
                            value: nstemi?.caseFatalityRatePct != null
                                ? "${nstemi?.caseFatalityRatePct?.toStringAsFixed(2) ?? '-'} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Average Length of Stay",
                            value: nstemi?.avgLengthOfStayDays != null
                                ? "${nstemi?.avgLengthOfStayDays!.toStringAsFixed(2)} days"
                                : "0 days"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ---------- Unstable Angina Section ----------
                    Text("Unstable Angina Dashboard",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: context.isDesktop ? 4 : 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                      children: [
                        CommonDashboardCard(
                            title: "Referral Rate",
                            value: ua?.referralRatePct != null
                                ? "${ua?.referralRatePct?.toStringAsFixed(2) ?? '-'} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Case Fatality Rate",
                            value: ua?.caseFatalityRatePct != null
                                ? "${ua?.caseFatalityRatePct?.toStringAsFixed(2) ?? '-'} %"
                                : "0 %"),
                        CommonDashboardCard(
                            title: "Average Length of Stay",
                            value: ua?.avgLengthOfStayDays != null
                                ? "${ua?.avgLengthOfStayDays!.toStringAsFixed(2)} days"
                                : "0 days"),
                      ],
                    ),
                  ],
                ),
              ),
      );
    });
  }

// ---------- KPI Card Widget ----------
  Widget _buildKpiCard(String title, String value) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
