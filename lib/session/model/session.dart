
class Session {
  String? authorizeType;
  String? account;
  String? fcmToken;
  String? authorization;

  Session(
      {this.authorizeType, this.account, this.fcmToken, this.authorization});

  Session.fromJson(Map<String, dynamic> json) {
    authorizeType = json['authorize_type'];
    account = json['account'];
    fcmToken = json['fcm_token'];
    authorization = json['authorization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorize_type'] = this.authorizeType;
    data['account'] = this.account;
    data['fcm_token'] = this.fcmToken;
    data['authorization'] = this.authorization;
    return data;
  }
}
