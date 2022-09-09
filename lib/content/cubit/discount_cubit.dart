import 'dart:convert';

import 'package:beben_pos_desktop/content/model/discount.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:bloc/bloc.dart';

import '../model/discount.dart';
import 'package:equatable/equatable.dart';
import '../provider/content_provider.dart';

part 'discount_state.dart';

class DiscountCubit extends Cubit<DiscountState> {

  DiscountCubit() : super(DiscountLoading()){
    onGetDiscount();
  }

  onGetDiscount() async {
    emit(DiscountLoading());
    emit(DiscountLoaded(listDiscount: await ContentProvider.discountList()));
  }

  creteDiscount(Discount discount) async {
    String key = FireshipCrypt().encrypt(jsonEncode(discount), await FireshipCrypt().getPassKeyPref());
    await ContentProvider.discountCreate(BodyEncrypt(key, key));
    onGetDiscount();
  }
}
