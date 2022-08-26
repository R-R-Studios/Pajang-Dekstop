part of 'bank_cubit.dart';

abstract class BankState extends Equatable {
  const BankState();

  @override
  List<Object> get props => [];
}

class BankInitial extends BankState {}

class BankLoaded extends BankState {

  final List<MerchantBank> listBank;

  BankLoaded({
    required this.listBank
  });

  @override
  List<Object> get props => [
    listBank
  ];

}

class BankLoading extends BankState {}
