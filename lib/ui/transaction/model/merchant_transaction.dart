class MerchantTransaction {
  int? id;
  String? bankName;
  String? taxName;
  String? userName;
  String? paymentName;
  String? typeName;
  String? transactionCode;
  String? cardNumber;
  dynamic valueTax;
  dynamic valueDocument;
  dynamic valuePay;

  MerchantTransaction({
    this.id,
    this.bankName,
    this.taxName,
    this.userName,
    this.paymentName,
    this.typeName,
    this.transactionCode,
    this.cardNumber,
    this.valueTax,
    this.valueDocument,
    this.valuePay
  });

  MerchantTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bank_name'];
    taxName = json['tax_name'];
    userName = json['user_name'];
    paymentName = json['payment_name'];
    typeName = json['type_name'];
    transactionCode = json['transaction_code'];
    cardNumber = json['card_number'];
    valueTax = json['value_tax'];
    valueDocument = json['value_document'];
    valuePay = json['value_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_name'] = this.bankName;
    data['tax_name'] = this.taxName;
    data['user_name'] = this.userName;
    data['payment_name'] = this.paymentName;
    data['type_name'] = this.typeName;
    data['transaction_code'] = this.transactionCode;
    data['card_number'] = this.cardNumber;
    data['value_tax'] = this.valueTax;
    data['value_document'] = this.valueDocument;
    data['value_pay'] = this.valuePay;
    return data;
  }
}
