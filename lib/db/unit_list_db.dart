import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'unit_list_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_UNIT_LIST)
class UnitListDB extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;

  UnitListDB({this.id, this.name});

  UnitListDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}