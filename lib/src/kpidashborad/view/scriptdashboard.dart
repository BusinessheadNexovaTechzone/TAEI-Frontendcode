import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../controller/controlller.dart';

class StrokeDashboard extends StatefulWidget {
  const StrokeDashboard({Key? key}) : super(key: key);

  @override
  State<StrokeDashboard> createState() => _StrokeDashboardState();
}

class _StrokeDashboardState extends State<StrokeDashboard> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stroke = controller.stroke.value;

      return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //   title: const
        //   centerTitle: true,
        // ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(context.isDesktop ? 16 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.isDesktop ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: context.isDesktop ? 3.3 : 1.6,
                      ),
                      children: [
                        CommonDashboardCard(
                          title: "Admitted to Stroke Unit (%)",
                          value:
                              "${stroke.strokeDashboard?.pctStrokeAdmitted?.toStringAsFixed(1) ?? "0"}%",
                          color: Colors.blue,
                        ),
                        CommonDashboardCard(
                          title: "Avg Door-to-CT Time (mins)",
                          value: stroke.strokeDashboard?.avgDoorToCtTime != null
                              ? ((stroke.strokeDashboard?.avgDoorToCtTime! ??
                                          0) /
                                      60)
                                  .toStringAsFixed(1)
                              : "0",
                          color: Colors.deepPurple,
                        ),
                        CommonDashboardCard(
                          title: "Ischemic Thrombolyzed (%)",
                          value:
                              "${stroke.strokeDashboard?.pctIschemicThrombolyzed?.toStringAsFixed(1) ?? "0"}%",
                          color: Colors.green,
                        ),
                        CommonDashboardCard(
                          title: "Avg Door-to-Needle (mins)",
                          value: stroke.strokeDashboard?.avgDoorToNeedleTime !=
                                  null
                              ? ((stroke.strokeDashboard
                                              ?.avgDoorToNeedleTime! ??
                                          0) /
                                      60)
                                  .toStringAsFixed(1)
                              : "0",
                          color: Colors.orange,
                        ),
                        CommonDashboardCard(
                          title: "IFT From Spoke Hospital",
                          value:
                              "${stroke.strokeDashboard?.totalIftSpoke ?? 0}",
                          color: Colors.indigo,
                        ),
                        CommonDashboardCard(
                          title: "Stroke Mortality Rate (%)",
                          value: stroke.strokeDashboard?.strokeMortalityRate !=
                                  null
                              ? "${stroke.strokeDashboard?.strokeMortalityRate!.toStringAsFixed(1)}%"
                              : "0%",
                          color: Colors.redAccent,
                        ),
                        CommonDashboardCard(
                          title: "Transferred Out (%)",
                          value: stroke.strokeDashboard?.pctTransferredOut !=
                                  null
                              ? "${stroke.strokeDashboard?.pctTransferredOut!.toStringAsFixed(1)}%"
                              : "0%",
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

Widget _buildKpiCard({
  required String title,
  required String value,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        )
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}
