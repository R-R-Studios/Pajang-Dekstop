import 'dart:convert';

import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/delivery/model/delivery_create.dart';
import 'package:beben_pos_desktop/delivery/model/operational.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:beben_pos_desktop/delivery/provider/delivery_provider.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:rxdart/subjects.dart';

import '../../utils/global_functions.dart';
import 'package:collection/collection.dart';

class DeliveryBloc {
  
  List<MerchantTransaction> listTransaction = [];
  List<Vehicle> listVehicle = [];
  List<Employee> listEmployee = [];
  List<Operational> listOperational = [];

  BehaviorSubject<List<MerchantTransaction>> merchantTransactionController = new BehaviorSubject();
  BehaviorSubject<List<Employee>> employeeController = new BehaviorSubject();
  BehaviorSubject<List<Vehicle>> vehicleController = new BehaviorSubject();
  BehaviorSubject<List<Operational>> operatioalController = new BehaviorSubject();

  Stream<List<MerchantTransaction>> get merchantTransaction => merchantTransactionController.stream;
  Stream<List<Employee>> get employee => employeeController.stream;
  Stream<List<Vehicle>> get vehicles => vehicleController.stream;
  Stream<List<Operational>> get operational => operatioalController.stream;

  addTransaction(MerchantTransaction merchantTransaction) {
    var index = listTransaction.indexWhere((element) => element.transactionCode == merchantTransaction.transactionCode);
    if(index == -1){
      merchantTransactionController.sink.add([]);
      listTransaction.add(merchantTransaction);
      merchantTransactionController.sink.add(listTransaction); 
    } else {
      GlobalFunctions.showSnackBarError("Transaksi sudah di masukan");
    }
  }

  addVehicle(Vehicle vehicle) {
    var index = listVehicle.indexWhere((element) => element.nopol == vehicle.nopol);
    if(index == -1){
      vehicleController.sink.add([]);
      listVehicle.add(vehicle);
      vehicleController.sink.add(listVehicle); 
    } else {
      GlobalFunctions.showSnackBarError("Kendaraan sudah di masukan");
    }
  }

  addEmployee(Employee employee){
    var index = listEmployee.indexWhere((element) => element.id == employee.id);
    if(index == -1){
      employeeController.sink.add([]);
      listEmployee.add(employee);
      employeeController.sink.add(listEmployee); 
    } else {
      GlobalFunctions.showSnackBarError("Kendaraan sudah di masukan");
    }
  }

  addOperational(Operational operational) {
    operatioalController.sink.add([]);
    listOperational.add(operational);
    operatioalController.sink.add(listOperational); 
  }

  deleteTransaction(int index){
    listTransaction.removeAt(index);
    merchantTransactionController.sink.add(listTransaction);
  }

  deleteVehicle(int index){
    listVehicle.removeAt(index);
    vehicleController.sink.add(listVehicle);
  }

  deleteEmploye(int index){
    listEmployee.removeAt(index);
    employeeController.sink.add(listEmployee);
  }

  deleteOperational(int index){
    listOperational.removeAt(index);
    operatioalController.sink.add(listOperational);
  }

  onCreateDelivery() async {
    DeliveryCreate deliveryCreate = DeliveryCreate(
      transactionIds: listTransaction.map((i) => i.id!).toList(),
      merchantDeliveryOrder: MerchantDeliveryOrder(
        employeeId: listEmployee.first.id,
        totalAmount: listTransaction.length,
        totalOperationalAmount: listOperational.length,
        vehicleId: listVehicle.first.id,
      ),
      merchantOperational: MerchantOperational(
        operationalDetailsAttributes: listOperational.map((e) => OperationalDetailsAttributes(
          amount: int.parse(e.price.toString()), 
          description: e.desc
        )).toList(),
        totalAmount: listOperational.map((i) => int.parse(i.price.toString())).toList().sum,
        description: "",
      )
    );
    String key = await FireshipCrypt().encrypt(jsonEncode(deliveryCreate), await FireshipCrypt().getPassKeyPref());
    await DeliveryProvider.create(BodyEncrypt(key, key));
  }

  close(){
    merchantTransactionController.close();
    employeeController.close();
    vehicleController.close();
    operatioalController.close();
  }
  
}