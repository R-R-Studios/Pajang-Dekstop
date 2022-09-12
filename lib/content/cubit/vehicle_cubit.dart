import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/content_provider.dart';

part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleLoaded(listVehicle: []));

  onGetVehicle() async {
    emit(VehicleLoading());
    // emit(VehicleLoaded(listVehicle: await ContentProvider.VehicleList()));
  }

  creteVehicle(String nopol, String merk, String desc) async {
    // await ContentProvider.VehicleCreate(VehicleCreate(Vehicle: MerchantVehicle(accountName: nameAccount, accountNumber: noAccount, name: Vehicle)));
    onGetVehicle();
  }
}
