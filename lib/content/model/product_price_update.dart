class ProductPriceUpdateRequest {
  int? productId;
  int? salePrice;
  String? type;

  ProductPriceUpdateRequest({this.productId, this.salePrice, this.type});

  ProductPriceUpdateRequest.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    salePrice = json['sale_price'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sale_price'] = this.salePrice;
    data['type'] = this.type;
    return data;
  }
}
