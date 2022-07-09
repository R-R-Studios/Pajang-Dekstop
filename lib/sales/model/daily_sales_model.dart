

class DailySalesModel {
  int? id;
  int? time;
  String? customer;
  int? amountDue;
  int? amountTendered;
  String? changeDue;
  String? type;
  String? invoice;

  bool selected = false;

  DailySalesModel(
      {this.id,
        this.time,
        this.customer,
        this.amountDue,
        this.amountTendered,
        this.changeDue,
        this.type,
        this.invoice});

  DailySalesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    customer = json['customer'];
    amountDue = json['amount_due'];
    amountTendered = json['amount_tendered'];
    changeDue = json['change_due'];
    type = json['type'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['customer'] = this.customer;
    data['amount_due'] = this.amountDue;
    data['amount_tendered'] = this.amountTendered;
    data['change_due'] = this.changeDue;
    data['type'] = this.type;
    data['invoice'] = this.invoice;
    return data;
  }
}