import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/db/transaction_failed_db.dart';
import 'package:beben_pos_desktop/db/transaction_failed_product_db.dart';
import 'package:beben_pos_desktop/product/provider/product_provider.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:beben_pos_desktop/db/merchant_product_db.dart';
import 'package:beben_pos_desktop/sales/model/merchant_transaction_model.dart';
import 'package:beben_pos_desktop/sales/model/request_transaction_model.dart';
import 'package:beben_pos_desktop/sales/model/response_status_transaction.dart';
import 'package:beben_pos_desktop/sales/model/return_transaction_model.dart';
import 'package:beben_pos_desktop/sales/provider/sales_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class SalesBloc {
  List<ProductModel> productList = [];
  List<MerchantProductDB> merchantProductList = [];
  List<TransactionFailedDB> transactionList = [];
  List<double> listTotal = [];

  List<ProductModelDB> productListDB = [];

  Box? box;
  bool isSearch = false;
  bool isPayment = false;
  TextEditingController qtyController = TextEditingController();

  String visibilityLayout = "sales_input";
  double totalQty = 0;
  int totalProduct = 0;
  double subtotal = 0;
  double totalBelanja = 0;
  int totalBayar = 0;
  String kembalian = "0";

  BehaviorSubject<double> controllerTotalBayar = new BehaviorSubject<double>();

  Stream<double> get streamTotalBayar => controllerTotalBayar.stream;

  BehaviorSubject<String> controllerKembalian = new BehaviorSubject<String>();

  Stream<String> get streamKembalian => controllerKembalian.stream;

  BehaviorSubject<TextEditingController> qtyChangeController =
      new BehaviorSubject<TextEditingController>();

  Stream<TextEditingController> get streamQtyChange =>
      qtyChangeController.stream;

  BehaviorSubject<List<ProductModel>> listProductController =
      new BehaviorSubject<List<ProductModel>>();

  Stream<List<ProductModel>> get streamListProductModel =>
      listProductController.stream;

  BehaviorSubject<List<MerchantProductDB>> merchantProductsController =
      new BehaviorSubject<List<MerchantProductDB>>();

  Stream<List<MerchantProductDB>> get streamMerchantProducts =>
      merchantProductsController.stream;

  BehaviorSubject<List<MerchantProductDB>> listMerchantProductController =
      new BehaviorSubject<List<MerchantProductDB>>();

  Stream<List<MerchantProductDB>> get streamListMerchantProductModel =>
      listMerchantProductController.stream;

  BehaviorSubject<List<TransactionFailedDB>> transactionListController =
      new BehaviorSubject<List<TransactionFailedDB>>();

  Stream<List<TransactionFailedDB>> get streamTransactionList =>
      transactionListController.stream;

  BehaviorSubject<String> updateView = new BehaviorSubject<String>();

  Stream<String> get streamUpdateView => updateView.stream;

  BehaviorSubject<bool> updateViewPayment = new BehaviorSubject<bool>();

  Stream<bool> get streamUpdateViewPayment => updateViewPayment.stream;

  BehaviorSubject<bool> updateBtnPayment = new BehaviorSubject<bool>();

  Stream<bool> get streamUpdateBtnPayment => updateBtnPayment.stream;

  BehaviorSubject<double> sumTotalQty = new BehaviorSubject<double>();

  Stream<double> get streamSumTotalQty => sumTotalQty.stream;

  BehaviorSubject<int> sumTotalProduct = new BehaviorSubject<int>();

  Stream<int> get streamSumTotalProduct => sumTotalProduct.stream;

  BehaviorSubject<double> sumSubTotal = new BehaviorSubject<double>();

  Stream<double> get streamSumSubTotal => sumSubTotal.stream;

  BehaviorSubject<double> sumTotalPayment = new BehaviorSubject<double>();

  Stream<double> get streamSumTotalPayment => sumTotalPayment.stream;

  BehaviorSubject<List<double>> listTotalPriceController =
      new BehaviorSubject<List<double>>();

  Stream<List<double>> get streamTotalPrice => listTotalPriceController.stream;

  BehaviorSubject<List<ProductModelDB>> controllerProductModelDB =
      new BehaviorSubject();

  Stream<List<ProductModelDB>> get streamProductModelDB =>
      controllerProductModelDB.stream;

  bool isEnableTrxCode = false;
  BehaviorSubject<bool> enableTrxCodeController = new BehaviorSubject<bool>();

  Stream<bool> get streamEnableTrxCode => enableTrxCodeController.stream;

  init() async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    productList = productModel.cast<ProductModel>();
    for (ProductModel product in productList) {
      listTotal.add(product.total ?? 0);
    }
    GlobalFunctions.log('init', listTotal);
    listProductController.sink.add(productList);
    listTotalPriceController.sink.add(listTotal);
    enableTrxCodeController.sink.add(isEnableTrxCode);
    controllerProductModelDB.sink.add(productListDB);
    selectTransaction();
    checkAllSumDataInputSales();
  }

  checkAllSumDataInputSales() {
    sumTotalQtyData();
    sumTotalProductItem();
    sumSubTotalProduct();
    sumTotalPricePayment();
  }

  selectTransaction() async {
    ProfileDB profile = await ProfileBloc().getProfile();
    var box = await Hive.openBox(FireshipBox.BOX_TRANSACTION);
    var transaction = box.values.toList();
    transactionList = <TransactionFailedDB>[];
    transactionList = transaction.cast<TransactionFailedDB>();
    transactionList = transactionList
        .where((element) => element.merchantId == profile.merchantId)
        .toList();
    transactionListController.sink.add(transactionList);
  }

  Future<List<MerchantProductDB>> initProduct(
          context, String query, String type) async =>
      await getListProduct(query, type);

  showVisibilityPayment(bool isShow) {
    if (isShow) {
      isSearch = true;
    } else {
      isSearch = false;
    }
    updateViewPayment.sink.add(isSearch);
  }

  showVisibilityBtnPayment(bool isShow) {
    if (isShow) {
      isPayment = true;
    } else {
      isPayment = false;
    }
    updateBtnPayment.sink.add(isPayment);
  }

  sumTotalQtyData() {
    totalQty = 0;
    for (int a = 0; a < productList.length; a++) {
      totalQty += productList[a].quantity!;
    }
    sumTotalQty.sink.add(totalQty);
    sumTotalProduct.sink.add(productList.length);
  }

  sumTotalProductItem() {
    totalProduct = 0;
    totalProduct = productList.length;
    sumTotalProduct.sink.add(totalProduct);
  }

  sumSubTotalProduct() {
    subtotal = 0;
    for (int a = 0; a < productList.length; a++) {
      double qty = productList[a].quantity ?? 0;
      double price = productList[a].price ?? 0;
      subtotal += price * qty;
    }
    sumSubTotal.sink.add(subtotal);
  }

  updateItem(int index, ProductModel productModel, double totalQty) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    box.putAt(index, productModel);
    productList[index].quantity = totalQty;
    checkAllSumDataInputSales();
  }

  updateItemPrice(
      int index, ProductModel productModel, double totalPrice) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    box.putAt(index, productModel);
    productList[index].price = totalPrice;
    checkAllSumDataInputSales();
  }

  updateItemTotalPrice(int index, ProductModel productModel, double quantity,
      double price) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    box.putAt(index, productModel);
    productList[index].total =
        productList[index].quantity! * productList[index].price!;
    listTotal[index] = productList[index].total ?? 0;
    listTotalPriceController.sink.add(listTotal);
    checkAllSumDataInputSales();
  }

  sumTotalPricePayment() {
    totalBelanja = 0;
    for (int a = 0; a < productList.length; a++) {
      totalBelanja += productList[a].quantity! * productList[a].price!;
    }
    sumTotalPayment.sink.add(totalBelanja);
  }

  addProduct(MerchantProductDB merchantProduct) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    double salePrice = double.parse("${merchantProduct.salePrice ?? "0"}");
    print("merchantProduct.salePrice $salePrice");
    ProductModel productModel = ProductModel(
        productId: merchantProduct.id,
        price: salePrice,
        itemName: merchantProduct.name,
        item: merchantProduct.barcode,
        disc: 0,
        total: 0,
        unitName: merchantProduct.unitName,
        unitId: merchantProduct.unitId,
        quantity: double.parse(merchantProduct.qty ?? "0"));
    var productDB = box.values.toList();
    productList = productDB.cast<ProductModel>();
    // after that check the product on the list or not
    bool isAdded = false;
    isAdded = productList.any((product) =>
        product.productId == merchantProduct.id &&
        product.unitId == merchantProduct.unitId &&
        product.unitName == merchantProduct.unitName);
    GlobalFunctions.logPrint("isAdded", isAdded);
    if (!isAdded) {
      productModel.total = productModel.quantity! * productModel.price!;
      box.add(productModel);
      listTotal.add(productModel.total ?? 0);
      listTotalPriceController.sink.add(listTotal);
      productList.add(productModel);
    } else {
      int index = productList
          .indexWhere((element) => element.productId == merchantProduct.id);
      productModel = box.getAt(index);
      productModel.quantity = productModel.quantity! + 1;
      double totalPrice = productModel.quantity! * productModel.price!;
      productModel.total = totalPrice;
      listTotal[index] = totalPrice;
      GlobalFunctions.log('addProduct', listTotal);
      listTotalPriceController.sink.add(listTotal);
      qtyChangeController.sink.add(qtyController);
      box.putAt(index, productModel);
    }
    listProductController.sink.add(productList);
    checkAllSumDataInputSales();
  }

  addProductV2(ProductModelDB merchantProduct) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    double salePrice = double.parse("${merchantProduct.salePrice ?? "0"}");
    print("merchantProduct.salePrice $salePrice");
    ProductModel productModel = ProductModel(
        productId: merchantProduct.id,
        price: salePrice,
        itemName: merchantProduct.name,
        item: merchantProduct.barcode,
        disc: 0,
        total: 0,
        unitName: merchantProduct.unitsName,
        unitId: merchantProduct.unitsId,
        quantity: 1);
    var productDB = box.values.toList();
    productList = productDB.cast<ProductModel>();
    // after that check the product on the list or not
    bool isAdded = false;
    isAdded = productList.any((product) =>
        product.productId == merchantProduct.id &&
        product.unitId == merchantProduct.unitsId &&
        product.unitName == merchantProduct.unitsName);
    GlobalFunctions.logPrint("isAdded", isAdded);
    if (!isAdded) {
      productModel.total = productModel.quantity! * productModel.price!;
      box.add(productModel);
      listTotal.add(productModel.total ?? 0);
      listTotalPriceController.sink.add(listTotal);
      productList.add(productModel);
    } else {
      int index = productList
          .indexWhere((element) => element.productId == merchantProduct.id);
      productModel = box.getAt(index);
      productModel.quantity = productModel.quantity! + 1;
      productModel.total = productModel.quantity! * productModel.price!;
      qtyChangeController.sink.add(qtyController);
      box.putAt(index, productModel);
    }
    listProductController.sink.add(productList);
    checkAllSumDataInputSales();
  }

  Future<List<ProductModelDB>> refreshProduct() async {
    await ProductProvider.refreshProduct();
    var boxProduct = await Hive.openBox<ProductModelDB>("product_db");
    List<ProductModelDB> productDB = [];
    if (boxProduct.length > 0) {
      productDB = boxProduct.values.toList();
      productListDB = productDB;
      controllerProductModelDB.sink.add(productListDB);
    }
    return productListDB;
  }

  Future<List<ProductModelDB>> getProductMerchant() async {
    var boxProduct = await Hive.openBox<ProductModelDB>("product_db");
    List<ProductModelDB> productDB = [];
    if (boxProduct.length > 0) {
      productDB = boxProduct.values.toList();
      productListDB = productDB;
      controllerProductModelDB.sink.add(productListDB);
    }
    return productListDB;
  }

  Future<List<ProductModelDB>> searchProductMerchant(String search) async {
    List<ProductModelDB> searchList = [];
    var listProduct = await getProductMerchant();
    if (listProduct.length > 0) {
      searchList = listProduct.where((element) {
        var name = element.name ?? "";
        var barcode = element.barcode ?? "";
        return name.toLowerCase().contains(search.toLowerCase()) ||
            barcode.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
    productListDB = searchList;
    controllerProductModelDB.sink.add(productListDB);
    return searchList;
  }

  selectProductMerchant(BuildContext context, String query, String type) async {
    // var box = await Hive.openBox(FireshipBox.BOX_PRODUCT_MERCHANT);
    // var productMerchant = box.values.toList();
    // if (box.values.toList().length == 0) {
    List<MerchantProductDB> tempData = [];
    tempData = await initProduct(context, query, type);
    // box.addAll(tempData);
    merchantProductList.addAll(tempData);
    // } else {
    //   merchantProductList = productMerchant.cast<MerchantProductDB>();
    // }

    GlobalFunctions.logPrint(
        "Jumlah Product Merchant ini", '${merchantProductList.length} product');
    merchantProductsController.sink.add(merchantProductList);
  }

  Future<MerchantProductDB> findProductBarcode(
      BuildContext context, String search) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT_MERCHANT);
    var productMerchant = box.values.toList();
    List<MerchantProductDB> list = productMerchant.cast<MerchantProductDB>();
    MerchantProductDB productDB = MerchantProductDB();
    productDB = list.firstWhere(
        (element) => element.barcode!.toLowerCase().contains(
              search.toLowerCase(),
            ),
        orElse: () => MerchantProductDB());
    print("productDB Sales ${jsonEncode(productDB)}");
    return productDB;
  }

  Future<ProductModelDB> findProductBarcodeV2(
      BuildContext context, String search) async {
    ProductModelDB searchList = ProductModelDB();
    var listProduct = await getProductMerchant();
    print("listProduct ${listProduct.length}");
    print("search $search");
    if (listProduct.length > 0) {
      searchList = listProduct.firstWhere(
          (element) =>
              element.barcode!.toLowerCase().contains(search.toLowerCase()),
          orElse: () => ProductModelDB());
    }
    // productListDB = searchList;
    // controllerProductModelDB.sink.add(productListDB);
    return searchList;
  }

  findProductByNameOrBarcode(BuildContext context, String query) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT_MERCHANT);
    var productMerchant = box.values.toList();
    merchantProductList = productMerchant.cast<MerchantProductDB>();
    List<MerchantProductDB> filteringData = [];
    filteringData = merchantProductList
        .where(
          (element) =>
              element.name!.toLowerCase().contains(query) ||
              element.barcode!.toLowerCase().contains(query),
        )
        .toList();
    // merchantProductList.forEach((element) {
    //   if (element.name!.toLowerCase().contains(query.toLowerCase())) {
    //     filteringData.add(element);
    //   }
    // });
    GlobalFunctions.logPrint(
        "Jumlah filter data Product Merchant", '${filteringData.length}');
    merchantProductsController.sink.add(filteringData);
  }

  refreshProductMerchant(
      BuildContext context, String query, String type) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT_MERCHANT);
    var productMerchant = box.values.toList();
    for (final data in productMerchant) {
      data.delete();
    }
    List<MerchantProductDB> tempData = [];
    tempData = await initProduct(context, query, type);
    box.addAll(tempData);
    merchantProductList.clear();
    merchantProductList.addAll(tempData);
    merchantProductsController.sink.add(merchantProductList);
    GlobalFunctions.logPrint("Product Merchant Refreshed", "Success");
  }

  Future addTransactionFailed(double totalPriceTransaction,
      double totalPaymentCustomer, int merchantId, String type) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    productList = productModel.cast<ProductModel>();
    listProductController.sink.add(productList);
    var boxTransaction = await Hive.openBox(FireshipBox.BOX_TRANSACTION);
    var boxProduct = await Hive.openBox(FireshipBox.BOX_TRANSACTION_PRODUCT);
    var uuid = Uuid();
    String idTransaction = uuid.v1();
    List<TransactionFailedProductDB> transactionProductList = [];
    for (int a = 0; a < productList.length; a++) {
      TransactionFailedProductDB transactionFailedProductDB =
          TransactionFailedProductDB(
              idTransaction: idTransaction,
              item: productList[a].item,
              itemName: productList[a].itemName,
              price: productList[a].price,
              quantity: productList[a].quantity,
              disc: productList[a].disc,
              total: productList[a].total,
              productId: productList[a].productId,
              unitId: productList[a].unitId,
              unitName: productList[a].unitName);
      transactionProductList.add(transactionFailedProductDB);
      boxProduct.add(transactionFailedProductDB);
    }
    double totalMoneyChanges = totalPriceTransaction - totalPaymentCustomer;

    TransactionFailedDB transactionFailedDB = TransactionFailedDB(
        id: idTransaction,
        date: DateTime.now().toString(),
        productList: transactionProductList,
        status: "Unsync",
        type: type,
        totalPriceTransaction: totalPriceTransaction,
        totalPaymentCustomer: totalPaymentCustomer,
        totalMoneyChanges: totalMoneyChanges,
        merchantId: merchantId);
    boxTransaction.add(transactionFailedDB);
    transactionList.add(transactionFailedDB);
    print('data product in product Transaction -> ${transactionList.length}');
    transactionListController.sink.add(transactionList);
    print('success add data');
    selectTransaction();
  }

  enabledTrxCode(bool enabled) {
    isEnableTrxCode = enabled;
    enableTrxCodeController.sink.add(isEnableTrxCode);
  }

  close() {
    updateView.close();
    updateBtnPayment.close();
    updateViewPayment.close();
    listProductController.close();
    sumTotalQty.close();
    sumTotalProduct.close();
    sumSubTotal.close();
    sumTotalPayment.close();
    listMerchantProductController.close();
    qtyChangeController.close();
    transactionListController.close();
    // transactionProductListController.close();
    merchantProductsController.close();
    controllerTotalBayar.close();
    controllerKembalian.close();
    listTotalPriceController.close();
    enableTrxCodeController.close();
    controllerProductModelDB.close();
  }

  getMerchantProductDB() async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    productList = productModel.cast<ProductModel>();
    GlobalFunctions.log('sales_input',
        'GetMerchantProductDB total Data : ${productList.length}');
    listProductController.sink.add(productList);
    checkAllSumDataInputSales();
  }

  deleteProduct(int index) async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    box.deleteAt(index);
    productList.removeAt(index);
    listTotal.removeAt(index);
    GlobalFunctions.log('deleteProduct', listTotal);
    listTotalPriceController.sink.add(listTotal);
    getMerchantProductDB();
    checkAllSumDataInputSales();
  }

  deleteTransactionAndProductTransaction(
      int index, String idTransaction) async {
    var box = await Hive.openBox(FireshipBox.BOX_TRANSACTION);
    var boxProduct = await Hive.openBox(FireshipBox.BOX_TRANSACTION_PRODUCT);
    box.deleteAt(index);
    boxProduct.delete(idTransaction);
    transactionList.removeAt(index);
    selectTransaction();
  }

  deleteAll() async {
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    productList = productModel.cast<ProductModel>();
    GlobalFunctions.log("Delete All first ", productList.length);
    for (final data in productList) {
      data.delete();
    }
    productList = [];
    listProductController.sink.add(productList);
    getMerchantProductDB();
  }

  // for api /api/pos/salestransaction
  Future<ResponseStatusTransaction> requestMerchantTransaction(
      double totalPriceTransaction,
      double totalPaymentCustomer,
      int merchantId,
      String type) async {
    ResponseStatusTransaction responseStatusTransaction =
        ResponseStatusTransaction(
      transactionCode: "",
      status: false,
    );
    // bool isSuccessTransaction = false;

    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    productList = productModel.cast<ProductModel>();
    listProductController.sink.add(productList);
    List<MerchantTransactionModel> merchantTransactionList = [];
    GlobalFunctions.logPrint("requestMerchantTransaction", productList.length);
    for (int i = 0; i < productList.length; i++) {
      MerchantTransactionModel merchantTransaction = MerchantTransactionModel(
          productId: productList[i].productId,
          trxStock: productList[i].quantity,
          unitId: productList[i].unitId,
          unitName: productList[i].unitName);
      merchantTransactionList.add(merchantTransaction);
    }
    ProductTransaction producTransaction = ProductTransaction(
        type: type, merchantTransaction: merchantTransactionList);
    GlobalFunctions.logPrint(
        "requestMerchantTransaction", jsonEncode(producTransaction));
    var key = FireshipCrypt().encrypt(
        jsonEncode(producTransaction), await FireshipCrypt().getPassKeyPref());
    await SalesProvider.requestTransaction(BodyEncrypt(key, key).toJson())
        .then((value) async {
      print('Data value from request -> ${value.status}');
      responseStatusTransaction = ResponseStatusTransaction(
          transactionCode: value.transactionCode ?? "",
          status: value.status ?? false,
          responseCode: value.responseCode);
      // isSuccessTransaction = value;
      // print('isSuccessTransaction -> $isSuccessTransaction');
      if (!value.status!) {
        if (value.responseCode != '402') {
          GlobalFunctions.log('sales_bloc',
              'response transaction [${value.responseCode}] code except 402 input to offline mode ');
          await addTransactionFailed(
              totalPriceTransaction, totalPaymentCustomer, merchantId, type);
        }
      }
    });

    return responseStatusTransaction;
  }

  Future<List<MerchantProductDB>> getListProduct(
      String search, String type) async {
    List<MerchantProductDB> dataProduct = [];
    dataProduct = await SalesProvider.merchantListProduct(search, type);
    GlobalFunctions.logPrint("Total Data Produk bloc", dataProduct.length);
    return dataProduct;
  }

  Future<bool> requestAsyncTransaction() async {
    bool onProgress = false;
    ProfileDB profile = await ProfileBloc().getProfile();
    var boxTransaction = await Hive.openBox(FireshipBox.BOX_TRANSACTION);
    var transaction = boxTransaction.values.toList();
    transactionList = <TransactionFailedDB>[];
    transactionList = transaction.cast<TransactionFailedDB>();
    transactionList = transactionList
        .where((element) => element.merchantId == profile.merchantId)
        .toList();
    transactionListController.sink.add(transactionList);
    GlobalFunctions.logPrint(
        "Total Data Transaksi ", "${transactionList.length}");

    await Future.forEach(transactionList,
        (TransactionFailedDB transaction) async {
      List<MerchantTransactionModel> merchantTransactionList = [];
      GlobalFunctions.logPrint(
          "requestMerchantTransaction", transaction.productList!.length);

      for (int i = 0; i < transaction.productList!.length; i++) {
        MerchantTransactionModel merchantTransaction = MerchantTransactionModel(
            productId: transaction.productList![i].productId,
            trxStock: transaction.productList![i].quantity,
            unitId: transaction.productList![i].unitId,
            unitName: transaction.productList![i].unitName);
        merchantTransactionList.add(merchantTransaction);
      }
      ProductTransaction producTransaction = ProductTransaction(
          type: transaction.type ?? "",
          merchantTransaction: merchantTransactionList);
      GlobalFunctions.logPrint(
          "requestMerchantTransaction", jsonEncode(producTransaction));
      var key = FireshipCrypt().encrypt(jsonEncode(producTransaction),
          await FireshipCrypt().getPassKeyPref());
      await SalesProvider.requestTransaction(BodyEncrypt(key, key).toJson())
          .then((value) async {
        print('Data request status -> ${value.status}');
        print('Data response code  -> ${value.responseCode}');
        if (value.status!) {
          if (value.responseCode == '402') {
            GlobalFunctions.log('sales_bloc',
                'Sales Bloc - RequestAsyncTransaction : Gagal Qty Melebihi kapasitas');
          } else {
            final index = transactionList
                .indexWhere((element) => element.id == transaction.id);
            deleteTransactionAndProductTransaction(index, transaction.id!);
          }
        }
      }).then((value) {
        // transactionList.clear();
        // transactionListController.sink.add(transactionList);
        // for(var data in transactionList){
        //   data.delete();
        // }
        // print("async request done");
      });
    });

    return onProgress;
  }

  sumTotalKembalian(double totalBelanja, double totalBayar) async {
    double totalKembalian = totalBayar - totalBelanja;
    kembalian = "$totalKembalian";
    controllerKembalian.sink.add("$kembalian");
    controllerTotalBayar.sink.add(totalBayar);
  }

  Future requestReturnTransaction(String trxCode) async {
    List<MerchantTransactionModel> merchantTransactionList = [];
    var box = await Hive.openBox(FireshipBox.BOX_PRODUCT);
    var productModel = box.values.toList();
    productList = productModel.cast<ProductModel>();
    listProductController.sink.add(productList);
    for (int i = 0; i < productList.length; i++) {
      MerchantTransactionModel merchantTransaction = MerchantTransactionModel(
          productId: productList[i].productId,
          trxStock: productList[i].quantity,
          unitId: productList[i].unitId,
          unitName: productList[i].unitName);
      merchantTransactionList.add(merchantTransaction);
    }
    ReturnTransactionModel producTransaction = ReturnTransactionModel(
        transactionCode: trxCode, merchantTransaction: merchantTransactionList);
    GlobalFunctions.logPrint(
        "requestMerchantTransaction", jsonEncode(producTransaction));
    var key = FireshipCrypt().encrypt(
        jsonEncode(producTransaction), await FireshipCrypt().getPassKeyPref());
    await SalesProvider.requestReturnTransaction(
        BodyEncrypt(key, key).toJson());
  }
}
