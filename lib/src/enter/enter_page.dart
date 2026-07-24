import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/enter/pillar_structure_screen.dart';
import 'package:taei_gov/src/login/view/login_page.dart';
import 'package:taei_gov/src/responsive.dart';
import '../../utils/helpers/space.dart';

class EntranceScreen extends StatelessWidget {
  const EntranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                /// new
                // Color(0xFFf26554),
                // Color(0xFFf79649),
                // Color(0xFFf79649),
                // Color(0xFFf79649),
                /////////////
                Color(0xFFffa394),
                Color(0xFFffc78e),

                // Color(0xFFF6D4CD),
                // Color(0xFFF6D4CD),
                // Color(0xFFCA8C8C),
                // Color(0xFFEAADAD),
                // Color(0xFFECB3B3),

                // Color(0xFFEDA94E),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            double maxWidth =
                constraints.maxWidth > 1200 ? 1200 : constraints.maxWidth;

            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    mainAxisAlignment: context.isDesktop
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      // Logos Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: context.isDesktop ? 40 : 30,
                            backgroundImage:
                                AssetImage('assets/logo/nhm_logo.png'),
                          ),
                          CircleAvatar(
                            radius: context.isDesktop ? 40 : 30,
                            backgroundImage:
                                AssetImage('assets/logo/tn_logo.png'),
                          ),
                          Image.asset(
                            'assets/logo/tnshp_logo.jpg',
                            width: context.isDesktop ? 80 : 60,
                            height: context.isDesktop ? 80 : 60,
                          ),
                        ],
                      ),
                      SizedBox(height: context.isDesktop ? 10 : 20),
                      Text(
                        'GOVERNMENT OF TAMIL NADU \n DEPARTMENT OF HEALTH AND FAMILY WELFARE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.isDesktop ? 22 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // if (context.isDesktop == false)
                      //   Text(
                      //     'DEPARTMENT OF HEALTH AND FAMILY WELFARE',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      SizedBox(height: context.isDesktop ? 10 : 20),
                      Text(
                        'TAMILNADU ACCIDENT AND EMERGENCY CARE INITIATIVE -TAEI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.isDesktop ? 22 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.isDesktop ? 10 : 20),
                      CircleAvatar(
                        radius: context.isDesktop ? 40 : 30,
                        backgroundImage:
                            const AssetImage('assets/logo/taei_logo.jpeg'),
                      ),
                      SizedBox(height: context.isDesktop ? 10 : 20),
                      PillarStructureScreen(),
                      // Pillars Image with clickable areas
                      // AspectRatio(
                      //   aspectRatio: !context.isDesktop ? 440 / 358 : 100 / 34,
                      //   child:
                      //       LayoutBuilder(builder: (context, stackConstraints) {
                      //     return Stack(
                      //       fit: StackFit.expand,
                      //       children: [
                      //         Image.asset(
                      //           'assets/pillars/Pillars_logo.png',
                      //           fit: BoxFit.contain,
                      //         ),
                      //         // Clickable areas scaled to Stack size
                      //         _clickableArea(
                      //             name: 'Stroke',
                      //             id: 1,
                      //             left: 0.05,
                      //             top: 0.60,
                      //             width: 0.12,
                      //             height: 0.30,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'MI STEMI/NSTEMI',
                      //             id: 2,
                      //             left: 0.20,
                      //             top: 0.60,
                      //             width: 0.12,
                      //             height: 0.30,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'Trauma',
                      //             id: 3,
                      //             left: 0.35,
                      //             top: 0.60,
                      //             width: 0.12,
                      //             height: 0.30,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'Burns',
                      //             id: 4,
                      //             left: 0.50,
                      //             top: 0.60,
                      //             width: 0.12,
                      //             height: 0.30,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'Poison',
                      //             id: 5,
                      //             left: 0.65,
                      //             top: 0.60,
                      //             width: 0.12,
                      //             height: 0.30,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'PREM',
                      //             id: 6,
                      //             left: 0.90,
                      //             top: 0.60,
                      //             width: 0.12,
                      //             height: 0.30,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'Triage Nurse',
                      //             id: 7,
                      //             left: 0.35,
                      //             top: 0.08,
                      //             width: 0.30,
                      //             height: 0.10,
                      //             stackConstraints: stackConstraints),
                      //         _clickableArea(
                      //             name: 'EMO',
                      //             id: 8,
                      //             left: 0.35,
                      //             top: 0.25,
                      //             width: 0.30,
                      //             height: 0.10,
                      //             stackConstraints: stackConstraints),
                      //       ],
                      //     );
                      //   }),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
