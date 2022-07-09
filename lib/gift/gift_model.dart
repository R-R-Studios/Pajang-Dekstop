
class GiftModel {
  int? id;
  String? lastName;
  String? firstName;
  String? giftCardNumber;
  int? value;

  bool selected = true;

  GiftModel(
      {this.id,
        this.lastName,
        this.firstName,
        this.giftCardNumber,
        this.value});

  GiftModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastName = json['last_name'];
    firstName = json['first_name'];
    giftCardNumber = json['gift_card_number'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    data['gift_card_number'] = this.giftCardNumber;
    data['value'] = this.value;
    return data;
  }
}

class GiftCheckboxModel {
  int? id;
  String? name;
  bool? ischecked;

  GiftCheckboxModel({this.id, this.name, this.ischecked});

  GiftCheckboxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ischecked = json['ischecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ischecked'] = this.ischecked;
    return data;
  }
}