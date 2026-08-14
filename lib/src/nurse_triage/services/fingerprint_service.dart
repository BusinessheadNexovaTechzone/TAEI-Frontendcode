import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class FingerprintService {
  static final _client = CustomHttpHelper();
  static final _httpClient = http.Client();

  // Mantra RD Service configuration
  static const String _mantraBaseUrl = 'http://127.0.0.1:11100';
  static const String _rdServicePath = '/';
  static const String _deviceInfoPath = '/rd/info';
  static const String _captureApiPath = '/rd/capture';

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

  // Mantra RD Service Discovery
  Future<bool> getServiceInfo() async {
    final url = _mantraBaseUrl + _rdServicePath;
    log('[MANTRA] RDSERVICE START');
    log('[MANTRA] RDSERVICE METHOD: RDSERVICE');
    log('[MANTRA] RDSERVICE URL: $url');

    try {
      final request = http.Request('RDSERVICE', Uri.parse(url));
      request.headers['Accept'] = 'text/xml';

      final streamedResponse = await request.send().timeout(const Duration(seconds: 5));
      final response = await http.Response.fromStream(streamedResponse);

      log('[MANTRA] RDSERVICE STATUS: ${response.statusCode}');
      log('[MANTRA] RDSERVICE RESPONSE:\n${response.body}');

      if (response.statusCode == 200) {
        final isReady = response.body.contains('status="READY"') &&
            response.body.contains('<RDService');
        
        if (isReady) {
          log('[MANTRA] RDSERVICE available and ready');
          return true;
        } else {
          log('[MANTRA] RDSERVICE responded but not ready');
          return false;
        }
      }

      log('[MANTRA] RDSERVICE unavailable - HTTP ${response.statusCode}');
      return false;
    } catch (ex) {
      log('[MANTRA] RDSERVICE error: $ex');
      return false;
    }
  }

  // Get Mantra Device Information
  Future<Map<String, dynamic>?> getDeviceInfo() async {
    final url = _mantraBaseUrl + _deviceInfoPath;
    log('[MANTRA] DEVICEINFO START');
    log('[MANTRA] DEVICEINFO METHOD: DEVICEINFO');
    log('[MANTRA] DEVICEINFO URL: $url');

    try {
      final request = http.Request('DEVICEINFO', Uri.parse(url));
      request.headers['Accept'] = 'text/xml';

      final streamedResponse = await request.send().timeout(const Duration(seconds: 5));
      final response = await http.Response.fromStream(streamedResponse);

      log('[MANTRA] DEVICEINFO STATUS: ${response.statusCode}');
      log('[MANTRA] DEVICEINFO RESPONSE:\n${response.body}');

      if (response.statusCode == 200) {
        // Verify device is MFS110
        final isMFS110 = response.body.contains('mi="MFS110"');
        final hasDeviceInfo = response.body.contains('<DeviceInfo');
        
        if (isMFS110 && hasDeviceInfo) {
          log('[MANTRA] MFS110 device detected and ready');
          return {
            'success': true,
            'deviceType': 'MFS110',
            'response': response.body,
          };
        } else {
          log('[MANTRA] Device info received but MFS110 not detected');
          return {
            'success': false,
            'error': 'Mantra MFS110 device not properly detected',
            'response': response.body,
          };
        }
      }

      log('[MANTRA] Failed to get device info - HTTP ${response.statusCode}');
      return {
        'success': false,
        'error': 'Unable to communicate with Mantra MFS110 device.',
      };
    } catch (ex) {
      log('[MANTRA] DEVICEINFO error: $ex');
      final errorMsg = ex.toString().contains('TimeoutException')
          ? 'Device communication timed out. Please check the device connection.'
          : 'Unable to communicate with Mantra MFS110 device.';
      return {
        'success': false,
        'error': errorMsg,
      };
    }
  }

  // Generate WADH (Work Around Data Hash)
  String _generateWadh() {
    const ra = 'F';
    const rc = 'Y';
    const lr = 'Y';
    const de = 'N';
    const pfr = 'N';

    final text = '2.5$ra$rc$lr$de$pfr';
    final digest = sha256.convert(
      Uint8List.fromList(utf8.encode(text)),
    );

    return base64Encode(digest.bytes);
  }

  // Create PID XML with WADH
  String _createPidXml(String wadh) {
    return '''<?xml version="1.0"?>
<PidOptions ver="1.0">
    <Opts
        env="P"
        fCount="1"
        fType="2"
        format="0"
        pidVer="2.0"
        timeout="10000"
        posh="UNKNOWN"
        wadh="$wadh"
    />
</PidOptions>''';
  }

  // Capture fingerprint from Mantra RD Service
  Future<Map<String, dynamic>?> captureFingerprint() async {
    final url = _mantraBaseUrl + _captureApiPath;
    log('[MANTRA] CAPTURE START');
    log('[MANTRA] CAPTURE METHOD: CAPTURE');
    log('[MANTRA] CAPTURE URL: $url');

    try {
      final wadh = _generateWadh();
      final pidXml = _createPidXml(wadh);

      log('[MANTRA] Sending capture request with WADH');

      final request = http.Request('CAPTURE', Uri.parse(url));
      request.headers['Content-Type'] = 'text/xml';
      request.headers['Accept'] = 'text/xml';
      request.body = pidXml;

      final response = await request.send().timeout(const Duration(seconds: 15));
      final responseBody = await response.stream.bytesToString();

      log('[MANTRA] CAPTURE STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Check for error in PID response
        if (responseBody.contains('errCode="0"')) {
          log('[MANTRA] FINGERPRINT CAPTURE SUCCESS');

          // Convert entire PID XML to Base64
          final fingerPrintAuthPid = base64Encode(utf8.encode(responseBody));

          log('[MANTRA] PID LENGTH: ${fingerPrintAuthPid.length}');

          return {
            'success': true,
            'fingerPrintAuthPid': fingerPrintAuthPid,
            'pidXml': responseBody,
            'statusMessage': 'Fingerprint captured successfully',
          };
        } else {
          log('[MANTRA] Fingerprint capture failed - errCode not 0');
          // Try to extract error info from response
          final errorMatch = RegExp(r'errInfo="([^"]*)"').firstMatch(responseBody);
          final errorInfo = errorMatch?.group(1) ?? 'Device reported capture error';
          return {
            'success': false,
            'error': errorInfo,
            'pidXml': responseBody,
          };
        }
      }

      log('[MANTRA] Fingerprint capture failed - HTTP ${response.statusCode}');
      return {
        'success': false,
        'error': 'Fingerprint capture failed. Please place your finger correctly and try again.',
      };
    } catch (ex) {
      log('[MANTRA] CAPTURE error: $ex');
      return {
        'success': false,
        'error': ex.toString().contains('TimeoutException')
            ? 'Fingerprint capture timed out. Please try again.'
            : 'Failed to communicate with fingerprint device. Please check the device connection.',
      };
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
