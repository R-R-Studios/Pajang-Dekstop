import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/db/merchant_product_db.dart';
import 'package:beben_pos_desktop/sales/model/response_status_transaction.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:hive/hive.dart';

class SalesProvider {
  static Future<ResponseStatusTransaction> requestTransaction(
      Map<String, dynamic> body) async {
    GlobalFunctions.logPrint("requestSession", body.toString());
    ResponseStatusTransaction responseStatusTransaction =
        ResponseStatusTransaction(
            status: true, transactionCode: "", responseCode: "");
    await DioService.checkConnection(
            tryAgainMethod: requestTransaction,
            isUseBearer: true,
            isLoading: true)
        .then((value) async {
      print('dio value -> $value');
      var dio = DioClient(value);
      var requestTransaction = await dio.requestMerchantTransaction(body);
      GlobalFunctions.logPrint(
          "merchant_transaction", requestTransaction.toJson());
      responseStatusTransaction =
          ResponseStatusTransaction.fromJson(requestTransaction.data);
      if (requestTransaction.meta.code! < 300) {
        responseStatusTransaction.status = true;
        responseStatusTransaction.responseCode =
            '${requestTransaction.meta.code}';
      } else if (requestTransaction.meta.code! == 402) {
        responseStatusTransaction.status = true;
        responseStatusTransaction.responseCode =
            '${requestTransaction.meta.code}';
      } else {
        responseStatusTransaction.status = false;
        responseStatusTransaction.responseCode = "500";
      }
    });
    return responseStatusTransaction;
  }

  static Future<List<MerchantProductDB>> merchantListProduct(
      String search, String type) async {
    List<MerchantProductDB> listProduct = [];
    String selectedType = "0";
    if (type == "Retail") {
      selectedType = "0";
    } else if (type == "E-Commerce") {
      selectedType = "1";
    } else if (type == "Agen") {
      selectedType = "2";
    }
    await DioService.checkConnection(
            tryAgainMethod: listProduct, isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var list = await dio.listMerchantProduct(search, selectedType);
      if (list.meta.code! < 300) {
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          print("JSON ENCODE ${jsonDecode(encode)}");
          listProduct.add(MerchantProductDB(
            salePrice: "100000",
            name: "Product Test Unit",
            barcode: "XYZ123",
            id: 123,
            currentPrice: "100000",
            qty: "10",
          ));
          listProduct.add(MerchantProductDB.fromJson(jsonDecode(encode)));
        }
      }
    });

    return listProduct;
  }

  static Future getProducts() async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    List<ProductModel> productList = productModel.cast<ProductModel>();
    GlobalFunctions.logPrint("productModel", "${productList[0].item}");
    GlobalFunctions.logPrint("productModel", "${productList[0].itemName}");
    GlobalFunctions.logPrint("productModel", "${productList[0].price}");
    GlobalFunctions.logPrint("productModel", "${productList[0].quantity}");
    GlobalFunctions.logPrint("productModel", "${productList[0].disc}");
    GlobalFunctions.logPrint("productModel", "${productList[0].total}");
    GlobalFunctions.logPrint(
        "salesModel from product", "${productList[1].toJson()}");
    return productList;
  }

  static Future requestReturnTransaction(Map<String, dynamic> body) async {
    GlobalFunctions.logPrint("requestReturnTransaction", body.toString());
    await DioService.checkConnection(
            tryAgainMethod: requestReturnTransaction,
            isUseBearer: true,
            isLoading: true)
        .then((value) async {
      print('dio value -> $value');
      var dio = DioClient(value);
      var requestTransaction = await dio.requestReturnTransaction(body);
      GlobalFunctions.logPrint(
          "requestReturnTransaction", requestTransaction.toJson());
      if (requestTransaction.meta.code! < 300) {
      } else if (requestTransaction.meta.code! == 402) {
      } else {}
    });
  }
}
