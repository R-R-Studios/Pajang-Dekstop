class ReportDataReceivingsModel {
  int? id;
  String? date;
  int? firstStock;
  int? totalReceivings;
  int? lastStock;

  ReportDataReceivingsModel(
      {this.id,
        this.date,
        this.firstStock,
        this.totalReceivings,
        this.lastStock});

  ReportDataReceivingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    firstStock = json['first_stock'];
    totalReceivings = json['total_receivings'];
    lastStock = json['last_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['first_stock'] = this.firstStock;
    data['total_receivings'] = this.totalReceivings;
    data['last_stock'] = this.lastStock;
    return data;
  }
}