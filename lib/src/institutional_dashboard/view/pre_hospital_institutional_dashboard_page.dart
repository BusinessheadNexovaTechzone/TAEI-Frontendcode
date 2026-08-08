import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/institutional_dashboard/controller/institutional_dashboard_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/model/pre_hospital_institutional_dashboard_model.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import 'package:taei_gov/utils/common/outcome_glass_chart.dart';

class PreHospitalInstitutionalDashboardPage extends StatefulWidget {
  const PreHospitalInstitutionalDashboardPage({super.key});

  @override
  State<PreHospitalInstitutionalDashboardPage> createState() =>
      _PreHospitalInstitutionalDashboardPageState();
}

class _PreHospitalInstitutionalDashboardPageState
    extends State<PreHospitalInstitutionalDashboardPage> {
  final controller = Get.find<InstitutionalDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe1e9f4),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.preHospitalDashboard.value.data;
          if (data == null) return const Center(child: Text("No Data"));
          final summaryMap = data.summary?.toJson() ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summarySection(context, data.summary),
                const SizedBox(height: 20),
                //_districtWiseSection(context, data.districtWiseTotal ?? []),
                // CommonOutcomeBarView(
                //   outcomes: (data.districtWiseTotal ?? []),
                //   getName: (e) => e.districtName ?? '',
                //   getCount: (e) => e.total108Calls ?? 0,
                //   title: "District Wise Section",
                // ),
                context.isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            child: DistrictVerticalBarFlow(
                              items: data.districtWiseTotal ?? [],
                              getName: (e) => e.districtName ?? '',
                              getCount: (e) => e.total108Calls ?? 0,
                              title: "District Wise 108 Call Flow",
                            ),
                          ),
                          Expanded(
                            child: DistrictVerticalBarFlow(
                              items: data.emergencyCategoryWise ?? [],
                              getName: (e) => e.emergencyCategory ?? '',
                              getCount: (e) => e.totalCases ?? 0,
                              title: "Emergency Category Wise",
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          DistrictVerticalBarFlow(
                            items: data.districtWiseTotal ?? [],
                            getName: (e) => e.districtName ?? '',
                            getCount: (e) => e.total108Calls ?? 0,
                            title: "District Wise 108 Call Flow",
                          ),
                          DistrictVerticalBarFlow(
                            items: data.emergencyCategoryWise ?? [],
                            getName: (e) => e.emergencyCategory ?? '',
                            getCount: (e) => e.totalCases ?? 0,
                            title: "Emergency Category Wise",
                          )
                        ],
                      ),

                const SizedBox(height: 20),

                // _emergencyCategorySection(
                //     context, data.emergencyCategoryWise ?? []),
              ],
            ),
          );
        }),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
        )
      ],
    );
  }

/*  Widget _emergencyCategorySection(
      BuildContext context, List<EmergencyCategoryWise> list) {
    final maxValue = list
        .map((e) => e.totalCases ?? 0)
        .fold<int>(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Emergency Category Wise",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...list.map((e) {
            final percent = ((e.totalCases ?? 0) / maxValue).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${e.emergencyCategory ?? '-'} (${e.totalCases})",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.blue,
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }*/

  Widget _summarySection(BuildContext context, Summary? summary) {
    if (summary == null) return const SizedBox();

    final items = [
      _summaryItem("108 Calls", summary.the108Calls, Icons.call),
      _summaryItem("Total Cases", summary.totalCases, Icons.assignment),
      _summaryItem("Critical", summary.critical, Icons.warning),
      _summaryItem("Non-Critical", summary.nonCritical, Icons.check_circle),
      _summaryItem("Trauma", summary.traumaCases, Icons.local_hospital),
      _summaryItem(
          "Critical Trauma", summary.criticalTraumaCases, Icons.healing),
      _summaryItem("IFT", summary.ift, Icons.swap_horiz),
      _summaryItem("Scene", summary.scene, Icons.location_on),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isDesktop ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: context.isDesktop ? 2.2 : 2.4,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => items[i],
    );
  }

  Widget _summaryItem(String title, int? value, IconData icon) {
    return CommonDashboardCard(title: title, value: value);
  }
}

class DistrictVerticalBarFlow<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) getName;
  final int Function(T) getCount;
  final String title;

  const DistrictVerticalBarFlow({
    super.key,
    required this.items,
    required this.getName,
    required this.getCount,
    this.title = "District Wise Flow",
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = items.isNotEmpty
        ? items.map(getCount).reduce((a, b) => a > b ? a : b)
        : 0;

    return SizedBox(
      width: 520,
      height: 420, // 👈 SMALL & FIXED
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),

              // 🔹 Flow List
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final value = getCount(item);
                    final double ratio = maxValue == 0 ? 0 : value / maxValue;

                    final barColor = Color.lerp(
                      Colors.blue.shade300,
                      Colors.red.shade600,
                      ratio,
                    )!;

                    return _VerticalFlowItem(
                      name: getName(item).isEmpty ? "Unknown" : getName(item),
                      value: value,
                      ratio: ratio,
                      color: barColor,
                      showConnector: index != items.length - 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalFlowItem extends StatelessWidget {
  final String name;
  final int value;
  final double ratio;
  final Color color;
  final bool showConnector;

  const _VerticalFlowItem({
    required this.name,
    required this.value,
    required this.ratio,
    required this.color,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Vertical flow line
        Column(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (showConnector)
              Container(
                width: 2,
                height: 46,
                color: Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 12),

        // 🔹 Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + value
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Flow bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: ratio,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.6),
                            color,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
