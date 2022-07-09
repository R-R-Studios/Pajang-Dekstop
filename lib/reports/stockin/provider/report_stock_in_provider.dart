import 'dart:convert';

import 'package:beben_pos_desktop/reports/stockin/model/report_stock_in_model.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';

class ReportStockInProvider {
  static Future<List<ReportStockInModel>> searchReportStockIn(String merchantId, String startDate, String endDate) async {
    List<ReportStockInModel> list = [];
    await DioService.checkConnection(isUseBearer: true, tryAgainMethod: null).then((value) async {
      var dio = DioClient(value);
      var searchReport = await dio.searchReportStockIn(merchantId, startDate, endDate);
      if(searchReport.meta.code! < 300){
        for (var i = 0; i < searchReport.data.length; i++) {
          list.add(ReportStockInModel.fromJson(jsonDecode(jsonEncode(searchReport.data[i]))));
        }
      }
    });
    print("LIST Report Stock In ${list.length}");
    return list;
  }
}