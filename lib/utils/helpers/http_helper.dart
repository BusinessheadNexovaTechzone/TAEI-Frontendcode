import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taei_gov/constants/constant.dart';
import 'package:taei_gov/src/enter/enter_page.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_debug_logger.dart';
import 'package:taei_gov/utils/helpers/local_data_helper.dart';
import 'package:taei_gov/src/login/view/login_page.dart';
import 'package:flutter/foundation.dart';

class CustomHttpHelper extends http.BaseClient {
  final http.Client _httpClient = http.Client();

  static const _abhaUrlSegment = '/api/abha/';
  static const _sensitiveKeys = <String>{
    'aadhaar',
    'otp',
    'mobile',
    'txnId',
    'healthId',
    'hid',
    'password',
    'fingerPrintAuthPid',
    'pidXml',
    'loginId',
    'abhaNumber',
    'ABHANumber',
  };

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = LocalDataHelper.getString(Constant.token);

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final isAbhaRequest = _isAbhaRequest(request.url);
    _logRequest(request, isAbhaRequest: isAbhaRequest);

    final response = await _httpClient.send(request);
    final httpResponse = await http.Response.fromStream(response);

    _logResponse(httpResponse, request: request, isAbhaRequest: isAbhaRequest);

    if (httpResponse.statusCode == 401 || httpResponse.statusCode == 403) {
      AbhaDebugLogger.error('Token expired or unauthorized: ${httpResponse.statusCode}');
      LocalDataHelper.clearData();
      Get.offAll(() => const EntranceScreen());
    } else if (httpResponse.statusCode >= 500) {
      // Server error: leave for caller handling.
      AbhaDebugLogger.http('← ${httpResponse.statusCode} Server error received from ${request.url}');
    } else if (httpResponse.statusCode == 200) {
      AbhaDebugLogger.http('← ${httpResponse.statusCode} Response received from ${request.url}');
    }

    return http.StreamedResponse(
      Stream.value(httpResponse.bodyBytes),
      httpResponse.statusCode,
      headers: httpResponse.headers,
      reasonPhrase: httpResponse.reasonPhrase,
      request: request,
    );
  }

  bool _isAbhaRequest(Uri url) {
    final normalizedPath = url.path.toLowerCase();
    return normalizedPath.contains(_abhaUrlSegment);
  }

  void _logRequest(http.BaseRequest request, {required bool isAbhaRequest}) {
    final marker = isAbhaRequest ? '[ABHA HTTP Request]' : '[HTTP Request]';
    AbhaDebugLogger.http(marker);
    AbhaDebugLogger.http('METHOD: ${request.method}');
    AbhaDebugLogger.http('URL: ${request.url}');
    AbhaDebugLogger.http('HEADERS: ${_formatHeaders(request.headers, isAbhaRequest)}');

    if (request is http.Request && request.body.isNotEmpty) {
      final bodyToLog = _formatBody(request.body, isAbhaRequest);
      AbhaDebugLogger.http('BODY:\n$bodyToLog');
    }
  }

  void _logResponse(http.Response response,
      {required http.BaseRequest request, required bool isAbhaRequest}) {
    final marker = isAbhaRequest ? '[ABHA HTTP Response]' : '[HTTP Response]';
    AbhaDebugLogger.http(marker);
    AbhaDebugLogger.http('STATUS: ${response.statusCode}');
    AbhaDebugLogger.http('URL: ${request.url}');
    AbhaDebugLogger.http('HEADERS: ${_formatHeaders(response.headers, isAbhaRequest)}');

    if (response.body.isNotEmpty) {
      final bodyToLog = _formatBody(response.body, isAbhaRequest);
      AbhaDebugLogger.http('BODY:\n$bodyToLog');
    } else {
      AbhaDebugLogger.http('BODY: <empty>');
    }
  }

  Map<String, String> _formatHeaders(
      Map<String, String> headers, bool isAbhaRequest) {
    final formatted = Map<String, String>.from(headers);
    if (formatted.containsKey('Authorization')) {
      formatted['Authorization'] = 'Bearer ***';
    }
    if (isAbhaRequest && formatted.containsKey('Transaction_Id')) {
      formatted['Transaction_Id'] = '***';
    }
    return formatted;
  }

  String _formatBody(String body, bool isAbhaRequest) {
    try {
      final decoded = jsonDecode(body);
      final sanitized = _sanitizeJson(decoded, isAbhaRequest: isAbhaRequest);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(sanitized);
    } catch (_) {
      return body;
    }
  }

  dynamic _sanitizeJson(dynamic value, {required bool isAbhaRequest}) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(value.entries.map((entry) {
        final key = entry.key.toString();
        final rawValue = entry.value;
        return MapEntry(key, _sanitizeField(key, rawValue, isAbhaRequest));
      }));
    }
    if (value is List) {
      return value.map((item) => _sanitizeJson(item, isAbhaRequest: isAbhaRequest)).toList();
    }
    return value;
  }

  dynamic _sanitizeField(String key, dynamic value, bool isAbhaRequest) {
    final lowerKey = key.toLowerCase();
    if (!isAbhaRequest) {
      if (value is Map || value is List) {
        return _sanitizeJson(value, isAbhaRequest: false);
      }
      return value;
    }

    if (value is Map || value is List) {
      return _sanitizeJson(value, isAbhaRequest: true);
    }

    if (_sensitiveKeys.contains(key) ||
        _sensitiveKeys.any((sensitiveKey) => lowerKey.contains(sensitiveKey.toLowerCase()))) {
      final stringValue = value?.toString() ?? '';
      if (lowerKey.contains('otp')) {
        return _maskOtp(stringValue);
      }
      if (lowerKey.contains('aadhaar')) {
        return _maskValue(stringValue, visibleChars: 4);
      }
      if (lowerKey.contains('mobile')) {
        return _maskValue(stringValue, visibleChars: 3);
      }
      if (lowerKey.contains('txn')) {
        return _maskValue(stringValue, visibleChars: 5);
      }
      return _maskValue(stringValue, visibleChars: 4);
    }

    return value;
  }

  String _maskValue(String value, {int visibleChars = 4}) {
    if (value.isEmpty) return value;
    if (value.length <= visibleChars) return '*' * value.length;
    final prefix = '*' * (value.length - visibleChars);
    final suffix = value.substring(value.length - visibleChars);
    return '$prefix$suffix';
  }

  String _maskOtp(String value) {
    if (value.isEmpty) return value;
    return '*' * value.length;
  }

  // void _showToast(String message, {bool isError = false}) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: kIsWeb ? ToastGravity.TOP : ToastGravity.BOTTOM,
  //     backgroundColor:
  //     isError ? Colors.red.shade600 : Colors.green.shade600,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //     webBgColor: isError ? "#f44336" : "#4CAF50", // web color
  //     webPosition: "center",
  //   );
  // }
}
