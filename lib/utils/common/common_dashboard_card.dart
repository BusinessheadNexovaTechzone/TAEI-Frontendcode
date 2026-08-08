import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:taei_gov/src/responsive.dart';

class CommonDashboardCard extends StatefulWidget {
  final String title;
  final dynamic value;
  final Color? color;
  final IconData? icon;

  const CommonDashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.color,
    this.icon,
  });

  @override
  State<CommonDashboardCard> createState() => _CommonDashboardCardState();
}

class _CommonDashboardCardState extends State<CommonDashboardCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.color ?? Colors.indigo;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 90,
        // 🔽 compact height
        width: 220,
        // 🔽 compact width
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -2.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(_hovered ? 0.22 : 0.12),
              blurRadius: _hovered ? 14 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 🔹 Soft glow (very subtle)
            Positioned(
              right: -30,
              top: -30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _hovered ? 0.12 : 0.06,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [accent, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon badge (smaller)
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.icon ?? Icons.analytics_outlined,
                    size: 18,
                    color: accent,
                  ),
                ),

                const SizedBox(width: 10),

                // Texts
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.value.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                          height: 1,
                        ),
                      ).animate().fadeIn(duration: 300.ms),
                    ],
                  ),
                ),
              ],
            ),

            // 🔹 Bottom accent rail (thin)
            Positioned(
              bottom: 0,
              left: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                width: _hovered ? 70 : 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.7),
                      Colors.red,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
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

/*class CommonDashboardCard extends StatefulWidget {
  final String title;
  final dynamic value;
  final Color? color; // optional accent color

  const CommonDashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  State<CommonDashboardCard> createState() => _CommonDashboardCardState();
}

class _CommonDashboardCardState extends State<CommonDashboardCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.color ?? Colors.blueAccent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 130,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? accent.withOpacity(0.3) : Colors.black12,
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: accent,
              width: 5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            // Animated number
            Row(
              children: [
                Text(
                  widget.value.toString(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    letterSpacing: 1.2,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(width: 6),
                const Text(
                  "",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            // Subtle gradient line animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: context.isDesktop ? 4 : 2,
              width: _isHovered ? 80 : 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.6), accent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
