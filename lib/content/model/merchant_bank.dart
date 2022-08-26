class MerchantBank {
  int? id;
  String? name;
  String? accountNumber;
  String? accountName;
  Logo? logo;
  String? createdAt;
  String? updatedAt;
  int? merchantId;

  MerchantBank({
    this.id,
    this.name,
    this.accountNumber,
    this.accountName,
    this.logo,
    this.createdAt,
    this.updatedAt,
    this.merchantId
  });

  MerchantBank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantId = json['merchant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['account_number'] = this.accountNumber;
    data['account_name'] = this.accountName;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['merchant_id'] = this.merchantId;
    return data;
  }
}

class Logo {
  Null? url;

  Logo({this.url});

  Logo.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
