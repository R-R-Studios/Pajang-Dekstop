class ReceivingsListModel {
  int? id;
  String? date;
  int? firstStock;
  int? totalReceivings;
  int? lastStock;
  int? unitId;
  String? unitName;

  ReceivingsListModel(
      {this.id,
        this.date,
        this.firstStock,
        this.totalReceivings,
        this.lastStock,
        this.unitId,
        this.unitName});

  ReceivingsListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    firstStock = json['first_stock'];
    totalReceivings = json['total_receivings'];
    lastStock = json['last_stock'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['first_stock'] = this.firstStock;
    data['total_receivings'] = this.totalReceivings;
    data['last_stock'] = this.lastStock;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    return data;
  }
}