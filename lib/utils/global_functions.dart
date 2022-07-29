import 'dart:async';
import 'dart:convert';
import 'package:beben_pos_desktop/session/login_screen.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'global_variable.dart';

class GlobalFunctions {
  static void log(String className, dynamic logData) {
    if (GlobalVariable.DEBUG) {
      logPrint(className, logData);
    }
  }

  static void logPrint(String tag, dynamic log) {
    if (GlobalVariable.DEBUG) {
      printWrapped(tag + " => " + jsonEncode(log));
    }
  }

  static void logOut(BuildContext context) async {
    await Hive.deleteFromDisk().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          ModalRoute.withName('/login'));
    });
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static Future<bool> checkConnectivity() async {
    bool connect = false;
    // try {
    //   final result = await InternetAddress.lookup('google.com')
    //       .timeout(Duration(seconds: 10));
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     connect = true;
    //   }
    //   GlobalFunctions.logPrint("connect", "$connect");
    // } on SocketException catch (_) {
    //   GlobalFunctions.logPrint("connect", "$connect");
    //   connect = false;
    // }
    // GlobalFunctions.logPrint("connect", "$connect");
    return connect = true;
  }

  static Future<bool> checkConnectivityApp() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
    }
    return result;
  }

  static showToast(String message,
      {int duration = 3,
      int position = 1,
      Color backgroundColor = GlobalColorPalette.colorPrimary}) {
    BotToast.showText(
      contentColor: Colors.white,
      text: message,
      textStyle: TextStyle(color: Colors.black),
      backgroundColor: backgroundColor,
    );
    // Flushbar(
    //   margin: EdgeInsets.all(8),
    //   // borderRadius: 8,
    //   borderRadius: BorderRadius.circular(8),
    //   duration: Duration(seconds: duration),
    //   backgroundColor: backgroundColor,
    //   icon: Icon(Icons.error_outline, color: Colors.red),
    //   message: message,
    // ).show(navGK.currentContext!);
  }

  static showSnackBarError(String message) {
    BotToast.showCustomNotification(toastBuilder: (cancel) {
      return Card(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
              margin: EdgeInsets.all(8),
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_sharp,
                    color: GlobalColorPalette.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: GlobalColorPalette.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )));
    });
    BotToast.closeAllLoading();
  }

  static showSnackBarWarning(String message,
      {Color colors = GlobalColorPalette.colorPrimary}) {
    BotToast.showCustomNotification(toastBuilder: (cancel) {
      return Card(
          color: colors,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
              margin: EdgeInsets.all(8),
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: GlobalColorPalette.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: GlobalColorPalette.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )));
    });
    BotToast.closeAllLoading();
  }

  static showSnackBarSuccess(String message,
      {Color colors = GlobalColorPalette.success}) {
    BotToast.showCustomNotification(toastBuilder: (cancel) {
      return Card(
          color: colors,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
              margin: EdgeInsets.all(8),
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: GlobalColorPalette.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: GlobalColorPalette.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )));
    });
    BotToast.closeAllLoading();
  }

  static version() {
    return "1.0.0";
  }

  // static showLoading(){
  //   CustomLoading customDialogLoading = CustomLoading();
  //   customDialogLoading.showCustomLoading();
  // }
  //
  // static dismisLoading(){
  //   CustomLoading customDialogLoading = CustomLoading();
  //   customDialogLoading.dismisCustomLoading();
  // }

  static formatPriceDouble(double price) => '\$ ${price.toStringAsFixed(2)}';

  static formatPriceInt(int price) => '\$ ${price.toStringAsFixed(2)}';

  static String myDomainStatus() {
    String url;
    if (GlobalVariable.RELEASE) {
      url = GlobalVariable.BASIC_URL_PRODUCTION;
    } else {
      url = GlobalVariable.BASIC_URL_STAGGING;
    }
    return url;
  }
}
