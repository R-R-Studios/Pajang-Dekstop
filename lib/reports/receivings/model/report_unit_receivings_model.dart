import 'package:beben_pos_desktop/reports/receivings/model/report_data_receivings_model.dart';

class ReportUnitReceivingsModel {
  int? unitId;
  String? unitName;
  List<ReportDataReceivingsModel>? reportList;

  ReportUnitReceivingsModel({this.unitId, this.unitName, this.reportList});

  ReportUnitReceivingsModel.fromJson(Map<String, dynamic> json) {
    unitId = json['unit_id'];
    unitName = json['unit_name'];
    if (json['report_list'] != null) {
      reportList = [];
      json['report_list'].forEach((v) {
        reportList!.add(new ReportDataReceivingsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    if (this.reportList != null) {
      data['report_list'] = this.reportList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}