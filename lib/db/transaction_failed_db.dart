
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/transaction_failed_product_db.dart';
import 'package:hive/hive.dart';

part 'transaction_failed_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_TRANSACTION_FAILED)
class TransactionFailedDB extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? date;
  @HiveField(2)
  List<TransactionFailedProductDB>? productList;
  @HiveField(3)
  String? status;
  @HiveField(4)
  double? totalPriceTransaction = 0;
  @HiveField(5)
  double? totalPaymentCustomer = 0;
  @HiveField(6)
  double? totalMoneyChanges = 0;
  @HiveField(7)
  int? merchantId;
  @HiveField(8)
  String? type;
  
  @HiveField(9)
  int? paymentMethodId;

  TransactionFailedDB({
    this.id, this.date, this.productList, this.status, this.totalPriceTransaction, this.totalPaymentCustomer, this.totalMoneyChanges,
    this.merchantId, this.type, this.paymentMethodId});

  factory TransactionFailedDB.fromProductModel(TransactionFailedDB productModel){
    return TransactionFailedDB(
      paymentMethodId: productModel.paymentMethodId,
      id: productModel.id,
      date: productModel.date,
      productList: productModel.productList,
      status: productModel.status,
      totalPriceTransaction: productModel.totalPriceTransaction,
      totalPaymentCustomer: productModel.totalPaymentCustomer,
      totalMoneyChanges: productModel.totalMoneyChanges,
      merchantId: productModel.merchantId
    );
  }

  TransactionFailedDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    productList = json['product_list'];
    status = json['status'];
    totalPriceTransaction = json['total_price_transaction'];
    totalPaymentCustomer = json['total_payment_customer'];
    totalMoneyChanges = json['total_money_changes'];
    merchantId = json['merchant_id'];
    type = json['type'];
    paymentMethodId = json['payment_method_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['product_list'] = this.productList;
    data['status'] = this.status;
    data['total_price_transaction'] = this.totalPriceTransaction;
    data['total_payment_customer'] = this.totalPaymentCustomer;
    data['total_money_changes'] = this.totalMoneyChanges;
    data['merchant_id'] = this.merchantId;
    data['type'] = this.type;
    data['payment_method_id'] = this.paymentMethodId;
    return data;
  }

}