class SalePriceModel {
  int? id;
  String? salePrice;
  String? typeId;

  SalePriceModel({this.id, this.salePrice, this.typeId});

  SalePriceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salePrice = json['sale_price'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sale_price'] = this.salePrice;
    data['type_id'] = this.typeId;
    return data;
  }
}