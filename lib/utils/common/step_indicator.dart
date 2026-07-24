import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepIndicator extends StatelessWidget {
  final RxInt currentIndex;
  final int stepCount;
  final Color activeColor;
  final Color inactiveColor;

  const StepIndicator({
    Key? key,
    required this.currentIndex,
    this.stepCount = 3,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(stepCount, (index) => _buildStep(index)),
    );
  }

  Widget _buildStep(int index) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor:
              currentIndex.value == index ? activeColor : inactiveColor,
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color:
                    currentIndex.value == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        if (index < stepCount - 1) const SizedBox(width: 16),
      ],
    );
  }
}

class LinearProgressSteps extends StatelessWidget {
  final RxInt currentIndex;
  final int stepCount;
  final Color fillColor;
  final Color bgColor;
  final double height;
  final BorderRadius radius;

  const LinearProgressSteps({
    Key? key,
    required this.currentIndex,
    required this.stepCount,
    this.fillColor = Colors.red,
    this.bgColor = const Color(0xFFE0E0E0),
    this.height = 8,
    this.radius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final percent = (currentIndex.value + 1) / stepCount;
      return Stack(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(color: bgColor, borderRadius: radius),
          ),
          FractionallySizedBox(
            widthFactor: percent.clamp(0.0, 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: height,
              decoration: BoxDecoration(color: fillColor, borderRadius: radius),
            ),
          ),
        ],
      );
    });
  }
}

class FancyStepIndicator extends StatelessWidget {
  final RxInt currentIndex;
  final int stepCount;
  final List<String>? titles;
  final Color activeColor;
  final Color inactiveColor;
  final Color connectorActiveColor;
  final Color connectorInactiveColor;
  final double dotSize;
  final double connectorHeight;
  final bool tappable;

  const FancyStepIndicator({
    Key? key,
    required this.currentIndex,
    required this.stepCount,
    this.titles,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
    this.connectorActiveColor = Colors.red,
    this.connectorInactiveColor = const Color(0xFFDDDDDD),
    this.dotSize = 32,
    this.connectorHeight = 4,
    this.tappable = true,
  })  : assert(titles == null || titles.length == stepCount,
            "titles length must match stepCount"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(stepCount * 2 - 1, (i) {
              final isDot = i.isEven;
              final step = i ~/ 2;

              if (isDot) {
                final isActive = currentIndex.value == step;
                final isDone = currentIndex.value > step;

                return _Dot(
                  index: step,
                  isActive: isActive,
                  isDone: isDone,
                  size: dotSize,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: tappable ? () => currentIndex.value = step : null,
                );
              } else {
                final leftStep = i ~/ 2;
                final isPassed = currentIndex.value > leftStep;
                return _Connector(
                  isActive: isPassed,
                  activeColor: connectorActiveColor,
                  inactiveColor: connectorInactiveColor,
                  height: connectorHeight,
                ).expanded();
              }
            }),
          ),
          if (titles != null) const SizedBox(height: 8),
          if (titles != null)
            Row(
              children: List.generate(stepCount * 2 - 1, (i) {
                if (i.isOdd) {
                  return const Spacer();
                }
                final step = i ~/ 2;
                final color =
                    step <= currentIndex.value ? activeColor : inactiveColor;
                return SizedBox(
                  width: dotSize,
                  child: Text(
                    titles![step],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: color),
                  ),
                );
              }),
            ),
        ],
      );
    });
  }
}

class _Dot extends StatelessWidget {
  final int index;
  final bool isActive;
  final bool isDone;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback? onTap;

  const _Dot({
    required this.index,
    required this.isActive,
    required this.isDone,
    required this.size,
    required this.activeColor,
    required this.inactiveColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isActive || isDone ? activeColor : inactiveColor;
    final fg = isActive || isDone ? Colors.white : Colors.black87;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isDone
              ? const Icon(Icons.check,
                  key: ValueKey('check'), size: 18, color: Colors.white)
              : Text(
                  '${index + 1}',
                  key: ValueKey(index),
                  style: TextStyle(
                    color: fg,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
        ),
      ),
    );

    return onTap == null
        ? child
        : GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: child,
          );
  }
}

class _Connector extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  const _Connector({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

// tiny helper
extension on Widget {
  Widget expanded() => Expanded(child: this);
}
