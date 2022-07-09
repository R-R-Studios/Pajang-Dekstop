import 'package:beben_pos_desktop/core/core.dart';

class ReportStockInModel {
  int? id;
  int? unitId;
  int? productId;
  String? productName;
  String? unitName;
  int? qty;
  int? originalPrice;
  int? salePrice;
  String? tanggal;

  bool selected = false;

  ReportStockInModel(
      {this.id,
        this.unitId,
        this.productId,
        this.productName,
        this.unitName,
        this.qty,
        this.originalPrice,
        this.salePrice,
        this.tanggal});

  ReportStockInModel.fromJson(Map<String, dynamic> json) {
    if(json['id'] != null){
      id = json['id'];
    }
    unitId = json['unit_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    unitName = json['unit_name'];
    qty = int.tryParse(json['qty']);

    originalPrice = double.parse(json['original_price']).toInt();
    salePrice = double.parse(json['sale_price']).toInt();
    Core.dateConverter(DateTime.tryParse(json['tanggal'])).then((value) {
      tanggal = value;
    });

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit_id'] = this.unitId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['unit_name'] = this.unitName;
    data['qty'] = this.qty;
    data['original_price'] = this.originalPrice;
    data['sale_price'] = this.salePrice;
    data['tanggal'] = this.tanggal;
    return data;
  }
}