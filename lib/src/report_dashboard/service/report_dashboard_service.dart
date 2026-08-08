import 'dart:convert';
import 'dart:developer';

import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/snackbar_helper.dart';
import '../models/institution_model.dart';

class ReportDashboardService {
  static final _client = CustomHttpHelper();
  static Future<String?> getData(
      {required String startDate,
      required String endDate,
      required int reportType,
      required String institutionId,
      String? districtId,
      int? directorateId}) async {
    try {
      var data = {
        "from_date": startDate,
        "to_date": endDate,
        "report_type": reportType,
        "institution_id": institutionId.toString(),
        "district_id": districtId ?? 0,
        "directorate_id": directorateId ?? 0,
      };
      log(data.toString());
      var url = Uri.parse(Urls.reportDashboard);
      var response = await _client.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
        },
      );
      log("eeeee" + response.body.toString());
      var d = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        showAppSnackbar(
            title: "Failed", message: d["message"], isSuccess: true);

        return null;
      }
    } catch (ex) {
      log("zzzzz" + ex.toString());
      return null;
    }
  }

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
