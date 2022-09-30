class BalanceResponse {
  int? id;
  int? balance;
  int? merchantId;
  String? createdAt;
  String? updatedAt;

  BalanceResponse(
      {this.id, this.balance, this.merchantId, this.createdAt, this.updatedAt});

  BalanceResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    merchantId = json['merchant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    data['merchant_id'] = this.merchantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
