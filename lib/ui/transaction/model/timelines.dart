
class Timelines {
  String? statusCode;
  String? statusName;
  String? date;

  Timelines({this.statusCode, this.statusName, this.date});

  Timelines.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusName = json['status_name'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_name'] = this.statusName;
    data['date'] = this.date;
    return data;
  }
}