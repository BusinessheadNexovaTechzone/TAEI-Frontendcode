import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import 'package:taei_gov/utils/common/outcome_glass_chart.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../controller/controlller.dart';

class PremDashboard extends StatefulWidget {
  const PremDashboard({super.key});

  @override
  State<PremDashboard> createState() => _PremDashboardState();
}

class _PremDashboardState extends State<PremDashboard> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final crossAxisCount = isDesktop ? 3 : 1;
    return Obx(() {
      final data = controller.prem.value;

      return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(isDesktop ? 24 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 2.4 : 2.1,
                      ),
                      children: [
                        CommonDashboardCard(
                          title: "% Pediatric Patients Triaged in Queue",
                          value:
                              "${data.premDashboard?.pctTriagedInQueue ?? 0}%",
                          color: Colors.blue,
                        ),
                        CommonDashboardCard(
                          title: "Avg Time to First Medical Contact",
                          value: formatMinutes(data
                              .premDashboard?.avgTimeToFirstMedicalContactMin),
                          color: Colors.orange,
                        ),
                        CommonDashboardCard(
                          title:
                              "% RED Cases Receiving Intervention within 15 min",
                          value:
                              "${data.premDashboard?.pctRedAnyIntervention ?? 0}%",
                          color: Colors.red,
                        ),
                        CommonDashboardCard(
                          title: "% Stabilized & Admitted to PICU",
                          value: data.premDashboard
                                      ?.pctStabilizedAndAdmittedToPicu !=
                                  null
                              ? "${data.premDashboard!.pctStabilizedAndAdmittedToPicu}%"
                              : "-",
                          color: Colors.green,
                        ),
                        CommonDashboardCard(
                          title: "Case Fatality Rate",
                          value: data.premDashboard?.caseFatalityRate != null
                              ? "${data.premDashboard!.caseFatalityRate}%"
                              : "-",
                          color: Colors.grey,
                        ),
                        CommonDashboardCard(
                          title: "% Resuscitation Among Admitted",
                          value: data.premDashboard
                                      ?.pctResuscitationAmongAdmitted !=
                                  null
                              ? "${data.premDashboard!.pctResuscitationAmongAdmitted}%"
                              : "-",
                          color: Colors.purple,
                        ),
                        CommonDashboardCard(
                          title: "Total Pediatric Cases Registered",
                          value: "${data.premDashboard?.totalRegistered ?? 0}",
                          color: Colors.teal,
                        ),
                        CommonDashboardCard(
                          title: "Average Length of Stay (Days)",
                          value: data.premDashboard?.avgLengthOfStayDays != null
                              ? "${data.premDashboard!.avgLengthOfStayDays}"
                              : "-",
                          color: Colors.brown,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // TOP 10 Complaints List
                    // buildSectionTitle("Top 10 Presenting Complaints"),
                    // ...?data.top10PresentingComplaints?.map((c) => ListTile(
                    //       title: Text(c.presentingComplaint ?? "-"),
                    //       trailing: Text("${c.totalCases ?? 0}"),
                    //     )),
                    CommonOutcomeBarView(
                      title: "Top 10 Presenting Complaints",
                      outcomes: data.top10PresentingComplaints ?? [],
                      getName: (e) => e.presentingComplaint ?? '',
                      getCount: (e) => e.totalCases ?? 0,
                    ),
                    const SizedBox(height: 32),

                    // Monthly registrations list
                    buildSectionTitle("Monthly Registrations"),
                    ...?data.monthlyRegistrations?.map(
                      (m) => ListTile(
                        title: Text(m.month ?? "-"),
                        trailing: Text("${m.count ?? 0}"),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

// Helper function to format minutes to HH:MM
  String formatMinutes(double? minutes) {
    if (minutes == null) return "-";
    int hrs = (minutes ~/ 60);
    int mins = (minutes % 60).toInt();
    return "${hrs}h ${mins}m";
  }

// Simple DashboardCard widget
}
