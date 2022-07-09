import 'dart:convert';

import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/model/product_data.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/product/model/units_model.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class ProductProvider {
  static Future createProduct(Map<String, dynamic> body) async {
    // var _navState = new GlobalKey<NavigatorState>();
    await DioService.checkConnection(tryAgainMethod: createProduct, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var createProduct = await dio.createProduct(body);
      if(createProduct.meta.code! < 300){
        // Navigator.pop(_navState.currentContext!);
      }
    });
  }

  static Future<List<ProductModel>> listProduct() async{
    List<ProductModel> listProduct = [];
    await DioService.checkConnection(tryAgainMethod: listProduct, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.listProduct();
      if(list.meta.code! < 300){
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          print("$encode");
          listProduct.add(ProductModel.fromJson(jsonDecode(encode)));
        }
      }
    });

    var listProductDB = await ProductBloc().getProductListDB();
    print("listProductDB ${listProductDB.length}");
    for(int i = 0; i < listProduct.length; i++){
      var check = listProductDB.where((element) => element.id == listProduct[i].product?.productId).toList();
      if(check.length < 1){
        print("SAVE NEW PRODUCT");
        await ProductBloc().saveProductToDB(listProduct[i]);
      }else{
        print("UPDATE PRODUCT");
        await ProductBloc().updateProductToDB(listProduct[i]);
      }
    }
    return listProduct;
  }

  static Future<List<ProductModel>> refreshProduct() async{
    await Hive.deleteBoxFromDisk("product_db");
    var box = await Hive.openBox<ProductModelDB>("product_db");
    List<ProductModel> listProduct = [];
    await DioService.checkConnection(tryAgainMethod: listProduct, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.listProduct();

      if(list.meta.code! < 300){
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          String encodeProduct = jsonEncode(list.data[i]['product']);
          print("$encodeProduct");
          var data = ProductData.fromJson(jsonDecode(encodeProduct));
          String createdAt = await Core.dateConverter(DateTime.tryParse(data.createdAt));
          ProductData productData = data;
          productData.createdAt = createdAt;
          print("createdAt Refrest $createdAt");
          ProductModelDB productDb = ProductModelDB(
            id: productData.productId,
            createdAt: createdAt,
            description: productData.description,
            productId: productData.productId,
            barcode: productData.barcode,
            name: productData.name,
            salePrice: productData.salePrice,
            originalPrice: productData.originalPrice,
            code: productData.code,
            stock: productData.lastStock,
            unitsId: productData.unitId,
            unitsName: productData.unit
          );
          print("refreshProduct ${productDb.createdAt}");
          // productDb.unitsName = list.data[i]['unit'];
          // productDb.unitsId = list.data[i]['unit_id'];
          box.add(productDb);
          listProduct.add(ProductModel(product: productData));
        }
      }
    });
    print("product db ${jsonEncode(box.values.toList())}");
    return listProduct;
  }

  static Future<List<UnitsModel>> getListProductUnits() async{
    List<UnitsModel> listUnits = [];
    await DioService.checkConnection(tryAgainMethod: listProduct, isUseBearer: true).then((value) async {
      var dio = DioClient(value);
      var list = await dio.getListProductUnits();
      if(list.meta.code! < 300){
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          print("$encode");
          listUnits.add(UnitsModel.fromJson(jsonDecode(encode)));
        }
      }
    });

    return listUnits;
  }

  static Future<bool> requestCreateMerchantProduct(Map<String, dynamic> body) async {
    bool isSuccess = false;
    GlobalFunctions.logPrint("requestCreateMerchantProduct", body.toString());
    await DioService.checkConnection(tryAgainMethod: requestCreateMerchantProduct, isUseBearer: true, isLoading: true).then((value) async {
      print('dio value -> $value');
      var dio = DioClient(value);
      var requestTransaction = await dio.requestCreateMerchantProduct(body);
      GlobalFunctions.logPrint("requestCreateMerchantProduct", requestTransaction.toJson());
      if(requestTransaction.meta.code! < 300){
        isSuccess = true;
      } else if(requestTransaction.meta.code! == 402){
        isSuccess = false;
      } else {
        isSuccess = false;
      }
      GlobalFunctions.logPrint("Status requestCreateMerchantProduct", '$isSuccess');
    });
    return isSuccess;
  }

}