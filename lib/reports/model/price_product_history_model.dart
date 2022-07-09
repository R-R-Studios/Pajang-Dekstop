
class PriceProductHistoryModel {
  int? id;
  String? productName;
  String? code;
  String? barcode;

  bool selected = false;

  PriceProductHistoryModel(
      {this.id,
        this.productName,
      this.code,
      this.barcode});

  PriceProductHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    code = json['code'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['code'] = this.code;
    data['barcode'] = this.barcode;
    return data;
  }
}