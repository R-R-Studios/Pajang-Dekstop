import 'package:beben_pos_desktop/reports/receivings/model/detail_report_receivings_model.dart';
import 'package:beben_pos_desktop/reports/receivings/model/product_report_receivings_model.dart';

class ReportReceivingsModel {
  DetailReportReceivingsModel? detail;
  List<ProductReportReceicingsModel>? product;

  ReportReceivingsModel({this.detail, this.product});

  ReportReceivingsModel.fromJson(Map<String, dynamic> json) {
    detail =
    json['detail'] != null ? new DetailReportReceivingsModel.fromJson(json['detail']) : null;
    if (json['data'] != null) {
      product = [];
      json['data'].forEach((v) {
        product?.add(new ProductReportReceicingsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail?.toJson();
    }
    if (this.product != null) {
      data['data'] = this.product?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}