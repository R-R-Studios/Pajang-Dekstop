
import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/session/model/session.dart';
import 'package:beben_pos_desktop/session/provider/session_provider.dart';
import 'package:flutter/material.dart';

class SessionBloc {
  Future login(String username, String password, BuildContext context) async {
    Session loginModel = new Session(
      authorizeType: "password",
        account: username,
        authorization: password,
        fcmToken: "239238sidaddsjajweqnwejqwjenq"
    );
    var key = FireshipCrypt().encrypt(jsonEncode(loginModel), await FireshipCrypt().getPassKeyPref());

    SessionProvider.requestSession(BodyEncrypt(key,key).toJson(), context);
  }
}