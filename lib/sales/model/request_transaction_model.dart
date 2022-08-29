import 'package:beben_pos_desktop/sales/model/merchant_transaction_model.dart';

class ProductTransaction {

  late int paymentMethodId;
  late List<MerchantTransactionModel> merchantTransaction;
  late String type;
  int? bankId;
  String? cardNumber;
  int? userId;

  ProductTransaction({
    required this.paymentMethodId,
    required this.merchantTransaction,
    required this.type,
    this.bankId,
    this.cardNumber,
    this.userId
  }
  );

  ProductTransaction.fromJson(Map<String, dynamic> json) {
    if (json['merchant_transaction'] != null) {
      merchantTransaction = <MerchantTransactionModel>[];
      json['merchant_transaction'].forEach((v) {
        merchantTransaction.add(new MerchantTransactionModel.fromJson(v));
      });
    }
    if (json['type'] != null){
      type = json['type'];
    } else {
      type = "";
    }
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method_id'] = this.paymentMethodId;
    data['bank_id'] = this.bankId;
    data['card_number'] = this.cardNumber;
    data['type'] = this.type;
    if (this.merchantTransaction != null) {
      data['merchant_transaction'] =
          this.merchantTransaction.map((v) => v.toJson()).toList();
    }
    data.removeWhere((key, value) => value == null);
    data['user_id'] = this.userId;
    return data;
  }
}