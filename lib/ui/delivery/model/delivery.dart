class Delivery {
  int? id;
  String? no;
  String? date;
  double? totalPrice;
  String? status;
  String? product;

  Delivery({
    this.id,
    this.no,
    this.date,
    this.totalPrice,
    this.status,
    this.product
  });

  Delivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    date = json['date'];
    totalPrice = json['total_price'];
    status = json['status'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['no'] = this.no;
    data['date'] = this.date;
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['product'] = this.product;
    return data;
  }
}
