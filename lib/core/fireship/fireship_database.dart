import 'dart:convert';
import 'dart:typed_data';

import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:hive/hive.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'fireship_encrypt.dart';

class FireshipDatabase {

  // static Future<Uint8List> generateKey() async {
  //   // final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  //   var containsEncryptionKey = await secureStorage.containsKey(key: FireshipCrypt.TOKEN);
  //
  //   if (!containsEncryptionKey) {
  //     var key = Hive.generateSecureKey();
  //     // await secureStorage.write(key: FireshipCrypt.TOKEN, value: base64UrlEncode(key));
  //   }
  //
  //   var encryptionKey = base64Url.decode(await secureStorage.read(key: FireshipCrypt.TOKEN) ?? "");
  //   GlobalFunctions.logPrint('Encryption key: ' ,encryptionKey);
  //   return encryptionKey;
  // }

  static Future<Box<dynamic>> openBoxDatabase(String boxName) async {
    var box = await Hive.openBox(boxName);
    return box;
  }
}