import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'package:universal_html/universal_html.dart' as html;

class TAEIReportDashboardController extends GetxController {
  static final _client = CustomHttpHelper();
  var selectedPillar = 3.obs;
  var StartDate = Rxn<DateTime>();
  var EndDate = Rxn<DateTime>();
  final LoginController loginController = Get.find();

  Future<bool> getTAEIReportDashboard({
    required String startDate,
    required String endDate,
    required int reportType,
    required String institutionId,
    String? districtId,
    String? directorateId,
  }) async {
    final uri = Uri.parse(Urls.getTaeiReportDashboard).replace(
      queryParameters: {
        "report_type": reportType.toString(),
        "from_date": startDate,
        "to_date": endDate,
        "institution_id": institutionId.toString(),
        "district_id":
            districtId ?? loginController.districtId.value.toString(),
        "directorate_id":
            directorateId ?? loginController.directorateId.value.toString(),
      },
    );

    html.AnchorElement(href: uri.toString())
      ..setAttribute("download", "TAEI_Report.xlsx")
      ..setAttribute("target", "_blank")
      ..click();

    return true;
  }
}
