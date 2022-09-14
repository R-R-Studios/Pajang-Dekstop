class TransactionDetail {
  int? id;
  int? merchantId;
  String? totalAmount;
  String? createdAt;
  String? updatedAt;
  int? statusId;
  int? subAmount;
  int? discountAmount;
  List<MerchantTransactionDetails>? merchantTransactionDetails;

  TransactionDetail(
      {this.id,
      this.merchantId,
      this.totalAmount,
      this.createdAt,
      this.updatedAt,
      this.statusId,
      this.subAmount,
      this.discountAmount,
      this.merchantTransactionDetails});

  TransactionDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statusId = json['status_id'];
    subAmount = json['sub_amount'];
    discountAmount = json['discount_amount'];
    if (json['merchant_transaction_details'] != null) {
      merchantTransactionDetails = <MerchantTransactionDetails>[];
      json['merchant_transaction_details'].forEach((v) {
        merchantTransactionDetails!
            .add(new MerchantTransactionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_id'] = this.merchantId;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status_id'] = this.statusId;
    data['sub_amount'] = this.subAmount;
    data['discount_amount'] = this.discountAmount;
    if (this.merchantTransactionDetails != null) {
      data['merchant_transaction_details'] =
          this.merchantTransactionDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MerchantTransactionDetails {
  String? merchantCurrentStock;
  String? merchantCurrentOrigPrice;
  String? currentSalePrice;
  MerchantProductPrice? merchantProductPrice;

  MerchantTransactionDetails(
      {this.merchantCurrentStock,
      this.merchantCurrentOrigPrice,
      this.currentSalePrice,
      this.merchantProductPrice});

  MerchantTransactionDetails.fromJson(Map<String, dynamic> json) {
    merchantCurrentStock = json['merchant_current_stock'];
    merchantCurrentOrigPrice = json['merchant_current_orig_price'];
    currentSalePrice = json['current_sale_price'];
    merchantProductPrice = json['merchant_product_price'] != null
        ? new MerchantProductPrice.fromJson(json['merchant_product_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_current_stock'] = this.merchantCurrentStock;
    data['merchant_current_orig_price'] = this.merchantCurrentOrigPrice;
    data['current_sale_price'] = this.currentSalePrice;
    if (this.merchantProductPrice != null) {
      data['merchant_product_price'] = this.merchantProductPrice!.toJson();
    }
    return data;
  }
}

class MerchantProductPrice {
  int? oldPrice;
  String? currentPrice;
  MerchantProduct? merchantProduct;

  MerchantProductPrice(
      {this.oldPrice, this.currentPrice, this.merchantProduct});

  MerchantProductPrice.fromJson(Map<String, dynamic> json) {
    oldPrice = json['old_price'];
    currentPrice = json['current_price'];
    merchantProduct = json['merchant_product'] != null
        ? new MerchantProduct.fromJson(json['merchant_product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_price'] = this.oldPrice;
    data['current_price'] = this.currentPrice;
    if (this.merchantProduct != null) {
      data['merchant_product'] = this.merchantProduct!.toJson();
    }
    return data;
  }
}

class MerchantProduct {
  int? productId;
  Product? product;

  MerchantProduct({this.productId, this.product});

  MerchantProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  String? name;

  Product({this.name});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
