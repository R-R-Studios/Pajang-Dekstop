import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/ui/transaction/model/transaction_detail.dart';
import 'package:beben_pos_desktop/ui/transaction/provider/transaction_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_detail_state.dart';

class TransactionDetailCubit extends Cubit<TransactionDetailState> {

  final MerchantTransaction merchantTransaction;

  TransactionDetailCubit({required this.merchantTransaction}) : super(TransactionDetailLoading()){
    onGetTransaction();
  }

  onGetTransaction() async {
    var detail = await TransactionProvider.transactionDetail(merchantTransaction.id.toString());
    emit(TransactionDetailLoaded(transactionDetail: detail));
  }

}
