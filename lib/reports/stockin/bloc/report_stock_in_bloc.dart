
import 'package:beben_pos_desktop/reports/stockin/model/report_stock_in_model.dart';
import 'package:beben_pos_desktop/reports/stockin/provider/report_stock_in_provider.dart';
import 'package:rxdart/rxdart.dart';

class ReportStockInBloc {

  List<ReportStockInModel> listStockIn = [];
  BehaviorSubject<List<ReportStockInModel>> listStockInController = BehaviorSubject<List<ReportStockInModel>>();
  Stream<List<ReportStockInModel>> get streamListStockIn => listStockInController.stream;

  Future<List<ReportStockInModel>> searchReportStockIn(String merchantId, String startDate, String endDate) async {
    List<ReportStockInModel> list = await ReportStockInProvider.searchReportStockIn(merchantId, startDate, endDate);
    listStockIn = list;
    listStockInController.sink.add(listStockIn);
    print("FUTURE LIST ${listStockIn.length}");
    return list;
  }

  close(){
    listStockInController.close();
  }

}