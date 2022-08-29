part of 'dialog_customer_cubit.dart';

abstract class DialogCustomerState extends Equatable {
  const DialogCustomerState();

  @override
  List<Object> get props => [];
}

class DialogCustomerInitial extends DialogCustomerState {}

class DialogCustomerLoading extends DialogCustomerState {}

class DialogCustomerLoaded extends DialogCustomerState {

  final List<EndUser> listCustomer;

  DialogCustomerLoaded({
    required this.listCustomer
  });

}
