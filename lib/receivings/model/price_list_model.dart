import 'package:beben_pos_desktop/receivings/model/unit_list_model.dart';

class PriceList {
  int? id;
  String? salePrice;
  UnitList? unitList;

  PriceList({this.id, this.salePrice, this.unitList});

  PriceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salePrice = json['sale_price'];
    unitList = json['unit_list'] != null
        ? new UnitList.fromJson(json['unit_list'])
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