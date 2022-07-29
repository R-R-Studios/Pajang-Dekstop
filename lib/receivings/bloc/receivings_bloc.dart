import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/product_receivings_db.dart';
import 'package:beben_pos_desktop/receivings/model/DetailPreviewTransactionPO.dart';
import 'package:beben_pos_desktop/receivings/model/body_search_po_model.dart';
import 'package:beben_pos_desktop/receivings/model/cart_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/model/create_product_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/model/create_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/model/preview_transaction_po.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/provider/receivings_provider.dart';
import 'package:beben_pos_desktop/service/model/core_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class ReceivingsBloc {
  bool isStruct = false;
  BehaviorSubject<bool> isStructController = new BehaviorSubject<bool>();

  Stream<bool> get streamIsStruct => isStructController.stream;

  List<CartReceivingsModel> listCartReceivings = [];
  List<double> listTotal = [];
  List<ProductReceivingsModel> productReceivings = [];

  BehaviorSubject<List<CartReceivingsModel>> listCartController =
      new BehaviorSubject<List<CartReceivingsModel>>();

  Stream<List<CartReceivingsModel>> get streamListCartModel =>
      listCartController.stream;

  BehaviorSubject<List<double>> listTotalPriceController =
      new BehaviorSubject<List<double>>();

  Stream<List<double>> get streamTotalPrice => listTotalPriceController.stream;

  double totalQty = 0;
  int totalProduct = 0;
  double subtotal = 0;
  double total = 0;
  double totalBayar = 0;
  String kembalian = "0";

  BehaviorSubject<double> controllerTotalBayar = new BehaviorSubject<double>();

  Stream<double> get streamTotalBayar => controllerTotalBayar.stream;

  BehaviorSubject<String> controllerKembalian = new BehaviorSubject<String>();

  Stream<String> get streamKembalian => controllerKembalian.stream;

  BehaviorSubject<double> sumSubTotal = new BehaviorSubject<double>();

  Stream<double> get streamSumSubTotal => sumSubTotal.stream;

  BehaviorSubject<double> sumTotalQty = new BehaviorSubject<double>();

  Stream<double> get streamSumTotalQty => sumTotalQty.stream;

  BehaviorSubject<int> sumTotalProduct = new BehaviorSubject<int>();

  Stream<int> get streamSumTotalProduct => sumTotalProduct.stream;

  BehaviorSubject<double> sumTotalPayment = new BehaviorSubject<double>();

  Stream<double> get streamSumTotalPayment => sumTotalPayment.stream;

  List<ProductModelDB> listDbProductModel = [];

  BehaviorSubject<List<ProductModelDB>> dbProductController =
      new BehaviorSubject<List<ProductModelDB>>();

  Stream<List<ProductModelDB>> get streamDbProduct =>
      dbProductController.stream;

  BehaviorSubject<List<ProductReceivingsModel>> productReceivingsController =
      new BehaviorSubject<List<ProductReceivingsModel>>();

  Stream<List<ProductReceivingsModel>> get streamProductReceivings =>
      productReceivingsController.stream;

  init() async {
    // listProductController.sink.add(productList);
    listTotalPriceController.sink.add(listTotal);
    productReceivingsController.sink.add(productReceivings);
    listCartController.sink.add(listCartReceivings);
    isStructController.sink.add(false);
    sumTotalQtyData();
    sumTotalProductItem();
    sumSubTotalProduct();
    sumTotalPricePayment();
  }

  sumTotalPricePayment() {
    total = 0;
    for (int a = 0; a < listCartReceivings.length; a++) {
      print(
          "qty ${listCartReceivings[a].qty ?? 0}, price ${listCartReceivings[a].originalPrice ?? 0}");
      double price = listCartReceivings[a].originalPrice ?? 0;
      double qty = listCartReceivings[a].qty ?? 0;
      total += price * qty;
    }
    print("TOTAL $total");
    sumTotalPayment.sink.add(total);
  }

  sumTotalQtyData() {
    totalQty = 0;
    for (int a = 0; a < listCartReceivings.length; a++) {
      totalQty += listCartReceivings[a].qty!;
    }
    sumTotalQty.sink.add(totalQty);
    sumTotalProduct.sink.add(listCartReceivings.length);
  }

  sumTotalProductItem() {
    totalProduct = 0;
    totalProduct = listCartReceivings.length;
    sumTotalProduct.sink.add(totalProduct);
  }

  sumSubTotalProduct() {
    subtotal = 0;
    for (int a = 0; a < listCartReceivings.length; a++) {
      subtotal +=
          listCartReceivings[a].qty! * listCartReceivings[a].originalPrice!;
    }
    sumSubTotal.sink.add(subtotal);
  }

  updateQtyProduct(int index, double qty) async {
    listCartReceivings[index].qty = qty;
    updateTotalPriceProduct(
        index, qty, listCartReceivings[index].originalPrice!);
  }

  updatePriceProduct(int index, double price) async {
    listCartReceivings[index].salePrice = price;
    print("updatePriceProduct ${jsonEncode(listCartReceivings)}");
    // updateTotalPriceProduct(index, listCartReceivings[index].qty!, price);
  }

  updateTotalPriceProduct(int index, double qty, double price) async {
    listCartReceivings[index].total = "${qty * price}";
    listTotal[index] = double.parse(listCartReceivings[index].total ?? "0");
    listTotalPriceController.sink.add(listTotal);
    sumTotalQtyData();
    sumTotalProductItem();
    sumSubTotalProduct();
    sumTotalPricePayment();
  }

  // addProduct(ProductModel productModel) async {
  //   var hasProduct =
  //       productList.where((element) => element.id == productModel.id);
  //   if (hasProduct.length > 0) {
  //     int indexWhere =
  //         productList.indexWhere((element) => element.id == productModel.id);
  //     int newQty = productList[indexWhere].qty! + 1;
  //     updateQtyProduct(indexWhere, newQty);
  //   } else {
  //     productList.add(productModel);
  //     listProductController.sink.add(productList);
  //     listTotal.add(productModel.total!);
  //     listTotalPriceController.sink.add(listTotal);
  //   }
  //   sumTotalQtyData();
  //   sumTotalProductItem();
  //   sumSubTotalProduct();
  //   sumTotalPricePayment();
  // }
  addCartReceivings(CartReceivingsModel cartReceivings) async {
    var hasProduct = listCartReceivings.where((element) =>
        element.id == cartReceivings.id &&
        element.unitId == cartReceivings.unitId);
    if (hasProduct.length > 0) {
      int indexWhere = listCartReceivings.indexWhere((element) =>
          element.id == cartReceivings.id &&
          element.unitId == cartReceivings.unitId);
      double newQty = listCartReceivings[indexWhere].qty! + 1;
      updateQtyProduct(indexWhere, newQty);
      print("update");
    } else {
      cartReceivings.focusPrice = FocusNode();
      cartReceivings.focusQty = FocusNode();
      cartReceivings.focusRaw = FocusNode();
      listCartReceivings.add(cartReceivings);
      listCartController.sink.add(listCartReceivings);
      listTotal.add(double.parse(cartReceivings.total ?? "0"));
      listTotalPriceController.sink.add(listTotal);
      print("new");
    }
    sumTotalQtyData();
    sumTotalProductItem();
    sumSubTotalProduct();
    sumTotalPricePayment();
  }

  deleteProduct(int index) async {
    listCartReceivings.removeAt(index);
    listCartController.sink.add(listCartReceivings);
    listTotal.removeAt(index);
    listTotalPriceController.sink.add(listTotal);
    sumTotalQtyData();
    sumTotalProductItem();
    sumSubTotalProduct();
    sumTotalPricePayment();
  }

  refreshProductReceivings() async {
    // listProductController.sink.add(productList);
    listCartController.sink.add(listCartReceivings);
  }

  deleteAll() async {
    listCartReceivings.clear();
    listCartController.sink.add(listCartReceivings);
    sumSubTotal.sink.add(0);
    sumTotalProduct.sink.add(0);
    sumTotalQty.sink.add(0);
    sumTotalPayment.sink.add(0);
  }

  productListDB(String search) async {
    final box = await Hive.openBox<ProductModelDB>("product_db");
    // print("value ${jsonEncode(listDbProductModel.first.name)}");
    List<ProductModelDB> list = box.values.toList();
    listDbProductModel = list.where(
      (element) {
        return element.name!.toLowerCase().contains(search.toLowerCase()) ||
            element.barcode!.toLowerCase().contains(search.toLowerCase());
      },
    ).toList();
    print("length ${listDbProductModel.length}");
    listDbProductModel.sort((idA, idB) => idA.barcode!.compareTo(idB.barcode!));
    print("search ${jsonEncode(listDbProductModel.first.name)}");
    dbProductController.sink.add(listDbProductModel);
  }

  Future<CoreModel> requestSaveReceivings(
      List<CartReceivingsModel> cartRecevings, String trxCode) async {
    List<CreateProductReceivingsModel> listProductReceivings = [];
    for (CartReceivingsModel cart in cartRecevings) {
      listProductReceivings.add(CreateProductReceivingsModel(
          productId: cart.id,
          unitId: cart.unitId,
          trxStock: cart.qty,
          salePrice: cart.salePrice.toString(),
          originalPrice: cart.salePrice.toString()));
    }
    var isFromPO = cartRecevings.any((element) => element.isFromPO == true);
    var body =
        CreateRecevingsModel(product: listProductReceivings, trxCode: trxCode);
    if (!isFromPO) {
      body.act = "not_po";
    }
    print("CreateRecevingsModel ${jsonEncode(body)}");
    var key = FireshipCrypt()
        .encrypt(jsonEncode(body), await FireshipCrypt().getPassKeyPref());
    print("KEY ENCY $key");
    return await ReceivingsProvider.createReceivings(
        BodyEncrypt(key, key).toJson());
  }

  Future<List<ProductReceivingsModel>> futureProductReceivings(
      {String? typePrice}) async {
    List<ProductReceivingsModel> list = [];
    var box = await Hive.openBox<ProductReceivingsDB>("product_receivings_db");
    if (box.values.length > 0) {
      List<ProductReceivingsDB> listDB = box.values.toList();
      for (ProductReceivingsDB productDB in listDB) {
        list.add(
            ProductReceivingsModel.fromJson(jsonDecode(jsonEncode(productDB))));
      }
      productReceivings = list;
    } else {
      list.addAll(
          await ReceivingsProvider.listProductReceivings(typePrice ?? "0"));
      productReceivings = list;
    }
    productReceivingsController.sink.add(productReceivings);
    print("productReceivingsDB ${list.length}");
    return list;
  }

  Future<List<ProductReceivingsModel>> refreshProduct(
      {String? typePrice}) async {
    List<ProductReceivingsModel> list = [];
    list.addAll(
        await ReceivingsProvider.listProductReceivings(typePrice ?? "0"));
    productReceivings = list;
    productReceivingsController.sink.add(productReceivings);
    print("productReceivingsDB ${list.length}");
    return list;
  }

  Future<List<ProductReceivingsModel>> productReceivingsDB() async {
    List<ProductReceivingsModel> list = [];
    var box = await Hive.openBox<ProductReceivingsDB>("product_receivings_db");
    if (box.values.length > 0) {
      List<ProductReceivingsDB> listDB = box.values.toList();
      for (ProductReceivingsDB productDB in listDB) {
        list.add(
            ProductReceivingsModel.fromJson(jsonDecode(jsonEncode(productDB))));
      }
    }
    // }else{
    //   list.addAll(await ReceivingsProvider.listProductReceivings());
    // }
    print("productReceivingsDB ${list.length}");
    return list;
  }

  saveProductReceivingsToDB(ProductReceivingsModel productReceivings) async {
    var box = await Hive.openBox<ProductReceivingsDB>("product_receivings_db");
    var db =
        ProductReceivingsDB.fromJson(jsonDecode(jsonEncode(productReceivings)));
    box.add(db);
  }

  updateProductReceivingsToDB(ProductReceivingsModel productReceivings) async {
    var box = await Hive.openBox<ProductReceivingsDB>("product_receivings_db");
    List<ProductReceivingsDB> list = box.values.toList();
    int i = list.indexWhere((element) => element.id == productReceivings.id);
    var product =
        ProductReceivingsDB.fromJson(jsonDecode(jsonEncode(productReceivings)));
    box.putAt(i, product);
    print("Update Product ${jsonEncode(box.getAt(i))}");
  }

  searchProductReceivings(String search) async {
    var box = await Hive.openBox<ProductReceivingsDB>("product_receivings_db");
    List<ProductReceivingsDB> listDB = box.values.toList();
    print("ProductReceivingsDB ${jsonEncode(listDB)}");
    List<ProductReceivingsModel> list = [];
    for (ProductReceivingsDB products in listDB) {
      list.add(
          ProductReceivingsModel.fromJson(jsonDecode(jsonEncode(products))));
    }
    list = list.where((element) {
      return element.name!.toLowerCase().contains(search.toLowerCase()) ||
          element.barcode!.toLowerCase().contains(search.toLowerCase());
    }).toList();
    productReceivings = list;
    productReceivingsController.sink.add(productReceivings);
    print("productReceivingsController ${jsonEncode(productReceivings)}");
    return list;
  }

  Future<List<CartReceivingsModel>> searchTransactionPO(String value) async {
    List<CartReceivingsModel> listCart = [];
    var body = BodySearchPoModel(transactionCode: value);
    var key = FireshipCrypt()
        .encrypt(jsonEncode(body), await FireshipCrypt().getPassKeyPref());
    print("KEY ENCY $key");
    await ReceivingsProvider.searchTransactionPO(BodyEncrypt(key, key).toJson())
        .then((value) {
      PreviewTransactionPO transactionPO = value;
      if (transactionPO.total != null) {
        for (DetailPreviewTransactionPO detail in transactionPO.detail ?? []) {
          double origPrice = detail.origPrice ?? 0;
          double qty = detail.qty ?? 0;
          double total = origPrice * qty;
          listCart.add(CartReceivingsModel(
              barcode: detail.barcode,
              name: detail.productName,
              originalPrice: origPrice,
              salePrice: origPrice,
              id: detail.productId,
              qty: qty,
              unitName: detail.unitName,
              unitId: detail.unitId,
              total: "$total"));
        }
      }
    });
    return listCart;
  }

  sumTotalKembalian(double totalBelanja, double totalBayar) async {
    double totalKembalian = totalBayar - totalBelanja;
    kembalian = "$totalKembalian";
    controllerKembalian.sink.add("$kembalian");
    controllerTotalBayar.sink.add(totalBayar);
  }

  close() {
    sumSubTotal.close();
    sumTotalQty.close();
    sumTotalProduct.close();
    sumTotalPayment.close();
    listCartController.close();
    listTotalPriceController.close();
    dbProductController.close();
    productReceivingsController.close();
    isStructController.close();
    controllerTotalBayar.close();
    controllerKembalian.close();
  }
}
