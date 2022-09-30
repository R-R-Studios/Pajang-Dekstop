import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/ui/profile/model/repsonse_profile.dart';

class ProfileProvider {

  static Future<Responseprofile> profile() async {
    var value = await DioService.checkConnection(tryAgainMethod: profile, isUseBearer: true);
    DioClient dioClient = DioClient(value);
    var response = await dioClient.profile();
    return Responseprofile.fromJson(response.data);
  }

}