
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';

class TransactionProvider {

  static Future<List<MerchantTransaction>> transactionList() async {
    List<MerchantTransaction> list = [];
    await DioService.checkConnection(tryAgainMethod: transactionList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.merchantTransactionList();
      for (var i = 0; i < response.data.length; i++) {
        list.add(MerchantTransaction.fromJson(response.data[i]));
      }
    });
    return list;
  }

  static Future<List<MerchantTransaction>> transactionDetail(String id) async {
    List<MerchantTransaction> list = [];
    await DioService.checkConnection(tryAgainMethod: transactionDetail, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.transactionDetail(id);
      for (var i = 0; i < response.data.length; i++) {
        list.add(MerchantTransaction.fromJson(response.data[i]));
      }
    });
    return list;
  }

}