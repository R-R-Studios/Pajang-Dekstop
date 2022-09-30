import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/ui/sale/model/balance_request.dart';
import 'package:beben_pos_desktop/ui/sale/provider/sale_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/balance_response.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(BalanceLoading()){
    onGetBalance();
  }

  onGetBalance() async {
    emit(BalanceLoaded(balanceResponse: BalanceResponse(balance: (await SaleProvider.balance()).toInt())));
  }

  onUpdateBalance(String balance) async {
    emit(BalanceLoading());
    var key = FireshipCrypt().encrypt(jsonEncode(BalanceRequest(balance: int.parse(balance))), await FireshipCrypt().getPassKeyPref());
    var response =  await SaleProvider.balanceUpdate(BodyEncrypt(key, key));
    emit(BalanceLoaded(balanceResponse: response));
  }
}
