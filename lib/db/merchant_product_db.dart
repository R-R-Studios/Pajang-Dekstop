
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'merchant_product_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_PRODUCT_MERCHANT)
class MerchantProductDB extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? barcode;
  @HiveField(3)
  String? currentPrice;
  @HiveField(4)
  String? salePrice;
  @HiveField(5)
  String? qty;
  @HiveField(6)
  int? unitId;
  @HiveField(7)
  String? unitName;

  MerchantProductDB(
      {this.id,
        this.name,
        this.barcode,
        this.currentPrice,
        this.salePrice,
        this.qty,
        this.unitId,
        this.unitName});

  MerchantProductDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    currentPrice = json['current_price'];
    salePrice = json['sale_price'];
    qty = json['qty'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['current_price'] = this.currentPrice;
    data['sale_price'] = this.salePrice;
    data['qty'] = this.qty;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    return data;
  }
}