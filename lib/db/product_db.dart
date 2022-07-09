
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'product_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_1)
class ProductModel extends HiveObject {
  @HiveField(0)
  String? item;
  @HiveField(1)
  String? itemName;
  @HiveField(2)
  double? price;
  @HiveField(3)
  double? quantity;
  @HiveField(4)
  int? disc;
  @HiveField(5)
  double? total;
  @HiveField(6)
  int? productId;
  @HiveField(7)
  int? unitId;
  @HiveField(8)
  String? unitName;

  FocusNode focusQty = FocusNode();

  bool isDiscount = false;

  bool selected = false;

  ProductModel(
      {
        this.item,
        this.itemName,
        this.price,
        this.quantity,
        this.disc,
        this.total,
        this.productId,
        this.unitId,
        this.unitName});

  factory ProductModel.fromProductModel(ProductModel productModel){
    return ProductModel(
      item: productModel.item,
      itemName: productModel.itemName,
      price: productModel.price,
      quantity: productModel.quantity,
      disc: productModel.disc,
      total: productModel.total,
      productId: productModel.productId,
      unitId:  productModel.unitId,
      unitName:  productModel.unitName
    );
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    item = json['item#'];
    itemName = json['item_name'];
    price = json['price'];
    quantity = json['quantity'];
    disc = json['disc'];
    total = json['total'];
    productId = json['id'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item#'] = this.item;
    data['item_name'] = this.itemName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['disc'] = this.disc;
    data['total'] = this.total;
    data['id'] = this.productId;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    return data;
  }
}