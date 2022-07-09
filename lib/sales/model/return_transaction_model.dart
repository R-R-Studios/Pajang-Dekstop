import 'package:beben_pos_desktop/sales/model/merchant_transaction_model.dart';

class ReturnTransactionModel {
  String? transactionCode;
  List<MerchantTransactionModel>? merchantTransaction;

  ReturnTransactionModel({
    required this.transactionCode,
    required this.merchantTransaction
  });

  ReturnTransactionModel.fromJson(Map<String, dynamic> json) {
    transactionCode = json['transaction_code'];
    if (json['merchant_transaction'] != null) {
      merchantTransaction = <MerchantTransactionModel>[];
      json['merchant_transaction'].forEach((v) {
        merchantTransaction?.add(new MerchantTransactionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_code'] = transactionCode;
    if (this.merchantTransaction != null) {
      data['merchant_transaction'] =
          this.merchantTransaction?.map((v) => v.toJson()).toList() ?? [];
    }
    return data;
  }
}