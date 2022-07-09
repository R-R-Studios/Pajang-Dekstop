
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'units_model.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_UNIT_CONVERSION)
class UnitsModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? updatedAt;

  UnitsModel(
      {this.id, this.name, this.description, this.createdAt, this.updatedAt});

  UnitsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}