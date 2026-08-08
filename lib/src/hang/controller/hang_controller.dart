import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/hang/model/hanging_dashboard_model.dart';
import 'package:taei_gov/src/hang/model/hanging_list_model.dart';
import 'package:taei_gov/src/hang/model/hanging_model.dart';
import 'package:taei_gov/src/hang/model/look_up.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import '../../../utils/helpers/loading_helper.dart';
import '../model/hangDetails.dart';
import '../service/hang_service.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class HangController extends GetxController {
  RxInt currentIndex = 0.obs;
  var lookupList = Rxn<HangingLookup>();
  RxBool isLookupLoading = true.obs;
  var hangingStartDate = Rxn<DateTime>();
  var hangingEndDate = Rxn<DateTime>();
  var hangingDashboard = HangingDashBoard().obs;

  var hangingDataMap = <String, String>{}.obs;
  static final _client = CustomHttpHelper();

  Rx<HangingDetails> hangDetails = HangingDetails().obs;

  Future<bool> getLookup() async {
    isLookupLoading(true);
    try {
      lookupList.value = null;
      var data = await HangingService.getLookup();
      if (data != null) {
        lookupList.value = data;
        isLookupLoading(false);
        return true;
      } else {
        isLookupLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  var hangModel = Rxn<HangingModel>();

  Future<bool> createHang() async {
    loadingIndicator(Get.context!);
    try {
      log(hangModel.toJson().toString());
      var data = await HangingService.createHang(data: hangModel.value!);
      if (data) {
        Get.back();
        getHangList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getHangingDashboard(
            startDate: DateFormat('yyyy-MM-dd 00:00:00')
                .format(DateTime.now().subtract(Duration(days: 7))),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()));
        return true;
      } else {
        Get.back();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //var hangList = Rxn<HangingListModel>();
  var hangingList = <HangingListData>[].obs;
  RxBool isHangLoading = true.obs;

  // Future<bool> getHangList({
  //   required String startDate,
  //   required String endDate,
  // }) async {
  //   try {
  //     hangList.value = null;
  //     var data = await HangingService.getHangingList(
  //       startDate: startDate,
  //       endDate: endDate,
  //     );
  //     log(data.toString());
  //     if (data != null) {
  //       hangList.value = data;
  //
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
  /// Pagination
  var hangingCurrentPage = 1.obs;
  var hangingTotalPages = 1.obs;
  final int hangingLimit = 20;
  var hangingTotalCount = 0.obs;
  RxString dischargeStatus = ''.obs;

  var searchText = "".obs;

// filtered list getter
  List<HangingListData> get filteredHangingList {
    if (searchText.value.isEmpty) {
      return hangingList;
    }
    return hangingList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getHangList({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1, // offset in your API
  }) async {
    try {
      var url = Uri.parse(Urls.getHangingRecord +
          "?limit=$hangingLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
      var response = await _client.get(url);
      log('Test HangList ${response.body}');
      if (response.body.isNotEmpty) {
        var list = hangingListModelFromJson(response.body);
        hangingList.assignAll(list.rows ?? []);
        log('getTrauma123 response: ${hangingList.toString()}');
        hangingTotalCount.value = list.totalCount ?? 0;
        hangingTotalPages.value = (hangingTotalCount.value / hangingLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        hangingStartDate.value = DateTime.parse(startDate);
        hangingEndDate.value = DateTime.parse(endDate);
        hangingCurrentPage.value = pageNumber;
        log('getTrauma response: ${hangingList.toString()}');
        Fluttertoast.showToast(msg: "Data loaded successfully");

        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getListEmo error: $ex");
      return false;
    }
  }

  Future<bool> getHangingDashboard(
      {required String startDate, required String endDate}) async {
    try {
      var url = Uri.parse(Urls.getHangingDashboard +
          "?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('getEmoLookup response: ${response.body}');

      if (response.body.isNotEmpty) {
        var list = hangingDashBoardFromJson(response.body);
        hangingDataMap.value = {
          "Total": list.first.total.toString(),
          "IFT": list.first.ift.toString(),
          "Admitted": list.first.admitted.toString(),
          "Pending": list.first.pending.toString(),
          "Accidental": list.first.accidental.toString(),
          "Homicidal": list.first.homicidal.toString(),
          "Suicidal": list.first.suicidal.toString(),
          "Complete Hanging": list.first.completeHanging.toString(),
          "Partial Hanging": list.first.partialHanging.toString(),
        };
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getEmoLookup error: $ex");
      return false;
    }
  }

  RxBool isUpdateHangLoading = true.obs;

  Future<bool> getHangById(id) async {
    isUpdateHangLoading(true);
    try {
      hangModel.value = null;
      var data = await HangingService.getHangById(id);
      log(data.toString());
      if (data != null) {
        hangModel.value = data;
        isUpdateHangLoading(false);
        return true;
      } else {
        isUpdateHangLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateHang() async {
    loadingIndicator(Get.context!);
    try {
      log(hangModel.toJson().toString());
      var data = await HangingService.updateHang(data: hangModel.value!);
      if (data) {
        Get.back();
        getHangList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getHangingDashboard(
            startDate: DateFormat('yyyy-MM-dd 00:00:00')
                .format(DateTime.now().subtract(Duration(days: 7))),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()));
        return true;
      } else {
        Get.back();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> getHangDetails({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getTriageDetails + id);
      var response = await _client.get(url);
      log('Triage Details: ${response.body}');
      if (response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        hangDetails.value = HangingDetails.fromJson(d);
        Fluttertoast.showToast(msg: 'Details Fetched Successfully');
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }
}
