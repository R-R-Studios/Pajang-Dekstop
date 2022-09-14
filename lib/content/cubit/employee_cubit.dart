import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/content/provider/content_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/employee_create.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeLoading()){
    onGetEmployee();
  }

  onGetEmployee() async {
    var list = await ContentProvider.employeeList();
    emit(EmployeeLoaded(listEmployee: list));
  }

  creteEmployee(String name, String phoneNumber, String jobDesk) async {
    await ContentProvider.employeeCreate(EmployeeCreate(
      employee: Employee(
        name: name,
        jobDesk: jobDesk,
        phoneNumber: phoneNumber
      )
    ));
    onGetEmployee();
  }

}
