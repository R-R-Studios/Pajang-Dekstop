
class ReportMerchantTransactionModel {
  int? id;
  String? merchantName;
  String? lastStock;
  String? currentStock;
  String? currentPrice;
  String? salePrice;
  String? qty;
  String? totalAmount;
  String? createdAt;

  bool selected = false;

  ReportMerchantTransactionModel(
      {this.id,
        this.merchantName,
        this.lastStock,
        this.currentStock,
        this.currentPrice,
        this.salePrice,
        this.qty,
        this.totalAmount,
        this.createdAt
      });

  ReportMerchantTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantName = json['merchant'];
    lastStock = json['last_stock'];
    currentStock = json['current_stock'];
    currentPrice = json['current_price'];
    salePrice = json['sale_price'];
    qty = json['qty'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant'] = this.merchantName;
    data['last_stock'] = this.lastStock;
    data['current_stock'] = this.currentStock;
    data['current_price'] = this.currentPrice;
    data['sale_price'] = this.salePrice;
    data['qty'] = this.qty;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    return data;
  }
}