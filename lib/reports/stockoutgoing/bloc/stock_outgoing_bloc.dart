
import 'package:beben_pos_desktop/core/fireship/fireship_database.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_utility_box.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/model/stock_outgoing_model.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/provider/stock_outgoing_report_provider.dart';
import 'package:rxdart/rxdart.dart';

class StockOutGoingBloc {

  List<StockOutgoingModel> stockOutgoingList = [];
  int totalStockOutgoing = 0;

  BehaviorSubject<List<StockOutgoingModel>> stockOutgoingReportController = new BehaviorSubject<List<StockOutgoingModel>>();
  Stream<List<StockOutgoingModel>> get streamOutGoingList => stockOutgoingReportController.stream;

  BehaviorSubject<int> totalStockOutgoingController = new BehaviorSubject<int>();
  Stream<int> get streamTotalStockOutgoing => totalStockOutgoingController.stream;

  init(){

  }

  close(){
    stockOutgoingReportController.close();
    totalStockOutgoingController.close();
  }

  Future<List<StockOutgoingModel>> futureProductReceivings(String startDate, String endDate) async {
    var utilityBox = await FireshipDatabase.openBoxDatabase(FireshipUtilityBox.TABEL_NAME);
    String authToken = await utilityBox.get(FireshipUtilityBox.AUTH_TOKEN);
    print('auth_token -> $authToken');
    List<StockOutgoingModel> list = [];
    list.addAll(await StockOutgoingReportProvider.getReportProduct(authToken, startDate, endDate));
    stockOutgoingReportController.sink.add(list);
    print('total_data_stock_outgoing -> ${list.length}');
    return list;
  }

  sumTotalOutgoingStock(){
    int data = 0;
    for (final stock in stockOutgoingList){
      data += stock.merchantCurrentStock!;
    }
    print("total outstock -> $data");
    totalStockOutgoingController.sink.add(data);
  }

}