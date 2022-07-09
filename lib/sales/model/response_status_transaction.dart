
class ResponseStatusTransaction {
  String? transactionCode;
  bool? status;
  String? responseCode;

  ResponseStatusTransaction({this.transactionCode, this.status, this.responseCode});

  ResponseStatusTransaction.fromJson(Map<String, dynamic> json) {
    transactionCode = json['transaction_code'];
    status = json['status'];
    responseCode = json['response_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_code'] = this.transactionCode;
    data['status'] = this.status;
    data['response_code'] = this.responseCode;
    return data;
  }
}