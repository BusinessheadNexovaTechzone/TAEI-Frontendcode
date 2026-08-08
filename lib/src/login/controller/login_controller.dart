import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/constant.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/enter/enter_page.dart';
import 'package:taei_gov/src/login/controller/toast.dart';
import 'package:taei_gov/src/login/models/user_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'package:taei_gov/utils/helpers/local_data_helper.dart';
import 'package:taei_gov/utils/helpers/loading_helper.dart';

class LoginController extends GetxController {
  final _client = CustomHttpHelper();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    loadingIndicator(Get.context!);
    try {
      var url = Uri.parse(Urls.login);
      var bodyData = {"username": email, "password": password};

      var response = await _client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      Get.back(); // close loader

      log("Login response: ${response.statusCode} => ${response.body}");

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        LocalDataHelper.setString(Constant.token, json["token"]);
        bool isValid = await validateToken();
        if (isValid) {
          ToastHelper.showSuccess("Successfully Logged In");
          checkUser();
          return true;
        }
      }

      ToastHelper.showError("Invalid email or password");
      return false;
    } catch (e) {
      Get.back();
      ToastHelper.showError("Network error occurred");
      debugPrint("Login error: $e");
      return false;
    }
  }

  Future<bool> validateToken() async {
    try {
      var url = Uri.parse(Urls.validateToken);
      var response = await _client.get(url);

      log("Validate token: ${response.body}");

      if (response.statusCode == 200) {
        LocalDataHelper.setString(Constant.userDetails, response.body);
        return true;
      } else {
        ToastHelper.showError("Token validation failed");
        return false;
      }
    } catch (e) {
      ToastHelper.showError("Error validating token");
      debugPrint(e.toString());
      return false;
    }
  }

  void saveUser(UserModel user) {
    LocalDataHelper.setString(
      Constant.userDetails,
      jsonEncode(user.toJson()),
    );
  }

  /// district and directorate id for institutional dashboard
  var districtId = 0.obs;
  var directorateId = 0.obs;

  //............//////////////
  var userDetails = Rxn<UserModel>();
  RxBool isDistrictAdmin = false.obs;
  RxBool isGHAdmin = false.obs;
  RxBool isAdmin = false.obs;
  RxBool isDMSAdmin = false.obs;
  RxBool isDMEAdmin = false.obs;
  RxBool isDME = false.obs;
  RxBool isDMS = false.obs;
  RxBool isInstitution = false.obs;

  void checkUser() {
    String data = LocalDataHelper.getString(Constant.userDetails);
    userDetails.value =
        data.isNotEmpty ? UserModel.fromJson(jsonDecode(data)) : UserModel();
    isDistrictAdmin.value =
        userDetails.value?.user?.role == "district admin" ? true : false;
    isGHAdmin.value =
        userDetails.value?.user?.role == "district GH" ? true : false;
    isAdmin.value =
        userDetails.value?.user?.role == 'state admin' ? true : false;
    isDMSAdmin.value =
        userDetails.value?.user?.role == 'district DMS' ? true : false;
    isDMEAdmin.value =
        userDetails.value?.user?.role == 'district DME' ? true : false;
    isInstitution.value =
        userDetails.value?.user?.role == "admin" ? true : false;
    isDME.value = userDetails.value?.user?.directorate == "DME" ? true : false;
    isDMS.value = userDetails.value?.user?.directorate == "DMS" ? true : false;

    /// district and directorate id for institutional dashboard
    if (userDetails.value?.user?.role != 'admin' &&
        userDetails.value?.user?.role != 'state admin' &&
        userDetails.value?.user?.role != 'district admin' &&
        userDetails.value?.user?.role != 'district DME' &&
        userDetails.value?.user?.role != 'district DMS' &&
        userDetails.value?.user?.role != 'district GH') {
      districtId.value = userDetails.value?.user?.hospital?.districtId ??
          userDetails.value?.user?.district?.id ??
          0;
      directorateId.value = userDetails.value?.user?.role == "district GH"
          ? 3
          : userDetails.value?.user?.directorate == "DME"
              ? 1
              : userDetails.value?.user?.directorate == "DMS"
                  ? 3
                  : 0;
    }
  }

  bool checkIsInstitution() {
    // print("ins" + isInstitution.value.toString());
    // print("dms" + isDMS.value.toString());
    // print("dm" + isDME.value.toString());
    return (isInstitution.value && isDME.value) ||
        (isInstitution.value && isDMS.value);
  }

  Future<bool> logout() async {
    try {
      LocalDataHelper.clearData();
      ToastHelper.showSuccess("Logged out successfully");
      Get.offAll(() => const EntranceScreen());
      return true;
    } catch (e) {
      ToastHelper.showError("Logout failed. Try again.");
      return false;
    }
  }

  int getDisrictId() {
    try {
      int dId = userDetails.value?.user?.hospital != null
          ? userDetails.value?.user?.hospital?.districtId ?? 0
          : userDetails.value?.user?.district?.id ?? 0;
      return dId;
    } catch (e) {
      return 0;
    }
  }

  int getInsId() {
    return userDetails.value?.user?.hospital?.hospitalid ?? 0;
  }

  int getDir() {
    try {
      return isDMEAdmin.value
          ? 1
          : isDMSAdmin.value
              ? 3
              : isGHAdmin.value
                  ? 2
                  : 0;
    } catch (e) {
      return 0;
    }
  }
}
