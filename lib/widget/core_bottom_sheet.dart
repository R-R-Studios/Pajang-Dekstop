
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class CoreBottomSheet {
  static void noConnection({dynamic method}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: navGK.currentContext!,
        builder: (builder) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0)
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "assets/images/img_otp_verifikasi.png",
                    height: 200,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                      ""
                    // AppLocalizations.of(navGK.currentContext!)!.noConnection,
                    // style: TextStyle(fontFamily: CoreVariable.AxiformaBold, fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    // AppLocalizations.of(navGK.currentContext!)!.notice_connection,
                    "",
                    textAlign: TextAlign.center,
                  ),
                  if (method != null) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      minWidth: SizeConfig.blockSizeHorizontal * 75,
                      // height: 40.0,
                      padding: EdgeInsets.all(10),
                      buttonColor: Colors.lightBlue,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: GlobalColorPalette.colorPrimary,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                          onPressed: () {
                            Navigator.of(navGK.currentContext!).pop();
                            method();
                          },
                          child: new Text(
                            "",
                            // AppLocalizations.of(navGK.currentContext!)!.try_again,
                            style: TextStyle(color: GlobalColorPalette.white),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}