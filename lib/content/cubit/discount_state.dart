part of 'discount_cubit.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object> get props => [];
}

class DiscountInitial extends DiscountState {}

class DiscountLoaded extends DiscountState {

  final List<Discount> listDiscount;

  DiscountLoaded({
    required this.listDiscount
  });

  @override
  List<Object> get props => [
    listDiscount
  ];

}

class DiscountLoading extends DiscountState {}
