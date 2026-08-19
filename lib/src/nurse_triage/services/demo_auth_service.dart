import 'dart:convert';
import 'dart:developer';

import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_debug_logger.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class DemoAuthService {
  static final CustomHttpHelper _client = CustomHttpHelper();

  Future<Map<String, dynamic>?> enrollByAadhaar({
    required Map<String, dynamic> body,
    String? flowId,
  }) async {
    final url = Urls.demoAuthEnrollByAadhaar;
    final requestBody = Map<String, dynamic>.from(body);

    AbhaDebugLogger.log('[DEMO-AUTH] START', flowId: flowId);
    AbhaDebugLogger.log('[DEMO-AUTH] VALIDATING FORM', flowId: flowId);
    AbhaDebugLogger.log('[DEMO-AUTH] ENDPOINT: /api/abha/aadhaar/enrol-by-aadhaar', flowId: flowId);
    AbhaDebugLogger.request(
      api: '/api/abha/aadhaar/enrol-by-aadhaar',
      method: 'POST',
      url: url,
      data: AbhaDebugLogger.sanitizeData(requestBody),
      flowId: flowId,
    );

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final decoded = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;

      AbhaDebugLogger.log('[DEMO-AUTH] RESPONSE RECEIVED', flowId: flowId);
      AbhaDebugLogger.response(
        api: '/api/abha/aadhaar/enrol-by-aadhaar',
        statusCode: response.statusCode,
        data: AbhaDebugLogger.sanitizeData(decoded),
        flowId: flowId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AbhaDebugLogger.log('[DEMO-AUTH] SUCCESS', flowId: flowId);
        if (decoded['profileId'] != null) {
          AbhaDebugLogger.log('[DEMO-AUTH] PROFILE ID: ${decoded['profileId']}', flowId: flowId);
        }
        return decoded;
      }

      final message = decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          'Demo authentication failed.';
      AbhaDebugLogger.error('[DEMO-AUTH] ERROR: $message', flowId: flowId);
      throw Exception(message);
    } catch (e, stackTrace) {
      AbhaDebugLogger.error('[DEMO-AUTH] ERROR: $e', flowId: flowId);
      AbhaDebugLogger.error('[DEMO-AUTH] STACKTRACE: $stackTrace', flowId: flowId);
      rethrow;
    }
  }
}
