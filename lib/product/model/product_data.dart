import 'package:beben_pos_desktop/core/core.dart';

class ProductData {
  int? productId;
  String? name;
  String? code;
  String? barcode;
  String? description;
  dynamic createdAt;
  int? priceId;
  int? stockId;
  String? unit;
  String? lastStock;
  String? salePrice;
  String? originalPrice;
  bool? productStatus;
  bool? priceStatus;
  int? unitId;

  ProductData(
      {this.productId,
        this.name,
        this.code,
        this.barcode,
        this.description,
        this.createdAt,
        this.priceId,
        this.stockId,
        this.unit,
        this.lastStock,
        this.salePrice,
        this.originalPrice,
        this.productStatus,
        this.priceStatus,
        this.unitId});

  ProductData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    if(json["created_at"] != null){
      createdAt = json["created_at"];
    }
    priceId = json['price_id'];
    stockId = json['stock_id'];
    unit = json['unit'];
    lastStock = json['last_stock'];
    salePrice = json['sale_price'];
    originalPrice = json['original_price'];
    productStatus = json['product_status'];
    priceStatus = json['price_status'];
    unitId = json['unit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    data['created_at'] = this.createdAt.toString();
    data['price_id'] = this.priceId;
    data['stock_id'] = this.stockId;
    data['unit'] = this.unit;
    data['last_stock'] = this.lastStock;
    data['sale_price'] = this.salePrice;
    data['original_price'] = this.originalPrice;
    data['product_status'] = this.productStatus;
    data['price_status'] = this.priceStatus;
    data['unit_id'] = this.unitId;
    return data;
  }
}