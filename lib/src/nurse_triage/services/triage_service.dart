import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show min;
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:taei_gov/src/nurse_triage/models/create_triage_model.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_list_model.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_lookup_model.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_debug_logger.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'package:http/http.dart' as http;
import '../../../constants/urls.dart';

class TriageService {
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

  static Future<bool> createTriage({required TriageModel data}) async {
    final url = Urls.createTriage;
    final requestBody = data.toJson();
    try {
      var response = await _client.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody));
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
      _logApi(
        apiName: 'createTriage',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Triage Created Successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      _logApi(
        apiName: 'createTriage',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return false;
    }
  }

  static Future<TriageLookupModel?> getLookup() async {
    final url = Urls.getTriageLookup;
    try {
      var response = await _client.get(Uri.parse(url));
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
      _logApi(
        apiName: 'getLookup',
        url: url,
        method: 'GET',
        requestBody: {},
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      if (response.statusCode == 200) {
        return triageLookupModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (ex) {
      _logApi(
        apiName: 'getLookup',
        url: url,
        method: 'GET',
        requestBody: {},
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return null;
    }
  }

  static Future<TriageListModel?> getTriageList() async {
    final url = Urls.getTriageList;
    try {
      var response = await _client.get(Uri.parse(url));
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
      _logApi(
        apiName: 'getTriageList',
        url: url,
        method: 'GET',
        requestBody: {},
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      if (response.statusCode == 200) {
        return triageListModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (ex) {
      _logApi(
        apiName: 'getTriageList',
        url: url,
        method: 'GET',
        requestBody: {},
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return null;
    }
  }

  /// Update
  static Future<bool> updateTriage({required TriageModel data}) async {
    final url = Urls.updateTriage;
    final requestBody = data.toJson();
    try {
      var response = await _client.put(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody));
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
      _logApi(
        apiName: 'updateTriage',
        url: url,
        method: 'PUT',
        requestBody: requestBody,
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Triage Created Successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      _logApi(
        apiName: 'updateTriage',
        url: url,
        method: 'PUT',
        requestBody: requestBody,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return false;
    }
  }

  static Future<Map<String, dynamic>?> sendAadhaarOtp({
    required String aadhaar,
    String? flowId,
  }) async {
    final url = Urls.sendAadhaarOtp;
    final requestBody = {'aadhaar': aadhaar};
    AbhaDebugLogger.log('START sendAadhaarOtp', flowId: flowId);
    AbhaDebugLogger.http('→ POST $url', flowId: flowId);
    AbhaDebugLogger.request(
      api: 'aadhaar/generate-otp',
      method: 'POST',
      url: url,
      data: AbhaDebugLogger.sanitizeData(requestBody),
      flowId: flowId,
    );
    try {
      var response = await _client.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody));
      final responseBody = response.body.isNotEmpty
          ? _parseResponseBody(response.body)
          : <String, dynamic>{};
      AbhaDebugLogger.http('← ${response.statusCode} $url', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'aadhaar/generate-otp',
        statusCode: response.statusCode,
        data: responseBody is Map<String, dynamic>
            ? AbhaDebugLogger.sanitizeData(responseBody)
            : {'raw': responseBody},
        flowId: flowId,
      );
      AbhaDebugLogger.log('END sendAadhaarOtp', flowId: flowId);
      return responseBody;
    } catch (ex, stackTrace) {
      AbhaDebugLogger.error('API FAILED: sendAadhaarOtp', flowId: flowId);
      AbhaDebugLogger.error('Exception: $ex', flowId: flowId);
      AbhaDebugLogger.error('StackTrace: $stackTrace', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'aadhaar/generate-otp',
        statusCode: 500,
        data: {'error': ex.toString()},
        flowId: flowId,
      );
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyAadhaarOtp({
    required String txnId,
    required String otp,
    required String mobile,
    String? flowId,
  }) async {
    final url = Urls.verifyAadhaarOtp;
    final requestBody = {'txnId': txnId, 'otp': otp, 'mobile': mobile};
    AbhaDebugLogger.log('START verifyAadhaarOtp', flowId: flowId);
    AbhaDebugLogger.http('→ POST $url', flowId: flowId);
    AbhaDebugLogger.request(
      api: 'aadhaar/verify-otp',
      method: 'POST',
      url: url,
      data: AbhaDebugLogger.sanitizeData(requestBody),
      flowId: flowId,
    );
    try {
      var response = await _client.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody));
      final responseBody = _parseResponseBody(response.body);
      AbhaDebugLogger.http('← ${response.statusCode} $url', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'aadhaar/verify-otp',
        statusCode: response.statusCode,
        data: responseBody is Map<String, dynamic>
            ? AbhaDebugLogger.sanitizeData(responseBody)
            : {'raw': responseBody},
        flowId: flowId,
      );
      AbhaDebugLogger.log('END verifyAadhaarOtp', flowId: flowId);
      return responseBody;
    } catch (ex, stackTrace) {
      AbhaDebugLogger.error('API FAILED: verifyAadhaarOtp', flowId: flowId);
      AbhaDebugLogger.error('Exception: $ex', flowId: flowId);
      AbhaDebugLogger.error('StackTrace: $stackTrace', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'aadhaar/verify-otp',
        statusCode: 500,
        data: {'error': ex.toString()},
        flowId: flowId,
      );
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendMobileUpdateOtp({
    required int profileId,
    required String mobile,
    String? flowId,
  }) async {
    final url = Urls.updateMobileSendOtp;
    final requestBody = {
      'profileId': profileId,
      'mobile': mobile,
    };
    AbhaDebugLogger.log('START sendMobileUpdateOtp', flowId: flowId);
    AbhaDebugLogger.http('→ POST $url', flowId: flowId);
    AbhaDebugLogger.request(
      api: 'updatemobile/send-otp',
      method: 'POST',
      url: url,
      data: AbhaDebugLogger.sanitizeData(requestBody),
      flowId: flowId,
    );
    try {
      var response = await _client.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );
      final responseBody = _parseResponseBody(response.body);
      AbhaDebugLogger.http('← ${response.statusCode} $url', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'updatemobile/send-otp',
        statusCode: response.statusCode,
        data: responseBody is Map<String, dynamic>
            ? AbhaDebugLogger.sanitizeData(responseBody)
            : {'raw': responseBody},
        flowId: flowId,
      );
      AbhaDebugLogger.log('END sendMobileUpdateOtp', flowId: flowId);
      return responseBody;
    } catch (ex, stackTrace) {
      AbhaDebugLogger.error('API FAILED: sendMobileUpdateOtp', flowId: flowId);
      AbhaDebugLogger.error('Exception: $ex', flowId: flowId);
      AbhaDebugLogger.error('StackTrace: $stackTrace', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'updatemobile/send-otp',
        statusCode: 500,
        data: {'error': ex.toString()},
        flowId: flowId,
      );
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyMobileUpdateOtp({
    required int profileId,
    required String txnId,
    required String otp,
    String? flowId,
  }) async {
    final url = Urls.updateMobileVerifyOtp;
    final requestBody = {
      'profileId': profileId,
      'txnId': txnId,
      'otp': otp,
    };

    final maskedOtp = otp.isEmpty ? 'EMPTY' : '*' * otp.length;

    debugPrint('============================================================');
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] update-mobile/verify-otp REQUEST');
    debugPrint('============================================================');
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] URL:');
    debugPrint(url);
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] METHOD: POST');
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] profileId: $profileId');
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] txnId: $txnId');
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] otp: $maskedOtp');
    debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] REQUEST BODY:');
    debugPrint('{');
    debugPrint('  "profileId": ${profileId},');
    debugPrint('  "txnId": "$txnId",');
    debugPrint('  "otp": "$maskedOtp"');
    debugPrint('}');
    debugPrint('============================================================');

    AbhaDebugLogger.log('START verifyMobileUpdateOtp', flowId: flowId);
    AbhaDebugLogger.http('→ POST $url', flowId: flowId);
    AbhaDebugLogger.request(
      api: 'updatemobile/verify-otp',
      method: 'POST',
      url: url,
      data: AbhaDebugLogger.sanitizeData(requestBody),
      flowId: flowId,
    );
    try {
      var response = await _client.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );
      final responseBody = _parseResponseBody(response.body);

      debugPrint('============================================================');
      debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] update-mobile/verify-otp RESPONSE');
      debugPrint('============================================================');
      debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] STATUS: ${response.statusCode}');
      debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] RESPONSE:');
      debugPrint(jsonEncode(responseBody));
      debugPrint('============================================================');

      if (responseBody is Map<String, dynamic>) {
        final authResult = responseBody['authResult']?.toString();
        if (authResult != null && authResult.isNotEmpty) {
          debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] authResult: $authResult');
        }
        final msg = responseBody['message']?.toString();
        if (msg != null && msg.isNotEmpty) {
          debugPrint('[ABHA][API][FLOW:${flowId ?? 'unknown'}] message: $msg');
        }
      }

