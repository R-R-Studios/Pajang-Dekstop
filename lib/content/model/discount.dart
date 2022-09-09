class Discount {
  
  String? name;
  int? minimumAmount;
  int? maximumAmount;
  int? amount;
  String? types;
  String? description;
  bool? isActive;
  String? kind;

  Discount({
    this.name,
    this.minimumAmount,
    this.maximumAmount,
    this.amount,
    this.types,
    this.description,
    this.isActive,
    this.kind
  });

  Discount.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    minimumAmount = json['minimum_amount'];
    maximumAmount = json['maximum_amount'];
    amount = json['amount'];
    types = json['types'];
    description = json['description'];
    isActive = json['is_active'];
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['minimum_amount'] = this.minimumAmount;
    data['maximum_amount'] = this.maximumAmount;
    data['amount'] = this.amount;
    data['types'] = this.types;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['kind'] = this.kind;
    final Map<String, dynamic> dataDiscount = new Map<String, dynamic>();
    dataDiscount['discount'] = data;
    return dataDiscount;
  }
}
