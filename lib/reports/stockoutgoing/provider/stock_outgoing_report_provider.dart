

import 'dart:convert';

import 'package:beben_pos_desktop/reports/stockoutgoing/model/stock_outgoing_model.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class StockOutgoingReportProvider {

  static Future<List<StockOutgoingModel>> getReportProduct(String authToken, String startDate, String endDate) async{
    List<StockOutgoingModel> listProduct = [];
    await DioService.checkConnection(tryAgainMethod: getReportProduct, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.getReportStockOutgoing(authToken, startDate, endDate);
      if(list.meta.code! < 300){
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          listProduct.add(StockOutgoingModel.fromJson(jsonDecode(encode)));
        }
      }
    });

    return listProduct;
  }
}