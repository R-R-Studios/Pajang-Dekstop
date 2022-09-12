
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';

import '../../ui/delivery/model/delivery.dart';

class DeliveryProvider {


  static Future transactionList() async {
    await DioService.checkConnection(tryAgainMethod: transactionList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.merchantTransactionList();
      GlobalFunctions.log("response", respose);
    });
  }

  static Future<List<Delivery>> deliveryList() async {
    List<Delivery> listDelivery = [];
    await DioService.checkConnection(tryAgainMethod: deliveryList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.merchantDeliveryList();
      for (var i = 0; i < response.data.length; i++) {
        listDelivery.add(Delivery.fromJson(response.data[i]));
      }
    });
    return listDelivery;
  }
}