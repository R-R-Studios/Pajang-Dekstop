class CheckPhoneNumberModel {
  UserOtp? userOtp;

  CheckPhoneNumberModel({this.userOtp});

  CheckPhoneNumberModel.fromJson(Map<String, dynamic> json) {
    userOtp = json['user_otp'] != null
        ? UserOtp.fromJson(json['user_otp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userOtp != null) {
      data['user_otp'] = userOtp!.toJson();
    }
    return data;
  }
}

class UserOtp {
  String? phoneNumber;

  UserOtp({this.phoneNumber});

  UserOtp.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    return data;
  }
}
