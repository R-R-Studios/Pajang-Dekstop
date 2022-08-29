import 'package:beben_pos_desktop/customer/model/end_user.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class CustomerProvider {

  static Future<List<EndUser>> customerList() async {
    List<EndUser> list = [];
    await DioService.checkConnection(tryAgainMethod: customerList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.customerList();
      for (var i = 0; i < response.data.length; i++) {
        list.add(EndUser.fromJson(response.data[i]));
      }
    });
    return list;
  }
}