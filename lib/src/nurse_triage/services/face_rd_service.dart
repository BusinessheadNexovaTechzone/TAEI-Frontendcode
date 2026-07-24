import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FaceRDService {
  // static const String _baseUrl =
  //     'https://abha-m1-hnefehcwghgzchgp.centralindia-01.azurewebsites.net';
  //static const String _baseUrl='https://192.168.1.6:5000';

  static const String _baseUrl = 'https://api.nexovatechzone.com';

  static const String _packageName = 'in.ndhm.phr.debug';
  static const String _initEndpoint = '$_baseUrl/api/abha/face/init';
  static const String _captureEndpoint = '$_baseUrl/api/abha/face/capture';
  static const MethodChannel _channel = MethodChannel('abha_face_auth');

  final http.Client _client;

  FaceRDService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> initFaceAuth() async {
    debugPrint('INIT API START');

    try {
      final response = await _client.post(
        Uri.parse(_initEndpoint),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20));

      debugPrint('INIT RESPONSE');
      debugPrint('statusCode: ${response.statusCode}');
      debugPrint('body: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
            'Init face auth failed with status ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final txnId = decoded['txnId']?.toString();

      if (txnId == null || txnId.trim().isEmpty) {
        throw const FormatException('txnId missing from init response');
      }

      debugPrint('txnId: $txnId');
      return txnId;
    } on TimeoutException {
      debugPrint('INIT API FAILURE: timeout');
      rethrow;
    } catch (e) {
      debugPrint('INIT API FAILURE: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> captureFaceAuth(String txnId) async {
    if (txnId.trim().isEmpty) {
      throw const FormatException("txnId is required");
    }

    debugPrint("=======================================");
    debugPrint("CAPTURE API");
    debugPrint("TXN : $txnId");
    debugPrint("=======================================");

    try {
      final response = await _client
          .post(
            Uri.parse(_captureEndpoint),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "txnId": txnId,
            }),
          )
          .timeout(
            const Duration(seconds: 20),
          );

      debugPrint("STATUS CODE : ${response.statusCode}");
      debugPrint("BODY : ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
          "Capture API Failed : ${response.statusCode}",
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      debugPrint("=======================================");
      debugPrint("CAPTURE RESPONSE");
      debugPrint(decoded.toString());
      debugPrint("=======================================");

      return decoded;
    } on TimeoutException {
      debugPrint("Capture Timeout");

      rethrow;
    } catch (e) {
      debugPrint("Capture Error");
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<void> launchAbhaApp(String faceAuthUrl) async {
    if (faceAuthUrl.trim().isEmpty) {
      throw const FormatException("faceAuthUrl is required");
    }

    debugPrint("==========================================");
    debugPrint("LAUNCH ABHA APP");
    debugPrint("Package : $_packageName");
    debugPrint("URL     : $faceAuthUrl");
    debugPrint("==========================================");

    try {
      final result = await _channel.invokeMethod(
        "launchSandboxApp",
        {
          "packageName": _packageName,
          "url": faceAuthUrl,
        },
      );

      debugPrint("MethodChannel Result : $result");
    } on PlatformException catch (e) {
      debugPrint("PlatformException");
      debugPrint("Code    : ${e.code}");
      debugPrint("Message : ${e.message}");
      debugPrint("Details : ${e.details}");

      rethrow;
    } catch (e, stack) {
      debugPrint("Launch Exception");
      debugPrint(e.toString());
      debugPrint(stack.toString());

      rethrow;
    }
  }

  String? getFaceAuthUrl(Map<String, dynamic> response) {
    final url = response["faceAuthUrl"]?.toString();

    if (url == null || url.isEmpty) {
      return null;
    }

    return url;
  }

  bool isFaceCompleted(Map<String, dynamic> response) {
    final status = response["status"]?.toString().toUpperCase();

    return status == "COMPLETE";
  }

  bool isFacePending(Map<String, dynamic> response) {
    final status = response["status"]?.toString().toUpperCase();

    return status == "PENDING";
  }

  void dispose() {
    _client.close();
  }
}
