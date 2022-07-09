import 'package:beben_pos_desktop/core/core.dart';

class DetailReportReceivingsModel {
  int? productId;
  String? productName;
  int? unitId;
  String? unitName;
  String? tanggal;

  DetailReportReceivingsModel(
      {this.productId,
        this.productName,
        this.unitId,
        this.unitName,
        this.tanggal});

  DetailReportReceivingsModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
    Core.dateConverter(DateTime.tryParse(json["tanggal"])).then((value) {
      tanggal = value;
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    data['tanggal'] = this.tanggal;
    return data;
  }
}