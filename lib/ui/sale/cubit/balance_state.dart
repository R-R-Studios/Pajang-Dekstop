part of 'balance_cubit.dart';

abstract class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object> get props => [];
}

class BalanceInitial extends BalanceState {}

class BalanceLoaded extends BalanceState {

  final BalanceResponse balanceResponse;

  BalanceLoaded({
    required this.balanceResponse
  });

  @override
  List<Object> get props => [balanceResponse];

}

class BalanceLoading extends BalanceState {}
