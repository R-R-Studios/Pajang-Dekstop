import 'package:beben_pos_desktop/customer/model/end_user.dart';
import 'package:beben_pos_desktop/customer/provider/customer_provider.dart';
import 'package:rxdart/rxdart.dart';

class DialogCustomerBloc {

  BehaviorSubject<List<EndUser>> controllerEndUser = new BehaviorSubject();

  Stream<List<EndUser>> get streamListEndUser => controllerEndUser.stream;

  getList() async {
    controllerEndUser.sink.add(await CustomerProvider.customerList());
  }

  close(){
    controllerEndUser.close();
  }
}