class CustomerCreate {

  User? user;
  String? address;
  String? contactName;
  String? contactPhoneNumber;

  CustomerCreate({this.user, this.address, this.contactName, this.contactPhoneNumber});

  CustomerCreate.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    address = json['address'];
    contactName = json['contact_name'];
    contactPhoneNumber = json['contact_phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['address'] = this.address;
    data['contact_name'] = this.contactName;
    data['contact_phone_number'] = this.contactPhoneNumber;
    return data;
  }
}

class User {
  String? name;
  String? phoneNumber;
  String? email;
  String? description;

  User({this.name, this.phoneNumber, this.email, this.description});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['description'] = this.description;
    return data;
  }
}
