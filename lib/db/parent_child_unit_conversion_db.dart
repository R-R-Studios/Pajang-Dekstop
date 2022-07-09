
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'parent_child_unit_conversion_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_PARENT_CHILD_UNIT_CONVERSION)
class ParentChildUnitDB {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;

  ParentChildUnitDB({this.id, this.name, this.description});

  ParentChildUnitDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}