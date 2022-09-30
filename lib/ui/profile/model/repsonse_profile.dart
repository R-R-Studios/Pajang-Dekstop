class Responseprofile {
  int? id;
  String? name;
  String? phoneNumber;
  int? roleId;
  String? createdAt;
  String? updatedAt;
  String? email;
  String? authToken;
  String? fcmToken;
  bool? isActive;
  String? referral;
  int? parentId;

  Responseprofile(
      {this.id,
      this.name,
      this.phoneNumber,
      this.roleId,
      this.createdAt,
      this.updatedAt,
      this.email,
      this.authToken,
      this.fcmToken,
      this.isActive,
      this.referral,
      this.parentId});

  Responseprofile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    roleId = json['role_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    email = json['email'];
    authToken = json['auth_token'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
    referral = json['referral'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['role_id'] = this.roleId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email'] = this.email;
    data['auth_token'] = this.authToken;
    data['fcm_token'] = this.fcmToken;
    data['is_active'] = this.isActive;
    data['referral'] = this.referral;
    data['parent_id'] = this.parentId;
    return data;
  }
}
