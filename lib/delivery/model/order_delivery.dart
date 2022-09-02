class OrderDelivery {
  String? id;
  String? transactionCode;
  String? kuantitas;
  String? total;
  String? date;

  OrderDelivery(
      {this.id, this.transactionCode, this.kuantitas, this.total, this.date});

  OrderDelivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionCode = json['transaction_code'];
    kuantitas = json['kuantitas'];
    total = json['total'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_code'] = this.transactionCode;
    data['kuantitas'] = this.kuantitas;
    data['total'] = this.total;
    data['date'] = this.date;
    return data;
  }
}
