class ReportTransaction {
  String? date;
  String? transactionCode;
  String? type;
  String? payment;
  String? totalTransaction;
  String? totalPayment;
  List<TransactionProductList>? transactionList;

  bool selected = false;

  ReportTransaction(
      {this.date,
        this.transactionCode,
        this.type,
        this.payment,
        this.totalTransaction,
        this.totalPayment,
        this.transactionList});

  ReportTransaction.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    transactionCode = json['transaction_code'];
    type = json['type'];
    payment = json['payment'];
    totalTransaction = json['total_transaction'];
    totalPayment = json['total_payment'];
    if (json['transaction_list'] != null) {
      transactionList = <TransactionProductList>[];
      json['transaction_list'].forEach((v) {
        transactionList!.add(new TransactionProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['transaction_code'] = this.transactionCode;
    data['type'] = this.type;
    data['payment'] = this.payment;
    data['total_transaction'] = this.totalTransaction;
    data['total_payment'] = this.totalPayment;
    if (this.transactionList != null) {
      data['transaction_list'] =
          this.transactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionProductList {
  int? productId;
  String? productName;
  double? qty;
  double? price;
  double? total;
  String? unitName;

  bool selected = false;

  TransactionProductList(
      {this.productId,
        this.productName,
        this.qty,
        this.price,
        this.total,
        this.unitName});

  TransactionProductList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    qty = json['qty'];
    price = json['price'];
    total = json['total'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['total'] = this.total;
    data['unit_name'] = this.unitName;
    return data;
  }
}
