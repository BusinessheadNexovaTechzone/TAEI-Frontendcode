import 'dart:convert';
import 'dart:developer';

import 'package:taei_gov/src/drowning/models/drowning_list_model.dart';
import 'package:taei_gov/src/drowning/models/drowning_lookup_model.dart';
import 'package:taei_gov/src/drowning/models/drowning_model.dart';

import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/snackbar_helper.dart';

class DrowningService {
  static final _client = CustomHttpHelper();

  static Future<bool> CreateDrowning({required DrowningModel data}) async {
    try {
      log(data.toJson().toString());
      var url = Uri.parse(Urls.createDrowningRecord);
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

  static Future<DrowningListModel?> getDrowningList({
    required String startDate,
    required String endDate,
  }) async {
    try {
      // Add start and end date as query parameters
      final url = Uri.parse(Urls.getDrowningRecord).replace(
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      final response = await _client.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      log("getDrowningList response: ${response.statusCode} | ${response.body}");

      final d = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return drowningListModelFromJson(response.body);
      } else {
        showAppSnackbar(
          title: "Failed",
          message: d["message"] ?? "Unable to fetch drowning records",
          isSuccess: false,
        );
        return null;
      }
    } catch (ex) {
      log("getDrowningList exception: $ex");
      return null;
    }
  }


  // get lookup list
  static Future<DrowninglookupModel?> getLookup() async {
    try {
      var url = Uri.parse(Urls.drowningLookup);
      var response = await _client.get(
        url,
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return drowninglookupModelFromJson(response.body);
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
  static Future<DrowningModel?> getHangById(id) async {
    try {
      var url = Uri.parse(Urls.getDrowningRecordById + id);
      var response = await _client.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return drowningModelFromJson(response.body);
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
  static Future<bool> updateHang({required DrowningModel data}) async {
    try {
      log(data.toJson().toString());
      var url = Uri.parse(Urls.updateDrowningRecord);
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
