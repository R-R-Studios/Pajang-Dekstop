import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/parent_child_unit_conversion_db.dart';
import 'package:hive/hive.dart';

part 'unit_conversions_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_UNIT_CONVERSION)
class UnitConversionDB {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? valueUnitParent;
  @HiveField(2)
  int? valueUnitChild;
  @HiveField(3)
  ParentChildUnitDB? child;
  @HiveField(4)
  ParentChildUnitDB? parent;

  UnitConversionDB(
      {this.id,
      this.valueUnitParent,
      this.valueUnitChild,
      this.child,
      this.parent});

  UnitConversionDB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valueUnitParent = json['value_unit_parent'];
    valueUnitChild = json['value_unit_child'];
    child = json['child'] != null
        ? new ParentChildUnitDB.fromJson(json['child'])
        : null;
    parent = json['parent'] != null
        ? new ParentChildUnitDB.fromJson(json['parent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value_unit_parent'] = this.valueUnitParent;
    data['value_unit_child'] = this.valueUnitChild;
    if (this.child != null) {
      data['child'] = this.child!.toJson();
    }
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
    }
    return data;
  }
}
