// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:taei_gov/src/bite/views/bites_List.dart';
// import 'package:taei_gov/src/burn/view/burns_list_page.dart';
// import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
// import 'package:taei_gov/src/emo_user/view/emo_list_page.dart';
// import 'package:taei_gov/src/hang/view/hang_form.dart';
// import 'package:taei_gov/src/hang/view/hang_list.dart';
// import 'package:taei_gov/src/login/controller/login_controller.dart';
// import 'package:taei_gov/src/nurse_triage/models/create_triage_model.dart';
// import 'package:taei_gov/src/nurse_triage/views/triage_108_caselist_page.dart';
// import 'package:taei_gov/src/nurse_triage/views/triage_nurse_list.dart';
// import 'package:taei_gov/src/poison/view/poison_list_page.dart';
// import 'package:taei_gov/src/poison_bites_hang/view/poison_bites_hang_page.dart';
// import 'package:taei_gov/src/responsive.dart';
// import 'package:taei_gov/src/script/views/script_list.dart';
// import 'package:taei_gov/src/stemi/views/stemi_list_page.dart';
// import 'package:taei_gov/src/transit_care/view/transit_care_list_page.dart';
// import 'package:taei_gov/src/trauma/views/trauma_list_page.dart';
// import '../../drowning/views/drowning_list.dart';
// import '../../enter/enter_page.dart';
// import '../../nurse_triage/views/add_accident.dart';
// import '../../prem/view/prem_form.dart';
// import '../../prem/view/prem_list_page.dart';
// import '../../stemi/views/add_stemi.dart';
// import '../../stemi/views/stemi_op.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   final LoginController loginController = Get.find();
//   final EmoController emoController = Get.put(EmoController());
//
//   // Module flags
//   bool dms = true;
//   bool dme = true;
//   bool triage = false;
//   bool trauma = false;
//   bool burn = false;
//   bool script = false;
//   bool stemi = false;
//   bool prem = false;
//   bool poison = false;
//   bool hang = false;
//   bool bite = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loginController.checkUser();
//     _tabController = TabController(length: 3, vsync: this);
//     emoController.getEmoLookup();
//     setModuleFlags();
//   }
//
//   void setModuleFlags() {
//     final user = loginController.userDetails.value?.user;
//     final perms = user?.permissions ?? [];
//
//     for (var perm in perms) {
//       if (perm.access != "write") continue;
//
//       switch (perm.page) {
//         case "Triage":
//           triage = true;
//           break;
//         case "Trauma":
//           trauma = true;
//           break;
//         case "Burns":
//           burn = true;
//           break;
//         case "Poisoning":
//           poison = true;
//           break;
//         case "Script":
//           script = true;
//           break;
//         case "Stroke":
//           script = true;
//           break;
//         case "Prem":
//           prem = true;
//           break;
//         case "Stemi":
//           stemi = true;
//           break;
//         case "Hanging":
//           hang = true;
//           break;
//         case "BitesStings":
//           bite = true;
//           break;
//       }
//     }
//
//     // Set directorate flags
//     dms = user?.directorate == "DMS";
//     dme = user?.directorate == "DME";
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Widget _buildDrawerContent() {
//     return Container(
//       // width: MediaQuery.of(context).size.width >= 900 ? 80 : 8,
//       color: Colors.white,
//       child: ListView(
//         children: [
//           CustomDrawerHeader(
//             trauma: trauma,
//             burn: burn,
//             script: script,
//             stemi: stemi,
//             prem: prem,
//             triage: triage,
//             dms: dms,
//             dme: dme,
//             hang: hang,
//           ),
//           if ((triage && dms) || (triage && dme))
//             ExpansionTile(
//               title: const Text(
//                 'Pre-Hospital Care',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               shape: const RoundedRectangleBorder(),
//               children: [
//                 ListTile(
//                   leading:
//                   const Icon(Icons.nature_outlined, color: Colors.black),
//                   title: const Text('Transit Care'),
//                   onTap: () => Get.to(() => TransitCarePage(isFromHome: true)),
//                 ),
//               ],
//             ),
//
//           if ((triage && dms) ||
//               (triage && dme) ||
//               (trauma && dms) ||
//               (trauma && dme) ||
//               (burn && dms) ||
//               (burn && dme) ||
//               (script && dms) ||
//               (script && dme) ||
//               (prem && dms) ||
//               (prem && dme) ||
//               (stemi && dms) ||
//               (stemi && dme) ||
//               (hang && dms) ||
//               (hang && dme))
//             ExpansionTile(
//               title: const Text(
//                 'In-Hospital Care',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               shape: const RoundedRectangleBorder(),
//               children: [
//                 if ((triage && dms) || (triage && dme)) ...[
//                   ListTile(
//                       leading: const Icon(Icons.add_chart_sharp,
//                           color: Colors.black),
//                       title: const Text('Triage Nurse (Non 108)'),
//                       onTap: () {
//                         TriageModel(
//                             triage: Triage(),
//                             triageBy108: TriageBy108(),
//                             triageDtls: TriageDtls());
//                         Get.to(() => AddAccident(form: true));
//                       }),
//                   ListTile(
//                     leading: const Icon(Icons.list, color: Colors.black),
//                     title: const Text('Triage Nurse (108)'),
//                     onTap: () => Get.to(() => TriageCaseListPage()),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.list, color: Colors.black),
//                     title: const Text('Triage Nurse + ED Line List'),
//                     onTap: () => Get.to(() => TriageNurseList()),
//                   ),
//                 ],
//
//                 if ((trauma && dms) || (trauma && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Trauma'),
//                     onTap: () => Get.to(() => TraumaListPage()),
//                   ),
//
//                 // Burn Module
//                 if ((burn && dms) || (burn && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Burns'),
//                     onTap: () => Get.to(() => BurnListPage()),
//                   ),
//                 // Burn Module
//                 /// Poison Module
//                 if ((poison && dms) || (poison && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Poisoning'),
//                     onTap: () => Get.to(() => PoisonListPage()),
//                   ),
//
//                 /// Bites & Stings Module
//                 if ((bite && dms) || (bite && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Bites & Stings'),
//                     onTap: () => Get.to(() => BitesListPage()),
//                   ),
//                 if ((hang && dms) || (hang && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Hanging'),
//                     onTap: () => Get.to(() => HangingListPage()),
//                   ),
//                 // Script Module
//                 if ((script && dms) || (script && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Script'),
//                     onTap: () => Get.to(() => ScriptListPage()),
//                   ),
//
//                 // Prem Module
//                 if ((prem && dms) || (prem && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Prem'),
//                     onTap: () => Get.to(() => PremListPage()),
//                   ),
//                 // Prem Module
//                 if ((prem && dms) || (prem && dme))
//                   ListTile(
//                     leading:
//                     const Icon(Icons.add_chart_sharp, color: Colors.black),
//                     title: const Text('Drowning'),
//                     onTap: () {
//                       Get.to(() => DrowningListPage());
//                     },
//                   ),
//                 if ((stemi && dms) || (stemi && dme))
//                   ExpansionTile(
//                     title: const Text('MI/ACS'),
//                     shape: const RoundedRectangleBorder(),
//                     children: [
//                       ListTile(
//                         leading: const Icon(Icons.add_chart_sharp,
//                             color: Colors.black),
//                         title: const Text('MI/ACS List'),
//                         onTap: () => Get.to(() => StemiListPage()),
//                       ),
//                     ],
//                   ),
//                 if ((stemi && dms) || (stemi && dme))
//                   ExpansionTile(
//                     title: const Text('Cardiology OP'),
//                     shape: const RoundedRectangleBorder(),
//                     children: [
//                       ListTile(
//                         leading: const Icon(Icons.add_chart_sharp,
//                             color: Colors.black),
//                         title: const Text('Form'),
//                         onTap: () async {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => StemiFormPage(
//                                 create: true,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.add_chart_sharp,
//                             color: Colors.black),
//                         title: const Text('OP List'),
//                         onTap: () => Get.to(() => StemiListPageOp()),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//
//           // EMO Module
//           if ((triage && dms) || (triage && dme))
//             ExpansionTile(
//               title: const Text(
//                 'EMO',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               shape: const RoundedRectangleBorder(),
//               children: [
//                 ListTile(
//                   leading:
//                   const Icon(Icons.add_chart_sharp, color: Colors.black),
//                   title: const Text('EMO-List'),
//                   onTap: () => Get.to(() => EmoListPage()),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     if (triage && (dms || dme)) return TransitCarePage(isFromHome: true);
//     if (trauma && (dms || dme)) return TraumaListPage(appBar: false);
//     if (burn && (dms || dme)) return BurnListPage(appBar: false);
//     if (script && (dms || dme)) return ScriptListPage(appBar: false);
//     if (stemi && (dms || dme)) return StemiListPage(appBar: false);
//     if (prem && (dms || dme)) return Center(child: Text("Prem Module"));
//     if (poison && hang && bite && (dms || dme)) return PoisonBitesHangPage();
//     return Center(child: Text("No module access"));
//   }
//
//   String getHeaderTitle() {
//     if (triage && (dms || dme)) return "Triage Nurse";
//     if (trauma && (dms || dme)) return "Trauma";
//     if (burn && (dms || dme)) return "Burns";
//     if (poison && hang && bite && (dms || dme)) return "Poison Bites Hang";
//     if (script && (dms || dme)) return "Script";
//     if (prem && (dms || dme)) return "Prem";
//     if (stemi && (dms || dme)) return "MI/ACS";
//
//     return "Transit Care";
//   }
//
//   Widget _buildDrawerContentWeb() {
//     RxInt selectedIndex = 0.obs;
//     Widget _drawerItem({
//       required IconData icon,
//       required String title,
//       required VoidCallback onTap,
//       required int index,
//     }) {
//       return Obx(() {
//         bool isSelected = selectedIndex.value == index;
//         return Material(
//           color: isSelected ? Colors.redAccent.shade200 : Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               selectedIndex.value = index;
//               onTap();
//             },
//             hoverColor: Colors.redAccent.shade200,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               child: Row(
//                 children: [
//                   Icon(icon,
//                       color: isSelected ? Colors.grey.shade100 : Colors.black),
//                   const SizedBox(width: 16),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontWeight:
//                       isSelected ? FontWeight.normal : FontWeight.normal,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       });
//     }
//
//     return Container(
//       color: Colors.white,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           CustomDrawerHeader(
//             trauma: trauma,
//             burn: burn,
//             script: script,
//             stemi: stemi,
//             prem: prem,
//             triage: triage,
//             dms: dms,
//             dme: dme,
//             hang: hang,
//           ),
//           // SizedBox(
//           //   height: 10,
//           // ),
//           // Pre-Hospital Care
//           if ((triage && dms) || (triage && dme))
//             _drawerItem(
//               icon: Icons.nature_outlined,
//               title: 'Transit Care',
//               onTap: () => Get.to(() => TransitCarePage(isFromHome: true)),
//               index: 0,
//             ),
//           // SizedBox(
//           //   height: 10,
//           // ),
//           // In-Hospital Care
//           if ((triage && dms) || (triage && dme))
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Triage Nurse (Non 108)',
//               onTap: () => Get.to(() => AddAccident(form: true)),
//               index: 1,
//             ),
//           // SizedBox(
//           //   height: 10,
//           // ),
//
//           if ((triage && dms) || (triage && dme)) ...[
//             _drawerItem(
//               icon: Icons.list,
//               title: 'Triage Nurse (108)',
//               onTap: () => Get.to(() => TriageCaseListPage()),
//               index: 2,
//             ),
//             SizedBox(
//               height: 1,
//             ),
//           ],
//
//           if ((trauma && dms) || (trauma && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Trauma',
//               onTap: () => Get.to(() => TraumaListPage()),
//               index: 3,
//             ),
//             SizedBox(
//               height: 2,
//             ),
//           ],
//
//           if ((burn && dms) || (burn && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Burns',
//               onTap: () => Get.to(() => BurnListPage()),
//               index: 4,
//             ),
//             SizedBox(
//               height: 6,
//             ),
//           ],
//
//           if ((script && dms) || (script && dme && !prem)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Script',
//               onTap: () => Get.to(() => ScriptListPage()),
//               index: 5,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//
//           if ((prem && dms) || (prem && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Prem Form',
//               // onTap: (){},
//               onTap: () => Get.to(() => PremFormPage()),
//               index: 6,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//
//           if ((prem && dms) || (prem && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Prem List',
//               // onTap: (){},
//               onTap: () => Get.to(() => PremListPage(appBar: true)),
//               index: 7,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//
//           if ((stemi && dms) || (stemi && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'MI/ACS List',
//               onTap: () => Get.to(() => StemiListPage()),
//               index: 8,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//
//           if ((stemi && dms) || (stemi && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Cardiology OP Form',
//               onTap: () => Get.to(() => StemiFormPage(create: true)),
//               index: 9,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//
//           if ((stemi && dms) || (stemi && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Cardiology OP List',
//               onTap: () => Get.to(() => StemiListPageOp()),
//               index: 10,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//
//           // EMO Module
//           if ((triage && dms) || (triage && dme)) ...[
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'EMO List',
//               onTap: () => Get.to(() => EmoListPage()),
//               index: 11,
//             ),
//           ],
//
//           if ((prem && dms) || (prem && dme))
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Bites and stings',
//               // onTap: (){},
//               onTap: () => Get.to(() => BitesListPage(appBar: true)),
//               index: 12,
//             ),
//           if ((prem && dms) || (prem && dme))
//             _drawerItem(
//               icon: Icons.add_chart_sharp,
//               title: 'Drowning',
//               onTap: () => Get.to(() => DrowningListPage(appBar: true)),
//               index: 13,
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       bool isDesktop = constraints.maxWidth >= 800;
//       return SafeArea(
//         child: Scaffold(
//           drawer: isDesktop
//               ? null
//               : Drawer(
//               width: context.isDesktop ? null : 250,
//               child: _buildDrawerContent()),
//           body: context.isDesktop
//               ? Row(
//             children: [
//               // Show drawer permanently only on desktop
//               if (isDesktop)
//                 Container(
//                   width: 256,
//                   color: Colors.white,
//                   child: _buildDrawerContentWeb(),
//                 ),
//
//               // Main content area
//               Expanded(
//                 child: Column(
//                   children: [
//                     // Header
//                     Container(
//                       height: 100,
//                       color: Colors.redAccent,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Show menu icon only on mobile/tablet
//                           if (!isDesktop)
//                             Builder(
//                               builder: (context) => IconButton(
//                                 icon: const Icon(Icons.menu,
//                                     color: Colors.white),
//                                 onPressed: () =>
//                                     Scaffold.of(context).openDrawer(),
//                               ),
//                             ),
//
//                           // Show date filter only on desktop
//                           if (isDesktop) ...[
//                             DateFilterBar(),
//                           ],
//
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 // Page Title
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 2),
//                                   child: Text(
//                                     getHeaderTitle(),
//                                     style: TextStyle(
//                                       fontSize:
//                                       !context.isDesktop ? 16 : 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: isDesktop ? 100 : 30),
//
//                                 // Hospital name
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12, vertical: 8),
//                                   decoration: const BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Color(0xFFFA4C7C),
//                                         Color(0xFFFF7A00)
//                                       ],
//                                       begin: Alignment.centerLeft,
//                                       end: Alignment.centerRight,
//                                     ),
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(6)),
//                                   ),
//                                   child: Text(
//                                     loginController.userDetails.value!
//                                         .user!.hospital!.hospitalname
//                                         .toString(),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                       fontSize:
//                                       !context.isDesktop ? 14 : 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//
//                                 const SizedBox(width: 20),
//
//                                 // Logout Button
//                                 GestureDetector(
//                                   onTap: loginController.logout,
//                                   child: CircleAvatar(
//                                     backgroundColor: isDesktop
//                                         ? Colors.white
//                                         : Colors.redAccent,
//                                     radius: 20,
//                                     child: Icon(
//                                       Icons.logout,
//                                       color: isDesktop
//                                           ? Colors.redAccent
//                                           : Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(child: _buildBody()),
//                   ],
//                 ),
//               ),
//             ],
//           )
//               : Row(
//             children: [
//               if (isDesktop)
//                 Container(
//                   width: 256,
//                   color: Colors.white,
//                   child: _buildDrawerContentWeb(),
//                 ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           color: Colors.redAccent,
//                           height: 100,
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                           child: Row(
//                             children: [
//                               if (!isDesktop)
//                                 Builder(
//                                   builder: (context) => IconButton(
//                                     icon: const Icon(Icons.menu,
//                                         color: Colors.white),
//                                     onPressed: () =>
//                                         Scaffold.of(context).openDrawer(),
//                                   ),
//                                 ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 16),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             getHeaderTitle(),
//                                             style: const TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight:
//                                                 FontWeight.bold,
//                                                 color: Colors.white),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           if (!context.isDesktop)
//                                             const CircleAvatar(
//                                               radius: 20,
//                                               backgroundImage: AssetImage(
//                                                   'assets/logo/taei_logo.jpeg'),
//                                             ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         loginController.userDetails.value!
//                                             .user!.hospital!.hospitalname
//                                             .toString(),
//                                         style: const TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () => loginController.logout(),
//                                 child: const CircleAvatar(
//                                   backgroundColor: Colors.redAccent,
//                                   radius: 16,
//                                   backgroundImage: AssetImage(
//                                       'assets/icons/logout.png'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (isDesktop) ...[
//                           DateFilterBar(),
//                         ],
//                       ],
//                     ),
//                     Expanded(child: _buildBody()),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
//
// class SidebarAppBarCurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.redAccent;
//
//     // Draw red AppBar background
//     Path path = Path();
//     path.moveTo(300, 0); // sidebar width
//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, 100);
//     path.lineTo(300, 100);
//
//     // Curve into sidebar
//     path.quadraticBezierTo(
//       250, 50, // control point
//       300, 0, // end point
//     );
//
//     path.close();
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// class CurvedLeftClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.moveTo(50, 0);
//     path.quadraticBezierTo(
//       0, size.height / 2, // control point
//       50, size.height, // end point of curve
//     );
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
//
// class CustomDrawerHeader extends StatelessWidget {
//   final bool trauma, burn, script, stemi, prem, triage, dms, dme, hang;
//
//   const CustomDrawerHeader(
//       {super.key,
//         required this.trauma,
//         required this.burn,
//         required this.script,
//         required this.stemi,
//         required this.prem,
//         required this.triage,
//         required this.dms,
//         required this.dme,
//         required this.hang});
//
//   bool _isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 900;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = _isDesktop(context);
//     final role = trauma && burn && script && stemi && prem
//         ? 'Doctor Login'
//         : (triage && dms) || (triage && dme)
//         ? 'Triage Nurse'
//         : (trauma && dms) || (trauma && dme)
//         ? 'Trauma'
//         : (burn && dms) || (burn && dme)
//         ? 'Burns'
//         : (script && dms) || (script && dme)
//         ? 'Script'
//         : (hang && dms) || (hang && dme)
//         ? 'Hanging'
//         : (stemi && dms) || (stemi && dme)
//         ? 'MI/ACS'
//         : (prem && dms) || (prem && dme)
//         ? 'Prem'
//         : 'TAEI';
//
//     return Container(
//       height: isDesktop ? 160 : 150,
//       color: Colors.redAccent,
//       child: Padding(
//         padding: context.isDesktop
//             ? EdgeInsets.all(0.0)
//             : EdgeInsets.only(left: 8.0),
//         child: Column(
//           crossAxisAlignment: context.isDesktop
//               ? CrossAxisAlignment.center
//               : CrossAxisAlignment.start,
//           mainAxisAlignment: context.isDesktop
//               ? MainAxisAlignment.center
//               : MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: isDesktop ? 40 : 35,
//               backgroundImage: const AssetImage('assets/logo/taei_logo.jpeg'),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               role,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DateFilterBar extends StatefulWidget {
//   const DateFilterBar({Key? key}) : super(key: key);
//
//   @override
//   State<DateFilterBar> createState() => _DateFilterBarState();
// }
//
// class _DateFilterBarState extends State<DateFilterBar> {
//   DateTime? startDate;
//   DateTime? endDate;
//
//   Future<void> _selectDate(BuildContext context, bool isStart) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startDate = picked;
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat('MM/dd/yyyy');
//     return Container(
//       width: 420,
//       height: 80,
//       margin: const EdgeInsets.only(top: 4),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           // Start Date
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _selectDate(context, true),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.calendar_today,
//                         color: Colors.black, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       startDate != null
//                           ? dateFormat.format(startDate!)
//                           : 'Start Date',
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//
//           // End Date
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _selectDate(context, false),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.calendar_today,
//                         color: Colors.black, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       endDate != null
//                           ? dateFormat.format(endDate!)
//                           : 'End Date',
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//
//           // Go Button
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//             ),
//             onPressed: () {
//               if (startDate != null && endDate != null) {
//                 debugPrint("Start: $startDate, End: $endDate");
//               }
//             },
//             child:
//             const Text("Go", style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class HospitalHeader extends StatelessWidget {
//   const HospitalHeader({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFFA4C7C), Color(0xFFFF7A00)], // pink → orange
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//       ),
//       child: Row(
//         children: [
//           // Profile Icon
//           Container(
//             width: 25,
//             height: 25,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white24,
//             ),
//             child: const Icon(
//               Icons.account_circle,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           const SizedBox(width: 10),
//
//           // Hospital Name
//           const Expanded(
//             child: Text(
//               "Government Tiruvannamalai Medical College Hospital",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 9,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
