import 'package:beben_pos_desktop/content/cubit/content_cubit.dart';

class ContentMenuModel {
  String? title;
  String? description;
  String? image;
  ContentMenu? contentMenu;

  ContentMenuModel({
    this.title, 
    this.description, 
    this.image,
    required this.contentMenu
  });

  ContentMenuModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
