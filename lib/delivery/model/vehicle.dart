class Vehicle {
  
  String? nopol;
  String? merk;
  String? deskripsi;

  Vehicle({this.nopol, this.merk, this.deskripsi});

  Vehicle.fromJson(Map<String, dynamic> json) {
    nopol = json['nopol'];
    merk = json['merk'];
    deskripsi = json['deskripsi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nopol'] = this.nopol;
    data['merk'] = this.merk;
    data['deskripsi'] = this.deskripsi;
    return data;
  }
}
