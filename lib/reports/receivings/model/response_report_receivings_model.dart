import 'package:beben_pos_desktop/reports/receivings/model/report_receivings_model.dart';

class ResponseReportReceivingsModel {
  List<ReportReceivingsModel>? report;

  ResponseReportReceivingsModel({this.report});

  ResponseReportReceivingsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      report = [];
      json['data'].forEach((v) {
        report?.add(new ReportReceivingsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['data'] = this.report?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}