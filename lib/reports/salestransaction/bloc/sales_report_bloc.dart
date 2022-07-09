
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction_model.dart';
import 'package:beben_pos_desktop/reports/salestransaction/provider/sales_transaction_report_provider.dart';
import 'package:rxdart/rxdart.dart';

class SalesReportBloc {
  List<SalesTransactionModel> salesTransactionsList = [];
  List<ReportTransaction> reportTransactionList = [];

  BehaviorSubject<List<SalesTransactionModel>> salesReportController = new BehaviorSubject<List<SalesTransactionModel>>();
  Stream<List<SalesTransactionModel>> get streamReportList => salesReportController.stream;

  BehaviorSubject<List<ReportTransaction>> salesTransactionController = new BehaviorSubject<List<ReportTransaction>>();
  Stream<List<ReportTransaction>> get streamSalesTransactionList => salesTransactionController.stream;

  BehaviorSubject<ReportTransaction> detailSalesTransactionController = new BehaviorSubject<ReportTransaction>();
  Stream<ReportTransaction> get streamDetailSalesTransaction => detailSalesTransactionController.stream;
  init(){

  }

  close(){
      salesReportController.close();
      salesTransactionController.close();
      detailSalesTransactionController.close();
  }

  Future<List<SalesTransactionModel>> futureProductReceivings(String fromDate, String toDate) async {
    salesTransactionsList = [];
    salesTransactionsList.addAll(await SalesTransactionReportProvider.getReportSalesTransaction(fromDate, toDate));
    salesReportController.sink.add(salesTransactionsList);
    return salesTransactionsList;
  }

  Future<List<ReportTransaction>> futureGetSalesTransactionReport(String fromDate, String toDate) async {
    reportTransactionList = [];
    reportTransactionList.addAll(
        await SalesTransactionReportProvider.getReportSalesTransactionV2(
            fromDate, toDate));
    salesTransactionController.sink.add(reportTransactionList);
    return reportTransactionList;
  }

  Future<ReportTransaction> getDetailSalesTransactionReport(String codeTransaction) async {
    var reportTransaction = await SalesTransactionReportProvider.getDetailReportSalesTransaction(codeTransaction);
    ReportTransaction data = reportTransaction;
    return data;
  }
}