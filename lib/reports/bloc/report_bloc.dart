import 'dart:convert';

import 'package:beben_pos_desktop/db/product_receivings_db.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/reports/model/report_merchant_transaction_model.dart';
import 'package:beben_pos_desktop/reports/model/price_product_history_model.dart';
import 'package:beben_pos_desktop/reports/receivings/model/report_receivings_model.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class ReportBloc {
  String reportName = "";
  String searchReport = "";

  List<ReportMerchantTransactionModel> reportMerchantTransactionList = [];
  List<PriceProductHistoryModel> priceProductHistoryList = [];
  List<PriceProductHistoryModel> searchPriceProductHistoryList = [];

  BehaviorSubject<String> reportViewController = new BehaviorSubject<String>();
  Stream<String> get streamReportView => reportViewController.stream;

  BehaviorSubject<List<ReportMerchantTransactionModel>>
      reportMerchantTransactionController =
      new BehaviorSubject<List<ReportMerchantTransactionModel>>();
  Stream<List<ReportMerchantTransactionModel>>
      get streamMerchantTransactionReport =>
          reportMerchantTransactionController.stream;

  BehaviorSubject<List<PriceProductHistoryModel>> priceProductController =
      new BehaviorSubject<List<PriceProductHistoryModel>>();
  Stream<List<PriceProductHistoryModel>> get streamPriceProductList =>
      priceProductController.stream;

  bool searchReportReceivings = false;
  BehaviorSubject<bool> searchReportReceivingsController =
      new BehaviorSubject();
  Stream<bool> get streamSearchReportReceivings =>
      searchReportReceivingsController.stream;

  ReportReceivingsModel reportReceivingsModel = ReportReceivingsModel();
  BehaviorSubject<ReportReceivingsModel> reportReceivingsController =
      new BehaviorSubject();
  Stream<ReportReceivingsModel> get streamReportReceivings =>
      reportReceivingsController.stream;

  List<ProductReceivingsModel> _productReportReceivings = [];
  BehaviorSubject<List<ProductReceivingsModel>>
      _productReportReceivingsController = new BehaviorSubject();
  Stream<List<ProductReceivingsModel>> get streamProductReportReceivings =>
      _productReportReceivingsController.stream;

  init() {
    priceProductController.sink.add(priceProductHistoryList);
    searchReportReceivingsController.sink.add(false);
  }

  initReportMerchant() {
    addDataReportMerchantTransaction();
    reportMerchantTransactionController.sink.add(reportMerchantTransactionList);
  }

  addDataReportMerchantTransaction() {
    ReportMerchantTransactionModel merchantTransactionReport =
        ReportMerchantTransactionModel(
            id: 1,
            merchantName: "nuzul beras",
            lastStock: "17",
            currentStock: "0",
            currentPrice: "27200",
            salePrice: "27200",
            qty: "1",
            totalAmount: "27200",
            createdAt: "28-09-2021");
    reportMerchantTransactionList.add(merchantTransactionReport);
    reportMerchantTransactionController.sink.add(reportMerchantTransactionList);
  }

  setToReportView(String reportView) {
    reportName = reportView;
    reportViewController.sink.add(reportName);
  }

  initPriceProductHistory(List<PriceProductHistoryModel> list) {
    priceProductHistoryList = list;
    priceProductController.sink.add(priceProductHistoryList);
  }

  onSearchPriceProductHistory(String search) {
    print("Search TExt $search");
    List<PriceProductHistoryModel> list = priceProductHistoryList;
    list = list.where((element) {
      return jsonEncode(element).toLowerCase().contains(search.toLowerCase());
    }).toList();
    print("LENGT PRODUCT ${list.length}");
    priceProductController.sink.add(list);
  }

  updateViewReportReceivings(bool value) async {
    searchReportReceivings = value;
    searchReportReceivingsController.sink.add(searchReportReceivings);
  }

  initReportReceivings() async {
    // String jsonReport = "{\"start_date\":\"2021-10-01\",\"end_date\":\"2021-10-04\",\"product_id\":1,\"product_name\":\"Teh Kotak\",\"unit_list\":[{\"unit_id\":2,\"unit_name\":\"Dus\",\"report_list\":[{\"id\":23,\"date\":\"2021-10-01\",\"first_stock\":100,\"total_receivings\":200,\"last_stock\":300}]},{\"unit_id\":1,\"unit_name\":\"Dus\",\"report_list\":[{\"id\":20,\"date\":\"2021-10-01\",\"first_stock\":100,\"total_receivings\":200,\"last_stock\":300},{\"id\":20,\"date\":\"2021-10-01\",\"first_stock\":100,\"total_receivings\":200,\"last_stock\":300}]},{\"unit_id\":1,\"unit_name\":\"Karton\",\"report_list\":[{\"id\":20,\"date\":\"2021-10-01\",\"first_stock\":100,\"total_receivings\":200,\"last_stock\":300},{\"id\":20,\"date\":\"2021-10-01\",\"first_stock\":100,\"total_receivings\":200,\"last_stock\":300},{\"id\":20,\"date\":\"2021-10-01\",\"first_stock\":100,\"total_receivings\":200,\"last_stock\":300}]}]}";
    // reportReceivingsModel = ReportReceivingsModel.fromJson(jsonDecode(jsonReport));
    // print("reportReceivingsModel ${jsonEncode(reportReceivingsModel)}");
    reportReceivingsController.sink.add(ReportReceivingsModel());
  }

  Future<List<ProductReceivingsModel>> initProductReportReceivings() async {
    List<ProductReceivingsModel> list = [];
    var box = await Hive.openBox<ProductReceivingsDB>("product_receivings_db");
    if (box.values.length > 0) {
      List<ProductReceivingsDB> listDB = box.values.toList();
      for (ProductReceivingsDB productDB in listDB) {
        list.add(
            ProductReceivingsModel.fromJson(jsonDecode(jsonEncode(productDB))));
      }
    }
    print("productReceivingsDB ${list.length}");
    return list;
  }

  close() {
    reportViewController.close();
    reportMerchantTransactionController.close();
    priceProductController.close();
    searchReportReceivingsController.close();
    reportReceivingsController.close();
    _productReportReceivingsController.close();
  }
}
