import 'dart:convert';
import 'dart:developer';

import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class FingerprintService {
  static final _client = CustomHttpHelper();

  static Map<String, dynamic> _parseResponseBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return <String, dynamic>{'data': decoded};
    } catch (_) {
      return <String, dynamic>{'message': body, 'rawBody': body};
    }
  }

  static void _logApi({
    required String apiName,
    required String url,
    required String method,
    Object? requestBody,
    required int statusCode,
    Object? responseBody,
  }) {
    final success = statusCode == 200 || statusCode == 201;
    final logMap = {
      'apiName': apiName,
      'url': url,
      'method': method,
      'requestBody': requestBody ?? {},
      'statusCode': statusCode,
      'success': success,
      'responseBody': responseBody ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    };
    log(jsonEncode(logMap));
  }

  Future<Map<String, dynamic>?> captureFingerprint() async {
    final url = Urls.fingerprintCapture;
    log('Fingerprint capture URL: $url');

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final responseBody = _parseResponseBody(response.body);
      _logApi(
        apiName: 'captureFingerprint',
        url: url,
        method: 'POST',
        requestBody: null,
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      return responseBody;
    } catch (ex) {
      _logApi(
        apiName: 'captureFingerprint',
        url: url,
        method: 'POST',
        requestBody: null,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> enrollFingerprint({
    required String aadhaar,
    required String mobile,
    required String fingerPrintAuthPid,
  }) async {
    final url = Urls.biometricFingerprintEnroll;
    final requestBody = {
      'aadhaar': aadhaar,
      'mobile': mobile,
      'fingerPrintAuthPid': fingerPrintAuthPid,
    };

    log('Fingerprint enroll URL: $url');
    log('Fingerprint enroll request: $requestBody');

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final responseBody = _parseResponseBody(response.body);
      _logApi(
        apiName: 'enrollFingerprint',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      return responseBody;
    } catch (ex) {
      _logApi(
        apiName: 'enrollFingerprint',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return null;
    }
  }
}
