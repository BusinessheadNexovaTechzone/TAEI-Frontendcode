import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/institutional_dashboard/controller/institutional_dashboard_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/model/in_hospital_institutional_dashboard_model.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/pi_chart_common.dart';

class InHospitalInstitutionalDashboardPage extends StatefulWidget {
  const InHospitalInstitutionalDashboardPage({super.key});

  @override
  State<InHospitalInstitutionalDashboardPage> createState() =>
      _InHospitalInstitutionalDashboardPageState();
}

class _InHospitalInstitutionalDashboardPageState
    extends State<InHospitalInstitutionalDashboardPage> {
  final InstitutionalDashboardController controller =
      Get.put(InstitutionalDashboardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.inHospitalDashboard.value.data;
        if (data == null) {
          return const Center(child: Text("No Data Available"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 SUMMARY
              _SummaryRow(data),

              const SizedBox(height: 16),

              /// 🔹 GENDER + AGE
              Row(
                children: [
                  Expanded(child: GenderCard(data)),
                  const SizedBox(width: 12),
                  Expanded(child: AgeWiseCard(data)),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 MODE OF ARRIVAL
              Column(
                children: [
                  const Text("Mode of Arrival"),
                  ModeOfArrivalCard(data),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 TRIAGE
              TriageCard(data),

              const SizedBox(height: 16),

              /// 🔹 EMERGENCY CATEGORY
              EmergencyCategoryCard(data),

              const SizedBox(height: 16),

              /// 🔹 OUTCOME
              OutcomeCard(data),

              const SizedBox(height: 16),

              /// 🔹 INJURY PROFILE
              InjuryProfileCard(data),

              const SizedBox(height: 16),

              /// 🔹 COMPLAINTS (TAB)
              ComplaintTabs(data),
            ],
          ),
        );
      }),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child
          ],
        ),
      ),
    );
  }
}

class GenderCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const GenderCard(this.data);

  @override
  Widget build(BuildContext context) {
    Map<String, IconData> icons = {
      'male': Icons.male,
      'female': Icons.female,
      'transgender': Icons.transgender,
      'unknown': Icons.question_mark,
    };
    final controller = Get.find<InstitutionalDashboardController>();
    final genders = controller.normalizeGender(data.genderWise ?? []);

    return DashboardCard(
      title: "Gender Distribution",
      child: Column(
        children: genders
            .map((g) => _StatRow(
                g.gender!, g.totalCount!, icons[g.gender!.toLowerCase()]!))
            .toList(),
      ),
    );
  }

  Widget _StatRow(String label, int value, IconData icons) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icons,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(NumberFormat.decimalPattern().format(value),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      );
}

class AgeWiseCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const AgeWiseCard(this.data);

  @override
  Widget build(BuildContext context) {
    final ageList = [...data.ageWise ?? []]
      ..sort((a, b) => a.sortOrder!.compareTo(b.sortOrder!));

    return DashboardCard(
      title: "Age Groups",
      child: Column(
        children:
            ageList.map((a) => _StatRow(a.ageGroup!, a.totalCount!)).toList(),
      ),
    );
  }

  Widget _StatRow(String label, int value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(NumberFormat.decimalPattern().format(value),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      );
}

class ModeOfArrivalCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const ModeOfArrivalCard(this.data, {super.key});

  IconData _icon(String? mode) {
    switch (mode) {
      case '108':
        return Icons.local_hospital;
      case 'Auto':
        return Icons.electric_rickshaw;
      case 'Car':
        return Icons.directions_car;
      case 'Twowheler':
        return Icons.two_wheeler;
      case 'Taxi':
        return Icons.local_taxi;
      default:
        return Icons.directions_walk;
    }
  }

  Color _iconBg(String? mode) {
    switch (mode) {
      case '108':
        return Colors.red.shade50;
      case 'Auto':
        return Colors.orange.shade50;
      case 'Car':
        return Colors.blue.shade50;
      case 'Twowheler':
        return Colors.green.shade50;
      case 'Taxi':
        return Colors.purple.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = data.modeOfArrivalWise ?? [];

    if (items.isEmpty) {
      return const DashboardCard(
        title: "Mode of Arrival",
        child: Center(child: Text("No data available")),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.4,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final m = items[i];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _iconBg(m.modeOfArrival),
                ),
                child: Icon(
                  _icon(m.modeOfArrival),
                  size: 26,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                m.modeOfArrival ?? "Unknown",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                NumberFormat.decimalPattern().format(m.totalCount ?? 0),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TriageCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const TriageCard(this.data);

  Color _color(String flag) {
    switch (flag) {
      case 'RED':
        return Colors.red;
      case 'YELLOW':
        return Colors.orange;
      case 'GREEN':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: "Triage",
      child: Wrap(
        spacing: 10,
        children: data.triageFlag!.map((t) {
          final c = _color(t.triageFlag ?? "");
          return Chip(
            label: Text("${t.triageFlag} (${t.totalCount})"),
            backgroundColor: c.withOpacity(0.15),
            labelStyle: TextStyle(color: c),
          );
        }).toList(),
      ),
    );
  }
}

class EmergencyCategoryCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const EmergencyCategoryCard(this.data);

  @override
  Widget build(BuildContext context) {
    final list = [...data.emergenncyCategory!]
      ..sort((a, b) => b.totalCount!.compareTo(a.totalCount!));

    return DashboardCard(
      title: "Emergency Category (Top 5)",
      child: Column(
        children: list
            .take(5)
            .map((e) =>
                _StatRow(e.emergencyCategory ?? "Unknown", e.totalCount!))
            .toList(),
      ),
    );
  }

  Widget _StatRow(String label, int value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(NumberFormat.decimalPattern().format(value),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      );
}

class OutcomeCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const OutcomeCard(this.data);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: "Outcome",
      child: Column(
        children: data.emoOutcome!
            .map((e) => _StatRow(e.outcome ?? "Unknown", e.totalCount!))
            .toList(),
      ),
    );
  }

  Widget _StatRow(String label, int value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(NumberFormat.decimalPattern().format(value),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      );
}

class InjuryProfileCard extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const InjuryProfileCard(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final i = data.injuryProfile;

    if (i == null) {
      return const DashboardCard(
        title: "Injury Profile",
        child: Center(
          child: Text(
            "No injury data available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return DashboardCard(
      title: "Injury Profile",
      child: Row(
        children: [
          Expanded(child: _BigStat("RTA", i.roadTraffic)),
          Expanded(child: _BigStat("Assault", i.assault)),
          Expanded(child: _BigStat("Fall", i.fallFromHeight)),
        ],
      ),
    );
  }

  Widget _BigStat(String label, int? value) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            NumberFormat.decimalPattern().format(value ?? 0),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}

class _SummaryRow extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const _SummaryRow(this.data);

  @override
  Widget build(BuildContext context) {
    final totalVisits = sumCounts(data.genderWise);

    final male = getCountByField(
      list: data.genderWise,
      matchValue: "Male",
      jsonField: "gender",
    );

    final female = getCountByField(
      list: data.genderWise,
      matchValue: "Female",
      jsonField: "gender",
    );

    final redTriage = getCountByField(
      list: data.triageFlag,
      matchValue: "RED",
      jsonField: "triage_flag",
    );

    final trauma = getCountByField(
      list: data.emergenncyCategory,
      matchValue: "TRAUMA",
      jsonField: "emergency_category",
    );

    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            title: "Total Visits",
            value: totalVisits,
            icon: Icons.groups,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryTile(
            title: "Male",
            value: male,
            icon: Icons.male,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryTile(
            title: "Female",
            value: female,
            icon: Icons.female,
            color: Colors.pink,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryTile(
            title: "RED Triage",
            value: redTriage,
            icon: Icons.warning,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryTile(
            title: "Trauma",
            value: trauma,
            icon: Icons.local_hospital,
            color: Colors.deepOrange,
          ),
        ),
      ],
    );
  }
}

int sumCounts(List<dynamic>? list) {
  if (list == null || list.isEmpty) return 0;

  int sum = 0;
  for (var e in list) {
    sum += (e.totalCount as int?) ?? 0;
  }
  return sum;
}

int getCountByField({
  required List<dynamic>? list,
  required String matchValue,
  required String jsonField,
}) {
  if (list == null || list.isEmpty) return 0;

  for (var e in list) {
    final map = e.toJson() as Map<String, dynamic>;
    if (map[jsonField] == matchValue) {
      return (map['total_count'] as int?) ?? 0;
    }
  }
  return 0;
}

/// In Hospital Institutional Dashboard Page

class ComplaintTabs extends StatelessWidget {
  final InHospitalInstitutionalDashboardData data;

  const ComplaintTabs(this.data);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: DashboardCard(
        title: "Complaints",
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Medical"),
                Tab(text: "Surgical"),
                Tab(text: "PREM"),
              ],
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  MedicalComplaintList(data.medicalComplaints ?? []),
                  SurgicalComplaintList(data.surgeryComplaints!),
                  PremComplaintList(data.premComplaints!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const SummaryTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.85),
            color.withOpacity(0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            NumberFormat.decimalPattern().format(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalComplaintList extends StatelessWidget {
  final List<MedicalComplaint> list;

  const MedicalComplaintList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("No Medical Complaints"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.medical_services),
        title: Text(list[i].medicalName ?? "Unknown"),
        trailing: Text("${list[i].totalCount}"),
      ),
    );
  }
}

class SurgicalComplaintList extends StatelessWidget {
  final List<SurgeryComplaint> list;

  const SurgicalComplaintList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("No Surgical Complaints"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.local_hospital),
        title: Text(list[i].surgicalName ?? "Unknown"),
        trailing: Text("${list[i].totalCount}"),
      ),
    );
  }
}

class PremComplaintList extends StatelessWidget {
  final List<PremComplaint> list;

  const PremComplaintList(this.list);

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text("No PREM Complaints"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.child_care),
        title: Text(list[i].premName ?? "Unknown"),
        trailing: Text("${list[i].totalCount}"),
      ),
    );
  }
}
