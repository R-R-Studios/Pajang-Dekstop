class CreateProductReceivingsModel {
  int? productId;
  int? unitId;
  double? trxStock;
  String? salePrice;
  String? originalPrice;

  CreateProductReceivingsModel({this.productId, this.unitId, this.trxStock, this.salePrice, this.originalPrice});

  CreateProductReceivingsModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    unitId = json['unit_id'];
    trxStock = json['trx_stock'];
    salePrice = json['sale_price'];
    originalPrice = json["original_price"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['unit_id'] = this.unitId;
    data['trx_stock'] = this.trxStock;
    data['sale_price'] = this.salePrice;
    data["original_price"] = this.originalPrice;
    return data;
  }
}