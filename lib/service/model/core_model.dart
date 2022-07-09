import 'meta.dart';

class CoreModel {
  Meta meta = Meta(code: 530, messages: "default error");
  dynamic data;

  CoreModel({required this.meta, this.data});

  CoreModel.fromJson(Map<String, dynamic> json) {
    meta = (json['meta'] != null ? new Meta.fromJson(json['meta']) : null)!;
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.meta != null) {
    data['meta'] = this.meta.toJson();
    // }
    data['data'] = this.data;
    return data;
  }
}
