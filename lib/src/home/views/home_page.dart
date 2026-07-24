/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/bite/views/bites_List.dart';
import 'package:taei_gov/src/burn/view/burns_list_page.dart';
import 'package:taei_gov/src/drowning/views/drowning_list.dart';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/view/emo_list_page.dart';
import 'package:taei_gov/src/hang/view/hang_list.dart';
import 'package:taei_gov/src/institutional_dashboard/view/institutional_dashboard_page.dart';
import 'package:taei_gov/src/kpidashborad/view/kpy_dashboard.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/create_triage_model.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_108_caselist_page.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_nurse_list.dart';
import 'package:taei_gov/src/poison/view/poison_list_page.dart';
import 'package:taei_gov/src/poison_bites_hang/view/poison_bites_hang_page.dart';
import 'package:taei_gov/src/report_dashboard/views/report_dashboard.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/script/views/script_list.dart';
import 'package:taei_gov/src/stemi/views/stemi_list_page.dart';
import 'package:taei_gov/src/transit_care/view/transit_care_list_page.dart';
import 'package:taei_gov/src/trauma/views/trauma_list_page.dart';
import '../../nurse_triage/views/add_accident.dart';
import '../../prem/view/prem_list_page.dart';
import '../../stemi/views/add_stemi.dart';
import '../../stemi/views/stemi_op.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({super.key});

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  //late TabController _tabController;

  final LoginController loginController = Get.find();
  final EmoController emoController = Get.put(EmoController());
  final NurseTriageController triageController =
      Get.put(NurseTriageController());

  // Module flags
  bool dms = true;
  bool dme = true;
  bool admin = false;
  bool stateAdmin = false;
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

  Color myCustomColor = Color(0xFF053648);

  @override
  void initState() {
    super.initState();
    loginController.checkUser();
    //_tabController = TabController(length: 3, vsync: this);
    //emoController.getEmoLookup();
    setModuleFlags();
  }

  void setModuleFlags() {
    final user = loginController.userDetails.value?.user;
    final perms = user?.permissions ?? [];

    for (var perm in perms) {
      if (perm.access != "write") continue;

      switch (perm.page) {
        case "Triage":
          triage = true;
          break;
        case "EmoTriage":
          emo = true;
          break;
        case "Trauma":
          trauma = true;
          break;
        case "Burns":
          burn = true;
          break;
        case "Poisoning":
          poison = true;
          break;
        case "Script":
          script = true;
          break;
        case "Stroke":
          script = true;
          break;
        case "Prem":
          prem = true;
          break;
        case "Stemi":
          stemi = true;
          break;
        case "Hanging":
          hang = true;
          break;
        case "BitesStings":
          bite = true;
          break;
        case "Drowning":
          drowning = true;
          break;
      }
    }

    // Set directorate flags
    dms = user?.directorate == "DMS";
    dme = user?.directorate == "DME";
    admin = user?.role == "admin";
    stateAdmin = user?.role == "state admin";
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  Widget _buildDrawerContent() {
    return Container(
      // width: MediaQuery.of(context).size.width >= 900 ? 80 : 8,
      color: Colors.white,
      child: ListView(
        children: [
          CustomDrawerHeader(
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
          ),
          if ((triage && dms) || (triage && dme))
            ExpansionTile(
              title: const Text(
                'Pre-Hospital Care',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              shape: const RoundedRectangleBorder(),
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.nature_outlined, color: Colors.black),
                  title: const Text('Transit Care'),
                  onTap: () => Get.to(() => TransitCarePage(isFromHome: true)),
                ),
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
              initiallyExpanded: true,
              title: const Text(
                'In-Hospital Care',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              shape: const RoundedRectangleBorder(),
              children: [
                if ((triage && dms) || (triage && dme)) ...[
                  ListTile(
                      leading: const Icon(Icons.add_chart_sharp,
                          color: Colors.black),
                      title: const Text('Triage Nurse (Non 108)'),
                      onTap: () {
                        triageController.currentIndex.value = 0;
                        Get.to(() => AddAccident(
                              form: true,
                              isUpdate: false,
                            ));
                      }),
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.black),
                    title: const Text('Triage Nurse (108)'),
                    onTap: () => Get.to(() => TriageCaseListPage()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.black),
                    title: const Text('Triage Nurse + ED Line List'),
                    onTap: () => Get.to(() => TriageNurseList()),
                  ),
                ],
                if ((emo && dms) || (emo && dme)) ...[
                  ListTile(
                    leading:
                        const Icon(Icons.add_chart_sharp, color: Colors.black),
                    title: const Text('EMO List'),
                    onTap: () => Get.to(() => EmoListPage()),
                  ),
                ],

                if ((trauma && dms) || (trauma && dme))
                  ListTile(
                    leading:
                        const Icon(Icons.add_chart_sharp, color: Colors.black),
                    title: const Text('Trauma'),
                    onTap: () => Get.to(() => TraumaListPage()),
                  ),

                // Burn Module
                if ((burn && dms) || (burn && dme))
                  ListTile(
                    leading:
                        const Icon(Icons.add_chart_sharp, color: Colors.black),
                    title: const Text('Burns'),
                    onTap: () => Get.to(() => BurnListPage()),
                  ),
                // Burn Module
                // Script Module
                if ((script && dms) || (script && dme && !prem))
                  ListTile(
                    leading:
                        const Icon(Icons.add_chart_sharp, color: Colors.black),
                    title: const Text('Script'),
                    onTap: () => Get.to(() => ScriptListPage()),
                  ),

                // Prem Module
                if ((prem && dms) || (prem && dme))
                  ListTile(
                    leading:
                        const Icon(Icons.add_chart_sharp, color: Colors.black),
                    title: const Text('Prem'),
                    onTap: () {
                      Get.to(() => PremListPage());
                    },
                  ),

                /// Poison Module
                if ((poison && dms) || (poison && dme && !prem))
                  ExpansionTile(
                    shape: const RoundedRectangleBorder(),
                    title: const Text('Poisoning Management'),
                    children: [
                      if ((poison && dms) || (poison && dme && !prem))
                        ListTile(
                          leading: const Icon(Icons.add_chart_sharp,
                              color: Colors.black),
                          title: const Text('Poisoning'),
                          onTap: () => Get.to(() => PoisonListPage()),
                        ),

                      /// Bites & Stings Module
                      if ((bite && dms) || (bite && dme && !prem))
                        ListTile(
                          leading: const Icon(Icons.add_chart_sharp,
                              color: Colors.black),
                          title: const Text('Bites & Stings'),
                          onTap: () => Get.to(() => BitesListPage()),
                        ),
                      if ((hang && dms) || (hang && dme && !prem))
                        ListTile(
                          leading: const Icon(Icons.add_chart_sharp,
                              color: Colors.black),
                          title: const Text('Hanging'),
                          onTap: () => Get.to(() => HangingListPage()),
                        ),
                      if ((drowning && dms) || (drowning && dme && !prem))
                        //if ((poison && dms) || (poison && dme && !prem))
                        ListTile(
                          leading: const Icon(Icons.add_chart_sharp,
                              color: Colors.black),
                          title: const Text('Drowning'),
                          onTap: () => Get.to(() => DrowningListPage()),
                        ),
                    ],
                  ),

                // // Prem Module
                // if ((prem && dms) || (prem && dme))
                //   ListTile(
                //     leading:
                //         const Icon(Icons.add_chart_sharp, color: Colors.black),
                //     title: const Text('Drowning'),
                //     onTap: () {
                //       Get.to(() => DrowningListPage());
                //     },
                //   ),
                if ((stemi && dms) || (stemi && dme && !prem))
                  ExpansionTile(
                    title: const Text('MI/ACS'),
                    shape: const RoundedRectangleBorder(),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add_chart_sharp,
                            color: Colors.black),
                        title: const Text('MI/ACS List'),
                        onTap: () => Get.to(() => StemiListPage()),
                      ),
                      if ((stemi && dms) || (stemi && dme && !prem))
                        ExpansionTile(
                          title: const Text('Cardiology OP'),
                          shape: const RoundedRectangleBorder(),
                          children: [
                            ListTile(
                              leading: const Icon(Icons.add_chart_sharp,
                                  color: Colors.black),
                              title: const Text('Form'),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StemiFormPage(
                                      create: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.add_chart_sharp,
                                  color: Colors.black),
                              title: const Text('OP List'),
                              onTap: () => Get.to(() => StemiListPageOp()),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),

          // // EMO Module
          // if ((emo && dms) || (emo && dme))
          //   ExpansionTile(
          //     title: const Text(
          //       'EMO',
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold),
          //     ),
          //     shape: const RoundedRectangleBorder(),
          //     children: [
          //       ListTile(
          //         leading:
          //             const Icon(Icons.add_chart_sharp, color: Colors.black),
          //         title: const Text('EMO-List'),
          //         onTap: () => Get.to(() => EmoListPage()),
          //       ),
          //     ],
          //   ),
          if (admin && dme)
            ExpansionTile(
              title: const Text(
                'Admin',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              shape: const RoundedRectangleBorder(),
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.add_chart_sharp, color: Colors.black),
                  title: const Text('Admin-List'),
                  onTap: () => Get.to(() => InstitutionalDashboardPage(
                        from: true,
                      )),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.add_chart_sharp, color: Colors.black),
                  title: const Text('KPI Dashboard'),
                  onTap: () => Get.to(() => kpiDashboard(
                        from: true,
                      )),
                  // onTap: () => Get.to(() => Container()),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.add_chart_sharp, color: Colors.black),
                  title: const Text('Report Dashboard'),
                  onTap: () => Get.to(() => ReportDashboard(
                        from: true,
                      )),
                ),
              ],
            ),
          if (stateAdmin)
            ExpansionTile(
              title: const Text(
                'State Admin',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              shape: const RoundedRectangleBorder(),
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.add_chart_sharp, color: Colors.black),
                  title: const Text('Admin-List'),
                  onTap: () => Get.to(() => InstitutionalDashboardPage(
                        from: true,
                      )),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.add_chart_sharp, color: Colors.black),
                  title: const Text('KPI Dashboard'),
                  onTap: () => Get.to(() => kpiDashboard(
                        from: true,
                      )),
                  // onTap: () => Get.to(() => Container()),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (triage && (dms || dme)) return TransitCarePage(isFromHome: true);
    if (emo && (dms || dme)) return EmoListPage(isFromHome: true);
    if (trauma && (dms || dme && !prem)) return TraumaListPage(appBar: false);
    if (burn && (dms || dme && !prem)) return BurnListPage(appBar: false);
    if (script && (dms || dme && !prem)) return ScriptListPage(appBar: false);
    if (stemi && (dms || dme && !prem)) return StemiListPage(appBar: false);
    if (prem && (dms || dme)) return PremListPage(appBar: false);
    if (poison && hang && bite && (dms || dme && !prem))
      return PoisonBitesHangPage();
    if (admin && dme) return InstitutionalDashboardPage();
    if (stateAdmin) return InstitutionalDashboardPage();
    return Center(child: Text("No module access"));
  }

  String getHeaderTitle() {
    if (triage && (dms || dme)) return "Triage Nurse";
    if (emo && (dms || dme)) return "EMO";
    if (trauma && (dms || dme)) return "Trauma Care";
    if (burn && (dms || dme && !prem)) return "Burns Management";
    if (poison && hang && bite && (dms || dme && !prem))
      return "Poisoning Management";
    if (script && (dms || dme && !prem)) return "SCRIPT";
    if (prem && (dms || dme)) return "PREM";
    if (stemi && (dms || dme && !prem)) return "MI/ACS";
    if (admin && dme) return "Institutional Dashboard";
    if (stateAdmin) return "Institutional Dashboard";
    return "Transit Care";
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
          body: context.isDesktop
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          // ✅ Header
                          Container(
                            height: 100,
                            color: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (!isDesktop)
                                  Builder(
                                    builder: (context) => IconButton(
                                      icon: const Icon(Icons.menu,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer(),
                                    ),
                                  ),
                                if (isDesktop) ...[
                                  Expanded(child: Container()),
                                ],
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      getHeaderTitle(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isDesktop ? 20 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Hospital name
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFA4C7C),
                                            Color(0xFFFF7A00)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                      child: Text(
                                        loginController.userDetails.value?.user
                                                ?.hospital?.hospitalname
                                                ?.toString() ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: isDesktop ? 18 : 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Logout button
                                    GestureDetector(
                                      onTap: () => loginController.logout(),
                                      child: CircleAvatar(
                                        backgroundColor: isDesktop
                                            ? Colors.white
                                            : Colors.redAccent,
                                        radius: 20,
                                        child: Icon(
                                          Icons.logout,
                                          color: isDesktop
                                              ? Colors.redAccent
                                              : Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ✅ Body content
                          Expanded(child: _buildBody()),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: Colors.redAccent,
                                height: 100,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    if (!isDesktop)
                                      Builder(
                                        builder: (context) => IconButton(
                                          icon: const Icon(Icons.menu,
                                              color: Colors.white),
                                          onPressed: () =>
                                              Scaffold.of(context).openDrawer(),
                                        ),
                                      ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getHeaderTitle(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(width: 10),
                                                if (!context.isDesktop)
                                                  const CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: AssetImage(
                                                        'assets/logo/taei_logo.jpeg'),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              loginController.userDetails.value!
                                                  .user!.hospital!.hospitalname
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
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
                                            'assets/icons/logout.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isDesktop) ...[
                                // DateFilterBar(),
                              ],
                            ],
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

  CustomDrawerHeader(
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
  Color myCustomColor = Color(0xFF053648);

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
                                            : (stateAdmin)
                                                ? 'State Admin'
                                                : 'TAEI';

    return Container(
      height: isDesktop ? 160 : 150,
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
              radius: isDesktop ? 40 : 35,
              backgroundImage: const AssetImage('assets/logo/taei_logo.jpeg'),
            ),
            const SizedBox(height: 10),
            Text(
              role,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: context.isDesktop ? 18 : 24,
              ),
            ),
            if (isDesktop)
              Divider(
                color: Colors.white,
                thickness: 0.13,
              )
          ],
        ),
      ),
    );
  }
}
*/
