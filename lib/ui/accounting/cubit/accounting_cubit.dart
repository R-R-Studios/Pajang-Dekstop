import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'accounting_state.dart';

class AccountingCubit extends Cubit<AccountingState> {
  AccountingCubit() : super(AccountingInitial());
}
