import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAppSnackbar({
  required String title,
  required String message,
  bool isError = false,
  bool isSuccess = false,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError
        ? const Color.fromARGB(255, 81, 81, 81)
        : isSuccess
            ? Colors.green.shade500
            : Theme.of(Get.context!).primaryColor,
    colorText: Colors.white,
    borderRadius: 25,
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 3),
    icon: Icon(
      isError
          ? Icons.error_outline
          : isSuccess
              ? Icons.check_circle_outline
              : Icons.info_outline,
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shouldIconPulse: true,
  );
}
