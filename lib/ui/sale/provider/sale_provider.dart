import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/ui/sale/model/balance_response.dart';

class SaleProvider {

  static Future<double> balance() async {
    var dio = await DioService.checkConnection(tryAgainMethod: balance, isUseBearer: true);
    DioClient dioClient = DioClient(dio);
    var response = await dioClient.balances();
    return double.parse(response.data.toString());
  }

  static Future<BalanceResponse> balanceUpdate(BodyEncrypt bodyEncrypt) async {
    var dio = await DioService.checkConnection(tryAgainMethod: balanceUpdate, isUseBearer: true);
    DioClient dioClient = DioClient(dio);
    var response  = await dioClient.balanceUpdate(bodyEncrypt.toJson());
    return BalanceResponse(balance: int.parse(response.data.toString()));
  }

}