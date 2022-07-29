import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/price_list_db.dart';
import 'package:hive/hive.dart';

part 'product_receivings_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_PRODUCT_RECEIVINGS)
class ProductReceivingsDB extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? code;
  @HiveField(3)
  String? barcode;
  @HiveField(4)
  String? description;
  @HiveField(5)
  List<PriceListDB>? priceList;

  ProductReceivingsDB(
      {this.id,
      this.name,
      this.code,
      this.barcode,
      this.description,
      this.priceList});

  ProductReceivingsDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    barcode = json['barcode'];
    description = json['description'];
    if (json['price_list'] != null) {
      priceList = [];
      json['price_list'].forEach((v) {
        priceList!.add(new PriceListDB.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    if (this.priceList != null) {
      data['price_list'] = this.priceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
