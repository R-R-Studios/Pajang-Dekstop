import 'package:beben_pos_desktop/content/model/brand.dart';
import 'package:beben_pos_desktop/content/model/category.dart';
import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/content/provider/content_provider.dart';
import 'package:beben_pos_desktop/delivery/model/operational.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/ui/transaction/provider/transaction_provider.dart';
import 'package:rxdart/subjects.dart';

class FindBloc {
  
  BehaviorSubject<List<MerchantTransaction>> merchantTransactionController = new BehaviorSubject();
  BehaviorSubject<List<Employee>> employeeController = new BehaviorSubject();
  BehaviorSubject<List<Vehicle>> vehicleController = new BehaviorSubject();
  BehaviorSubject<List<Operational>> operatioalController = new BehaviorSubject();
  BehaviorSubject<List<Brand>> brandController = new BehaviorSubject();
  BehaviorSubject<List<Category>> categoryController = new BehaviorSubject();

  Stream<List<MerchantTransaction>> get merchantTransaction => merchantTransactionController.stream;
  Stream<List<Employee>> get employee => employeeController.stream;
  Stream<List<Vehicle>> get vehicles => vehicleController.stream;
  Stream<List<Operational>> get operational => operatioalController.stream;
  Stream<List<Brand>> get brand => brandController.stream;
  Stream<List<Category>> get category => categoryController.stream;

  close(){
    merchantTransactionController.close();
    employeeController.close();
    vehicleController.close();
    operatioalController.close();
    brandController.close();
    categoryController.close();
  }

  getTransaction() async {
    var list = await TransactionProvider.transactionList();
    merchantTransactionController.add(list);
  }

  getVehicle() async {
    var list = await ContentProvider.vehicleList();
    vehicleController.sink.add(list);
  }

  getEmployee() async {
    var list = await ContentProvider.employeeList();
    employeeController.add(list);
  }
  
  getBrand() async {
    var list = await ContentProvider.brands();
    brandController.add(list);
  }
  
  getCategory() async {
    var list = await ContentProvider.category();
    categoryController.add(list);
  }
}