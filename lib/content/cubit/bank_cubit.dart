import 'package:beben_pos_desktop/content/model/bank_create.dart';
import 'package:beben_pos_desktop/content/provider/content_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/merchant_bank.dart';

part 'bank_state.dart';

class BankCubit extends Cubit<BankState> {
  BankCubit() : super(BankLoading()){
    onGetBank();
  }

  onGetBank() async {
    emit(BankLoading());
    emit(BankLoaded(listBank: await ContentProvider.bankList()));
  }

  creteBank(String bank, String nameAccount, String noAccount) async {
    await ContentProvider.bankCreate(BankCreate(bank: MerchantBank(accountName: nameAccount, accountNumber: noAccount, name: bank)));
    onGetBank();
  }
}