      AbhaDebugLogger.http('← ${response.statusCode} $url', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'updatemobile/verify-otp',
        statusCode: response.statusCode,
        data: responseBody is Map<String, dynamic>
            ? AbhaDebugLogger.sanitizeData(responseBody)
            : {'raw': responseBody},
        flowId: flowId,
      );
      AbhaDebugLogger.log('END verifyMobileUpdateOtp', flowId: flowId);
      return responseBody;
    } catch (ex, stackTrace) {
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] update-mobile/verify-otp failed');
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] Exception: $ex');
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] StackTrace: $stackTrace');
      debugPrint('[ABHA][ERROR][FLOW:${flowId ?? 'unknown'}] Request: profileId=$profileId txnId=$txnId otp=$maskedOtp');
      AbhaDebugLogger.error('API FAILED: verifyMobileUpdateOtp', flowId: flowId);
      AbhaDebugLogger.error('Exception: $ex', flowId: flowId);
      AbhaDebugLogger.error('StackTrace: $stackTrace', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'updatemobile/verify-otp',
        statusCode: 500,
        data: {'error': ex.toString()},
        flowId: flowId,
      );
      return null;
    }
  }

  static Future<String?> downloadFile(String url) async {
    try {
      log('🔷 STARTING DOWNLOAD: $url');

      // Use http.get directly to ensure we get bodyBytes
      final httpClient = http.Client();
      final response = await _client.get(Uri.parse(url));

      log('🔷 Response Status: ${response.statusCode}');
      log('🔷 Content-Type: ${response.headers['content-type']}');
      log('🔷 Content-Length: ${response.headers['content-length']}');
      log('🔷 Body Bytes Length: ${response.bodyBytes.length}');

      _logApi(
        apiName: 'downloadFile',
        url: url,
        method: 'GET',
        requestBody: null,
        statusCode: response.statusCode,
        responseBody: {
          'contentLength': response.bodyBytes.length,
          'contentType': response.headers['content-type']
        },
      );

      // ✅ Check for successful status codes (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final bytes = response.bodyBytes;

        if (bytes.isEmpty) {
          log('❌ ERROR: Downloaded file is empty');
          Fluttertoast.showToast(msg: 'Downloaded file is empty');
          return null;
        }

        // Verify PNG signature
        if (bytes.length > 4) {
          final hexString = bytes
              .take(4)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join();
          log('🔷 First 4 bytes (hex): $hexString');

          // PNG magic number: 89 50 4E 47
          if (hexString == '89504e47') {
            log('✅ Valid PNG signature detected');
          } else {
            log('⚠️ WARNING: Not a standard PNG signature, but proceeding...');
          }
        }

        // Generate filename with timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'ABHA_Card_$timestamp.png';

        try {
          // Choose directory path based on platform and plugin availability
          String? downloadPath;

          if (kIsWeb) {
            log('⚠️ Running on web; using browser download mechanism.');

            try {
              // Use universal_html to create blob and anchor for download
              final blob = html.Blob(
                  [response.bodyBytes],
                  response.headers['content-type'] ??
                      'application/octet-stream');
              final url = html.Url.createObjectUrlFromBlob(blob);
              final anchor = html.AnchorElement(href: url)
                ..download = fileName
                ..style.display = 'none';

              html.document.body?.append(anchor);
              anchor.click();
              anchor.remove();
              html.Url.revokeObjectUrl(url);

              Fluttertoast.showToast(
                  msg: 'ABHA Card download started in browser.');
              return fileName;
            } catch (webEx) {
              log('❌ ERROR web download action failed: $webEx');
              Fluttertoast.showToast(
                  msg: 'Web download failed: ${webEx.toString()}');
              return null;
            }
          }

          try {
            // Prefer downloads directory on desktop (Windows/macOS/Linux) if available
            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
              final downloads = await getDownloadsDirectory();
              if (downloads != null) {
                downloadPath = downloads.path;
                log('🔷 Download Directory (Downloads): $downloadPath');
              }
            }

            // fallback to application documents for Android/iOS or if downloads path null
            if (downloadPath == null) {
              final directory = await getApplicationDocumentsDirectory();
              downloadPath = directory.path;
              log('🔷 Download Directory (Documents): $downloadPath');
            }
          } catch (pathEx) {
            log('⚠️ WARNING: path_provider(getApplicationDocumentsDirectory/getDownloadsDirectory) failed: $pathEx');
            // fallback to safe current directory as last resort
            try {
              downloadPath = Directory.current.path;
              log('🔷 Fallback to Directory.current: $downloadPath');
            } catch (currentEx) {
              log('❌ ERROR: all directory mechanisms failed (downloads, application, current): $currentEx');
              Fluttertoast.showToast(
                  msg:
                      'Cannot access download directory. Please ensure path_provider is configured and app has write permission.');
              return null;
            }
          }

          final filePath = '$downloadPath/$fileName';

          // Create directory if it doesn't exist
          final dir = Directory(downloadPath);
          if (!await dir.exists()) {
            log('🔷 Creating directory: $downloadPath');
            await dir.create(recursive: true);
          }

          // Write file to disk
          final file = File(filePath);
          await file.writeAsBytes(bytes);

          log('✅ ABHA Card downloaded successfully!');
          log('✅ File path: $filePath');
          log('✅ File size: ${bytes.length} bytes');

          Fluttertoast.showToast(
              msg:
                  'ABHA Card downloaded!\nFile: $fileName\nLocation: $downloadPath');
          return filePath;
        } catch (writeEx) {
          log('❌ ERROR writing file to disk: $writeEx');
          Fluttertoast.showToast(
              msg: 'Error saving file: ${writeEx.toString()}');
          return null;
        }
      } else {
        // API returned error status
        final errorBody = response.body.isNotEmpty
            ? response.body.substring(0, min(200, response.body.length))
            : 'No response body';

        log('❌ Download failed with status ${response.statusCode}');
        log('❌ Error response: $errorBody');

        Fluttertoast.showToast(
            msg: 'Download failed: Status ${response.statusCode}');
        return null;
      }
    } catch (ex) {
      log('❌ Download file exception: $ex');
      log('❌ Stack trace: $ex');

      _logApi(
        apiName: 'downloadFile',
        url: url,
        method: 'GET',
        requestBody: null,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );

      Fluttertoast.showToast(msg: 'Error: ${ex.toString()}');
      return null;
    }
  }

  Future<bool> testServerConnection() async {
    final url = 'http://192.168.1.5:5000/health'; // replace with your PC IP
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        print("✅ Server reachable! Response: ${response.body}");
        return true;
      } else {
        print("⚠️ Server responded but with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Cannot reach server: $e");
      return false;
    }
  }

