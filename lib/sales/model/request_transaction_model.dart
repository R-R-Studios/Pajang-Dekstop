import 'package:beben_pos_desktop/sales/model/merchant_transaction_model.dart';

class ProductTransaction {
  late List<MerchantTransactionModel> merchantTransaction;
  late String type;

  ProductTransaction({
    required this.merchantTransaction,
    required this.type
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.merchantTransaction != null) {
      data['merchant_transaction'] =
          this.merchantTransaction.map((v) => v.toJson()).toList();
    }
    return data;
  }
}