class TransactionDetailResponse {
  int? id;
  int? merchantId;
  String? totalAmount;
  String? createdAt;
  String? updatedAt;
  String? transactionCode;
  int? transactionTypeId;
  bool? isReturn;
  Null? paymentMethodId;
  Null? bankId;
  String? cardNumber;
  int? taxId;
  dynamic valueTax;
  dynamic valueDocument;
  dynamic valuePay;
  int? userId;
  int? userAddressId;
  String? accountName;
  String? accountNumber;
  int? statusId;
  int? subAmount;
  int? discountAmount;
  List<MerchantTransactionDetails>? merchantTransactionDetails;
  List<HistoryMerchantTransactions>? historyMerchantTransactions;
  Status? status;
  UserAddress? userAddress;
  Product? user;

  TransactionDetailResponse({
    this.id,
    this.merchantId,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.transactionCode,
    this.transactionTypeId,
    this.isReturn,
    this.paymentMethodId,
    this.bankId,
    this.cardNumber,
    this.taxId,
    this.valueTax,
    this.valueDocument,
    this.valuePay,
    this.userId,
    this.userAddressId,
    this.accountName,
    this.accountNumber,
    this.statusId,
    this.subAmount,
    this.discountAmount,
    this.merchantTransactionDetails,
    this.historyMerchantTransactions,
    this.status,
    this.user,
    this.userAddress
  });

  TransactionDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    transactionCode = json['transaction_code'];
    transactionTypeId = json['transaction_type_id'];
    isReturn = json['is_return'];
    paymentMethodId = json['payment_method_id'];
    bankId = json['bank_id'];
    cardNumber = json['card_number'];
    taxId = json['tax_id'];
    valueTax = json['value_tax'];
    valueDocument = json['value_document'];
    valuePay = json['value_pay'];
    userId = json['user_id'];
    userAddressId = json['user_address_id'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
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
    if (json['history_merchant_transactions'] != null) {
      historyMerchantTransactions = <HistoryMerchantTransactions>[];
      json['history_merchant_transactions'].forEach((v) {
        historyMerchantTransactions!
            .add(new HistoryMerchantTransactions.fromJson(v));
      });
    }
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    userAddress = json['user_address'] != null
        ? new UserAddress.fromJson(json['user_address'])
        : null;
    user = json['user'] != null ? new Product.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_id'] = this.merchantId;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['transaction_code'] = this.transactionCode;
    data['transaction_type_id'] = this.transactionTypeId;
    data['is_return'] = this.isReturn;
    data['payment_method_id'] = this.paymentMethodId;
    data['bank_id'] = this.bankId;
    data['card_number'] = this.cardNumber;
    data['tax_id'] = this.taxId;
    data['value_tax'] = this.valueTax;
    data['value_document'] = this.valueDocument;
    data['value_pay'] = this.valuePay;
    data['user_id'] = this.userId;
    data['user_address_id'] = this.userAddressId;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['status_id'] = this.statusId;
    data['sub_amount'] = this.subAmount;
    data['discount_amount'] = this.discountAmount;
    if (this.merchantTransactionDetails != null) {
      data['merchant_transaction_details'] =
          this.merchantTransactionDetails!.map((v) => v.toJson()).toList();
    }
    if (this.historyMerchantTransactions != null) {
      data['history_merchant_transactions'] =
          this.historyMerchantTransactions!.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
  dynamic oldPrice;
  dynamic currentPrice;
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

class HistoryMerchantTransactions {
  int? id;
  int? statusId;
  int? merchantTransactionId;
  String? createdAt;
  String? updatedAt;

  HistoryMerchantTransactions(
      {this.id,
      this.statusId,
      this.merchantTransactionId,
      this.createdAt,
      this.updatedAt});

  HistoryMerchantTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusId = json['status_id'];
    merchantTransactionId = json['merchant_transaction_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status_id'] = this.statusId;
    data['merchant_transaction_id'] = this.merchantTransactionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? code;
  String? description;
  String? createdAt;
  String? updatedAt;

  Status(
      {this.id,
      this.name,
      this.code,
      this.description,
      this.createdAt,
      this.updatedAt});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class UserAddress {
  int? id;
  int? userId;
  String? name;
  String? description;
  bool? isMaenAddress;
  bool? isActive;
  String? address;
  String? contactName;
  String? contactPhoneNumber;
  String? province;
  String? city;
  String? distric;
  String? postelCode;
  String? createdAt;
  String? updatedAt;
  String? village;
  dynamic latitude;
  dynamic longitude;
  int? provinceId;
  int? cityId;

  UserAddress(
      {this.id,
      this.userId,
      this.name,
      this.description,
      this.isMaenAddress,
      this.isActive,
      this.address,
      this.contactName,
      this.contactPhoneNumber,
      this.province,
      this.city,
      this.distric,
      this.postelCode,
      this.createdAt,
      this.updatedAt,
      this.village,
      this.latitude,
      this.longitude,
      this.provinceId,
      this.cityId});

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    description = json['description'];
    isMaenAddress = json['is_maen_address'];
    isActive = json['is_active'];
    address = json['address'];
    contactName = json['contact_name'];
    contactPhoneNumber = json['contact_phone_number'];
    province = json['province'];
    city = json['city'];
    distric = json['distric'];
    postelCode = json['postel_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    village = json['village'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    provinceId = json['province_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_maen_address'] = this.isMaenAddress;
    data['is_active'] = this.isActive;
    data['address'] = this.address;
    data['contact_name'] = this.contactName;
    data['contact_phone_number'] = this.contactPhoneNumber;
    data['province'] = this.province;
    data['city'] = this.city;
    data['distric'] = this.distric;
    data['postel_code'] = this.postelCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['village'] = this.village;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['province_id'] = this.provinceId;
    data['city_id'] = this.cityId;
    return data;
  }
}