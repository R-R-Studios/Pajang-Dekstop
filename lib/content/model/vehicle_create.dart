import '../../delivery/model/vehicle.dart';

class VehicleCreate {

  Vehicle? vehicle;

  VehicleCreate({this.vehicle});

  VehicleCreate.fromJson(Map<String, dynamic> json) {
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    return data;
  }
}