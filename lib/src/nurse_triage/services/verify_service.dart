import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class VerifyAbhaService {
  final CustomHttpHelper _client = CustomHttpHelper();

  Future<Map<String, dynamic>?> sendOtp({
    required String loginType,
    required String loginId,
  }) async {
    final url = Urls.sendVerifyAbhaOtp;
    final body = {
      'loginType': loginType,
      'loginId': loginId,
    };

    debugPrint('===== SEND OTP REQUEST =====');
    debugPrint('URL : $url');
    debugPrint('loginType : $loginType');
    debugPrint('loginId : $loginId');
    debugPrint('Body : ${jsonEncode(body)}');

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('Status : ${response.statusCode}');
      debugPrint('Response : ${response.body}');
      debugPrint(
          'Decoded sendOtp response: ${response.body.trim().isEmpty ? '<empty>' : jsonDecode(response.body)}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.trim().isEmpty) {
          return <String, dynamic>{};
        }

        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
        return {'message': decoded.toString()};
      }

      final decoded = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'message': decoded.toString()};
    } catch (e) {
      log('Verify ABHA send OTP service error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String loginType,
    required String txnId,
    required String otp,
  }) async {
    final url = Urls.verifyVerifyAbhaOtp;
    final body = {
      'loginType': loginType,
      'txnId': txnId,
      'otp': otp,
    };

    try {
      debugPrint('===== VERIFY OTP REQUEST =====');
      debugPrint('URL : $url');
      debugPrint('loginType : $loginType');
      debugPrint('txnId : $txnId');
      debugPrint('otp : $otp');
      debugPrint('Body : ${jsonEncode(body)}');

      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('Status : ${response.statusCode}');
      debugPrint('Response : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.trim().isEmpty) {
          return <String, dynamic>{'success': true};
        }

        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
        return {'message': decoded.toString(), 'success': true};
      }

      final decoded = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'message': decoded.toString()};
    } catch (e) {
      log('Verify ABHA verify OTP service error: $e');
      return null;
    }
  }
}
