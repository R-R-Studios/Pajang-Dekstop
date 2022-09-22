class DeliveryDetail {
  int? id;
  String? nameEmployee;
  String? nameVehicle;
  String? nopolVehicle;
  int? totalAmountTransaction;
  String? qty;
  String? transactionCode;
  String? discountAmount;
  double? valueTax;
  double? valuePay;
  String? totalOperationalAmount;
  String? orderNumber;

  DeliveryDetail({
    this.id,
    this.nameEmployee,
    this.nameVehicle,
    this.nopolVehicle,
    this.totalAmountTransaction,
    this.qty,
    this.transactionCode,
    this.discountAmount,
    this.valueTax,
    this.valuePay,
    this.totalOperationalAmount,
    this.orderNumber
  });

  DeliveryDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEmployee = json['name_employee'];
    nameVehicle = json['name_vehicle'];
    nopolVehicle = json['nopol_vehicle'];
    totalAmountTransaction = json['total_amount_transaction'];
    qty = json['qty'];
    transactionCode = json['transaction_code'];
    discountAmount = json['discount_amount'];
    valueTax = json['value_tax'];
    valuePay = json['value_pay'];
    totalOperationalAmount = json['total_operational_amount'];
    orderNumber = json['order_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_employee'] = this.nameEmployee;
    data['name_vehicle'] = this.nameVehicle;
    data['nopol_vehicle'] = this.nopolVehicle;
    data['total_amount_transaction'] = this.totalAmountTransaction;
    data['qty'] = this.qty;
    data['transaction_code'] = this.transactionCode;
    data['discount_amount'] = this.discountAmount;
    data['value_tax'] = this.valueTax;
    data['value_pay'] = this.valuePay;
    data['total_operational_amount'] = this.totalOperationalAmount;
    data['order_number'] = this.orderNumber;
    return data;
  }
}
