import 'dart:convert';
import 'dart:developer';

import 'package:taei_gov/src/burn/models/burn_lookup_model.dart';
import 'package:taei_gov/src/burn/models/create_burn_model.dart';

import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/snackbar_helper.dart';

class BurnService {
  static final _client = CustomHttpHelper();

  static Future<bool> createBurn({required BurnsModel data}) async {
    try {
      log(data.toJson().toString());
      var url = Uri.parse(Urls.createBurnRecord);
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
  static Future<List<BurnsModel>?> getBurnList() async {
    try {
      var url = Uri.parse(Urls.getBurnRecord);
      var response = await _client.post(
        url,
        headers: {"Content-Type": "application/json"},
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return d["data"]
            .map<BurnsModel>((json) => BurnsModel.fromJson(json))
            .toList();
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  // get list
  static Future<BurnLookupModel?> getLookup() async {
    try {
      var url = Uri.parse(Urls.getBurnLookup);
      var response = await _client.get(
        url,
      );
      log(response.body);
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return burnLookupModelFromJson(response.body);
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return null;
      }
    } catch (ex) {
      return null;
    }
  }
}
