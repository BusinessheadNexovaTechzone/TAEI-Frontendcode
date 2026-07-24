import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:taei_gov/src/script/models/create_script_model.dart';
import 'package:taei_gov/src/script/models/script_list_model.dart';
import 'package:taei_gov/src/script/models/script_lookup_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

import '../../../constants/urls.dart';

class ScriptService {
  static final _client = CustomHttpHelper();

  static Future<bool> createScript({required CreateScriptModel data}) async {
    try {
      var url = Uri.parse(Urls.createScript);
      var response = await _client.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data.toJson()));
      log(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log(ex.toString());
      return false;
    }
  }

  static Future<ScriptLookupModel?> getLookup() async {
    try {
      var url = Uri.parse(Urls.scriptLookup);
      var response = await _client.get(
        url,
      );

      if (response.statusCode == 200) {
        return scriptLookupModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  static Future<ScriptListModel?> getScriptList({
    required String startDate,
    required String endDate,
    required int pageNumber,
  }) async {
    try {
      //?limit=10&offset=1&start_date=2025-10-13 00:00:00&end_date=2025-10-28 23:59:59
      var url = Uri.parse(Urls.getScriptList +
          "?limit=10&offset=1&start_date=$startDate&end_date=$endDate");
      var response = await _client.get(
        url,
      );
      log("errr${response.body}");
      if (response.statusCode == 200) {
        return scriptListModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (ex) {
      log(ex.toString());
      return null;
    }
  }

  /// Update
// static Future<bool> updateTriage({required CreateTriageModel data}) async {
//   try {
//     var url = Uri.parse(Urls.updateTriage);
//     var response = await _client.put(url, headers: {
//       "Content-Type": "application/json",
//     });
//     log(response.body.toString());
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Fluttertoast.showToast(msg: "Triage Created Successfully");
//       return true;
//     } else {
//       return false;
//     }
//   } catch (ex) {
//     log(ex.toString());
//     return false;
//   }
// }
}
