import 'package:beben_pos_desktop/content/model/vehicle_create.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/content_provider.dart';

part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleLoaded(listVehicle: [])){
    onGetVehicle();
  }

  onGetVehicle() async {
    emit(VehicleLoading());
    emit(VehicleLoaded(listVehicle: await ContentProvider.vehicleList()));
  }

  creteVehicle(String nopol, String merk, String desc) async {
    await ContentProvider.veheicleCreate(VehicleCreate(vehicle: Vehicle(
      nopol: nopol,
      merk: merk,
      description: desc
    )));
    onGetVehicle();
  }
}
