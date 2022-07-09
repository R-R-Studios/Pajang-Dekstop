import 'package:beben_pos_desktop/reports/receivings/model/report_receivings_model.dart';
import 'package:beben_pos_desktop/reports/receivings/provider/report_receivings_provider.dart';

class ReportReceivingsBloc {

  Future<List<ReportReceivingsModel>> searchReportReceivings(String merchantId, String productName, String startDate, String endDate) async {
    List<ReportReceivingsModel> list = await ReportReceivingsProvider.searchReportReceivings(merchantId, productName, startDate, endDate);
    print("FUTURE LIST ${list.length}");
    return list;
  }

}