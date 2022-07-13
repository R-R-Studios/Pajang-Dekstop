import 'dart:convert';

import 'package:beben_pos_desktop/reports/receivings/model/report_receivings_model.dart';
import 'package:beben_pos_desktop/reports/receivings/model/response_report_receivings_model.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class ReportReceivingsProvider {
  static Future<List<ReportReceivingsModel>> searchReportReceivings(
      String merchantId,
      String productName,
      String startDate,
      String endDate) async {
    List<ReportReceivingsModel> list = [];
    await DioService.checkConnection(isUseBearer: true, tryAgainMethod: null)
        .then((value) async {
      var dio = DioClient(value);
      var searchReport = await dio.searchReportReceivings(
          merchantId, productName, startDate, endDate);
      if (searchReport.meta.code! < 300) {
        ResponseReportReceivingsModel response =
            ResponseReportReceivingsModel.fromJson(
                jsonDecode(jsonEncode(searchReport.data)));
        print("ResponseReportReceivingsModel ${jsonEncode(response)}");
        for (var i = 0; i < response.report!.length; i++) {
          list.add(response.report![i]);
        }
      }
    });
    print("LIST ReportReceivingsProvider ${list.length}");
    return list;
  }
}
