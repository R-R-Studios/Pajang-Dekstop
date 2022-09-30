import 'dart:convert';
import 'dart:io';

import 'package:beben_pos_desktop/content/model/product_price_update.dart';
import 'package:beben_pos_desktop/content/view/dialog_product_price.dart';
import 'package:beben_pos_desktop/content/widget/product_widget.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/product/model/request_create_product_merchant.dart';
import 'package:beben_pos_desktop/product/provider/product_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:nav_router/nav_router.dart';
import 'package:rxdart/subjects.dart';

import '../../core/fireship/fireship_encrypt.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductLoading()){
    onGetProduct();
  }

  List<File?> _listImage = List.filled(5, null);

  BehaviorSubject<List<File?>> listImageController = BehaviorSubject();

  Stream<List<File?>> get listImage => listImageController.stream;

  int productId = -1;

  onGetProduct() async {
    var list = await ProductProvider.refreshProduct();
    emit(ProductLoaded(listProduct: list));
  }

  changeScreen(int key){
    switch (key) {
      case 1: 
        emit(ProductLoading());
        onGetProduct();
        break;
      case 2: 
        listImageController.sink.add(_listImage);
        emit(ProductAdd());
        break;
      default:
    }
  }

  addProductPhoto(File file, int index){
    _listImage[index] = file;
    listImageController.sink.add(_listImage);
  }

  deletePhoto(index) {
    _listImage[index] = null;
    listImageController.sink.add(_listImage);
  }

  onClose(){
    listImageController.close();
  }


  createProduct(
    String productName,
    String productCode, 
    String productBarcode, 
    String productDesc,
    bool isActive,
    int productUnitId, 
    double productStock, 
    double productCurrentStock,
    double currentPrice, 
    double salePrice,
    int brandId,
    int categoryId
  ) async {


    List<File> list = [];
    for (var i = 0; i < _listImage.length; i++) {
      if(_listImage[i] != null){
          final tempDir = await getTemporaryDirectory();
        CompressObject compressObject = CompressObject(
          imageFile: _listImage[i], //image
          path: tempDir.path, //compress to path
          quality: 80,//first compress quality, default 80
          step: 9,//compress quality step, The bigger the fast, Smaller is more accurate, default 6
          mode: CompressMode.LARGE2SMALL,//default AUTO
        );

        var image = await Luban.compressImage(compressObject);

        list.add(File(image!));
      }  
    }

    bool isSuccess = false;
    CreateProduct createProduct = CreateProduct(
      name: productName,
      code: productCode,
      barcode: productBarcode,
      description: productDesc,
      isActive: isActive,
      brandId: brandId,
      categoryId: categoryId
    );

    CreateProductStock createProductStock = CreateProductStock(
      unitId: productUnitId,
      trxStock: productStock,
      currentStock: productCurrentStock
    );

    CreateProductPrice createProductPrice = CreateProductPrice(
      currentPrice: currentPrice,
      salePrice: salePrice
    );

    RequestCreateMerchantProduct requestCreateMerchantProduct = RequestCreateMerchantProduct(
      product: createProduct,
      productStock: createProductStock,
      productPrice: createProductPrice,
      image: list.map((i) => CoreFunction.convertImageToBase64(i)).toList()
    );

    GlobalFunctions.logPrint("requestMerchantTransaction", jsonEncode(requestCreateMerchantProduct));
    var key = FireshipCrypt().encrypt(jsonEncode(requestCreateMerchantProduct), await FireshipCrypt().getPassKeyPref());
    await ProductProvider.requestCreateMerchantProduct(BodyEncrypt(key, key).toJson());
    emit(ProductLoading());
    onGetProduct();
  }

  onDetailProduct(id) async {
    productId = id;
    ProductWidget.dialogDetail(await ProductProvider.productDetail(id), dialogUpdatePrice);
  }

  dialogUpdatePrice(){
    Navigator.of(navGK.currentContext!).pop();
    showDialog(
      context: navGK.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Container(
            width: 500,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upate harga product"),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  tooltip: "Tutup",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close)
                )
              ],
            ),
          ),
          content: DialogProductPrice(),
        );
      }
    ).then((value) {
      if(value != null){
        value as ProductPriceUpdateRequest;
        onUpdateProductPrice(productId, value.salePrice ?? 0, value.type ?? "");
      }
    });
  }

  onUpdateProductPrice(int id, int salePrice, String type) async {
    ProductPriceUpdateRequest productPriceUpdateRequest = ProductPriceUpdateRequest(
      productId: id,
      salePrice: salePrice,
      type: type
    );
    var key = FireshipCrypt().encrypt(jsonEncode(productPriceUpdateRequest), await FireshipCrypt().getPassKeyPref());
    await ProductProvider.productPriceUpdate(BodyEncrypt(key, key));
    emit(ProductLoading());
    onGetProduct();
  }

}