// ─────────────────────────────────────────
// FACE AUTH STEP 3 - CREATE ABHA
// ─────────────────────────────────────────

  static Future<Map<String, dynamic>?> createAbhaUsingFace({
    required String txnId,
    required String aadhaar,
    required String mobile,
  }) async {
    final url = Urls.createAbhaUsingFace;

    final requestBody = {
      "txnId": txnId,
      "aadhaar": aadhaar,
      "mobile": mobile,
    };

    print("======================================");
    print("ABHA ENROLL API");
    print("URL : $url");
    print("REQUEST");
    print(requestBody);
    print("======================================");

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("STATUS CODE : ${response.statusCode}");
      print("BODY : ${response.body}");

      Object? decodedBody;

      if (response.body.trim().isNotEmpty) {
        try {
          decodedBody = jsonDecode(response.body);
        } catch (_) {
          decodedBody = response.body;
        }
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorMessage = decodedBody is Map<String, dynamic>
            ? (decodedBody['message']?.toString() ??
                decodedBody['error']?.toString() ??
                'Enroll API failed')
            : decodedBody?.toString() ?? 'Enroll API failed';

        print("ENROLL API ERROR MESSAGE : $errorMessage");

        _logApi(
          apiName: "createAbhaUsingFace",
          url: url,
          method: "POST",
          requestBody: requestBody,
          statusCode: response.statusCode,
          responseBody: decodedBody ?? {},
        );

        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }

      final decoded = decodedBody is Map<String, dynamic>
          ? decodedBody
          : <String, dynamic>{'data': decodedBody};

      print("======================================");
      print("ENROLL RESPONSE");
      print(decoded);
      print("======================================");

      _logApi(
        apiName: "createAbhaUsingFace",
        url: url,
        method: "POST",
        requestBody: requestBody,
        statusCode: response.statusCode,
        responseBody: decoded,
      );

      return decoded;
    } catch (e, stack) {
      print("======================================");
      print("ENROLL API ERROR");
      print(e);
      print(stack);
      print("======================================");

      return null;
    }
  }

  /// Download official ABHA card from backend
  /// 
  /// Returns a map with:
  /// - 'success': bool indicating if download succeeded
  /// - 'bytes': Uint8List containing the card file data
  /// - 'contentType': String indicating file type (image/png or application/pdf)
  /// - 'filename': String suggested filename
  /// - 'error': String error message if failed
  static Future<Map<String, dynamic>> downloadAbhaCard({
    required int profileId,
    String? flowId,
  }) async {
    final url = '${Urls.downloadAbhaCard}/$profileId';
    
    log('[ABHA CARD][DOWNLOAD] Starting download from backend');
    log('[ABHA CARD][DOWNLOAD] URL: $url');
    log('[ABHA CARD][DOWNLOAD] profileId: $profileId');
    
    AbhaDebugLogger.log('START downloadAbhaCard', flowId: flowId);
    AbhaDebugLogger.http('→ GET $url', flowId: flowId);
    AbhaDebugLogger.request(
      api: 'abha/card/{profileId}',
      method: 'GET',
      url: url,
      data: {'profileId': profileId},
      flowId: flowId,
    );

    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/pdf, image/png',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('ABHA card download timeout'),
      );

      log('[ABHA CARD][DOWNLOAD] HTTP Status: ${response.statusCode}');
      log('[ABHA CARD][DOWNLOAD] Content-Type: ${response.headers['content-type']}');
      log('[ABHA CARD][DOWNLOAD] Content-Length: ${response.bodyBytes.length}');

      AbhaDebugLogger.http(
        '← ${response.statusCode} $url',
        flowId: flowId,
      );

      // Validate successful response
      if (response.statusCode != 200) {
        final errorMessage = 'Failed to download ABHA card. '
            'Status: ${response.statusCode}';
        
        log('[ABHA CARD][DOWNLOAD][ERROR] $errorMessage');
        AbhaDebugLogger.error(
          'API FAILED: downloadAbhaCard - Status ${response.statusCode}',
          flowId: flowId,
        );
        AbhaDebugLogger.response(
          api: 'abha/card/{profileId}',
          statusCode: response.statusCode,
          data: {'error': errorMessage},
          flowId: flowId,
        );

        return {
          'success': false,
          'error': errorMessage,
          'statusCode': response.statusCode,
        };
      }

      // Validate response bytes
      if (response.bodyBytes.isEmpty) {
        const errorMessage = 'ABHA card response was empty';
        log('[ABHA CARD][DOWNLOAD][ERROR] $errorMessage');
        AbhaDebugLogger.error(
          'API FAILED: downloadAbhaCard - Empty response',
          flowId: flowId,
        );
        AbhaDebugLogger.response(
          api: 'abha/card/{profileId}',
          statusCode: 200,
          data: {'error': errorMessage},
          flowId: flowId,
        );

        return {
          'success': false,
          'error': errorMessage,
        };
      }

      // Determine content type and filename
      final contentType = response.headers['content-type'] ?? 'application/octet-stream';
      late String fileExtension;
      
      if (contentType.contains('pdf')) {
        fileExtension = '.pdf';
      } else if (contentType.contains('png')) {
        fileExtension = '.png';
      } else if (contentType.contains('image')) {
        fileExtension = '.png'; // Default to PNG for generic image types
      } else {
        fileExtension = '.pdf'; // Default to PDF
      }

      final filename = 'ABHA_Card_$profileId$fileExtension';

      log('[ABHA CARD][DOWNLOAD][SUCCESS]');
      log('[ABHA CARD][DOWNLOAD] Filename: $filename');
      log('[ABHA CARD][DOWNLOAD] Content-Type: $contentType');
      log('[ABHA CARD][DOWNLOAD] Byte Length: ${response.bodyBytes.length}');

      AbhaDebugLogger.log('END downloadAbhaCard', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'abha/card/{profileId}',
        statusCode: 200,
        data: {
          'filename': filename,
          'contentType': contentType,
          'byteLength': response.bodyBytes.length,
        },
        flowId: flowId,
      );

      return {
        'success': true,
        'bytes': response.bodyBytes,
        'contentType': contentType,
        'filename': filename,
      };
    } on TimeoutException catch (e) {
      const errorMessage = 'ABHA card download timed out. Please check your connection.';
      log('[ABHA CARD][DOWNLOAD][ERROR] $errorMessage');
      AbhaDebugLogger.error('API TIMEOUT: downloadAbhaCard', flowId: flowId);
      AbhaDebugLogger.error('Exception: $e', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'abha/card/{profileId}',
        statusCode: 408,
        data: {'error': errorMessage},
        flowId: flowId,
      );

      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e, stackTrace) {
      final errorMessage = 'Error downloading ABHA card: ${e.toString()}';
      log('[ABHA CARD][DOWNLOAD][ERROR] $errorMessage');
      log('[ABHA CARD][DOWNLOAD][STACK] $stackTrace');
      AbhaDebugLogger.error('API FAILED: downloadAbhaCard', flowId: flowId);
      AbhaDebugLogger.error('Exception: $e', flowId: flowId);
      AbhaDebugLogger.error('StackTrace: $stackTrace', flowId: flowId);
      AbhaDebugLogger.response(
        api: 'abha/card/{profileId}',
        statusCode: 500,
        data: {'error': errorMessage},
        flowId: flowId,
      );

      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }
}
