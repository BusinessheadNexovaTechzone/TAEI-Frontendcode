import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class TriageDetailScreen extends StatelessWidget {
  final String triageId;

  TriageDetailScreen({super.key, required this.triageId});

  final TriageGetController controller = Get.put(TriageGetController());

  @override
  Widget build(BuildContext context) {
    controller.getTriageById(id: triageId); // fetch when screen opens

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("Triage Details")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return controller.buildTriageForm();
      }),
    );
  }
}
