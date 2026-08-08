import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/bite/views/bites_List.dart';
import 'package:taei_gov/src/bite/views/bites_save_list_page.dart';
import 'package:taei_gov/src/burn/view/burns_list_page.dart';
import 'package:taei_gov/src/burn/view/burns_save_list_page.dart';
import 'package:taei_gov/src/dashboards/taei_report/view/taei_report_dashboard_page.dart';
import 'package:taei_gov/src/drowning/views/drowning_list.dart';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/view/emo_list_page.dart';
import 'package:taei_gov/src/emo_user/view/emo_prem_children_list.dart';
import 'package:taei_gov/src/hang/view/hang_list.dart';
import 'package:taei_gov/src/hang/view/hang_save_list_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/institutional_dashboard_page.dart';
import 'package:taei_gov/src/kpidashborad/view/kpy_dashboard.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_108_caselist_page.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_children_list_page.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_nurse_list.dart';
import 'package:taei_gov/src/poison/view/poison_list_page.dart';
import 'package:taei_gov/src/poison/view/poison_save_list_page.dart';
import 'package:taei_gov/src/prem/view/prem_save_list_page.dart';
import 'package:taei_gov/src/report_dashboard/views/entry_report/entry_dashboard.dart';
import 'package:taei_gov/src/report_dashboard/views/report_dashboard.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/script/views/script_list.dart';
import 'package:taei_gov/src/script/views/script_save_list_page.dart';
import 'package:taei_gov/src/stemi/views/stemi_list_page.dart';
import 'package:taei_gov/src/transit_care/view/state_transitcare_list_page.dart';
import 'package:taei_gov/src/transit_care/view/transit_care_list_page.dart';
import 'package:taei_gov/src/trauma/views/trauma_list_page.dart';
import 'package:taei_gov/src/trauma/views/trauma_save_list_page.dart';
import '../../nurse_triage/views/add_accident.dart';
import '../../prem/view/prem_list_page.dart';
import '../../stemi/views/add_stemi.dart';
import '../../stemi/views/stemi_op.dart';

/// Refactored Home.dart — Option A (GetX, dashboard-style)
/// - Sidebar updates the central content only (no Get.to navigation)
/// - Permission-driven menu remains
/// - Uses selectedIndex (RxInt) and Obx to reactively swap content
// git add .
// git commit -m "Refactor: Add test comment"
// git push
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LoginController loginController = Get.find();
  final EmoController emoController = Get.put(EmoController());
  final NurseTriageController triageController =
      Get.put(NurseTriageController());

