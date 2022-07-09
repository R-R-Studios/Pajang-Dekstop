
import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_database.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_utility_box.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:hive/hive.dart';

class ProfileProvider {

  static Future initProfile() async {
    GlobalFunctions.logPrint("getProfile", "Profile");
    await DioService.checkConnection(isUseBearer: true, tryAgainMethod: initProfile).then((value) async {
      var dio = DioClient(value);
      var profile = await dio.getProfile();
      GlobalFunctions.logPrint("requestSession", profile.toJson());
      if(profile.meta.code! < 300){
        var decrypt = FireshipCrypt().decrypt(profile.data, await FireshipCrypt().getPassKeyPref());
        decrypt = decrypt.replaceAll("=>", ":");
        print("decrypt profile $decrypt");
        ProfileDB profileDB = ProfileDB.fromJson(jsonDecode(decrypt));
        var box = await Hive.openBox(FireshipBox.BOX_PROFILE);
        box.add(profileDB);


        print("profile.date ${jsonEncode(box.values.last)}");
      }
    });
  }

}