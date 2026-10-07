import 'dart:convert';

import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_debug_logger.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class DemoAuthException implements Exception {
  const DemoAuthException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

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
    AbhaDebugLogger.log(
        '[DEMO-AUTH] ENDPOINT: /api/abha/aadhaar/enrol-by-aadhaar',
        flowId: flowId);
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

      Object? decodedBody;
      if (response.body.trim().isNotEmpty) {
        try {
          decodedBody = jsonDecode(response.body);
        } on FormatException {
          decodedBody = response.body.trim();
        }
      }
      final decoded = decodedBody is Map
          ? Map<String, dynamic>.from(decodedBody)
          : <String, dynamic>{
              if (decodedBody != null)
                'message': decodedBody is String
                    ? decodedBody
                    : decodedBody.toString(),
            };

      AbhaDebugLogger.log('[DEMO-AUTH] RESPONSE RECEIVED', flowId: flowId);
      AbhaDebugLogger.response(
        api: '/api/abha/aadhaar/enrol-by-aadhaar',
        statusCode: response.statusCode,
        data: AbhaDebugLogger.sanitizeData(decoded),
        flowId: flowId,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        AbhaDebugLogger.log('[DEMO-AUTH] SUCCESS', flowId: flowId);
        return decoded;
      }

      final message = decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          decoded['detail']?.toString() ??
          'Demo authentication failed (HTTP ${response.statusCode}).';
      AbhaDebugLogger.error('[DEMO-AUTH] ERROR: $message', flowId: flowId);
      throw DemoAuthException(message, statusCode: response.statusCode);
    } catch (e, stackTrace) {
      AbhaDebugLogger.error('[DEMO-AUTH] ERROR: $e', flowId: flowId);
      AbhaDebugLogger.error('[DEMO-AUTH] STACKTRACE: $stackTrace',
          flowId: flowId);
      rethrow;
    }
  }
}
