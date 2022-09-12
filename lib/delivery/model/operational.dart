class Operational {
  
  String? price;
  String? desc;

  Operational({this.price, this.desc});

  Operational.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['desc'] = this.desc;
    return data;
  }
}
