part of 'sale_cubit.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

class SaleInitial extends SaleState {}

class SaleBalance extends SaleState {}

class SaleShift extends SaleState {}
