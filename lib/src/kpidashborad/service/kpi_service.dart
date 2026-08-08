import 'dart:convert';
import 'dart:developer';

import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/snackbar_helper.dart';
import '../../report_dashboard/models/institution_model.dart';

class KpiService {
  static final _client = CustomHttpHelper();
  static Future<List<InstitutionModel>> getInstitutionList(
      {required int district_id, required int dirId}) async {
    try {
      var data = {"district_id": district_id, "directorate_id": dirId};
      var url = Uri.parse(Urls.getInstitutionById).replace(
          queryParameters:
              data.map((key, value) => MapEntry(key, value.toString())));
      var response = await _client.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      log("eeeee" + response.body.toString());
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return institutionModelFromJson(response.body);
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return [];
      }
    } catch (ex) {
      log("zzzzz" + ex.toString());
      return [];
    }
  }
}
