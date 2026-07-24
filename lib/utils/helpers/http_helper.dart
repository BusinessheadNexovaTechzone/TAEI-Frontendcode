import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taei_gov/constants/constant.dart';
import 'package:taei_gov/src/enter/enter_page.dart';
import 'package:taei_gov/utils/helpers/local_data_helper.dart';
import 'package:taei_gov/src/login/view/login_page.dart';
import 'package:flutter/foundation.dart';

class CustomHttpHelper extends http.BaseClient {
  final http.Client _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = LocalDataHelper.getString(Constant.token);

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    _logRequest(request);

    final response = await _httpClient.send(request);
    final httpResponse = await http.Response.fromStream(response);

    _logResponse(httpResponse);

    // Handle unauthorized
    if (httpResponse.statusCode == 401 || httpResponse.statusCode == 403) {
      log('Token expired or unauthorized: ${httpResponse.statusCode}');
      // _showToast(
      //   "Unauthorized! Please login again.",
      //   isError: true,
      // );
      LocalDataHelper.clearData();
      Get.offAll(() => const EntranceScreen());
    } else if (httpResponse.statusCode >= 500) {
      // _showToast("Server error! Please try again later.", isError: true);
    } else if (httpResponse.statusCode == 200) {
      log('✅ Success: ${httpResponse.request?.url}');
    }

    return http.StreamedResponse(
      Stream.value(httpResponse.bodyBytes),
      httpResponse.statusCode,
      headers: httpResponse.headers,
      reasonPhrase: httpResponse.reasonPhrase,
      request: request,
    );
  }

  void _logRequest(http.BaseRequest request) {
    log('[HTTP Request]');
    log('METHOD: ${request.method}');
    log('URL: ${request.url}');
    log('HEADERS: ${request.headers}');
    if (request is http.Request && request.body.isNotEmpty) {
      try {
        final jsonObject = jsonDecode(request.body);
        const encoder = JsonEncoder.withIndent('  ');
        log('BODY:\n${encoder.convert(jsonObject)}');
      } catch (_) {
        log('BODY: ${request.body}');
      }
    }
  }

  void _logResponse(http.Response response) {
    log('[HTTP Response]');
    log('STATUS: ${response.statusCode}');
    try {
      final jsonObject = jsonDecode(response.body);
      const encoder = JsonEncoder.withIndent('  ');
      log('BODY:\n${encoder.convert(jsonObject)}');
    } catch (_) {
      log('BODY: ${response.body}');
    }
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
