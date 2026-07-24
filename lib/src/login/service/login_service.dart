// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:taei_gov/constants/constant.dart';
// import 'package:taei_gov/utils/helpers/local_data_helper.dart';
// import '../../../constants/urls.dart';
// import '../../../utils/helpers/http_helper.dart';
// import '../controller/toast.dart';
//
// class LoginService {
//   static final _client = CustomHttpHelper();
//
//   static Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       var url = Uri.parse(Urls.login);
//       var data = {"username": email, "password": password};
//       var response = await _client.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );
//       log("Login response: ${response.statusCode} => ${response.body}");
//       if (response.statusCode == 200) {
//         var d = jsonDecode(response.body);
//         LocalDataHelper.setString(Constant.token, d["token"]);
//         var isValid = await validateToken();
//         if (isValid) return true;
//         return false;
//       } else if (response.statusCode == 401) {
//         return false;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Login error: $e");
//       ToastHelper.showError("Network error occurred");
//       return false;
//     }
//   }
//
//   static Future<bool> validateToken() async {
//     try {
//       var url = Uri.parse(Urls.validateToken);
//       var response = await _client.get(url);
//       log('Validate token response: ${response.body}');
//       if (response.statusCode == 200) {
//         LocalDataHelper.setString(Constant.userDetails, response.body);
//         return true;
//       } else {
//         ToastHelper.showError("Token validation failed");
//         return false;
//       }
//     } catch (ex) {
//       debugPrint(ex.toString());
//       ToastHelper.showError("Error validating token");
//       return false;
//     }
//   }
// }
