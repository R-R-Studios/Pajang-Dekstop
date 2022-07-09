import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'product_model_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_2)
class ProductModelDB extends HiveObject{
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
  String? createdAt;
  @HiveField(6)
  String? stock;
  @HiveField(7)
  String? originalPrice;
  @HiveField(8)
  String? salePrice;
  @HiveField(9)
  int? unitsId;
  @HiveField(10)
  String? unitsName;
  @HiveField(11)
  int? productId;

  ProductModelDB({this.id, this.name, this.code, this.barcode, this.description,
        this.createdAt,  this.stock, this.originalPrice, this.salePrice, this.unitsId, this.unitsName, this.productId});

  ProductModelDB.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    barcode = json["barcode"];
    description = json["description"];
    if(json["created_at"] != null){
      createdAt = json["created_at"];
    }
    originalPrice = json["original_price"];
    // salePrice = json["sale_price"];
    stock = json["last_stock"];
    unitsId = json["unit_id"];
    unitsName = json["units_name"];
    productId = json["product_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data["id"] = this.id;
    data["name"] = this.name;
    data["code"] = this.code;
    data["barcode"] = this.barcode;
    data["description"] = this.description;
    if (this.createdAt != null) data["created_at"] = this.createdAt;
    if (this.salePrice != null) data["price"] = this.salePrice;
    if (this.originalPrice != null) data["price"] = this.originalPrice;
    if (this.stock != null) data["last_stock"] = this.stock;
    if (this.unitsId != null) data["unit_id"] = this.unitsId;
    if (this.unitsName != null) data["units_name"] = this.unitsName;
    data["product_id"] = productId;
    return data;
  }
}