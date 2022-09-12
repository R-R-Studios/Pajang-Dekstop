import 'package:beben_pos_desktop/delivery/provider/delivery_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryInitial()){
    onGetTransactionList();
  }

  onGetTransactionList() async {
    // await DeliveryProvider.orderList();
  }

}
