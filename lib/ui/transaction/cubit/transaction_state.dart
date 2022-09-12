part of 'transaction_cubit.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {

  final List<MerchantTransaction> listTransaction;

  TransactionLoaded({
    required this.listTransaction
  });

  @override
  List<Object> get props => [listTransaction];

}
