part of 'vehicle_cubit.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoaded extends VehicleState {

  final List<Vehicle> listVehicle;

  VehicleLoaded({
    required this.listVehicle
  });

  @override
  List<Object> get props => [
    listVehicle
  ];

}

class VehicleLoading extends VehicleState {}

