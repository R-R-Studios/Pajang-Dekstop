class DetailPreviewTransactionPO {
  int? productId;
  String? productName;
  int? unitId;
  String? unitName;
  double? origPrice;
  String? barcode;
  double? qty;

  DetailPreviewTransactionPO(
      {this.productId,
        this.productName,
        this.unitId,
        this.unitName,
        this.origPrice,
        this.barcode,
        this.qty});

  DetailPreviewTransactionPO.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
    origPrice = double.parse("${int.parse("${json['orig_price']}")}");
    barcode = json['barcode'];
    qty = double.parse("${json['qty']}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    data['orig_price'] = this.origPrice;
    data['barcode'] = this.barcode;
    data['qty'] = this.qty;
    return data;
  }
}