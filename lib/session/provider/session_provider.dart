
import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_database.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_utility_box.dart';
import 'package:beben_pos_desktop/dashboard.dart';
import 'package:beben_pos_desktop/main.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/session/model/otp_response.dart';
import 'package:beben_pos_desktop/session/model/response_session.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class SessionProvider {

  static Future requestSession(Map<String, dynamic> body, BuildContext context) async {
    GlobalFunctions.logPrint("requestSession", body.toString());
    await DioService.checkConnection(
        isLoading: true,
        tryAgainMethod: requestSession).then((value) async {
      var dio = DioClient(value);
      var requestSession = await dio.requestSession(body);
      GlobalFunctions.logPrint("requestSession", requestSession.toJson());
      if(requestSession.meta.code! < 300){
        //? TODO excecute response
        var decrypt = FireshipCrypt().decrypt(requestSession.data["secret"], await FireshipCrypt().getPassKeyPref());
        print("decrypt session $decrypt");
        var data = decrypt;
        data = data.replaceAll("{", "");
        data = data.replaceAll("}", "");
        data = data.replaceAll("'", "");
        var listData = data.split(",");
        ResponseSession session = ResponseSession(authToken: listData[0].split(":")[1].toString(), token: listData[1].split(":")[1].toString());

        var utilityBox = await FireshipDatabase.openBoxDatabase(FireshipUtilityBox.TABEL_NAME);
        utilityBox.put(FireshipUtilityBox.BEARIER, session.token);
        utilityBox.put(FireshipUtilityBox.AUTH_TOKEN, session.authToken);
        await ProfileBloc().initProfile().then((value) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), ModalRoute.withName('/dashboard'));
        });
      }
    });
  }

  static Future<OTPResponse> otpRequest(BodyEncrypt bodyEncrypt) async {
    var dio = await DioService.checkConnection(tryAgainMethod: otpRequest, isLoading: true);
    DioClient dioClient = DioClient(dio);
    var response = await dioClient.otp(bodyEncrypt.toJson());
    return OTPResponse.fromJson(response.data);
  }

}