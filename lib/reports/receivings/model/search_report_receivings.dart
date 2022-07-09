import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';

class SearchReportReceivings {
  String? dateRange;
  ProductReceivingsModel? product;

  SearchReportReceivings(this.dateRange, this.product);

  SearchReportReceivings.fromJson(Map<String, dynamic> json) {
    dateRange = json['date_range'];
    if(json['product_receivings'] != null){
      product = ProductReceivingsModel.fromJson(json['product_receivings']);
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_range'] = this.dateRange;
    if(this.product != null){
      data['product_receivings'] = this.product;
    }
    return data;
  }
}