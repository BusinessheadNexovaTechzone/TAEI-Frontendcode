import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/kpidashborad/commondatepickertest.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_dashboard_card.dart';
import 'package:taei_gov/utils/helpers/space.dart';

import '../../../utils/common/common_drop_down.dart';
import '../../login/controller/login_controller.dart';
import '../controller/controlller.dart';

class TraumaDashboard extends StatefulWidget {
  const TraumaDashboard({Key? key}) : super(key: key);

  @override
  State<TraumaDashboard> createState() => _TraumaDashboardState();
}

class _TraumaDashboardState extends State<TraumaDashboard> {
  final KpiDashboard controller = Get.find<KpiDashboard>();
  final loginController = Get.find<LoginController>();
  final InstitutionalController institutionController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.trauma.value;

      // ---------- CALCULATIONS ----------

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
                    context.isDesktop
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 16,
                            children: [
                              Expanded(
                                  child: CommonDashboardCard(
                                      title: 'ER cases by 108',
                                      value: _percent(data.totalCases108 ?? 0,
                                          data.totalEdCases ?? 0))),
                              Expanded(
                                  child: CommonDashboardCard(
                                      title: 'Trauma by 108',
                                      value: _percent(data.traumaBy108 ?? 0,
                                          data.totalTrauma ?? 0))),
                              Expanded(
                                  child: CommonDashboardCard(
                                      title: 'Avg Transport Time',
                                      value: "${data.avgTransportTime} min")),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                  child: CommonDashboardCard(
                                      title: 'ER cases by 108',
                                      value: _percent(data.totalCases108 ?? 0,
                                          data.totalEdCases ?? 0))),
                              Expanded(
                                  child: CommonDashboardCard(
                                      title: 'Trauma by 108',
                                      value: _percent(data.traumaBy108 ?? 0,
                                          data.totalTrauma ?? 0))),
                              Expanded(
                                  child: CommonDashboardCard(
                                      title: 'Avg Transport Time',
                                      value: "${data.avgTransportTime} min")),
                            ],
                          ),
                    SizedBox(height: 20),
                    context.isDesktop
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 16,
                            children: [
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Improved Outcomes',
                                    value: _percent(data.traumaDischarged ?? 0,
                                        data.traumaAdmitted ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Red Cases Improved',
                                    value: _percent(data.redDischarged ?? 0,
                                        data.redAdmitted ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Trauma Mortality (ER)',
                                    value: "${data.totalDeath.toString()} min"),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Improved Outcomes',
                                    value: _percent(data.traumaDischarged ?? 0,
                                        data.traumaAdmitted ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Red Cases Improved',
                                    value: _percent(data.redDischarged ?? 0,
                                        data.redAdmitted ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Trauma Mortality (ER)',
                                    value: "${data.totalDeath.toString()} min"),
                              ),
                            ],
                          ),
                    Space(
                      height: 16,
                    ),
                    context.isDesktop
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 16,
                            children: [
                              //
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'In-Hospital Mortality %',
                                    value: _percent(data.totalDeath ?? 0,
                                        data.traumaAdmitted ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Trauma Admissions %',
                                    value: _percent(data.traumaAdmitted ?? 0,
                                        data.totalTrauma ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Trauma Referred Out %',
                                    value: _percent(data.traumaReferredOut ?? 0,
                                        data.totalTrauma ?? 0)),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'In-Hospital Mortality %',
                                    value: _percent(data.totalDeath ?? 0,
                                        data.traumaAdmitted ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Trauma Admissions %',
                                    value: _percent(data.traumaAdmitted ?? 0,
                                        data.totalTrauma ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Trauma Referred Out %',
                                    value: _percent(data.traumaReferredOut ?? 0,
                                        data.totalTrauma ?? 0)),
                              ),
                            ],
                          ),
                    SizedBox(height: 20),
                    context.isDesktop
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 16,
                            children: [
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Referred In %',
                                    value: _percent(data.referredIn ?? 0,
                                        data.totalTrauma ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Definitive Care (6 hrs)',
                                    value: (data.definitiveCareWithin6hrs ?? 0)
                                        .toString()),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Avg Length of Stay',
                                    value:
                                        "${(data.averageLengthOfStay ?? 0).toStringAsFixed(2)} Days"),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Referred In %',
                                    value: _percent(data.referredIn ?? 0,
                                        data.totalTrauma ?? 0)),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Definitive Care (6 hrs)',
                                    value: (data.definitiveCareWithin6hrs ?? 0)
                                        .toString()),
                              ),
                              Expanded(
                                child: CommonDashboardCard(
                                    title: 'Avg Length of Stay',
                                    value:
                                        "${(data.averageLengthOfStay ?? 0).toStringAsFixed(2)} Days"),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
      );
    });
  }

  String _percent(num x, num y) {
    if (y == 0) return "0%";
    return "${((x / y) * 100).toStringAsFixed(1)}%";
  }
}
