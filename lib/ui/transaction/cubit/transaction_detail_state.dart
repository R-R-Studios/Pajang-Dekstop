part of 'transaction_detail_cubit.dart';

abstract class TransactionDetailState extends Equatable {
  const TransactionDetailState();

  @override
  List<Object> get props => [];
}

class TransactionDetailInitial extends TransactionDetailState {}

class TransactionDetailLoading extends TransactionDetailState {}

class TransactionDetailLoaded extends TransactionDetailState {

  final TransactionDetail transactionDetail;

  TransactionDetailLoaded({
    required this.transactionDetail
  });

  @override
  List<Object> get props => [transactionDetail];
  
}
