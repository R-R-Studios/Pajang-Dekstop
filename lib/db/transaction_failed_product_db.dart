import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'transaction_failed_product_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_TRANSACTION_FAILED_PRODUCT)
class TransactionFailedProductDB extends HiveObject {
  @HiveField(0)
  String? idTransaction;
  @HiveField(1)
  String? item;
  @HiveField(2)
  String? itemName;
  @HiveField(3)
  double? price;
  @HiveField(4)
  double? quantity;
  @HiveField(5)
  int? disc;
  @HiveField(6)
  double? total;
  @HiveField(7)
  int? productId;
  @HiveField(8)
  int? unitId;
  @HiveField(9)
  String? unitName;

  bool isDiscount = false;

  bool selected = false;

  TransactionFailedProductDB(
      {
        this.idTransaction,
        this.item,
        this.itemName,
        this.price,
        this.quantity,
        this.disc,
        this.total,
        this.productId,
        this.unitId,
        this.unitName
      });

  factory TransactionFailedProductDB.fromProductModel(TransactionFailedProductDB productModel){
    return TransactionFailedProductDB(
      idTransaction: productModel.idTransaction,
      item: productModel.item,
      itemName: productModel.itemName,
      price: productModel.price,
      quantity: productModel.quantity,
      disc: productModel.disc,
      total: productModel.total,
      productId: productModel.productId,
      unitId: productModel.unitId,
      unitName: productModel.unitName
    );
  }

  TransactionFailedProductDB.fromJson(Map<String, dynamic> json) {
    idTransaction = json['id_transaction'];
    item = json['item#'];
    itemName = json['item_name'];
    price = json['price'];
    quantity = json['quantity'];
    disc = json['disc'];
    total = json['total'];
    productId = json['product_id'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transaction'] = this.idTransaction;
    data['item#'] = this.item;
    data['item_name'] = this.itemName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['disc'] = this.disc;
    data['total'] = this.total;
    data['product_id'] = this.productId;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    return data;
  }
}