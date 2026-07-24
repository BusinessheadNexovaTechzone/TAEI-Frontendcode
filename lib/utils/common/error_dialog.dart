import 'package:flutter/material.dart';

class CommonErrorDialog {
  static Future<void> show(
    BuildContext context, {
    String title = "Error",
    required String message,
    String buttonText = "OK",
    VoidCallback? onPressed,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text("Error"),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: onPressed ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
