import 'package:beben_pos_desktop/customer/model/end_user.dart';

class PaymentMethod {
  int? id;
  String? name;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? cardNumber;
  int? bankId;
  EndUser? endUser;

  PaymentMethod({this.id, this.name, this.isActive, this.createdAt, this.updatedAt, this.cardNumber, this.bankId, this.endUser});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
