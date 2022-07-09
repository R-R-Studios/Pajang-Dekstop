import 'package:beben_pos_desktop/product/model/product_data.dart';
import 'package:beben_pos_desktop/product/model/sale_price_model.dart';

class ProductModel {
  ProductData? product;
  List<SalePriceModel>? salePrice;

  bool selected = false;

  ProductModel({this.product, this.salePrice});

  ProductModel.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new ProductData.fromJson(json['product']) : null;
    if (json['sale_price'] != null) {
      salePrice =  [];
      json['sale_price'].forEach((v) {
        salePrice?.add(new SalePriceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product?.toJson();
    }
    if (this.salePrice != null) {
      data['sale_price'] = this.salePrice?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}