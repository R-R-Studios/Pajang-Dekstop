import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/ui/password/model/password_update_request.dart';
import 'package:beben_pos_desktop/ui/password/provider/password_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nav_router/nav_router.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {

  PasswordCubit() : super(PasswordInitial());

  onUpdatePassword(String phoneNumber, String otp, String password, String passwordConfirm) async {
    PasswordUpdateRequest passwordUpdateRequest = PasswordUpdateRequest(
      otpCode: otp,
      phoneNumber: phoneNumber,
      password: password,
      passwordConfirmation: passwordConfirm
    );
    var key = FireshipCrypt().encrypt(jsonEncode(passwordUpdateRequest), await FireshipCrypt().getPassKeyPref());
    await PasswordProvider.update(BodyEncrypt(key, key));
    GlobalFunctions.showSnackBarSuccess("Sukses Mengganti Password");
    GlobalFunctions.logOut(navGK.currentContext!);
  }

}
