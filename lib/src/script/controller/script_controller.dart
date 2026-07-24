import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/script/models/create_script_model.dart';
import 'package:taei_gov/src/script/models/script_list_model.dart';
import 'package:taei_gov/src/script/models/stroke_dashBoard_model.dart';
import 'package:taei_gov/src/script/service/script_service.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

import '../../../utils/helpers/loading_helper.dart';
import '../models/script_lookup_model.dart';

class ScriptController extends GetxController {
  RxnString selectedRefer = RxnString();
  static final _client = CustomHttpHelper();

  var seletedLysis = Rxn<String>();
  var seletedCBG = Rxn<String>();
  var seletedCTScan = Rxn<String>();
  var seletedMRI = Rxn<String>();
  var seletedLysisInside = Rxn<String>();
  var selectedThrombctomy = Rxn<String>();
  var selectedCraniectomy = Rxn<String>();

  var strokeDashboard = StrokeDashBoard().obs;
  var strokeDataMap = <String, String>{}.obs;

  var lookupList = Rxn<ScriptLookupModel>();
  RxBool isLookupLoading = true.obs;
  RxBool isLoading = false.obs;

  var scriptStartDate = Rxn<DateTime>();
  var scriptEndDate = Rxn<DateTime>();

  Future<bool> getLookup() async {
    isLookupLoading(true);
    try {
      lookupList.value = null;
      var data = await ScriptService.getLookup();
      log("script Lookup ${data.toString()}");
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

  // var scriptModel = Rxn<CreateScriptModel>();
  // Rx<BurnsModel> burnFormData = BurnsModel(
  //   burns: Burns(),
  //   burnsOutcome: BurnsOutcome(),
  //   burnsValues: BurnsValues(),
  //   burnsTbsa: BurnsTbsa(),
  //   burnsSurgeryElective: [BurnsSurgeryElective()],
  // ).obs;
  Rx<CreateScriptModel> scriptModel = CreateScriptModel(
    stroke: Stroke(),
    outcome: Outcome(),
  ).obs;
  var isName = Rxn<bool>();

  // Future<bool> createScript() async {
  //   loadingIndicator(Get.context!);
  //   try {
  //     log(scriptModel.toJson().toString());
  //     var data = await ScriptService.createScript(data: );
  //     if (data) {
  //       Get.back();
  //       return true;
  //     } else {
  //       Get.back();
  //       return false;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  Future<bool> createScript({required CreateScriptModel data}) async {
    try {
      isLoading.value = true;
      log(data.toString());
      var url = Uri.parse(Urls.createScript);
      var response = await _client.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toCleanJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "Data created successfully");
        isLoading.value = false;
        Get.back();
        getScriptList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getStrokeDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> getScriptById({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getScriptById + id);
      var response = await _client.get(
        url,
      );
      print(url);
      log('getPoi response: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        scriptModel.value = CreateScriptModel(
          stroke: Stroke.fromJson(d['stroke']),
          outcome: Outcome.fromJson(d['outcome']),
        );
        print("TEst Added SCript${scriptModel.value.toString()}");
        Fluttertoast.showToast(msg: "Data loaded successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  Future<bool> updateScript(
      {required CreateScriptModel data, required String id}) async {
    try {
      isLoading.value = true;
      var url = Uri.parse(Urls.updateScript + id);
      var response = await _client.put(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toJson()));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('updatePoison response: ${response.body}');
        Fluttertoast.showToast(msg: "Data updated successfully");
        isLoading.value = false;
        Get.back();
        getScriptList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getStrokeDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      isLoading.value = false;
      return false;
    }
  }

  var scriptList = <ScriptListData>[].obs;
  RxBool isScriptLoading = true.obs;

  /// Pagination
  var scriptCurrentPage = 1.obs;
  var scriptTotalPages = 1.obs;
  final int scriptLimit = 20;
  var scriptTotalCount = 0.obs;
  var dischargeStatus = "".obs;
  var searchText = "".obs;

// filtered list getter
  List<ScriptListData> get filteredScriptList {
    if (searchText.value.isEmpty) {
      return scriptList;
    }

    return scriptList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getScriptList({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1, // offset in your API
  }) async {
    try {
      var url = Uri.parse(Urls.getScriptList +
          "list?limit=$scriptLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
      var response = await _client.get(url);

      log(response.body);

      if (response.body.isNotEmpty) {
        var list = scriptListModelFromJson(response.body);
        scriptList.assignAll(list.rows ?? []);
        log('getscript123 response: ${scriptList.toString()}');
        scriptTotalCount.value = list.totalCount ?? 0;
        scriptTotalPages.value = (scriptTotalCount.value / scriptLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        scriptStartDate.value = DateTime.parse(startDate);
        scriptEndDate.value = DateTime.parse(endDate);
        scriptCurrentPage.value = pageNumber;
        log('getscript response: ${scriptList.toString()}');
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

  Future<bool> getStrokeDashboard(
      {required String startDate, required String endDate}) async {
    try {
      var url = Uri.parse(
          Urls.getStrokeDashboard + "?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('getEmoLookup response: ${response.body}');
      if (response.body.isNotEmpty) {
        //"total": total,
        //         "ischemic": ischemic,
        //         "hemorrhagic": hemorrhagic,
        //         "ift": ift,
        //         "admitted": admitted,
        //         "pending": pending,
        var list = strokeDashBoardFromJson(response.body);
        strokeDashboard.value = list.first ?? StrokeDashBoard();
        strokeDataMap.value = {
          "Total": strokeDashboard.value.total.toString(),
          "Ischemic": strokeDashboard.value.ischemic.toString(),
          "Hemorrhagic": strokeDashboard.value.hemorrhagic.toString(),
          "IFT": strokeDashboard.value.ift.toString(),
          "Admitted": strokeDashboard.value.admitted.toString(),
          "Pending": strokeDashboard.value.pending.toString(),
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
}
