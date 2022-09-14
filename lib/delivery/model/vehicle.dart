class Vehicle {
  
  int? id;
  String? nopol;
  String? merk;
  String? description;

  Vehicle({this.id, this.nopol, this.merk, this.description});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nopol = json['nopol'];
    merk = json['merk'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nopol'] = this.nopol;
    data['merk'] = this.merk;
    data['description'] = this.description;
    return data;
  }
}
