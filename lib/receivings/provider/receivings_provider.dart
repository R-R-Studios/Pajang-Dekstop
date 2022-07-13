import 'dart:convert';

import 'package:beben_pos_desktop/receivings/bloc/receivings_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/preview_transaction_po.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/service/model/core_model.dart';
import 'package:beben_pos_desktop/service/model/meta.dart';
import 'package:beben_pos_desktop/db/merchant_product_db.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class ReceivingsProvider {
  static Future<List<MerchantProductDB>> merchantListProduct(
      String search, String type) async {
    List<MerchantProductDB> listProduct = [];
    await DioService.checkConnection(
            tryAgainMethod: merchantListProduct, isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var list = await dio.listMerchantProduct(search, type);
      if (list.meta.code! < 300) {
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          listProduct.add(MerchantProductDB.fromJson(jsonDecode(encode)));
        }
      }
    });

    return listProduct;
  }

  static Future<CoreModel> createReceivings(Map<String, dynamic> body) async {
    // var _navState = new GlobalKey<NavigatorState>();
    CoreModel? coreModel;
    await DioService.checkConnection(
            isLoading: true,
            tryAgainMethod: createReceivings,
            isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var createProduct = await dio.createProduct(body);
      coreModel = createProduct;
    });
    return coreModel ?? CoreModel(meta: Meta());
  }

  static Future<List<ProductReceivingsModel>> listProductReceivings(
      String typePrice) async {
    List<ProductReceivingsModel> listProduct = [];
    await DioService.checkConnection(
            tryAgainMethod: listProductReceivings, isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var list = await dio.listProductReceivings(typePrice);
      if (list.meta.code! < 300) {
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          print("PRINT ENCODE $encode");
          listProduct.add(ProductReceivingsModel.fromJson(jsonDecode(encode)));
        }
      }
    });
    var listProductDB = await ReceivingsBloc().productReceivingsDB();
    print("listProductDB ${listProductDB.length}");
    for (int i = 0; i < listProduct.length; i++) {
      var check = listProductDB
          .where((element) => element.id == listProduct[i].id)
          .toList();
      if (check.length < 1) {
        await ReceivingsBloc().saveProductReceivingsToDB(listProduct[i]);
      } else {
        await ReceivingsBloc().updateProductReceivingsToDB(listProduct[i]);
      }
    }

    return listProduct;
  }

  static Future<PreviewTransactionPO> searchTransactionPO(
      Map<String, dynamic> body) async {
    PreviewTransactionPO transactionPO = PreviewTransactionPO();
    await DioService.checkConnection(
            isLoading: true,
            tryAgainMethod: searchTransactionPO,
            isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var searchPO = await dio.searchTransactionPO(body);
      if (searchPO.meta.code! < 300) {
        transactionPO = PreviewTransactionPO.fromJson(
            jsonDecode(jsonEncode(searchPO.data)));
      }
    });
    return transactionPO;
  }
}
