
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';

class DeliveryProvider {

  static Future orderList() async {
    await DioService.checkConnection(tryAgainMethod: orderList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.customerList();
      GlobalFunctions.log("response", respose);
    });
  }
}