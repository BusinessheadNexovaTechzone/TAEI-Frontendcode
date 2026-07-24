import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A reusable chart widget that can visualize outcomes for
/// any model type (Burns, Trauma, Prem, Script, etc.)
///
/// You just need to provide:
/// - a list of data objects
/// - a function to extract the `name`
/// - a function to extract the `count`
class OutcomeGlassChart<T> extends StatelessWidget {
  final List<T> outcomes;
  final String Function(T item) getName;
  final int Function(T item) getCount;
  final String title;

  const OutcomeGlassChart({
    super.key,
    required this.outcomes,
    required this.getName,
    required this.getCount,
    this.title = "Outcome",
  });

  @override
  Widget build(BuildContext context) {
    final int maxValue = outcomes.isEmpty
        ? 0
        : outcomes.map((e) => getCount(e)).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Main Chart
          SizedBox(
            height: 280,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(outcomes.length, (index) {
                  final item = outcomes[index];
                  final String name = getName(item);
                  final int value = getCount(item);
                  final double ratio =
                      maxValue == 0 ? 0.0 : value.toDouble() / maxValue;

                  final Color color = _tileColors[index % _tileColors.length];

                  return Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 🔸 Rotated Label
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "  $name",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // 🔸 Bar & Value
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Value Chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Text(
                                "$value",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Bar Tile with Icon
                            AnimatedContainer(
                              color: color,
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeOutBack,
                              height: 130 + (80.0 * ratio),
                              width: 60,
                              child: Center(
                                child: Icon(
                                  _pickIcon(name),
                                  color: color,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          // 🔹 Base Line
          Container(
            height: 4,
            width: double.infinity,
            color: Colors.black87,
          ),

          // 🔹 Title
          const SizedBox(height: 28),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

/// Common color palette for bar tiles
final List<Color> _tileColors = [
  Colors.teal,
  Colors.deepOrange,
  Colors.indigo,
  Colors.pink,
  Colors.green,
  Colors.blueGrey,
];

/// Icon logic by outcome name
IconData _pickIcon(String name) {
  name = name.toLowerCase();
  if (name.contains("death")) return Icons.heart_broken;
  if (name.contains("icu")) return Icons.monitor_heart;
  if (name.contains("ward")) return Icons.bed;
  if (name.contains("transferred")) return Icons.local_hospital;
  if (name.contains("op")) return Icons.medical_services;
  if (name.contains("discharge")) return Icons.assignment_turned_in;
  return Icons.analytics;
}

/// Generic animated horizontal bar chart widget for outcomes.
///
/// You can use it with any model type — Burns, Trauma, Prem, Script, etc.
/// Just provide a list and two extractors:
///
/// Example:
/// ```dart
/// OutcomeBarView<BurnsInstitutionOutcome>(
///   outcomes: burnsList,
///   getName: (e) => e.name ?? '',
///   getCount: (e) => e.totalCount ?? 0,
///   title: "Burns Outcomes",
/// )
/// ```
class CommonOutcomeBarView<T> extends StatefulWidget {
  final List<T> outcomes;
  final String Function(T) getName;
  final int Function(T) getCount;
  final String title;

  const CommonOutcomeBarView({
    super.key,
    required this.outcomes,
    required this.getName,
    required this.getCount,
    this.title = "Outcomes Overview",
  });

  @override
  State<CommonOutcomeBarView<T>> createState() =>
      _CommonOutcomeBarViewState<T>();
}

class _CommonOutcomeBarViewState<T> extends State<CommonOutcomeBarView<T>> {
  final List<IconData> outcomeIcons = [
    Icons.home_rounded,
    Icons.exit_to_app_rounded,
    Icons.report_problem_rounded,
    Icons.directions_run_rounded,
    Icons.heart_broken_rounded,
    Icons.local_hospital_rounded,
    Icons.medical_services_rounded,
    Icons.health_and_safety_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final int maxValue = widget.outcomes.isNotEmpty
        ? widget.outcomes
            .map((e) => widget.getCount(e))
            .reduce((a, b) => a > b ? a : b)
        : 0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Card(
          elevation: 12,
          shadowColor: Colors.blueGrey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Title Header with Accent
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      " ${widget.title}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 🔹 Animated Bars
                ...widget.outcomes.mapIndexed((index, item) {
                  final double ratio = maxValue == 0
                      ? 0
                      : widget.getCount(item).toDouble() / maxValue.toDouble();
                  final colorStart = Colors
                      .primaries[index % Colors.primaries.length].shade400;
                  final colorEnd = Colors
                      .primaries[index % Colors.primaries.length].shade700;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          child: Row(
                            children: [
                              // 🔸 Icon
                              Icon(
                                outcomeIcons[index % outcomeIcons.length],
                                color: colorEnd,
                                size: 26,
                              ),
                              const SizedBox(width: 14),

                              // 🔸 Label
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.getName(item),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // 🔸 Animated Bar
                              Expanded(
                                flex: 5,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 800),
                                      curve: Curves.easeInOutBack,
                                      height: 26,
                                      width: (400 * ratio)
                                          .clamp(0, 400)
                                          .toDouble(),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [colorStart, colorEnd],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorEnd.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                    ).animate().fadeIn(
                                          delay: (index * 80).ms,
                                          duration: 400.ms,
                                        ),

                                    // Value Label (Right-Aligned)
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            widget.getCount(item).toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().slide(
                            begin: const Offset(-0.2, 0),
                            end: Offset.zero,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 Helper Extension (like Kotlin mapIndexed)
extension IterableX<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}

///
/// ////////////////////////////
/// New FLow Chart Design ///////////////////
///
///
///
///

class OutcomeVerticalFlowChart<T> extends StatelessWidget {
  final List<T> outcomes;
  final String Function(T item) getName;
  final int Function(T item) getCount;
  final String title;

  OutcomeVerticalFlowChart({
    super.key,
    required this.outcomes,
    required this.getName,
    required this.getCount,
    this.title = "Outcome Flow",
  });

  @override
  Widget build(BuildContext context) {
    final int maxValue = outcomes.isEmpty
        ? 1
        : outcomes.map((e) => getCount(e)).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          /// Flow List
          Column(
            children: List.generate(outcomes.length, (index) {
              final item = outcomes[index];
              final name = getName(item);
              final value = getCount(item);
              final ratio = value / maxValue;
              final color = _flowColors[index % _flowColors.length];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Left Flow Line + Dot
                  Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (index != outcomes.length - 1)
                        Container(
                          width: 2,
                          height: 42,
                          color: color.withOpacity(0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  /// Card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name + Icon + Count
                          Row(
                            children: [
                              Icon(
                                _pickIcon(name),
                                size: 18,
                                color: color,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "$value",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// Mini Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeOut,
                              height: 6,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: ratio.clamp(0.0, 1.0),
                                child: Container(color: color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  final List<Color> _flowColors = [
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
    Colors.green,
    Colors.pink,
    Colors.blueGrey,
  ];
}

///
///
///...............................//////
///
///

class OutcomeRadarChart<T> extends StatelessWidget {
  final List<T> outcomes;
  final String Function(T item) getName;
  final int Function(T item) getCount;
  final String title;

  const OutcomeRadarChart({
    super.key,
    required this.outcomes,
    required this.getName,
    required this.getCount,
    this.title = "Outcome Distribution",
  });

  @override
  Widget build(BuildContext context) {
    final counts = outcomes.map((e) => getCount(e)).toList();
    final int maxValue =
        counts.isEmpty ? 1 : counts.reduce((a, b) => a > b ? a : b);

    final int total = counts.fold(0, (sum, item) => sum + item);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade50,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Total: $total",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          /// Radar Chart
          SizedBox(
            height: 240,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                gridBorderData: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                radarBorderData: BorderSide(
                  color: Colors.grey.shade400,
                ),
                titleTextStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                getTitle: (index, angle) {
                  return RadarChartTitle(
                    text: _shortName(getName(outcomes[index])),
                  );
                },
                dataSets: [
                  /// Light background reference
                  RadarDataSet(
                    fillColor: Colors.teal.withOpacity(0.05),
                    borderColor: Colors.teal.withOpacity(0.15),
                    borderWidth: 1,
                    dataEntries: List.generate(
                      outcomes.length,
                      (_) => RadarEntry(value: maxValue.toDouble()),
                    ),
                  ),

                  /// Main dataset
                  RadarDataSet(
                    fillColor: Colors.teal.withOpacity(0.35),
                    borderColor: Colors.teal,
                    borderWidth: 2.5,
                    entryRadius: 4,
                    dataEntries: outcomes
                        .map((e) => RadarEntry(
                              value: getCount(e).toDouble(),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// Modern Legend
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: outcomes.map((e) {
              final value = getCount(e);

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${_shortName(getName(e))}: $value",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _shortName(String name) {
    if (name.length <= 10) return name;
    return name.split(" ").take(2).join(" ");
  }
}

/// Try
///

class OutcomeCompactControlPanel<T> extends StatelessWidget {
  final List<T> outcomes;
  final String Function(T item) getName;
  final int Function(T item) getCount;
  final String title;

  const OutcomeCompactControlPanel({
    super.key,
    required this.outcomes,
    required this.getName,
    required this.getCount,
    this.title = "Outcome Summary",
  });

  @override
  Widget build(BuildContext context) {
    if (outcomes.isEmpty) {
      return const Center(child: Text("No data"));
    }

    final total = outcomes.fold<int>(0, (sum, e) => sum + getCount(e));

    final sorted = [...outcomes]
      ..sort((a, b) => getCount(b).compareTo(getCount(a)));

    final maxValue =
        sorted.map((e) => getCount(e)).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          ...sorted.map((item) {
            final name = getName(item);
            final value = getCount(item);
            final percent = total == 0 ? 0 : (value / total * 100);

            final ratio = maxValue == 0 ? 0 : value / maxValue;

            final isCritical = name.toLowerCase().contains("death") ||
                name.toLowerCase().contains("icu");

            final color = isCritical ? Colors.redAccent : Colors.tealAccent;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  /// Vertical indicator
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// Count
                  SizedBox(
                    width: 40,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  /// Name
                  Expanded(
                    flex: 3,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  /// Percentage
                  SizedBox(
                    width: 50,
                    child: Text(
                      "${percent.toStringAsFixed(0)}%",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// Mini bar
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: ratio.toDouble(),
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
