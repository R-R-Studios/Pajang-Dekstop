
class RequestCreateMerchantProduct {
  CreateProduct? product;
  CreateProductStock? productStock;
  CreateProductPrice? productPrice;
  List<String>? image;

  RequestCreateMerchantProduct({
    this.product, 
    this.productStock, 
    this.productPrice,
    this.image
  });

  RequestCreateMerchantProduct.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new CreateProduct.fromJson(json['product']) : null;
    productStock = json['product_stock'] != null
        ? new CreateProductStock.fromJson(json['product_stock'])
        : null;
    productPrice = json['product_price'] != null
        ? new CreateProductPrice.fromJson(json['product_price'])
        : null;
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product?.toJson();
    }
    if (this.productStock != null) {
      data['product_stock'] = this.productStock?.toJson();
    }
    if (this.productPrice != null) {
      data['product_price'] = this.productPrice?.toJson();
    }
    if (this.image != null) {
    data['image'] = this.image;
    }
    return data;
  }
}

class CreateProduct {
  String? name;
  String? code;
  String? barcode;
  String? description;
  bool? isActive;
  int? brandId;
  int? categoryId;

  CreateProduct({
    this.name, 
    this.code, 
    this.barcode, 
    this.description, 
    this.isActive,
    this.brandId,
    this.categoryId
  });

  CreateProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    isActive = json['is_active'];
    brandId = json['brand_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['brand_id'] = this.brandId;
    data['category_id'] = this.categoryId;
    return data;
  }
}

class CreateProductStock {
  int? unitId;
  double? trxStock;
  double? currentStock;

  CreateProductStock({this.unitId, this.trxStock, this.currentStock});

  CreateProductStock.fromJson(Map<String, dynamic> json) {
    unitId = json['unit_id'];
    trxStock = json['trx_stock'];
    currentStock = json['current_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_id'] = this.unitId;
    data['trx_stock'] = this.trxStock;
    data['current_stock'] = this.currentStock;
    return data;
  }
}

class CreateProductPrice {
  double? currentPrice;
  double? salePrice;

  CreateProductPrice({this.currentPrice, this.salePrice});

  CreateProductPrice.fromJson(Map<String, dynamic> json) {
    currentPrice = json['current_price'];
    salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_price'] = this.currentPrice;
    data['sale_price'] = this.salePrice;
    return data;
  }
}