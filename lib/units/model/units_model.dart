import 'package:beben_pos_desktop/core/core.dart';

class UnitsModel {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  bool selected = false;

  UnitsModel(
      {this.id, this.name, this.description, this.createdAt, this.updatedAt});

  UnitsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    Core.dateConverter(DateTime.tryParse(json["created_at"])).then((value) {
      createdAt = value;
    });
    Core.dateConverter(DateTime.tryParse(json["updated_at"])).then((value) {
      updatedAt = value;
    });
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