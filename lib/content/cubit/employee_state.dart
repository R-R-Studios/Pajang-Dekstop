part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {

  final List<Employee> listEmployee;

  EmployeeLoaded({
    required this.listEmployee
  });

  @override
  List<Object> get props => [
    listEmployee
  ];

}

class EmployeeInitial extends EmployeeState {}
