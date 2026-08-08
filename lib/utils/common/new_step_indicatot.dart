import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewFancyStepIndicator extends StatelessWidget {
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

  /// Validation callback
  final bool Function(int currentStep, int tappedStep)? canMoveToStep;

  const NewFancyStepIndicator({
    Key? key,
    required this.currentIndex,
    required this.stepCount,
    this.titles,
    this.canMoveToStep,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
    this.connectorActiveColor = Colors.red,
    this.connectorInactiveColor = const Color(0xFFDDDDDD),
    this.dotSize = 32,
    this.connectorHeight = 4,
    this.tappable = true,
  })  : assert(titles == null || titles.length == stepCount,
            'titles length must match stepCount'),
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

                return _NewDot(
                  stepNumber: step + 1, // 👈 STEP NUMBER
                  size: dotSize,
                  isActive: isActive,
                  isDone: isDone,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: tappable
                      ? () {
                          final currentStep = currentIndex.value;

                          // Backward allowed
                          if (step <= currentStep) {
                            currentIndex.value = step;
                            return;
                          }

                          // Prevent skipping
                          if (step != currentStep + 1) return;

                          // Validation
                          if (canMoveToStep != null &&
                              !canMoveToStep!(currentStep, step)) {
                            return;
                          }

                          currentIndex.value = step;
                        }
                      : null,
                );
              } else {
                final leftStep = i ~/ 2;
                final isPassed = currentIndex.value > leftStep;

                return _NewConnector(
                  isActive: isPassed,
                  height: connectorHeight,
                  activeColor: connectorActiveColor,
                  inactiveColor: connectorInactiveColor,
                ).expanded();
              }
            }),
          ),
          if (titles != null) const SizedBox(height: 8),
          if (titles != null)
            Row(
              children: List.generate(stepCount * 2 - 1, (i) {
                if (i.isOdd) return const Spacer();
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

extension ExpandedWidget on Widget {
  Widget expanded() => Expanded(child: this);
}

class _NewDot extends StatelessWidget {
  final int stepNumber;
  final bool isActive;
  final bool isDone;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback? onTap;

  const _NewDot({
    required this.stepNumber,
    required this.isActive,
    required this.isDone,
    required this.size,
    required this.activeColor,
    required this.inactiveColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = inactiveColor;

    if (isDone) bgColor = activeColor;
    if (isActive) bgColor = activeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: isDone
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _NewConnector extends StatelessWidget {
  final bool isActive;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  const _NewConnector({
    required this.isActive,
    required this.height,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: isActive ? activeColor : inactiveColor,
    );
  }
}
