import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/hospital/model/hospital_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class HospitalController extends GetxController {
  var isLoading = false.obs;
  var hospitalList = <Hospital>[].obs;

  //RxList<String> hospital108List = <String>[].obs;
  RxString selectedHospital = "Select Hospital Name".obs;
  static final _client = CustomHttpHelper();

  Future<bool> getHospitalListData() async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.getHospitalList);
      var response =
          await _client.get(url, headers: {"Content-Type": "application/json"});
      log("PPPPPP${response.body}");
      if (response.body.isNotEmpty) {
        log("listttttt${response.body}");
        var data = hospitalListModelFromJson(response.body);
        hospitalList.assignAll(data.hospitals ?? []);
        // hospital108List.assignAll(
        //   hospitalList
        //       .map((h) => h.hospitalname108)
        //       .where((name) => name != null && name.isNotEmpty)
        //       .cast<String>()
        //       .toList(),
        // );
        log("KKKKK${hospitalList.toString()}");
        Fluttertoast.showToast(msg: "Data loaded successfully");
        isLoading.value = false;
        return true;
      } else {
        Fluttertoast.showToast(msg: "No data found");
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
