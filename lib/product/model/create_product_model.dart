import 'package:beben_pos_desktop/product/model/product_model.dart';

class CreateProductModel {
  ProductModel? product;

  CreateProductModel({this.product});

  CreateProductModel.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}