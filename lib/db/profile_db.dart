import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:hive/hive.dart';

part 'profile_db.g.dart';

@HiveType(typeId: FireshipBox.HIVE_TYPE_PROFILE)
class ProfileDB extends HiveObject {
  @HiveField(0)
  int? userId;
  @HiveField(1)
  String? userName;
  @HiveField(2)
  int? merchantId;
  @HiveField(3)
  String? merchantName;
  @HiveField(4)
  String? phoneNumber;
  @HiveField(5)
  String? email;
  @HiveField(6)
  String? address;

  ProfileDB(
      {this.userId,
        this.userName,
        this.merchantId,
        this.merchantName,
        this.phoneNumber,
        this.email,
        this.address});

  ProfileDB.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    merchantId = json['merchant_id'];
    merchantName = json['merchant_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['merchant_id'] = this.merchantId;
    data['merchant_name'] = this.merchantName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}