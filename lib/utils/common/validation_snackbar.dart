import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/responsive.dart';

class ValidationSnackbar extends StatelessWidget {
  final String message;

  const ValidationSnackbar({
    super.key,
    required this.message,
  });

  static void show(String message) {
    if (Get.isSnackbarOpen) Get.back();

    final context = Get.context!;
    final isDesktop = context.isDesktop;

    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 520,
        margin: EdgeInsets.only(
          bottom: 12,
          left: isDesktop ? MediaQuery.of(context).size.width / 1.5 : 12,
          right: 12,
        ),
        backgroundColor: Colors.transparent,
        // ✅ for custom container
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        shouldIconPulse: false,
        messageText: ValidationSnackbar(message: message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade900.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔔 Icon
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: isDesktop ? 26 : 22,
            ),
          ),
          const SizedBox(width: 10),

          // 📝 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Validation Error",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: isDesktop ? 15 : 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.95),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // ❌ Close
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/responsive.dart';

class ValidationSnackbar extends StatelessWidget {
  final String message;

  const ValidationSnackbar({
    super.key,
    required this.message,
  });

  static void show(String message) {
    if (Get.isSnackbarOpen) Get.back();

    Get.showSnackbar(
      GetSnackBar(
        titleText: const Text(
          "Validation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        messageText: ValidationSnackbar(message: message),
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 520,
        margin: EdgeInsets.only(
          bottom: 10,
          left: Get.context!.isDesktop
              ? MediaQuery.of(Get.context!).size.width / 1.5
              : 10,
          right: 10,
        ),
        backgroundColor: Colors.redAccent.shade200,
        borderRadius: 14,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        duration: const Duration(seconds: 4),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        shouldIconPulse: false,
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      // ✅ VERY IMPORTANT
      child: Text(
        message,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontSize: context.isDesktop ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.4,
        ),
      ),
    );
  }
}
*/
