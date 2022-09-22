import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/content/model/vehicle.dart';

class Delivery {
  int? id;
  String? orderNumber;
  String? totalAmount;
  String? totalOperationalAmount;
  int? merchantVehicleId;
  int? merchantEmployeeId;
  String? description;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;
  Employee? employee;

  Delivery({
    this.id,
    this.orderNumber,
    this.totalAmount,
    this.totalOperationalAmount,
    this.merchantVehicleId,
    this.merchantEmployeeId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.vehicle,
    this.employee
  });

  Delivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    totalAmount = json['total_amount'];
    totalOperationalAmount = json['total_operational_amount'];
    merchantVehicleId = json['merchant_vehicle_id'];
    merchantEmployeeId = json['merchant_employee_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if( json['merchant_vehicle'] != null){
      vehicle = Vehicle.fromJson(json['merchant_vehicle']);
    }
    if( json['merchant_employee'] != null){
      employee = Employee.fromJson(json['merchant_employee']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['total_amount'] = this.totalAmount;
    data['total_operational_amount'] = this.totalOperationalAmount;
    data['merchant_vehicle_id'] = this.merchantVehicleId;
    data['merchant_employee_id'] = this.merchantEmployeeId;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}