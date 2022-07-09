
import 'dart:convert';

import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction_model.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class SalesTransactionReportProvider {

  //! old Version
  static Future<List<SalesTransactionModel>> getReportSalesTransaction(String fromDate, String toDate) async{
    List<SalesTransactionModel> listData = [];
    await DioService.checkConnection(tryAgainMethod: getReportSalesTransaction, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.getReportSalesTransaction(fromDate, toDate);
      if(list.meta.code! < 300){
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          listData.add(SalesTransactionModel.fromJson(jsonDecode(encode)));
        }
      }
    });

    return listData;
  }

  // New Version
  static Future<List<ReportTransaction>> getReportSalesTransactionV2(String fromDate, String toDate) async{
    List<ReportTransaction> listData = [];
    await DioService.checkConnection(tryAgainMethod: getReportSalesTransaction, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.getReportSalesTransactionV2(fromDate, toDate);
      if(list.meta.code! < 300){
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          listData.add(ReportTransaction.fromJson(jsonDecode(encode)));
        }
      }
    });

    return listData;
  }

  static Future<ReportTransaction> getDetailReportSalesTransaction(String codeTransaction) async{
    late ReportTransaction reportData;
    await DioService.checkConnection(tryAgainMethod: getReportSalesTransaction, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.getDetailReportSalesTransactionV2(codeTransaction);
      if(list.meta.code! < 300){
        reportData = ReportTransaction.fromJson(list.data);
      }
    });

    return reportData;
  }
}