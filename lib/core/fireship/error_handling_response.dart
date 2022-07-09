import 'package:beben_pos_desktop/dashboard.dart';
import 'package:beben_pos_desktop/main.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';
import 'fireship_converter.dart';

class ErrorHandlingResponse {
  late final FireshipConverter fireship;
  final bool isPage;
  final bool isPPOB;
  final bool showMessage;

  ErrorHandlingResponse({required this.fireship, this.isPage = false, this.isPPOB = false, this.showMessage = true});

  void checkErrror() {
    GlobalFunctions.logPrint("fireship Code", fireship.code.toString());
    GlobalFunctions.logPrint("fireship Message", fireship.message.toString());
    if (fireship.code! >= 400 && fireship.code! < 500) {
      if (fireship.code == 400) {

      } else if (fireship.code == 401) {
        GlobalFunctions.logPrint('Unauthorize', fireship.code);
        GlobalFunctions.showSnackBarError(fireship.message!);
        GlobalFunctions.logOut(navGK.currentContext!);
        // CoreFunction.onLogout();
      } else if (fireship.code == 402) {
        print('Error 402');
        if(showMessage){
          GlobalFunctions.showSnackBarError(fireship.message!);
        }
      } else if (fireship.code == 403) {
      } else if (fireship.code == 404) {
        GlobalFunctions.logPrint("404", "Service not available");
        GlobalFunctions.showSnackBarWarning(fireship.message!);
      } else if (fireship.code == 406) {
      } else if (fireship.code == 409) {
      } else if (fireship.code == 413) {
      } else if (fireship.code == 426) {
      } else if (fireship.code == 428) {
      } else {
        GlobalFunctions.logPrint("Else ${fireship.code}", "Not Handled");
      }
    } else if (fireship.code! >= 500) {
      if (fireship.code == 503) {
      } else {
        GlobalFunctions.showSnackBarError(fireship.message!);
      }
    } else {
      GlobalFunctions.showSnackBarError(fireship.message!);
    }
  }
}