import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/emo_user/view/emo_details_page.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_details_page.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? id;
  final bool? emo;

  const CommonAppBar({
    super.key,
    this.title,
    this.id,
    this.emo = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD32F2F),
            Color(0xFFE64A19)
          ], // Red → Orange gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // borderRadius: BorderRadius.vertical(
        //   bottom: Radius.circular(20),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: context.isDesktop
              ? EdgeInsets.symmetric(horizontal: 12)
              : EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              context.isDesktop
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      overflow: TextOverflow.visible,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //✅ Action buttons
              if (id != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      context,
                      label: "Triage",
                      icon: Icons.local_hospital_outlined,
                      onTap: () =>
                          Get.to(() => TriageDetailsPage(triageId: id!)),
                    ),
                    if (emo == true)
                      _buildActionButton(
                        context,
                        label: "EMO",
                        icon: Icons.monitor_heart_outlined,
                        onTap: () => Get.to(() => EmoDetailsPage(id: id!)),
                      ),
                  ],
                ),

              // if (id != null)
              //   _buildActionButton(
              //     context,
              //     label: "View",
              //     icon: Icons.local_hospital_outlined,
              //     onTap: () => Get.to(() => TriageEmoPillarsViewPage(
              //           triageId: id!,
              //           triage: true,
              //           from: 'Triage',
              //         )),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white24,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
