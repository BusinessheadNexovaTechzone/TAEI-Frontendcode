import 'dart:convert';
import 'dart:developer';

import 'package:taei_gov/src/hang/model/hanging_list_model.dart';
import 'package:taei_gov/src/hang/model/hanging_model.dart';
import 'package:taei_gov/src/hang/model/look_up.dart';

import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/snackbar_helper.dart';

class HangingService {
  static final _client = CustomHttpHelper();

  static Future<bool> createHang({required HangingModel data}) async {
    try {
      log(data.toJson().toString());
      var url = Uri.parse(Urls.createHangingRecord);
      var response = await _client.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data.toJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  // get list
  static Future<HangingListModel?> getHangingList({
    required String startDate,
    required String endDate,
  }) async {
    try {
      var url = Uri.parse(Urls.getHangingRecord +
          "?limit=15&offset=1&start_date=$startDate&end_date=$endDate");
      var response = await _client.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return hangingListModelFromJson(response.body);
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  // get lookup list
  static Future<HangingLookup?> getLookup() async {
    try {
      var url = Uri.parse(Urls.hangingLookupList);
      var response = await _client.get(
        url,
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return hangingLookupFromJson(response.body);
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return null;
      }
    } catch (ex) {
      return null;
    }
  }

// get by id
  static Future<HangingModel?> getHangById(id) async {
    try {
      var url = Uri.parse(Urls.getHangingRecordById + id);
      var response = await _client.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return hangingModelFromJson(response.body);
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  // update
  static Future<bool> updateHang({required HangingModel data}) async {
    try {
      log(data.toJson().toString());
      var url =
          Uri.parse(Urls.updateHangingRecord + data.hanging!.id.toString());
      var response = await _client.put(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data.toJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }
}
