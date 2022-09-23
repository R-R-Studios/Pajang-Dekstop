import 'dart:convert';
import 'dart:io';

import 'package:beben_pos_desktop/content/widget/product_widget.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/product/model/request_create_product_merchant.dart';
import 'package:beben_pos_desktop/product/provider/product_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_luban/flutter_luban.dart';
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
    await ProductProvider.requestCreateMerchantProduct(BodyEncrypt(key, key).toJson()).then((value) async {
    GlobalFunctions.logPrint("Return Status from provider RequestCreateMerchantProduct", '$value');
      if (value) {
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });
  }

  onDetailProduct(id) async {
    ProductWidget.dialogDetail(await ProductProvider.productDetail(id));
  }

}
