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
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'package:http/http.dart' as http;
import '../../../constants/urls.dart';

class TriageService {
  static final _client = CustomHttpHelper();

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
      var response = await _client.put(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      }, body: jsonEncode(requestBody));
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

  static Future<Map<String, dynamic>?> sendAadhaarOtp({required String aadhaar}) async {
    final url = Urls.sendAadhaarOtp;
    final requestBody = {'aadhaar': aadhaar};
    try {
      var response = await _client.post(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      }, body: jsonEncode(requestBody));
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
      _logApi(
        apiName: 'sendAadhaarOtp',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      return responseBody;
    } catch (ex) {
      _logApi(
        apiName: 'sendAadhaarOtp',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyAadhaarOtp({
    required String txnId,
    required String otp,
    required String mobile,
  }) async {
    final url = Urls.verifyAadhaarOtp;
    final requestBody = {'txnId': txnId, 'otp': otp, 'mobile': mobile};
    try {
      var response = await _client.post(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      }, body: jsonEncode(requestBody));
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
      _logApi(
        apiName: 'verifyAadhaarOtp',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
      return responseBody;
    } catch (ex) {
      _logApi(
        apiName: 'verifyAadhaarOtp',
        url: url,
        method: 'POST',
        requestBody: requestBody,
        statusCode: 500,
        responseBody: {'error': ex.toString()},
      );
      return null;
    }
  }

  static Future<String?> downloadFile(String url) async {
    try {
      log('🔷 STARTING DOWNLOAD: $url');
      
      // Use http.get directly to ensure we get bodyBytes
      final httpClient = http.Client();
      final response = await httpClient.get(Uri.parse(url));

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
          final hexString = bytes.take(4).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
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
              final blob = html.Blob([response.bodyBytes], response.headers['content-type'] ?? 'application/octet-stream');
              final url = html.Url.createObjectUrlFromBlob(blob);
              final anchor = html.AnchorElement(href: url)
                ..download = fileName
                ..style.display = 'none';

              html.document.body?.append(anchor);
              anchor.click();
              anchor.remove();
              html.Url.revokeObjectUrl(url);

              Fluttertoast.showToast(msg: 'ABHA Card download started in browser.');
              return fileName;
            } catch (webEx) {
              log('❌ ERROR web download action failed: $webEx');
              Fluttertoast.showToast(msg: 'Web download failed: ${webEx.toString()}');
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
              Fluttertoast.showToast(msg: 'Cannot access download directory. Please ensure path_provider is configured and app has write permission.');
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
          
          Fluttertoast.showToast(msg: 'ABHA Card downloaded!\nFile: $fileName\nLocation: $downloadPath');
          return filePath;
        } catch (writeEx) {
          log('❌ ERROR writing file to disk: $writeEx');
          Fluttertoast.showToast(msg: 'Error saving file: ${writeEx.toString()}');
          return null;
        }
      } else {
        // API returned error status
        final errorBody = response.body.isNotEmpty 
            ? response.body.substring(0, min(200, response.body.length)) 
            : 'No response body';
        
        log('❌ Download failed with status ${response.statusCode}');
        log('❌ Error response: $errorBody');
        
        Fluttertoast.showToast(msg: 'Download failed: Status ${response.statusCode}');
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
    final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
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

}
