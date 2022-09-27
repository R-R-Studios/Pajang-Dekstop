import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class ProfileProvider {

  static profile() async {
    var value = await DioService.checkConnection(tryAgainMethod: profile, isUseBearer: true);
    DioClient dioClient = DioClient(value);
    dioClient.profile();
  }

}