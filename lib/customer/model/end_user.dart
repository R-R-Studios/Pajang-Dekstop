class EndUser {
  
  int? id;
  String? name;
  String? phoneNumber;

  EndUser({this.id, this.name, this.phoneNumber});

  EndUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
