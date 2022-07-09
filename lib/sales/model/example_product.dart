class MyProduct {
  late List<Product> product;

  MyProduct({required this.product});

  MyProduct.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? productId;
  int? unitId;
  int? trxStock;
  int? salePrice;

  Product({this.productId, this.unitId, this.trxStock, this.salePrice});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    unitId = json['unit_id'];
    trxStock = json['trx_stock'];
    salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['unit_id'] = this.unitId;
    data['trx_stock'] = this.trxStock;
    data['sale_price'] = this.salePrice;
    return data;
  }
}