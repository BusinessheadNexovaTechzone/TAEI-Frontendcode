import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taei_gov/src/responsive.dart';

/*class AvgStaySemiCircleWidget extends StatelessWidget {
  final String? title;
  final double avgStay;

  const AvgStaySemiCircleWidget({super.key, required this.avgStay, this.title});

  @override
  Widget build(BuildContext context) {
    final double normalized =
        (avgStay / 10).clamp(0.0, 1.0); // assume max 10 days
    final Color gaugeColor = Color.lerp(Colors.red, Colors.green, normalized)!;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            const SizedBox(height: 12),
            // 🔹 Semi-circular gauge
            CustomPaint(
              size: const Size(220, 110),
              painter: _SemiCirclePainter(
                progress: normalized,
                color: gaugeColor,
              ),
            ),

            // 🔹 Value text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  avgStay.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: gaugeColor,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 6),
                const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    "Days",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 Status Chip
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: gaugeColor.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Text(
            //     avgStay <= 2
            //         ? "🏆 Excellent – Short stays"
            //         : avgStay <= 5
            //             ? "😊 Stable – Average duration"
            //             : "⚠️ High – Extended stays",
            //     style: TextStyle(
            //       color: gaugeColor,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 13,
            //     ),
            //   ),
            // ),
            const Text(
              "Average Stay Duration",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _SemiCirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Draw base arc
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    canvas.drawArc(rect, pi, pi, false, basePaint);

    // Draw progress arc
    final double sweepAngle = pi * progress;
    canvas.drawArc(rect, pi, sweepAngle, false, progressPaint);

    // Add glow
    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height), radius: size.height))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(rect, pi, sweepAngle, false, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}*/

/// new Design
///
///
class AvgStaySemiCircleWidget extends StatelessWidget {
  final String? title;
  final double avgStay;

  const AvgStaySemiCircleWidget({super.key, required this.avgStay, this.title});

  @override
  Widget build(BuildContext context) {
    //final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isZero = avgStay <= 0;

    final Color color = isZero
        ? Colors.blueGrey
        : avgStay <= 2
            ? Colors.green
            : avgStay <= 5
                ? Colors.orange
                : Colors.redAccent;

    final String status = isZero
        ? "No inpatient stay recorded"
        : avgStay <= 2
            ? "Short stay"
            : avgStay <= 5
                ? "Normal duration"
                : "Extended stay";

    final String description = isZero
        ? "Patients were treated without admission"
        : "Average number of days patients stayed admitted";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: !context.isDesktop
          ? _mobileLayout(color, status, description)
          : _webLayout(color, status, description),
    );
  }

  Widget _webLayout(Color color, String status, String description) {
    return Row(
      children: [
        /// Metric
        _metricBlock(color, status),

        const SizedBox(width: 24),

        /// Divider
        Container(width: 1, height: 80, color: Colors.grey.shade300),

        const SizedBox(width: 24),

        /// Context
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileLayout(Color color, String status, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricBlock(color, status),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _metricBlock(Color color, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "AVG STAY",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              avgStay.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: color,
                height: 1,
              ),
            ),
            const SizedBox(width: 6),
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                "days",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),

        const SizedBox(height: 10),

        /// Visual Strip (works even for zero)
        Row(
          children: List.generate(
            12,
            (index) => Container(
              margin: const EdgeInsets.only(right: 4),
              width: 6,
              height: 10,
              decoration: BoxDecoration(
                color: index < (avgStay.clamp(0, 12))
                    ? color
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
