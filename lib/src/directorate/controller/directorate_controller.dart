import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/directorate/model/directorate_list_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import '../../../constants/urls.dart';

class DirectorateController extends GetxController {
  var isLoading = false.obs;
  static final _client = CustomHttpHelper();
  var directorateList = <DirectorateListModel>[].obs;
  var selectedDirectorateId = 0.obs;

  // var selectedDirectorateIdString= "".obs;

  Future<bool> getDirectorateListData() async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.getDirectorate);
      var response =
          await _client.get(url, headers: {"Content-Type": "application/json"});
      log("PPPPPP${response.body}");
      if (response.body.isNotEmpty) {
        log("listttttt${response.body}");
        var data = directorateListModelFromJson(response.body);
        if (data.length > 1) {
          directorateList.value = [
            DirectorateListModel(
              id: 0,
              name: "All Directorate",
            ),
            ...data,
          ];
        }

        log("KKKKK${directorateList.toString()}");
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
