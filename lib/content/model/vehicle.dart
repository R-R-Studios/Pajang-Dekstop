class Vehicle {
  String? nopol;
  String? merk;
  String? desc;
  String? kirDate;
  String? stnkDate;

  Vehicle({this.nopol, this.merk, this.desc, this.kirDate, this.stnkDate});

  Vehicle.fromJson(Map<String, dynamic> json) {
    nopol = json['nopol'];
    merk = json['merk'];
    desc = json['desc'];
    kirDate = json['kir_date'];
    stnkDate = json['stnk_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nopol'] = this.nopol;
    data['merk'] = this.merk;
    data['desc'] = this.desc;
    data['kir_date'] = this.kirDate;
    data['stnk_date'] = this.stnkDate;
    return data;
  }
}
