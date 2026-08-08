import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/transit_care/controller/transit_care_controller.dart';

class TransitCareDashboardCountPage extends StatelessWidget {
  final controller = Get.put(TransitCareController());

  final List<List<Color>> gradients = [
    [Colors.blue, Colors.blueAccent],
    [Colors.green, Colors.lightGreen],
    [Colors.red, Colors.orange],
    [Colors.purple, Colors.deepPurple],
    [Colors.teal, Colors.cyan],
    [Colors.pink, Colors.pinkAccent],
    [Colors.indigo, Colors.blueGrey],
  ];

  final List<String> titles = [
    "Total",
    "Non-Critical",
    "Critical",
    "IFT",
    "Non-IFT",
    "Submitted",
    "Pending",
  ];

  @override
  Widget build(BuildContext context) {
    // controller.fetchDashboard();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.dashboard.value;
      if (data == null) {
        return const Center(child: Text("No Data Found"));
      }

      final values = [
        // data.total,
        // data.nonCritical,
        // data.critical,
        // data.ift,
        // data.nonIft,
        // data.submitted,
        // data.pending,
      ];

      return SizedBox(
        height: 220, // ✅ fix: give fixed height
        child: GridView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // ✅ prevent scroll conflict
          itemCount: values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradients[index % gradients.length],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titles[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      values[index].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
