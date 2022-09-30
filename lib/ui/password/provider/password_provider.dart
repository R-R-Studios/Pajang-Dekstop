import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';

class PasswordProvider {

  static Future update(BodyEncrypt bodyEncrypt) async {
    var dio = await DioService.checkConnection(tryAgainMethod: update, isLoading: true);
    DioClient dioClient = DioClient(dio);
    var response = await dioClient.updatePassword(bodyEncrypt.toJson());
  }

}