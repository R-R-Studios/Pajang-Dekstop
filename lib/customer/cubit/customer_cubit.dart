import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/customer/model/customer_create.dart';
import 'package:beben_pos_desktop/customer/model/end_user.dart';
import 'package:beben_pos_desktop/customer/provider/customer_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerLoading()){
    onGetCustomer();
  }

  onGetCustomer() async {
    emit(CustomerLoaded(listCustomer: await CustomerProvider.customerList()));
  }

  createCustomer(String name, String phoneNumber, String address, String email) async {
    CustomerCreate customerCreate = CustomerCreate(
      address: address,
      contactName: name,
      contactPhoneNumber: phoneNumber,
      user: User(
        phoneNumber: phoneNumber,
        description: '',
        email: email,
        name: name
      )
    );
    var key = FireshipCrypt().encrypt(jsonEncode(customerCreate), await FireshipCrypt().getPassKeyPref());
    await CustomerProvider.customerCreate(BodyEncrypt(key, key));
    emit(CustomerLoading());
    onGetCustomer();
  }
}
