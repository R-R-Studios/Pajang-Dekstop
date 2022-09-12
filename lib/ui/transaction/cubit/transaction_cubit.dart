import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/ui/transaction/provider/transaction_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionLoading()){
    onGetTransaction();
  }

  onGetTransaction() async {
    emit(TransactionLoaded(listTransaction: await TransactionProvider.transactionList()));
  }

  navDetail(){
    
  }

}
