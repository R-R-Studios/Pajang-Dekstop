import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/ui/sale/provider/sale_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sale_state.dart';

class SaleCubit extends Cubit<SaleState> {
  SaleCubit() : super(SaleInitial());

  navigation(SaleTypeMenu saleTypeMenu) {
    switch (saleTypeMenu) {
      case SaleTypeMenu.balance:
        emit(SaleBalance());
        break;
      case SaleTypeMenu.shift:
        emit(SaleShift());
        break;
      default:
        emit(SaleInitial());
    }
  }
  
  updateBalance(){

  }

}
