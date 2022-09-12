import 'package:beben_pos_desktop/delivery/provider/delivery_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/delivery.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {

  DeliveryCubit() : super(DeliveryLoading()){
    onGetDelivery();
  }

  onGetDelivery() async {
    emit(DeliveryLoaded(listDelivery: await DeliveryProvider.deliveryList()));
  }
}
