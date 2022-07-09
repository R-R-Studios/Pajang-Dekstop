class StockOutgoingModel {
  int? id;
  String? name;
  String? code;
  String? barcode;
  int? unitId;
  String? unitName;
  int? trxId;
  String? status;
  String? transactionDate;
  int? qtyTrx;
  int? merchantCurrentStock;
  String? lastStock;

  bool selected = false;

  StockOutgoingModel(
      {this.id,
        this.name,
        this.code,
        this.barcode,
        this.unitId,
        this.unitName,
        this.trxId,
        this.status,
        this.transactionDate,
        this.qtyTrx,
        this.merchantCurrentStock,
        this.lastStock});

  StockOutgoingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
    trxId = json['trx_id'];
    status = json['status'];
    transactionDate = json['transaction_date'];
    qtyTrx = json['qty_trx'];
    merchantCurrentStock = json['merchant_current_stock'];
    lastStock = json['last_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    data['trx_id'] = this.trxId;
    data['status'] = this.status;
    data['transaction_date'] = this.transactionDate;
    data['qty_trx'] = this.qtyTrx;
    data['merchant_current_stock'] = this.merchantCurrentStock;
    data['last_stock'] = this.lastStock;
    return data;
  }
}