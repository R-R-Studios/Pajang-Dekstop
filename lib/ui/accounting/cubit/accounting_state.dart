part of 'accounting_cubit.dart';

abstract class AccountingState extends Equatable {
  const AccountingState();

  @override
  List<Object> get props => [];
}

class AccountingInitial extends AccountingState {}
