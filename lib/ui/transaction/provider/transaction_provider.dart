
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/ui/transaction/model/transaction_detail.dart';

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

  static Future<TransactionDetailResponse> transactionDetail(String id) async {
    var dio = await DioService.checkConnection(tryAgainMethod: transactionDetail, isUseBearer: true, showMessage: true, isLoading: true);
    DioClient dioClient = DioClient(dio);
    var response = await dioClient.transactionDetail(id);
    return TransactionDetailResponse.fromJson(response.data);
  }

  static Future<TransactionDetailResponse> transactionAccept(String id) async {
    var dio = await DioService.checkConnection(tryAgainMethod: transactionAccept, isUseBearer: true, showMessage: true, isLoading: true);
    DioClient dioClient = DioClient(dio);
    var response = await dioClient.merchantAcceptTransaction(BodyEncrypt(id, id).toJson());
    return TransactionDetailResponse.fromJson(response.data);
  }

  static Future<TransactionDetailResponse> transactionCancel(String id) async {
    var dio = await DioService.checkConnection(tryAgainMethod: transactionAccept, isUseBearer: true, showMessage: true, isLoading: true);
    DioClient dioClient = DioClient(dio);
    var response = await dioClient.merchantCancelTransaction(BodyEncrypt(id, id).toJson());
    return TransactionDetailResponse.fromJson(response.data);
  }

}