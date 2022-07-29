import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/profile/provider/profile_provider.dart';
import 'package:hive/hive.dart';

class ProfileBloc {
  Future initProfile() async {
    await ProfileProvider.initProfile();
  }

  Future<ProfileDB> getProfile() async {
    var box = await Hive.openBox(FireshipBox.BOX_PROFILE);
    ProfileDB profile = ProfileDB();
    if (box.values.isNotEmpty) {
      profile = box.values.last;
    }

    print("Future<ProfileDB> getProfile() async { ${jsonEncode(profile)}");
    return profile;
  }
}
