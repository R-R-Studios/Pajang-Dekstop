import 'package:beben_pos_desktop/receivings/model/DetailPreviewTransactionPO.dart';

class PreviewTransactionPO {
  List<DetailPreviewTransactionPO>? detail;
  int? total;

  PreviewTransactionPO({this.detail, this.total});

  PreviewTransactionPO.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      detail = [];
      json['detail'].forEach((v) {
        detail?.add(new DetailPreviewTransactionPO.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail?.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}