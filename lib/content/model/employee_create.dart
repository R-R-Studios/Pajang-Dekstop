import 'employee.dart';

class EmployeeCreate {

  Employee? employee;

  EmployeeCreate({this.employee});

  EmployeeCreate.fromJson(Map<String, dynamic> json) {
    employee =
        json['employee'] != null ? new Employee.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    return data;
  }
}