import 'package:beben_pos_desktop/customer/model/end_user.dart';
import 'package:beben_pos_desktop/customer/provider/customer_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerLoading()){
    onGetCustomer();
  }

  onGetCustomer() async {
    emit(CustomerLoaded(listCustomer: await CustomerProvider.customerList()));
  }
}
