class BodySearchPoModel {
  String? transactionCode;

  BodySearchPoModel({this.transactionCode});

  BodySearchPoModel.fromJson(Map<String, dynamic> json) {
    transactionCode = json['transaction_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_code'] = this.transactionCode;
    return data;
  }
}