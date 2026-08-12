import 'package:flutter/foundation.dart';

class AbhaDebugLogger {
  static void separator() {
    debugPrint('============================================================');
  }

  static void section(String title, {String? flowId}) {
    separator();
    debugPrint('[ABHA]${_flowTag(flowId)} $title');
    separator();
  }

  static void log(String message, {String? flowId}) {
    debugPrint('[ABHA]${_flowTag(flowId)} $message');
  }

  static void ui(String message, {String? flowId}) {
    debugPrint('[ABHA][UI]${_flowTag(flowId)} $message');
  }

  static void controller(String message, {String? flowId}) {
    debugPrint('[ABHA][CONTROLLER]${_flowTag(flowId)} $message');
  }

  static void repository(String message, {String? flowId}) {
    debugPrint('[ABHA][REPOSITORY]${_flowTag(flowId)} $message');
  }

  static void http(String message, {String? flowId}) {
    debugPrint('[ABHA][HTTP]${_flowTag(flowId)} $message');
  }

  static void request({
    required String api,
    required String method,
    required String url,
    Map<String, dynamic>? data,
    String? flowId,
  }) {
    section('API REQUEST', flowId: flowId);
    debugPrint('[ABHA][REQUEST]${_flowTag(flowId)} API: $api');
    debugPrint('[ABHA][REQUEST]${_flowTag(flowId)} METHOD: $method');
    debugPrint('[ABHA][REQUEST]${_flowTag(flowId)} URL: $url');
    if (data != null && data.isNotEmpty) {
      debugPrint('[ABHA][REQUEST]${_flowTag(flowId)} DATA: $data');
    }
    separator();
  }

  static void response({
    required String api,
    int? statusCode,
    Map<String, dynamic>? data,
    String? flowId,
  }) {
    section('API RESPONSE', flowId: flowId);
    debugPrint('[ABHA][RESPONSE]${_flowTag(flowId)} API: $api');
    debugPrint('[ABHA][RESPONSE]${_flowTag(flowId)} STATUS: $statusCode');
    if (data != null) {
      debugPrint('[ABHA][RESPONSE]${_flowTag(flowId)} DATA: $data');
    } else {
      debugPrint('[ABHA][RESPONSE]${_flowTag(flowId)} DATA: <no data>');
    }
    separator();
  }

  static void workflow(String message, {String? flowId}) {
    debugPrint('[ABHA][WORKFLOW]${_flowTag(flowId)} $message');
  }

  static void error(String message, {String? flowId}) {
    debugPrint('[ABHA][ERROR]${_flowTag(flowId)} $message');
  }

  static void navigation(String message, {String? flowId}) {
    debugPrint('[ABHA][NAVIGATION]${_flowTag(flowId)} $message');
  }

  static void skip(String message, {String? flowId}) {
    debugPrint('[ABHA][SKIP]${_flowTag(flowId)} $message');
  }

  static void state(String message, {String? flowId}) {
    debugPrint('[ABHA][STATE]${_flowTag(flowId)} $message');
  }

  static Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};
    data.forEach((key, value) {
      sanitized[key] = _sanitizeField(key, value);
    });
    return sanitized;
  }

  static dynamic _sanitizeField(String key, dynamic value) {
    final lowerKey = key.toLowerCase();
    if (value is Map<String, dynamic>) {
      return sanitizeData(value);
    }
    if (value is List) {
      return value.map((e) {
        if (e is Map<String, dynamic>) {
          return sanitizeData(e);
        }
        return e;
      }).toList();
    }

    if (lowerKey.contains('otp') || lowerKey.contains('pin')) {
      return redact();
    }
    if (lowerKey.contains('token') || lowerKey.contains('jwt') || lowerKey.contains('refresh')) {
      return redact();
    }
    if (lowerKey.contains('aadhaar')) {
      final stringValue = value?.toString() ?? '';
      return maskMobile(stringValue, visibleChars: 4);
    }
    if (lowerKey.contains('mobile')) {
      final stringValue = value?.toString() ?? '';
      return maskMobile(stringValue, visibleChars: 4);
    }
    if (lowerKey.contains('txn')) {
      return redact();
    }
    if (lowerKey.contains('photo') || lowerKey.contains('base64')) {
      return '[REDACTED]';
    }

    return value;
  }

  static String maskMobile(String value, {int visibleChars = 4}) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= visibleChars) {
      return '*' * digits.length;
    }
    return '${'*' * (digits.length - visibleChars)}${digits.substring(digits.length - visibleChars)}';
  }

  static String redact() => '[REDACTED]';

  static String _flowTag(String? flowId) => flowId != null ? '[FLOW:$flowId]' : '';
}
