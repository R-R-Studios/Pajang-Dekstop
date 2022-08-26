import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/error_handling_response.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_converter.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_database.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_utility_box.dart';
import 'package:beben_pos_desktop/dashboard.dart';
import 'package:beben_pos_desktop/main.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/global_variable.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:beben_pos_desktop/widget/core_bottom_sheet.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static late Dio dio;

  static Future<Dio> checkConnection(
      {bool showMessage = true,
      bool isLoading = false,
      bool isUseBearer = false,
      bool isBaseUrl = false,
      bool isGeocode = false,
      @required dynamic tryAgainMethod,
      dynamic stopLoadingMethod,
      List<dynamic>? params}) async {
    if (isLoading) dialogLoading();

    return GlobalFunctions.checkConnectivity().then((internet) async {
      GlobalFunctions.logPrint("connect", "$internet");
      if (internet) {
        return await settingUpDio(
            isUseBearer: isUseBearer,
            showMessage: showMessage,
            isLoading: isLoading,
            isGeocode: isGeocode,
            params: params,
            tryAgainMethod: tryAgainMethod,
            stopLoadingMethod: stopLoadingMethod);
      } else {
        return Dio();
      }
    });
  }

  static Future<Dio> settingUpDio(
      {bool showMessage = true,
      bool isLoading = false,
      bool isUseBearer = false,
      bool isGeocode = false,
      bool isPage = false,
      dynamic tryAgainMethod,
      dynamic stopLoadingMethod,
      dynamic params}) async {
    var timeRequest = "";
    dio = new Dio(await baseOptions(isGeocode, isUseBearer));

    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions? requestOptions, handler) async {
      GlobalFunctions.logPrint("RequestOptions", requestOptions.toString());
      GlobalFunctions.logPrint("============= onRequest =============", "");
      handler.next(requestOptions!);
    }, onResponse: (Response? response, handler) async {
      if (!isGeocode) {
        GlobalFunctions.logPrint("============= onResponse =============", "");
        FireshipConverter fireship = FireshipConverter();
        GlobalFunctions.logPrint("response", "${response}");
        fireship.toAtozObject(response!.data['meta']);


        if (fireship.code! > 200 && fireship.code! < 600) {
          print("ErrorHandlingResponse");
          ErrorHandlingResponse(fireship: fireship, showMessage: showMessage).checkErrror();
        } else {
          if (isLoading) {
            GlobalFunctions.showSnackBarSuccess(fireship.message!);
          }
        }
      }
      if (isLoading) {
        Navigator.pop(navGK.currentContext!);
      }
      handler.next(response!);
    }, onError: (DioError e, handler) async {
      GlobalFunctions.logPrint("response", "${e.message}");
      if (stopLoadingMethod != null) stopLoadingMethod();

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        showTimeOut(
            "Periksa kembali koneksi anda atau coba untuk berpindah jaringan",
            "Koneksi lambat",
            params: params,
            tryAgainMethod: tryAgainMethod);
        return Future.error(e);
      } else if (e.type == DioErrorType.other) {
        BotToast.showText(
            contentColor: Colors.white,
            text: '${e.message}',
            textStyle: TextStyle(color: Colors.black));
      } else if (e.type == DioErrorType.response) {
        print("response.statusCode =========== ${e.response!.statusCode}");
        print("Fireshop Response ${e.response}");
        FireshipConverter fireship = FireshipConverter();
        fireship.code = e.response!.statusCode!;
        fireship.message = e.response!.statusMessage!;
        ErrorHandlingResponse(fireship: fireship, showMessage: showMessage)
            .checkErrror();
      }
      if (isLoading) {
        Navigator.pop(navGK.currentContext!);
      }
      handler.next(e);
    }));

    dio.interceptors.add(PrettyDioLogger(
        error: GlobalVariable.DEBUG,
        request: GlobalVariable.DEBUG,
        requestBody: GlobalVariable.DEBUG,
        requestHeader: GlobalVariable.DEBUG,
        responseBody: GlobalVariable.DEBUG,
        responseHeader: GlobalVariable.DEBUG,
        compact: GlobalVariable.DEBUG,
        maxWidth: 500));

    return dio;
  }

  static Future<BaseOptions> baseOptions(bool isGeoCode, bool isBearier) async {
    var utilityBox =
        await FireshipDatabase.openBoxDatabase(FireshipUtilityBox.TABEL_NAME);

    return BaseOptions(
        baseUrl: GlobalFunctions.myDomainStatus(),
        connectTimeout: GlobalVariable.TIME_REQUEST_API.inMilliseconds,
        receiveTimeout: GlobalVariable.TIME_REQUEST_API.inMilliseconds,
        sendTimeout: GlobalVariable.TIME_REQUEST_API.inMilliseconds,
        headers: isBearier
            ? ({
                'Cache-Control': GlobalVariable.CACHE_CONTROL,
                'Content-Type': GlobalVariable.CONTENT_TYPE,
                'ClientKey': GlobalVariable.CLIENT_KEY,
                'Apps-Version': GlobalFunctions.version(),
                // 'Apps-Origin': GlobalVariable.APPS_ORIGIN,
                // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
                // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
                // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                // "Access-Control-Allow-Methods": "POST, OPTIONS",
                'Authorization':
                    'Bearer' + await utilityBox.get(FireshipUtilityBox.BEARIER),
                // 'device-agen': GlobalVariable.DEVICE_AGEN,
              })
            : ({
                // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
                // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
                // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                // "Access-Control-Allow-Methods": "POST, OPTIONS",
                'Cache-Control': GlobalVariable.CACHE_CONTROL,
                'Content-Type': GlobalVariable.CONTENT_TYPE,
                'ClientKey': GlobalVariable.CLIENT_KEY,
                'Apps-Version': GlobalFunctions.version(),
                // 'Apps-Origin': GlobalVariable.APPS_ORIGIN,
                // 'device-agen': GlobalVariable.DEVICE_AGEN,
              }));
  }

  static void dialogLoading() {
    showDialog(
      context: navGK.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Card(
              color: Colors.white,
              child: Container(
                width: SizeConfig.screenWidth * 0.3,
                height: SizeConfig.screenHeight * 0.3,
                child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoActivityIndicator(radius: 30,),
                        Text("Mohon Tunggu...")
                      ],
                    )
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  static void showTimeOut(message, title, {params, tryAgainMethod}) {
    if (tryAgainMethod == null) {
      // AtozDialog.dialog(
      //   context: navGK.currentContext!,
      //   message: message,
      //   title: title,
      //   dismissable: true,
      // );
    } else {
      showDialog(
          context: navGK.currentContext!,
          barrierDismissible: true,
          builder: (BuildContext buildContext) {
            return AlertDialog(
                title: Text(
                  title,
                ),
                content: Text(message),
                actions: [
                  ElevatedButton(
                    child: new Text(
                      "",
                      // AppLocalizations.of(navGK.currentContext!)!.try_again,
                      style: new TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: () {
                      Navigator.of(buildContext).pop();
                      if (params == null) {
                        tryAgainMethod();
                      } else {
                        try {
                          if (params.length == 4) {
                            tryAgainMethod(
                                params[0], params[1], params[2], params[3]);
                          } else if (params.length == 3) {
                            tryAgainMethod(params[0], params[1], params[2]);
                          } else if (params.length == 2) {
                            tryAgainMethod(params[0], params[1]);
                          } else {
                            tryAgainMethod(params.first);
                          }
                        } catch (e) {
                          tryAgainMethod(params.first);
                        }
                      }
                    },
                  )
                ]);
          });
    }
  }
}
