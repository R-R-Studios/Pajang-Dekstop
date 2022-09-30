import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/session/model/otp_response.dart';
import 'package:beben_pos_desktop/ui/password/cubit/password_cubit.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class PasswordView extends StatelessWidget {

  final OTPResponse otpResponse;

  PasswordView({ required this.otpResponse, Key? key }) : super(key: key);

  static final _formKey = new GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.white,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 10,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25.0,
              ),
              label: Component.text("Back", colors: ColorPalette.white),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                primary: Color(0xff3498db)
              ),
            ),
          ),
        ),
      ),
      backgroundColor: ColorPalette.white,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Component.text(
                "Lupa Kata Sandi",
                fontSize: 25,
                colors: ColorPalette.primary,
                fontWeight: FontWeight.bold
              ),
              const SizedBox(height: 20,),
              Card(
                color: GlobalColorPalette.colorPrimaryGreen,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          child: Container(
                            width: SizeConfig.screenWidth * 0.4,
                            child: TextFormField(
                              controller: otpController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Please enter your otp';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 14, height: 1),
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.pin,
                                  color: Colors.lightBlue[800],
                                ),
                                contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 0.0
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0
                                  ),
                                ),
                                hintText: 'Otp',
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: SizeConfig.screenWidth * 0.4,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              // obscureText: _obscureText,
                              style: TextStyle(fontSize: 14, height: 1),
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.lock_open,
                                  color: Colors.lightBlue[800],
                                ),
                                contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 0.0
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0
                                  ),
                                ),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: SizeConfig.screenWidth * 0.4,
                            child: TextFormField(
                              controller: passwordConfirmationController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Please enter your confirmation password';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              // obscureText: _obscureText,
                              style: TextStyle(fontSize: 14, height: 1),
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true,
                                // suffixIcon: IconButton(
                                //   icon: Icon(
                                //     // Based on passwordVisible state choose the icon
                                //     !_obscureText ? Icons.visibility : Icons.visibility_off,
                                //     color: Theme.of(context).primaryColorDark,
                                //   ),
                                //   onPressed: _toggle,
                                // ),
                                prefixIcon: Icon(
                                  Icons.lock_open,
                                  color: Colors.lightBlue[800],
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(
                                        6.0, 18.0, 6.0, 18.0),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.0),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0),
                                ),
                                hintText: 'Password Confirmation',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth * 0.4,
                          margin: EdgeInsets.only(top: 18),
                          height: 40,
                          child: ElevatedButton(
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                PasswordCubit().onUpdatePassword(
                                  otpResponse.phoneNumber!, 
                                  otpController.text,
                                  passwordController.text, 
                                  passwordConfirmationController.text
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: GlobalColorPalette.colorButtonActive,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0),
                              ),
                            ), child:  Text(
                            'Konfirmasi',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}