// DashBoard Name
  String institutionalDashboardName = 'Institutional Dashboard';
  String kpiDashboardName = 'KPI Dashboard';
  String reportDashboardName = 'Report Dashboard';
  String entryDashboardName = 'Entry Dashboard';
  String taeiReportDashboardName = "TAEI Report";
  late final String _role;

  // permission flags
  bool dms = true;
  bool dme = true;
  bool triage = false;
  bool emo = false;
  bool trauma = false;
  bool burn = false;
  bool script = false;
  bool stemi = false;
  bool prem = false;
  bool poison = false;
  bool hang = false;
  bool bite = false;
  bool drowning = false;
  bool admin = false;
  bool stateAdmin = false;
  bool districtAdmin = false;
  bool dmeAdmin = false;
  bool dmsAdmin = false;
  bool ghAdmin = false;

  Color myCustomColor = const Color(0xFF053648);

  // selected index for dashboard content
  final RxInt selectedIndex = 0.obs;
  late Map<int, String> indexKeys;

  String resolveDashboardName(String baseName) {
    switch (_role) {
      case 'state admin':
        return 'State $baseName';
      case 'district admin':
        return 'District $baseName';
      case 'district DME':
        return 'District DME $baseName';
      case 'district DMS':
        return 'District DMS $baseName';
      case 'district GH':
        return 'District GH $baseName';
      case 'admin':
        return 'Admin $baseName';
      default:
        return baseName;
    }
  }

  @override
  void initState() {
    super.initState();
    loginController.checkUser();
    setModuleFlags();
    _role = loginController.userDetails.value?.user?.role ?? '';
    institutionalDashboardName =
        resolveDashboardName('Institutional Dashboard');

    kpiDashboardName = resolveDashboardName('KPI Dashboard');

    reportDashboardName = resolveDashboardName('Report Dashboard');

    entryDashboardName = resolveDashboardName('Entry Dashboard');

    taeiReportDashboardName = resolveDashboardName('TAEI Report');

    indexKeys = {
      0: 'TransitCare',
      1: 'TriageForm',
      2: 'Triage108List',
      3: 'TriageNurseList',
      4: 'Trauma',
      5: 'Burns',
      6: 'Script',
      7: 'Prem',
      8: 'Poisoning',
      9: 'Bites',
      10: 'Hanging',
      11: 'Drowning',
      12: 'StemiList',
      13: 'StemiForm',
      14: 'StemiOpList',
      15: 'EmoList',
      16: institutionalDashboardName,
      17: kpiDashboardName,
      18: reportDashboardName,
      19: entryDashboardName,
      28: taeiReportDashboardName,
      29: 'PremChildList',
    };
  }

  // Mapping index -> readable key (for debug/analytics)

  void setModuleFlags() {
    final user = loginController.userDetails.value?.user;
    final perms = user?.permissions ?? [];

    triage = emo = trauma =
        burn = script = stemi = prem = poison = hang = bite = drowning = false;

    for (var perm in perms) {
      if (perm.access != 'write') continue;
      switch (perm.page) {
        case 'Triage':
          triage = true;
          break;
        case 'EmoTriage':
          emo = true;
          break;
        case 'Trauma':
          trauma = true;
          break;
        case 'Burns':
          burn = true;
          break;
        case 'Poisoning':
          poison = true;
          break;
        case 'Script':
          script = true;
          break;
        case 'Stroke':
          script = true;
          break;
        case 'Prem':
          prem = true;
          break;
        case 'Stemi':
          stemi = true;
          break;
        case 'Hanging':
          hang = true;
          break;
        case 'BitesStings':
          bite = true;
          break;
        case 'Drowning':
          drowning = true;
          break;
        default:
          break;
      }
    }

    dms = user?.directorate == 'DMS';
    dme = user?.directorate == 'DME';
    admin = user?.role == 'admin';
    stateAdmin = user?.role == 'state admin';
    districtAdmin = user?.role == 'district admin';
    dmeAdmin = user?.role == 'district DME';
    dmsAdmin = user?.role == 'district DMS';
    ghAdmin = user?.role == 'district GH';

    // After flags set, choose a sensible default selectedIndex
    // Priority: triage -> emo -> trauma -> burns -> script -> stemi -> prem -> poison -> admin
    if (triage && (dms || dme)) {
      selectedIndex.value = 0; // Transit Care / triage
    } else if (emo && (dms || dme)) {
      selectedIndex.value = 15;
    } else if (trauma && (dms || dme)) {
      selectedIndex.value = 4;
    } else if (burn && (dms || dme)) {
      selectedIndex.value = 5;
    } else if (script && (dms || dme && !prem)) {
      selectedIndex.value = 6;
    } else if (stemi && (dms || dme && !prem)) {
      selectedIndex.value = 12;
    } else if (prem && (dms || dme)) {
      selectedIndex.value = 7;
    } else if ((poison && dms) || (poison && dme && !prem)) {
      selectedIndex.value = 8;
    } else if (admin && dme) {
      selectedIndex.value = 16;
    } else if (stateAdmin) {
      selectedIndex.value = 16;
    } else if (districtAdmin) {
      selectedIndex.value = 16;
    } else if (dmeAdmin) {
      selectedIndex.value = 16;
    } else if (dmsAdmin) {
      selectedIndex.value = 16;
    } else if (ghAdmin) {
      selectedIndex.value = 16;
    } else {
      selectedIndex.value = 0;
    }
  }

  Widget _drawerHeader(bool isDesktop) => CustomDrawerHeader(
        trauma: trauma,
        emo: emo,
        burn: burn,
        script: script,
        stemi: stemi,
        prem: prem,
        triage: triage,
        dms: dms,
        dme: dme,
        hang: hang,
        admin: admin,
        stateAdmin: stateAdmin,
      );

  // Centralized drawer item builder for web/desktop //
  /// Old Desktop Drawer Item Builder
  /* Widget _drawerItemWeb(
      {required IconData icon, required String title, required int index}) {
    return Obx(() {
      bool isSelected = selectedIndex.value == index;
      return Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: InkWell(
          onTap: () => selectedIndex.value = index,
          hoverColor: Colors.redAccent.shade200,
          child: Material(
            color: isSelected ? Colors.redAccent : Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(icon,
                      color: isSelected ? Colors.grey.shade100 : Colors.white),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }*/
  Widget _drawerItemWeb({
    required IconData icon,
    required String title,
    required int index,
  }) {
    return Obx(() {
      bool isSelected = selectedIndex.value == index;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => selectedIndex.value = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          Colors.redAccent.shade400,
                          Colors.redAccent.shade200,
                        ],
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  // 🔥 Active Indicator Bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isSelected ? 4 : 0,
                    height: 28,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  Icon(
                    Icons.local_hospital,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey.shade300,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _modernExpansionTile() {
    return Obx(() {
      bool isExpanded = selectedIndex.value == 30;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            childrenPadding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            initiallyExpanded: true,
            collapsedBackgroundColor: Colors.transparent,
            backgroundColor: Colors.redAccent.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            iconColor: Colors.white,
            collapsedIconColor: Colors.grey.shade400,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'EMO Prem List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              _drawerItemWeb(
                icon: Icons.child_friendly_rounded,
                title: 'EMO Prem List',
                index: 30,
              ),
            ],
          ),
        ),
      );
    });
  }

  // Mobile/Drawer style item (ListTile)
  Widget _drawerItemMobile(
      {required IconData icon, required String title, required int index}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        selectedIndex.value = index;
        if (!context.isDesktop) Navigator.of(context).maybePop();
      },
    );
  }

  Widget _buildDrawerContent() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          _drawerHeader(false),
          if ((triage && dms) ||
              (triage && dme) ||
              (admin && dme) ||
              districtAdmin ||
              dmeAdmin ||
              dmsAdmin ||
              ghAdmin)
            ExpansionTile(
              initiallyExpanded: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: const Text('Pre-Hospital Care',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              children: [
                _drawerItemMobile(
                    icon: Icons.nature_outlined,
                    title: 'Transit Care',
                    index: 0),
              ],
            ),
          if (stateAdmin)
            ExpansionTile(
              initiallyExpanded: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: const Text('Pre-Hospital Care',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              children: [
                _drawerItemMobile(
                    icon: Icons.nature_outlined,
                    title: 'Transit Care',
                    index: 27),
              ],
            ),
          if ((triage && dms) ||
              (triage && dme) ||
              (emo && dms) ||
              (emo && dme) ||
              (trauma && dms) ||
              (trauma && dme) ||
              (burn && dms) ||
              (burn && dme) ||
              (script && dms) ||
              (script && dme) ||
              (prem && dms) ||
              (prem && dme) ||
              (stemi && dms) ||
              (stemi && dme) ||
              (poison && dms) ||
              (poison && dme))
            ExpansionTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              initiallyExpanded: true,
              title: const Text('In-Hospital Care',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              children: [
                if ((triage && dms) || (triage && dme)) ...[
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp,
                      title: 'Triage Nurse (Non 108)',
                      index: 1),
                  _drawerItemMobile(
                      icon: Icons.list, title: 'Triage Nurse (108)', index: 2),
                  _drawerItemMobile(
                      icon: Icons.list,
                      title: 'Triage Nurse + ED Line List',
                      index: 3),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    title: const Text('Triage Prem List',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    children: [
                      _drawerItemMobile(
                          icon: Icons.child_friendly,
                          title: 'Triage Prem List',
                          index: 29),
                    ],
                  ),
                ],
                if ((emo && dms) || (emo && dme)) ...[
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp,
                      title: 'EMO List',
                      index: 15),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    title: const Text('EMO Prem List',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    children: [
                      _drawerItemMobile(
                          icon: Icons.child_friendly,
                          title: 'EMO Prem List',
                          index: 30),
                    ],
                  ),
                ],
                if ((trauma && dms) || (trauma && dme))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp, title: 'Trauma', index: 4),
                if ((trauma && dms) || (trauma && dme))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp,
                      title: 'Trauma Save List',
                      index: 20),
                if ((burn && dms) || (burn && dme))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp, title: 'Burns', index: 5),
                if ((burn && dms) || (burn && dme))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp,
                      title: 'Burns Save List',
                      index: 21),
                if ((script && dms) || (script && dme && !prem))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp, title: 'Script', index: 6),
                if ((script && dms) || (script && dme && !prem))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp,
                      title: 'Script Save List',
                      index: 22),
                if ((prem && dms) || (prem && dme))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp, title: 'Prem', index: 7),
                if ((prem && dms) || (prem && dme))
                  _drawerItemMobile(
                      icon: Icons.add_chart_sharp,
                      title: 'Prem Save List',
                      index: 23),
                if ((poison && dms) || (poison && dme && !prem))
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    initiallyExpanded: true,
                    title: const Text('Poisoning Management',
                        style: TextStyle(color: Colors.black)),
                    children: [
                      _drawerItemMobile(
                          icon: Icons.add_chart_sharp,
                          title: 'Poisoning',
                          index: 8),
                      _drawerItemMobile(
                          icon: Icons.add_chart_sharp,
                          title: 'Poisoning Save List',
                          index: 24),
                      if ((bite && dms) || (bite && dme && !prem))
                        _drawerItemMobile(
                            icon: Icons.add_chart_sharp,
                            title: 'Bites & Stings',
                            index: 9),
                      if ((bite && dms) || (bite && dme && !prem))
                        _drawerItemMobile(
                            icon: Icons.add_chart_sharp,
                            title: 'Bites & Stings Save List',
                            index: 26),
                      if ((hang && dms) || (hang && dme && !prem))
                        _drawerItemMobile(
                            icon: Icons.add_chart_sharp,
                            title: 'Hanging',
                            index: 10),
                      if ((hang && dms) || (hang && dme && !prem))
                        _drawerItemMobile(
                            icon: Icons.add_chart_sharp,
                            title: 'Hanging Save List',
                            index: 25),
                      if ((drowning && dms) || (drowning && dme && !prem))
                        _drawerItemMobile(
                            icon: Icons.add_chart_sharp,
                            title: 'Drowning',
                            index: 11),
                    ],
                  ),
                if ((stemi && dms) || (stemi && dme && !prem))
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    initiallyExpanded: true,
                    title: const Text('MI/ACS',
                        style: TextStyle(color: Colors.black)),
                    children: [
                      _drawerItemMobile(
                          icon: Icons.add_chart_sharp,
                          title: 'MI/ACS List',
                          index: 12),
                      _drawerItemMobile(
                          icon: Icons.add_chart_sharp,
                          title: 'Cardiology OP Form',
                          index: 13),
                      _drawerItemMobile(
                          icon: Icons.add_chart_sharp,
                          title: 'Cardiology OP List',
                          index: 14),
                    ],
                  ),
              ],
            ),
          if ((admin && dme) ||
              (admin && dms) ||
              districtAdmin ||
              dmeAdmin ||
              dmsAdmin ||
              ghAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('Admin'),
              onTap: () => selectedIndex.value = 16,
            ),
          if ((admin && dme) ||
              (admin && dms) ||
              districtAdmin ||
              dmeAdmin ||
              dmsAdmin ||
              ghAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('KPI'),
              onTap: () => selectedIndex.value = 17,
            ),
          if ((admin && dme) ||
              (admin && dms) ||
              districtAdmin ||
              dmeAdmin ||
              dmsAdmin ||
              ghAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('TAEI Report'),
              onTap: () => selectedIndex.value = 18,
            ),
          if (stateAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('Admin'),
              onTap: () => selectedIndex.value = 16,
            ),
          if (stateAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('KPI'),
              onTap: () => selectedIndex.value = 17,
            ),
          if (stateAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('TAEI Report'),
              onTap: () => selectedIndex.value = 18,
            ),
          // TODO: if you dont need entry report please comment bleow code
          if (stateAdmin ||
              (admin && dme) ||
              (admin && dms) ||
              districtAdmin ||
              dmeAdmin ||
              dmsAdmin ||
              ghAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('Entry Report'),
              onTap: () => selectedIndex.value = 19,
            ),
          if (stateAdmin ||
              (admin && dme) ||
              (admin && dms) ||
              districtAdmin ||
              dmeAdmin ||
              dmsAdmin ||
              ghAdmin)
            ListTile(
              leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
              title: const Text('Download'),
              onTap: () => selectedIndex.value = 28,
            ),
          // if (stateAdmin || (admin && dme))
          //   ListTile(
          //     leading: const Icon(Icons.add_chart_sharp, color: Colors.black),
          //     title: const Text('Patient Report'),
          //     onTap: () => selectedIndex.value = 28,
          //   ),
        ],
      ),
    );
  }

  Widget _buildDrawerContentWeb() {
    return Container(
      color: myCustomColor,
      child: ListView(padding: EdgeInsets.zero, children: [
        _drawerHeader(true),
        if ((triage && dms) ||
            (triage && dme) ||
            (admin && dme) ||
            (admin && dms) ||
            districtAdmin ||
            dmeAdmin ||
            dmsAdmin ||
            ghAdmin)
          CommonDrawerExpansionTile(
            initiallyExpanded: true,
            title: 'Pre-Hospital Care',
            children: [
              _drawerItemWeb(
                  icon: Icons.nature_outlined, title: 'Transit Care', index: 0),
            ],
          ),

        if (stateAdmin)
          CommonDrawerExpansionTile(
            initiallyExpanded: true,
            title: 'Pre-Hospital Care',
            children: [
              _drawerItemWeb(
                  icon: Icons.nature_outlined,
                  title: 'Transit Care',
                  index: 27),
            ],
          ),

        // In-hospital
        if ((triage && dms) ||
            (triage && dme) ||
            (emo && dms) ||
            (emo && dme) ||
            (trauma && dms) ||
            (trauma && dme) ||
            (burn && dms) ||
            (burn && dme) ||
            (script && dms) ||
            (script && dme) ||
            (prem && dms) ||
            (prem && dme) ||
            (stemi && dms) ||
            (stemi && dme) ||
            (hang && dms) ||
            (hang && dme))
          CommonDrawerExpansionTile(
            initiallyExpanded: true,
            title: 'In-Hospital Care',
            children: [
              if ((triage && dms) || (triage && dme)) ...[
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp,
                    title: 'Triage Nurse (Non 108)',
                    index: 1),
                _drawerItemWeb(
                    icon: Icons.list, title: 'Triage Nurse (108)', index: 2),
                _drawerItemWeb(
                    icon: Icons.list,
                    title: 'Triage Nurse + ED Line List',
                    index: 3),
                CommonDrawerExpansionTile(
                  initiallyExpanded: true,
                  title: 'Triage Prem List',
                  children: [
                    _drawerItemWeb(
                        icon: Icons.child_friendly_rounded,
                        title: 'Triage Prem List',
                        index: 29),
                  ],
                ),
              ],
              if ((emo && dms) || (emo && dme)) ...[
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp, title: 'EMO List', index: 15),
                CommonDrawerExpansionTile(
                  initiallyExpanded: true,
                  title: 'EMO Prem List',
                  children: [
                    _drawerItemWeb(
                        icon: Icons.child_friendly_rounded,
                        title: 'EMO Prem List',
                        index: 30),
                  ],
                ),
              ],
              if ((trauma && dms) || (trauma && dme))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp, title: 'Trauma', index: 4),
              if ((trauma && dms) || (trauma && dme))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp,
                    title: 'Trauma Save List',
                    index: 20),
              if ((burn && dms) || (burn && dme))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp, title: 'Burns', index: 5),
              if ((burn && dms) || (burn && dme))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp,
                    title: 'Burns Save List',
                    index: 21),
              if ((script && dms) || (script && dme && !prem))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp, title: 'Script', index: 6),
              if ((script && dms) || (script && dme && !prem))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp,
                    title: 'Script Save List',
                    index: 22),
              if ((prem && dms) || (prem && dme))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp, title: 'Prem', index: 7),
              if ((prem && dms) || (prem && dme))
                _drawerItemWeb(
                    icon: Icons.add_chart_sharp,
                    title: 'Prem Save List',
                    index: 23),
              if ((poison && dms) || (poison && dme && !prem))
                CommonDrawerExpansionTile(
                  initiallyExpanded: true,
                  title: 'Poisoning Management',
                  children: [
                    _drawerItemWeb(
                        icon: Icons.add_chart_sharp,
                        title: 'Poisoning',
                        index: 8),
                    _drawerItemWeb(
                        icon: Icons.add_chart_sharp,
                        title: 'Poisoning Save List',
                        index: 24),
                    if ((bite && dms) || (bite && dme && !prem))
                      _drawerItemWeb(
                          icon: Icons.add_chart_sharp,
                          title: 'Bites & Stings',
                          index: 9),
                    if ((bite && dms) || (bite && dme && !prem))
                      _drawerItemWeb(
                          icon: Icons.add_chart_sharp,
                          title: 'Bites & Stings Save List',
                          index: 26),
                    if ((hang && dms) || (hang && dme && !prem))
                      _drawerItemWeb(
                          icon: Icons.add_chart_sharp,
                          title: 'Hanging',
                          index: 10),
                    if ((hang && dms) || (hang && dme && !prem))
                      _drawerItemWeb(
                          icon: Icons.add_chart_sharp,
                          title: 'Hanging Save List',
                          index: 25),
                    if ((drowning && dms) || (drowning && dme && !prem))
                      _drawerItemWeb(
                          icon: Icons.add_chart_sharp,
                          title: 'Drowning',
                          index: 11),
                      _drawerItemWeb(
                          icon: Icons.add_chart_sharp,
                          title: 'Save Drowning List',
                          index: 32),
                  ],
                ),
              if ((stemi && dms) || (stemi && dme && !prem))
                CommonDrawerExpansionTile(
                  initiallyExpanded: true,
                  title: 'MI/ACS',
                  children: [
                    _drawerItemWeb(
                        icon: Icons.add_chart_sharp,
                        title: 'MI/ACS List',
                        index: 12),
                    _drawerItemWeb(
                        icon: Icons.add_chart_sharp,
                        title: 'Save MI/ACS List',
                        index: 31),
                    CommonDrawerExpansionTile(
                      title: 'Cardiology OP',
                      children: [
                        _drawerItemWeb(
                            icon: Icons.add_chart_sharp,
                            title: 'Form',
                            index: 13),
                        _drawerItemWeb(
                            icon: Icons.add_chart_sharp,
                            title: 'OP List',
                            index: 14),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        if ((admin && dme) ||
            (admin && dms) ||
            districtAdmin ||
            dmeAdmin ||
            dmsAdmin ||
            ghAdmin)
          CommonDrawerExpansionTile(
            initiallyExpanded: true,
            title: 'Dashboard',
            children: [
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'Admin', index: 16),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'KPI', index: 17),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'TAEI Report', index: 18),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp,
                  title: 'Entry Report',
                  index: 19),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'Download', index: 28),

              // _drawerItemWeb(
              //     icon: Icons.add_chart_sharp,
              //     title: 'Patient Report',
              //     index: 28),
            ],
          ),
        // if ((admin && dme) || (admin && dms)) ...[
        //   _drawerItemWeb(
        //       icon: Icons.add_chart_sharp, title: 'Admin', index: 16),
        // ],
        if (stateAdmin)
          CommonDrawerExpansionTile(
            initiallyExpanded: true,
            title: 'Dashboard',
            children: [
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'Admin', index: 16),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'KPI', index: 17),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'TAEI Report', index: 18),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp,
                  title: 'Entry Report',
                  index: 19),
              _drawerItemWeb(
                  icon: Icons.add_chart_sharp, title: 'Download', index: 28),

              // _drawerItemWeb(
              //     icon: Icons.add_chart_sharp,
              //     title: 'Patient Report',
              //     index: 28),
            ],
          )
      ]),
    );
  }

  // Build central body according to selected index
  Widget _buildBody() {
    return Obx(() {
      switch (selectedIndex.value) {
        case 0:
          return TransitCarePage(isFromHome: true);
        case 1:
          return AddAccident(
            form: true,
            isUpdate: false,
            appbar: false,
          );
        case 2:
          return TriageCaseListPage(isFromHome: true);
        case 3:
          return TriageNurseList(
            appBar: false,
          );
        case 4:
          return TraumaListPage(appBar: false);
        case 5:
          return BurnListPage(appBar: false);
        case 6:
          return ScriptListPage(appBar: false);
        case 7:
          return PremListPage(appBar: false);
        case 8:
          return PoisonListPage(
            appBar: false,
          );
        case 9:
          return BitesListPage(
            appBar: false,
          );
        case 10:
          return HangingListPage(
            appBar: false,
          );
        case 11:
          return DrowningListPage(
            appBar: false,
              discharge:0
          );
        case 12:
          return StemiListPage(appBar: false, discharge:0);
        case 13:
          return StemiFormPage(create: true, appbar: false);
        case 14:
          return StemiListPageOp(
            appBar: false,
          );
        case 15:
          return EmoListPage(isFromHome: true);
        case 16:
          return InstitutionalDashboardPage();
        // return kpiDashboard();
        case 17:
          // return InstitutionalDashboardPage();
          return kpiDashboard();
        // return Container();
        case 18:
          return ReportDashboard();
        case 19:
          return EntryDashboardScreen();
        // return PatientReportScreen();
        case 20:
          return TraumaSaveListPage(appBar: false);
        case 21:
          return BurnsSaveListPage(appBar: false);
        case 22:
          return ScriptSaveListPage(appBar: false);
        case 23:
          return PremSaveListPage(appBar: false);
        case 24:
          return PoisonSaveListPage(appBar: false);
        case 25:
          return HangingSaveListPage(appBar: false);
        case 26:
          return BitesSaveListPage(appBar: false);
        case 27:
          return StateTransitCarePage(isFromHome: true);
        case 28:
          return TAEIReportDashboardPage();
        case 29:
          return TriageChildrenListPage(
            appBar: false,
          );
        case 30:
          return EmoPremChildrenList(
            isFromHome: true,
          );
        case 31:
          return StemiListPage(appBar: false, discharge:1);

        case 32:
          return DrowningListPage(
              appBar: false,
              discharge:1
          );

        // case 28:
        //   return PatientReportScreen();
        default:
          return Center(child: Text('No module access'));
      }
    });
  }

  String getHeaderTitle() {
    if (triage && (dms || dme)) return 'Triage Nurse';
    if (emo && (dms || dme)) return 'EMO';
    if (trauma && (dms || dme)) return 'TRAUMA CARE';
    if (burn && (dms || dme && !prem)) return 'BURNS MANAGEMENT';
    if (poison && hang && bite && (dms || dme && !prem))
      return 'POISON MANAGEMENT';
    if (script && (dms || dme && !prem)) return 'SCRIPT';
    if (prem && (dms || dme)) return 'PREM';
    if (stemi && (dms || dme && !prem)) return 'MI/ACS';
    if (admin && dme) return 'ADMIN';
    if (admin && dms) return 'ADMIN';
    return 'Transit Care';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth >= 800;
      return SafeArea(
        child: Scaffold(
          drawer: isDesktop
              ? null
              : Drawer(
                  width: context.isDesktop ? null : 250,
                  child: _buildDrawerContent()),
          body: isDesktop
              ? Row(
                  children: [
                    // Drawer
                    Container(width: 266, child: _buildDrawerContentWeb()),
                    Expanded(
                      child: Column(
                        children: [
                          // Header
                          /* Container(
                            height: 70,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE53935),
                                  Color(0xFFFF7043),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                districtAdmin || dmeAdmin || dmsAdmin || ghAdmin
                                    ? Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 320),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person,
                                                color: Colors.white, size: 18),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: districtAdmin ||
                                                      dmeAdmin ||
                                                      dmsAdmin ||
                                                      ghAdmin
                                                  ? Text(
                                                      "${loginController.userDetails.value?.user?.username}" ??
                                                          '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isDesktop ? 14 : 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      loginController
                                                              .userDetails
                                                              .value
                                                              ?.user
                                                              ?.hospital
                                                              ?.hospitalname ??
                                                          '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isDesktop ? 14 : 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),

                                /// 🟦 Title (Center)
                                Expanded(
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        indexKeys[selectedIndex.value] ??
                                            'TAEI',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: isDesktop ? 14 : 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// 🟦 Right Section
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// Hospital Name Chip
                                    ///

                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 320),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.local_hospital,
                                              color: Colors.white, size: 10),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: districtAdmin ||
                                                    dmeAdmin ||
                                                    dmsAdmin ||
                                                    ghAdmin
                                                ? Text(
                                                    "${loginController.userDetails.value?.user?.district?.name} District" ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isDesktop ? 10 : 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    loginController
                                                            .userDetails
                                                            .value
                                                            ?.user
                                                            ?.hospital
                                                            ?.hospitalname ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isDesktop ? 10 : 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    /// Logout Button
                                    InkWell(
                                      onTap: () => loginController.logout(),
                                      borderRadius: BorderRadius.circular(24),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.logout_rounded,
                                          color: Colors.redAccent,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                          Container(
                            height: 72,
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  // Colors.redAccent.shade400,
                                  // Colors.redAccent.shade200,
                                  Color(0xFFFF1744),
                                  Color(0xFFFF5252)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                /// 🔹 Left User Info
                                if (districtAdmin ||
                                    dmeAdmin ||
                                    dmsAdmin ||
                                    ghAdmin)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.white24,
                                          child: Icon(Icons.person,
                                              size: 14, color: Colors.white),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          loginController.userDetails.value
                                                  ?.user?.username ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                /// 🔹 Center Title
                                Expanded(
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        indexKeys[selectedIndex.value] ??
                                            'TAEI Dashboard',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// 🔹 Right Section
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// District / Hospital Chip
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.15),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 14, color: Colors.white70),
                                          const SizedBox(width: 6),
                                          Text(
                                            districtAdmin ||
                                                    dmeAdmin ||
                                                    dmsAdmin ||
                                                    ghAdmin
                                                ? "${loginController.userDetails.value?.user?.district?.name ?? ''} District"
                                                : loginController
                                                        .userDetails
                                                        .value
                                                        ?.user
                                                        ?.hospital
                                                        ?.hospitalname ??
                                                    '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 18),

                                    /// Logout Button
                                    InkWell(
                                      onTap: () => loginController.logout(),
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 6,
                                            )
                                          ],
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.logout_rounded,
                                                color: Color(0xFF053648),
                                                size: 16),
                                            SizedBox(width: 6),
                                            Text(
                                              "Logout",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF053648),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Body
                          Expanded(child: _buildBody()),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    if (isDesktop)
                      Container(
                          width: 256,
                          color: Colors.white,
                          child: _buildDrawerContentWeb()),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.redAccent,
                            height: 120,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                if (!isDesktop)
                                  Builder(
                                      builder: (context) => IconButton(
                                          icon: const Icon(Icons.menu,
                                              color: Colors.white),
                                          onPressed: () => Scaffold.of(context)
                                              .openDrawer())),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Column(
                                      children: [
                                        districtAdmin ||
                                                dmeAdmin ||
                                                dmsAdmin ||
                                                ghAdmin
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  districtAdmin ||
                                                          dmeAdmin ||
                                                          dmsAdmin ||
                                                          ghAdmin
                                                      ? Text(
                                                          "${loginController.userDetails.value?.user?.username}" ??
                                                              '',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  const CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: AssetImage(
                                                          'assets/logo/taei_logo.jpeg')),
                                                ],
                                              )
                                            : CircleAvatar(
                                                radius: 20,
                                                backgroundImage: AssetImage(
                                                    'assets/logo/taei_logo.jpeg')),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                overflow: TextOverflow.ellipsis,
                                                indexKeys[
                                                        selectedIndex.value] ??
                                                    'TAEI',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        districtAdmin ||
                                                dmeAdmin ||
                                                dmsAdmin ||
                                                ghAdmin
                                            ? Text(
                                                "${loginController.userDetails.value?.user?.district?.name} District" ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 14 : 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                loginController
                                                        .userDetails
                                                        .value
                                                        ?.user
                                                        ?.hospital
                                                        ?.hospitalname ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 14 : 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () => loginController.logout(),
                                    child: const CircleAvatar(
                                        backgroundColor: Colors.redAccent,
                                        radius: 16,
                                        backgroundImage: AssetImage(
                                            'assets/icons/logout.png'))),
                              ],
                            ),
                          ),
                          Expanded(child: _buildBody()),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}

class CustomDrawerHeader extends StatelessWidget {
  final bool trauma,
      burn,
      script,
      stemi,
      prem,
      triage,
      dms,
      dme,
      hang,
      emo,
      admin,
      stateAdmin;

  const CustomDrawerHeader(
      {super.key,
      required this.trauma,
      required this.emo,
      required this.burn,
      required this.script,
      required this.stemi,
      required this.prem,
      required this.triage,
      required this.dms,
      required this.dme,
      required this.hang,
      required this.admin,
      required this.stateAdmin});

  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;
  final Color myCustomColor = const Color(0xFF053648);

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktop(context);
    final role = trauma && burn && script && stemi && prem
        ? 'Doctor Login'
        : (triage && dms) || (triage && dme)
            ? 'Triage Nurse'
            : (emo && dms) || (emo && dme)
                ? 'EMO'
                : (trauma && dms) || (trauma && dme)
                    ? 'TRAUMA CARE'
                    : (burn && dms) || (burn && dme && !prem)
                        ? 'BURNS MANAGEMENT'
                        : (script && dms) || (script && dme && !prem)
                            ? 'SCRIPT'
                            : (hang && dms) || (hang && dme && !prem)
                                ? 'POISON MANAGEMENT'
                                : (stemi && dms) || (stemi && dme && !prem)
                                    ? 'MI/ACS'
                                    : (prem && dms) || (prem && dme)
                                        ? 'PREM'
                                        : (admin && dme)
                                            ? 'Admin'
                                            : (admin && dms)
                                                ? "Admin"
                                                : (stateAdmin)
                                                    ? 'State Admin'
                                                    : 'TAEI';

    return Container(
      height: isDesktop ? 130 : 150,
      color: myCustomColor,
      child: Padding(
        padding: context.isDesktop
            ? EdgeInsets.all(0.0)
            : EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: context.isDesktop
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: context.isDesktop
              ? MainAxisAlignment.center
              : MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: context.isDesktop ? 28 : 35,
                backgroundImage:
                    const AssetImage('assets/logo/taei_logo.jpeg')),
            const SizedBox(height: 10),
            Text(role,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.isDesktop ? 16 : 24)),
            //if (isDesktop) const Divider(color: Colors.white, thickness: 0.13),
          ],
        ),
      ),
    );
  }
}

class CommonDrawerExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const CommonDrawerExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          iconColor: Colors.white,
          collapsedIconColor: Colors.grey.shade400,
          initiallyExpanded: initiallyExpanded,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Row(
            children: [
              Icon(
                Icons.medical_services,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}
