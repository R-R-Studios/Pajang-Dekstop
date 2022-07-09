
class SalesPayment {
  String? type;
  int? amount;

  bool selected = false;

  SalesPayment({this.type, this.amount});

  SalesPayment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['amount'] = this.amount;
    return data;
  }
}

