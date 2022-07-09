class MerchantTransactionModel {
  int? productId;
  double? trxStock;
  int? unitId;
  String? unitName;

  MerchantTransactionModel({this.productId, this.trxStock, this.unitId, this.unitName});

  MerchantTransactionModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    trxStock = json['trx_stock'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['trx_stock'] = this.trxStock;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    return data;
  }
}