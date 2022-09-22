import 'package:beben_pos_desktop/delivery/model/delivery_detail.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';

import '../../core/fireship/fireship_encrypt.dart';
import '../model/delivery.dart';

class DeliveryProvider {

  static Future transactionList() async {
    await DioService.checkConnection(tryAgainMethod: transactionList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.merchantTransactionList();
      GlobalFunctions.log("response", respose);
    });
  }
  
  static Future create(BodyEncrypt bodyEncrypt) async {
    await DioService.checkConnection(tryAgainMethod: create, isUseBearer: true, showMessage: true, isLoading: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.merchantDeliveryCreate(bodyEncrypt.toJson());
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

  static Future<List<DeliveryDetail>> deliveryDetail(int id) async {
    List<DeliveryDetail> listDelivery = [];
    await DioService.checkConnection(tryAgainMethod: deliveryDetail, isUseBearer: true, showMessage: true, isLoading: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.merchantDeliveryDetail(id.toString());
      for (var i = 0; i < response.data.length; i++) {
        listDelivery.add(DeliveryDetail.fromJson(response.data[i]));
      }
    });
    return listDelivery;
  }
}