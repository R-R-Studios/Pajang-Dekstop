import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/debouncer.dart';

class CoreFunction {
  
  static final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk

  static Debouncer debouncer = Debouncer(delay: const Duration(seconds: 1));

  static void logPrint(String tag, dynamic log) {
    // if (CoreVariable.debug) {
    //   pattern
    //       .allMatches(tag + " => " + log.toString())
    //       .forEach((match) => debugPrint(match.group(0)));
    // }
  }

  static String moneyFormatter(dynamic value) {
    double price = double.tryParse(value.toString()) ?? 0;
    var idr =
    NumberFormat.currency(locale: "id_ID", decimalDigits: 0, symbol: "Rp");
    return idr.format(price);
  }

  static Future<bool> checkConnectivity() async {
    bool connect = false;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connect = true;
      }
    } on SocketException catch (_) {
      connect = false;
    }
    return connect;
  }

  // static showToast(String message, {int duration = 3, int position = 1, Color backgroundColor = ColorPalette.red}) {
    // Flushbar(
    //   margin: const EdgeInsets.all(8),
    //   borderRadius: BorderRadius.circular(8),
    //   duration: Duration(seconds: duration),
    //   backgroundColor: backgroundColor,
    //   icon: const Icon(Icons.error_outline, color: ColorPalette.white),
    //   // message: message,
    //   messageText: Text(
    //     message,
    //     style: const TextStyle(
    //       color: ColorPalette.white,
    //       fontSize: 12
    //     ),
    //     maxLines: 3,
    //   ),
    // ).show(navGK.currentContext!);
  // }

  static String validatePhoneNumber(String phoneNumberUnvalidate) {
    String? phoneNumber;
    if (phoneNumberUnvalidate.substring(0, 2) == '08') {
      phoneNumber = phoneNumberUnvalidate;
    } else if (phoneNumberUnvalidate.substring(0, 2) == '62') {
      phoneNumber = '0${phoneNumberUnvalidate.substring(2)}';
    } else if (phoneNumberUnvalidate.substring(0, 3) == '+62') {
      phoneNumber = '0${phoneNumberUnvalidate.substring(3)}';
    } else if (phoneNumberUnvalidate.substring(0, 1) == '8') {
      phoneNumber = '0' + phoneNumberUnvalidate;
    } else {
      phoneNumber = '0' + phoneNumberUnvalidate;
    }

    return phoneNumber;
  }

  // static String convertMonthToBahasa(String orderDate) {
  //   Map<String, String> map = Map.fromIterables(
  //     CoreVariable.codedMonth,
  //     CoreVariable.decodedMonth,
  //   );
  //   var newDate = map.entries
  //       .fold(orderDate, (String prev, e) => prev.replaceAll(e.key, e.value));
  //   return newDate;
  // }

  static String constructTime(int seconds) {
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return twoDigitNumber(minute.toString()) + ":" + twoDigitNumber(second.toString());
  }

  static String twoDigitNumber(String twoDigit) {
    return twoDigit.toString().length == 1 ? "0" + twoDigit.toString() : twoDigit.toString();
  }

  // static Future<String?> generateFirebaseToken() async {
  //   try {
  //     await FirebaseMessaging.instance.deleteToken();
  //   } catch (e) {
  //     CoreFunction.logPrint("Delete Firebase", e.toString());
  //   }
  //   var token = await FirebaseMessaging.instance.getToken();
  //   return token;
  // }

  // static String version() {
  //   if (Platform.isAndroid) {
  //     return CoreVariable.appsVersionAndroid;
  //   } else if (Platform.isIOS) {
  //     return CoreVariable.appsversionIos;
  //   } else {
  //     return "";
  //   }
  // }

  static String convertImageToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return "data:image/jpeg;base64," + base64Image;
  }

  static Future<File?> convertImageFormBase64(String? image) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dir = await Directory(directory.path + '/dir').create(recursive: true);
    List<int> imageBytes = base64Decode(image ?? "");
    File? file = File("${dir.path}/${DateTime.now().microsecond}.jpg",);
    file.writeAsBytesSync(imageBytes);
    return file;
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Future<Uint8List> getBytesFromAsset({required String path, required int width})async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(), 
      targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png))!
    .buffer.asUint8List();
  }

  static String timeNow() => DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
