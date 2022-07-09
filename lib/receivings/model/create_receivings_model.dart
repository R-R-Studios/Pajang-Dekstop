import 'package:beben_pos_desktop/receivings/model/create_product_receivings_model.dart';

class CreateRecevingsModel {
  List<CreateProductReceivingsModel>? product;
  String? trxCode;
  String? act;

  CreateRecevingsModel({this.product, this.trxCode, this.act});

  CreateRecevingsModel.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = [];
      json['product'].forEach((v) {
        product!.add(new CreateProductReceivingsModel.fromJson(v));
      });
    }
    if(json['transaction_code'] != null){
      trxCode = json['transaction_code'];
    }
    if(json['act'] != null){
      act = json['act'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product?.map((v) => v.toJson()).toList()??[];
    }
    if (this.trxCode != null){
      data['transaction_code'] = this.trxCode??"";
    }
    if (this.act != null){
      data['act'] = this.act??"";
    }
    return data;
  }
}
