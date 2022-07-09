class SalesTransactionModel {
  int? id;
  String? orderDate;
  String? productName;
  String? codeTransaction;
  String? unitsName;
  String? salePrice;
  String? qty;
  String? totalSalePrice;
  String? purchasePrice;
  String? totalPurchasePrice;
  String? profit;

  bool selected = false;

  SalesTransactionModel(
      {this.id,
        this.orderDate,
        this.productName,
        this.codeTransaction,
        this.unitsName,
        this.salePrice,
        this.qty,
        this.totalSalePrice,
        this.purchasePrice,
        this.totalPurchasePrice,
        this.profit
      });

  SalesTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderDate = json['order_date'];
    productName = json['product_name'];
    codeTransaction = json['transaction_code'];
    unitsName = json['units'];
    salePrice = json['sale_price'];
    qty = json['qty'];
    totalSalePrice = json['total_sale_price'];
    purchasePrice = json['purchase_price'];
    totalPurchasePrice = json['total_purchase_price'];
    profit = json['profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_date'] = this.orderDate;
    data['product_name'] = this.productName;
    data['transaction_code'] = this.codeTransaction;
    data['units'] = this.unitsName;
    data['sale_price'] = this.salePrice;
    data['qty'] = this.qty;
    data['total_sale_price'] = this.totalSalePrice;
    data['purchase_price'] = this.purchasePrice;
    data['total_purchase_price'] = this.totalPurchasePrice;
    data['profit'] = this.profit;
    return data;
  }
}