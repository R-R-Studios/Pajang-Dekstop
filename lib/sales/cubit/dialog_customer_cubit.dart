import 'package:beben_pos_desktop/customer/model/end_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dialog_customer_state.dart';

class DialogCustomerCubit extends Cubit<DialogCustomerState> {
  DialogCustomerCubit() : super(DialogCustomerInitial());
}
