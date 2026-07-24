import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/transit_care/model/transit_care_model.dart';

import 'package:http/http.dart' as http;
import 'package:taei_gov/src/transit_care/model/transitcare_dashboard_count_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'package:taei_gov/utils/helpers/local_data_helper.dart';

class TransitCareController extends GetxController {
  LoginController loginController = Get.find();
  var isLoading = false.obs;
  var transitCareList = <TransitCareModel>[].obs;
  var filteredTransitCareList = <TransitCareModel>[].obs;
  static final _client = CustomHttpHelper();
  var totalPages = 1.obs;
  var transitList = <TransitCareModel>[].obs;

  var NewTransitCareList = <TransitCareModel>[].obs;

  var currentPage = 1.obs;
  final int itemsPerPage = 10;

  var dashboard = Rxn<TransitCareDashboardModel>();

  ///api/summary/TransitCare?start_date=2025-08-01 00:00:00&end_date=2025-09-30 23:59:59

  Future<bool> getTransitCareList(
      {bool isRefresh = false, String? fromDate, String? toDate}) async {
    if (isLoading.value) return false;

    try {
      if (isRefresh) {
        currentPage.value = 1;
        NewTransitCareList.clear();
      }

      isLoading.value = true;

      final url = Uri.parse(
          "https://taei.co.in/WebAPI108/TransitCareLinelist?Page_Number=${"1"}&FromDate=$fromDate&ToDate=$toDate&Search_Text=&Hospital=${loginController.userDetails.value?.user?.hospital?.hospitalid}&DistrictId=0&HospitalType=null");
      log(url.toString());

      final response = await http.get(url);
      log(response.body);
      debugPrint(
          "Hospital Name: ${loginController.userDetails.value?.user?.hospital?.hospitalname}");
      debugPrint(
          "Hospital ID: ${loginController.userDetails.value?.user?.hospital?.hospitalid}");
      debugPrint(
          "District Name: ${loginController.userDetails.value?.user?.hospital?.districtname}");
      debugPrint(
          "API Hospital: ${loginController.userDetails.value?.user?.hospital?.hospitalname108}");
      debugPrint(
          "User Type ID: ${loginController.userDetails.value?.user?.username}");
      debugPrint("UID: ${loginController.userDetails.value?.user?.id}");

      if (response.body.isNotEmpty) {
        log("TransitCare New LIst: ${response.body}");
        final parsed = transitCareResponseFromJson(response.body);
        NewTransitCareList.assignAll(parsed.data ?? []);
        totalPages.value = parsed.pageCount ?? 1;
        currentPage.value++;
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      isLoading.value = false;
      log("getTransitCareList error: $ex");
      return false;
    }
  }

  List<TransitCareModel> get paginatedList {
    if (NewTransitCareList.isEmpty) return [];

    int startIndex = (currentPage.value - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    // clamp startIndex
    if (startIndex < 0) startIndex = 0;

    // clamp endIndex
    if (endIndex > NewTransitCareList.length) {
      endIndex = NewTransitCareList.length;
    }

    // if startIndex is already past the list length, reset to last page
    if (startIndex >= NewTransitCareList.length) {
      currentPage.value = (NewTransitCareList.length / itemsPerPage)
          .ceil()
          .clamp(1, double.infinity)
          .toInt();
      startIndex = (currentPage.value - 1) * itemsPerPage;
      endIndex = NewTransitCareList.length;
    }
    return NewTransitCareList.sublist(startIndex, endIndex);
  }

  /// Transit Care Dash borard
  ///api/summary/TransitCare?start_date=2025-08-01 00:00:00&end_date=2025-09-30 23:59:59
}
