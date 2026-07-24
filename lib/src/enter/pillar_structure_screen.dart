import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/responsive.dart';
import '../login/view/login_page.dart';

class PillarStructureScreen extends StatelessWidget {
  const PillarStructureScreen({super.key});

  // ✅ Auto-get username
  String _getUsername(String name) {
    switch (name) {
      case 'Triage Nurse':
        return 'Test_Triage_9901';
      //  return "admin_1";
      case 'EMO':
        return 'Test_Emo_9901';
      case 'Stroke':
        return 'Test_Script_9901';
      case 'MI STEMI/NSTEMI':
        return 'Test_Stemi_9901';
      case 'Trauma':
        return 'Test_Trauma_9901';
      case 'Burns':
        return 'Test_Burns_9901';
      case 'Poison':
        return 'Test_Poisoning_9901';
      case 'Prem':
        return 'Test_Prem_9901';
      case 'State - District - Admin':
        return 'TAEI_TNHSP1';
      default:
        return 'Unknown';
    }
  }

  // ✅ Auto-get password
  String _getPassword(String username) {
    switch (username) {
      case 'Test_Triage_9901':
        return '904296';
      case "admin_1":
        return "529326";
      case 'Test_Emo_9901':
        return '330271';
      case 'Test_Script_9901':
        return '538986';
      case 'Test_Stemi_9901':
        return '956007';
      case 'Test_Trauma_9901':
        return '653847';
      case 'Test_Burns_9901':
        return '334824';
      case 'Test_Poisoning_9901':
        return '378639';
      case 'Test_Prem_9901':
        return '633593';
      case 'TAEI_TNHSP1':
        return '486258';
      default:
        return '000000';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.isDesktop ? 500 : 600),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double baseWidth = 400;
            final double scale = constraints.maxWidth / baseWidth;

            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/outline_new.png',
                  width: constraints.maxWidth,
                  fit: BoxFit.contain,
                ),
                _part(
                  name: 'Triage Nurse',
                  assetPath: 'assets/images/Triage.png',
                  position: Offset(108 * scale, 16 * scale),
                  size: Size(180 * scale, 70 * scale),
                  id: 7,
                ),
                _part(
                  name: 'EMO',
                  assetPath: 'assets/images/Emo_Doctor.png',
                  position: Offset(48 * scale, 84 * scale),
                  size: Size(300 * scale, 90 * scale),
                  id: 8,
                ),
                _part(
                  name: 'Stroke',
                  assetPath: 'assets/images/Strock.png',
                  position: Offset(8 * scale, 138 * scale),
                  size: Size(62 * scale, 60 * scale),
                  id: 1,
                ),

                /// 🔹 MI STEMI/NSTEMI
                _part(
                  name: 'MI STEMI/NSTEMI',
                  assetPath: 'assets/images/Stemi.png',
                  position: Offset(72 * scale, 138 * scale),
                  size: Size(62 * scale, 60 * scale),
                  id: 2,
                ),

                /// 🔹 Trauma
                _part(
                  name: 'Trauma',
                  assetPath: 'assets/images/Trauma.png',
                  position: Offset(136 * scale, 138 * scale),
                  size: Size(62 * scale, 60 * scale),
                  id: 3,
                ),

                /// 🔹 Burns
                _part(
                  name: 'Burns',
                  assetPath: 'assets/images/Burns.png',
                  position: Offset(200 * scale, 138 * scale),
                  size: Size(62 * scale, 60 * scale),
                  id: 4,
                ),

                /// 🔹 Poison
                _part(
                  name: 'Poison',
                  assetPath: 'assets/images/Poison.png',
                  position: Offset(264 * scale, 138 * scale),
                  size: Size(62 * scale, 60 * scale),
                  id: 5,
                ),

                /// 🔹 Prem
                _part(
                  name: 'Prem',
                  assetPath: 'assets/images/Prem.png',
                  position: Offset(328 * scale, 138 * scale),
                  size: Size(62 * scale, 60 * scale),
                  id: 6,
                ),

                /// 🔹 State - District- Admin
                _part(
                  name: 'State - District - Admin',
                  assetPath: 'assets/images/admin.png',
                  // long banner image
                  position: Offset(8 * scale, 298 * scale),
                  size: Size(385 * scale, 150 * scale),
                  id: 9,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _part({
    required String name,
    required String assetPath,
    required Offset position,
    required Size size,
    required int id,
  }) {
    final username = _getUsername(name);
    final password = _getPassword(username);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: _HoverZoomImageWithLabel(
        name: name,
        imagePath: assetPath,
        size: size,
        onTap: () {
          Get.to(() => LoginPage(
                name: name,
                id: id,
                username: kDebugMode && kIsWeb ? username : "",
                password: kDebugMode && kIsWeb ? password : "",
              ));
        },
      ),
    );
  }
}

class _HoverZoomImageWithLabel extends StatefulWidget {
  final String imagePath;
  final String name;
  final Size size;
  final VoidCallback? onTap;

  const _HoverZoomImageWithLabel({
    required this.imagePath,
    required this.name,
    required this.size,
    this.onTap,
  });

  @override
  State<_HoverZoomImageWithLabel> createState() =>
      _HoverZoomImageWithLabelState();
}

class _HoverZoomImageWithLabelState extends State<_HoverZoomImageWithLabel> {
  bool _hovering = false;
  bool _pressed = false;
  Timer? _hoverTimer;

  void _showHoverLabel() {
    setState(() => _hovering = true);
    _hoverTimer?.cancel();
    _hoverTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _hovering = false);
    });
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHoveredOrPressed = _hovering || _pressed;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressed = true);
          _showHoverLabel();
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedScale(
              scale: isHoveredOrPressed ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Image.asset(
                widget.imagePath,
                width: widget.size.width,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: -20,
              child: AnimatedOpacity(
                opacity: _hovering ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
