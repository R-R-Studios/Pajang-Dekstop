import 'package:beben_pos_desktop/receivings/model/price_list_model.dart';

class ProductReceivingsModel {
  int? id;
  String? name;
  String? code;
  String? barcode;
  String? description;
  List<PriceList>? priceList;

  ProductReceivingsModel(
      {this.id,
        this.name,
        this.code,
        this.barcode,
        this.description,
        this.priceList});

  ProductReceivingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    if (json['price_list'] != null) {
      priceList = [];
      json['price_list'].forEach((v) {
        priceList!.add(new PriceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    if (this.priceList != null) {
      data['price_list'] = this.priceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}