part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {

  final List<EndUser> listCustomer;

  CustomerLoaded({
    required this.listCustomer
  });

  @override
  List<Object> get props => [listCustomer];

}
