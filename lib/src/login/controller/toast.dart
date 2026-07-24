import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {

  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: kIsWeb ? ToastGravity.BOTTOM : ToastGravity.BOTTOM,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "#4CAF50", // nice green for web
      webPosition: "center", // or "right"
    );
  }

  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: kIsWeb ? ToastGravity.BOTTOM : ToastGravity.BOTTOM,
      backgroundColor: Colors.red.shade600,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "#f44336", // red for web
      webPosition: "center", // or "right"
    );
  }

  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: kIsWeb ? ToastGravity.BOTTOM : ToastGravity.BOTTOM,
      backgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "#ff9800",
      webPosition: "center",
    );
  }
}
