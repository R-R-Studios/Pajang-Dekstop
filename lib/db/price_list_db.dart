import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/unit_list_db.dart';
import 'package:hive/hive.dart';

part 'price_list_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_PRICE_LIST)
class PriceListDB extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? salePrice;
  @HiveField(2)
  UnitListDB? unitList;

  PriceListDB({this.id, this.salePrice, this.unitList});

  PriceListDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salePrice = json['sale_price'];
    unitList = json['unit_list'] != null
        ? new UnitListDB.fromJson(json['unit_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sale_price'] = this.salePrice;
    if (this.unitList != null) {
      data['unit_list'] = this.unitList!.toJson();
    }
    return data;
  }
}