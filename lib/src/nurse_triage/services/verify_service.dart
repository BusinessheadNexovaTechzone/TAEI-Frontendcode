import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class VerifyAbhaService {
  final CustomHttpHelper _client = CustomHttpHelper();

  Future<Map<String, dynamic>?> _postJson({
    required String url,
    required String debugLabel,
    required Map<String, dynamic> body,
    bool logBody = true,
  }) async {
    log('[ABHA VerifyService] ===== $debugLabel =====');
    log('[ABHA VerifyService] URL : $url');
    log('[ABHA VerifyService] Body : ${logBody ? jsonEncode(body) : '[redacted]'}');

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      log('[ABHA VerifyService] Status : ${response.statusCode}');
      log('[ABHA VerifyService] Response received');

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
        return {...decoded, 'statusCode': response.statusCode};
      }
      return {'message': decoded.toString(), 'statusCode': response.statusCode};
    } catch (e) {
      log('Verify ABHA $debugLabel service error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendOtp({
    required String loginType,
    required String loginId,
  }) async {
    final url = Urls.sendVerifyAbhaOtp;
    final body = {
      'loginType': loginType,
      'loginId': loginId,
    };

    return _postJson(
      url: url,
      debugLabel: 'SEND OTP REQUEST',
      body: body,
      logBody: false,
    );
  }

  Future<Map<String, dynamic>?> searchAbhaByMobile({
    required String mobile,
  }) {
    return _postJson(
      url: Urls.searchAbhaByMobile,
      debugLabel: 'SEARCH ABHA BY MOBILE',
      body: {'mobile': mobile},
    );
  }

  Future<Map<String, dynamic>?> sendAbhaSearchOtp({
    required String txnId,
    required int index,
  }) {
    return _postJson(
      url: Urls.sendAbhaSearchOtp,
      debugLabel: 'SEND ABHA SEARCH OTP',
      body: {
        'txnId': txnId,
        'index': index,
      },
    );
  }

  Future<Map<String, dynamic>?> verifyAbhaSearchOtp({
    required String otpTxnId,
    required String otp,
  }) {
    return _postJson(
      url: Urls.verifyAbhaSearchOtp,
      debugLabel: 'VERIFY ABHA SEARCH OTP',
      body: {
        'otpTxnId': otpTxnId,
        'otp': otp,
      },
      logBody: false,
    );
  }

  Future<Map<String, dynamic>?> sendAbhaAddressOtp({
    required String loginType,
    required String loginId,
  }) async {
    final url = Urls.abhaAddressSendOtp;
    final body = {
      'loginType': loginType,
      'loginId': loginId,
    };

    debugPrint('=============================');
    debugPrint('VERIFY ABHA ADDRESS');
    debugPrint('Authentication Method : ABHA Address');
    debugPrint('ABHA Address : $loginId');
    debugPrint('loginType : $loginType');
    debugPrint('Send OTP URL : $url');
    debugPrint('Send OTP Request : ${jsonEncode(body)}');

    return _postJson(
      url: url,
      debugLabel: 'SEND ABHA ADDRESS OTP',
      body: body,
    );
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String loginType,
    required String txnId,
    required String otp,
  }) async {
    final isMobileFlow = loginType == 'mobile-mobile-otp';
    final url = isMobileFlow ? Urls.mobileOtpVerify : Urls.verifyVerifyAbhaOtp;
    final body = isMobileFlow
        ? {
            'txnId': txnId,
            'otp': otp,
          }
        : {
            'loginType': loginType,
            'txnId': txnId,
            'otp': otp,
          };

    try {
      debugPrint('========== MOBILE OTP VERIFY ==========');
      debugPrint(
          'Endpoint: ${isMobileFlow ? '/api/abha/login/mobile/verify-otp' : '/api/abha/login/verify-otp'}');
      debugPrint('URL : $url');
      debugPrint('Body : [redacted]');

      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('Status : ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('========== MOBILE OTP VERIFY SUCCESS ==========');
        debugPrint('Status Code: ${response.statusCode}');
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

      debugPrint('========== MOBILE OTP VERIFY FAILED ==========');
      debugPrint('Status Code: ${response.statusCode}');

      final decoded = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return {...decoded, 'statusCode': response.statusCode};
      }
      return {'message': decoded.toString(), 'statusCode': response.statusCode};
    } catch (e) {
      log('Verify ABHA verify OTP service error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> verifyAbhaAddressOtp({
    required String loginType,
    required String txnId,
    required String otp,
  }) async {
    final url = Urls.abhaAddressVerifyOtp;
    final body = {
      'loginType': loginType,
      'txnId': txnId,
      'otp': otp,
    };

    debugPrint('=============================');
    debugPrint('VERIFY ABHA ADDRESS');
    debugPrint('Authentication Method : ABHA Address');
    debugPrint('txnId : $txnId');
    debugPrint('loginType : $loginType');
    debugPrint('Verify OTP URL : $url');
    debugPrint('Verify OTP Request : ${jsonEncode(body)}');

    return _postJson(
      url: url,
      debugLabel: 'VERIFY ABHA ADDRESS OTP',
      body: body,
    );
  }

  Future<Map<String, dynamic>?> verifyAbhaUser({
    required String abhaNumber,
    required String txnId,
    required String tToken,
  }) {
    return _postJson(
      url: Urls.abhaVerifyUser,
      debugLabel: 'VERIFY ABHA USER',
      body: {
        'ABHANumber': abhaNumber,
        'txnId': txnId,
        'tToken': tToken,
      },
      logBody: false,
    );
  }

  Future<Map<String, dynamic>?> getAbhaAccountDetails({
    required String accessToken,
  }) =>
      _getJson(
        url: Urls.abhaAccountDetails,
        label: 'ABHA ACCOUNT DETAILS',
        accessToken: accessToken,
      );

  Future<Map<String, dynamic>?> getAbhaPhrProfile({
    required String accessToken,
  }) =>
      _getJson(
        url: Urls.abhaPhrProfile,
        label: 'ABHA PHR PROFILE',
        accessToken: accessToken,
      );

  Future<Map<String, dynamic>?> _getJson({
    required String url,
    required String label,
    required String accessToken,
  }) async {
    final trimmedToken = accessToken.trim();
    final token = trimmedToken.toLowerCase().startsWith('bearer ')
        ? trimmedToken
        : 'Bearer ' + trimmedToken;
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {'X-Token': token},
      );

      log('[ABHA VerifyService] $label status: ${response.statusCode}');
      final decoded = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        return {'data': decoded};
      }

      if (decoded is Map<String, dynamic>) {
        return {...decoded, 'statusCode': response.statusCode};
      }
      if (decoded is Map) {
        return {
          ...Map<String, dynamic>.from(decoded),
          'statusCode': response.statusCode,
        };
      }
      return {'message': decoded.toString(), 'statusCode': response.statusCode};
    } catch (e) {
      log('Get $label service error: $e');
      return null;
    }
  }
}
