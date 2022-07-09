class ResponseSession {
  String? authToken;
  dynamic token;

  ResponseSession({this.authToken, this.token});

  ResponseSession.fromJson(Map<String, dynamic> json) {
    authToken = json['auth_token'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_token'] = this.authToken;
    data['token'] = this.token;
    return data;
  }
}