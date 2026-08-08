// import 'package:flutter/material.dart';
// import 'package:taei_gov/src/transit_care/view/transit_care_list_page.dart';
//
// class WebHomePage extends StatefulWidget {
//   const WebHomePage({super.key});
//
//   @override
//   State<WebHomePage> createState() => _WebHomePageState();
// }
//
// class _WebHomePageState extends State<WebHomePage> {
//   int _selectedIndex = 0;
//
//   final List<String> _titles = ['Triage', 'Trauma', 'Burns'];
//   final List<IconData> _icons = [
//     Icons.local_hospital,
//     Icons.healing,
//     Icons.fire_extinguisher
//   ];
//
//   final List<Widget> _pages = [
//     Center(
//         child: SizedBox(
//             child: TransitCarePage(
//       isFromHome: false,
//     ))),
//     Center(child: Text('Trauma Page', style: TextStyle(fontSize: 22))),
//     Center(child: Text('Burns Page', style: TextStyle(fontSize: 22))),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: Row(
//         children: [
//           // LEFT SIDE PANEL
//           Container(
//             width: 260,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(50),
//               ),
//               color: Colors.transparent,
//             ),
//             child: Column(
//               children: [
//                 // HEADER SECTION
//
//                 Container(
//                   height: 150,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFFD32F2F), Color(0xFFE64A19)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(14),
//                       bottomRight: Radius.circular(50),
//                     ),
//                   ),
//                   child: Row(
//                     children: const [
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.dashboard_customize,
//                             color: Colors.teal, size: 30),
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         'Care Modules',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // NAVIGATION MENU
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _titles.length,
//                     itemBuilder: (context, index) {
//                       final isSelected = _selectedIndex == index;
//                       return GestureDetector(
//                         onTap: () => setState(() => _selectedIndex = index),
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 14),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Colors.white.withOpacity(0.15)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 _icons[index],
//                                 color: isSelected
//                                     ? Colors.tealAccent
//                                     : Colors.white70,
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 _titles[index],
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: isSelected
//                                       ? Colors.tealAccent
//                                       : Colors.white70,
//                                   fontWeight: isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 // FOOTER (optional)
//                 const Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Text(
//                     'v1.0.0',
//                     style: TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // RIGHT SIDE CONTENT
//           Expanded(
//             child: Scaffold(
//               backgroundColor: Colors.grey.shade50,
//               appBar: PreferredSize(
//                 preferredSize: const Size.fromHeight(110),
//                 child: AppBar(
//                   backgroundColor: Colors.black,
//                   elevation: 3,
//                   title: Row(
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 25,
//                         decoration: BoxDecoration(
//                           color: Colors.teal,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         _titles[_selectedIndex],
//                         style: const TextStyle(
//                           color: Colors.teal,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     IconButton(
//                       icon: const Icon(Icons.notifications_outlined,
//                           color: Colors.teal),
//                       onPressed: () {},
//                     ),
//                     const CircleAvatar(
//                       backgroundColor: Colors.teal,
//                       child: Icon(Icons.person, color: Colors.white),
//                     ),
//                     const SizedBox(width: 16),
//                   ],
//                 ),
//               ),
//               body: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 400),
//                 child: _pages[_selectedIndex],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
