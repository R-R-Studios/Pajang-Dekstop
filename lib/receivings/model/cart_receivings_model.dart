import 'package:flutter/cupertino.dart';

class CartReceivingsModel {
  int? id;
  String? name;
  String? code;
  String? barcode;
  String? description;
  int? unitId;
  double? salePrice;
  double? originalPrice;
  String? unitName;
  double? qty;
  String? total;

  bool isFromPO = false;

  FocusNode focusPrice = FocusNode();
  FocusNode focusQty = FocusNode();
  FocusNode focusRaw = FocusNode();

  CartReceivingsModel(
      {this.id,
        this.name,
        this.code,
        this.barcode,
        this.description,
        this.unitId,
        this.salePrice,
        this.originalPrice,
        this.unitName,
        this.qty,
        this.total});

  CartReceivingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    unitId = json['unit_id'];
    salePrice = json['sale_price'];
    originalPrice = json['original_price'];
    unitName = json['unit'];
    qty = json['qty'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    data['unit_id'] = this.unitId;
    data['sale_price'] = this.salePrice;
    data['original_price'] = this.originalPrice;
    data['unit'] = this.unitName;
    data['qty'] = this.qty;
    data['total'] = this.total;
    return data;
  }
}