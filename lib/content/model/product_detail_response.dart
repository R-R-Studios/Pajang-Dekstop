class ProductDetailResponse {
  int? id;
  int? productId;
  String? createdAt;
  String? updatedAt;
  List<MerchantProductStocks>? merchantProductStocks;
  List<MerchantProductPrices>? merchantProductPrices;
  Product? product;

  ProductDetailResponse(
      {this.id,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.merchantProductStocks,
      this.merchantProductPrices,
      this.product});

  ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['merchant_product_stocks'] != null) {
      merchantProductStocks = <MerchantProductStocks>[];
      json['merchant_product_stocks'].forEach((v) {
        merchantProductStocks!.add(new MerchantProductStocks.fromJson(v));
      });
    }
    if (json['merchant_product_prices'] != null) {
      merchantProductPrices = <MerchantProductPrices>[];
      json['merchant_product_prices'].forEach((v) {
        merchantProductPrices!.add(new MerchantProductPrices.fromJson(v));
      });
    }
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.merchantProductStocks != null) {
      data['merchant_product_stocks'] =
          this.merchantProductStocks!.map((v) => v.toJson()).toList();
    }
    if (this.merchantProductPrices != null) {
      data['merchant_product_prices'] =
          this.merchantProductPrices!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class MerchantProductStocks {
  int? id;
  String? currentStock;
  int? unitId;
  dynamic firstStock;
  dynamic trxStock;
  dynamic lastStock;
  int? merchantTransactionId;
  String? createdAt;
  String? updatedAt;
  int? merchantProductId;
  int? merchantId;
  bool? isActive;

  MerchantProductStocks(
      {this.id,
      this.currentStock,
      this.unitId,
      this.firstStock,
      this.trxStock,
      this.lastStock,
      this.merchantTransactionId,
      this.createdAt,
      this.updatedAt,
      this.merchantProductId,
      this.merchantId,
      this.isActive});

  MerchantProductStocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentStock = json['current_stock'];
    unitId = json['unit_id'];
    firstStock = json['first_stock'];
    trxStock = json['trx_stock'];
    lastStock = json['last_stock'];
    merchantTransactionId = json['merchant_transaction_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantProductId = json['merchant_product_id'];
    merchantId = json['merchant_id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['current_stock'] = this.currentStock;
    data['unit_id'] = this.unitId;
    data['first_stock'] = this.firstStock;
    data['trx_stock'] = this.trxStock;
    data['last_stock'] = this.lastStock;
    data['merchant_transaction_id'] = this.merchantTransactionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['merchant_product_id'] = this.merchantProductId;
    data['merchant_id'] = this.merchantId;
    data['is_active'] = this.isActive;
    return data;
  }
}

class MerchantProductPrices {
  int? id;
  int? merchantProductId;
  int? oldPrice;
  dynamic currentPrice;
  String? createdAt;
  String? updatedAt;
  int? merchantProductStockId;
  dynamic salePrice;
  bool? isActive;
  int? merchantDiscountId;
  String? originalSalePrice;

  MerchantProductPrices(
      {this.id,
      this.merchantProductId,
      this.oldPrice,
      this.currentPrice,
      this.createdAt,
      this.updatedAt,
      this.merchantProductStockId,
      this.salePrice,
      this.isActive,
      this.merchantDiscountId,
      this.originalSalePrice});

  MerchantProductPrices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantProductId = json['merchant_product_id'];
    oldPrice = json['old_price'];
    currentPrice = json['current_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantProductStockId = json['merchant_product_stock_id'];
    salePrice = json['sale_price'];
    isActive = json['is_active'];
    merchantDiscountId = json['merchant_discount_id'];
    originalSalePrice = json['original_sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_product_id'] = this.merchantProductId;
    data['old_price'] = this.oldPrice;
    data['current_price'] = this.currentPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['merchant_product_stock_id'] = this.merchantProductStockId;
    data['sale_price'] = this.salePrice;
    data['is_active'] = this.isActive;
    data['merchant_discount_id'] = this.merchantDiscountId;
    data['original_sale_price'] = this.originalSalePrice;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? code;
  String? barcode;
  String? createdAt;
  String? updatedAt;
  bool? isActive;
  int? categoryId;
  bool? isAging;
  String? description;
  int? countRates;
  Null? productTotalReview;
  int? brandId;
  List<String>? listImage;

  Product(
      {this.id,
      this.name,
      this.code,
      this.barcode,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      this.categoryId,
      this.isAging,
      this.description,
      this.countRates,
      this.productTotalReview,
      this.brandId,
      this.listImage});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    categoryId = json['category_id'];
    isAging = json['is_aging'];
    description = json['description'];
    countRates = json['count_rates'];
    productTotalReview = json['product_total_review'];
    brandId = json['brand_id'];
    listImage = json['list_image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    data['category_id'] = this.categoryId;
    data['is_aging'] = this.isAging;
    data['description'] = this.description;
    data['count_rates'] = this.countRates;
    data['product_total_review'] = this.productTotalReview;
    data['brand_id'] = this.brandId;
    data['list_image'] = this.listImage;
    return data;
  }
}
