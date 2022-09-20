class DeliveryCreate {
  List<int>? transactionIds;
  MerchantDeliveryOrder? merchantDeliveryOrder;
  MerchantOperational? merchantOperational;

  DeliveryCreate({
    this.transactionIds,
    this.merchantDeliveryOrder,
    this.merchantOperational
  });

  DeliveryCreate.fromJson(Map<String, dynamic> json) {
    transactionIds = json['transaction_ids'].cast<int>();
    merchantDeliveryOrder = json['merchant_delivery_order'] != null
        ? new MerchantDeliveryOrder.fromJson(json['merchant_delivery_order'])
        : null;
    merchantOperational = json['merchant_operational'] != null
        ? new MerchantOperational.fromJson(json['merchant_operational'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_ids'] = this.transactionIds;
    if (this.merchantDeliveryOrder != null) {
      data['merchant_delivery_order'] = this.merchantDeliveryOrder!.toJson();
    }
    if (this.merchantOperational != null) {
      data['merchant_operational'] = this.merchantOperational!.toJson();
    }
    return data;
  }
}

class MerchantDeliveryOrder {
  int? totalAmount;
  int? totalOperationalAmount;
  int? vehicleId;
  int? employeeId;

  MerchantDeliveryOrder(
      {this.totalAmount,
      this.totalOperationalAmount,
      this.vehicleId,
      this.employeeId});

  MerchantDeliveryOrder.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    totalOperationalAmount = json['total_operational_amount'];
    vehicleId = json['vehicle_id'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_amount'] = this.totalAmount;
    data['total_operational_amount'] = this.totalOperationalAmount;
    data['vehicle_id'] = this.vehicleId;
    data['employee_id'] = this.employeeId;
    return data;
  }
}

class MerchantOperational {
  int? totalAmount;
  String? description;
  List<OperationalDetailsAttributes>? operationalDetailsAttributes;

  MerchantOperational(
      {this.totalAmount, this.description, this.operationalDetailsAttributes});

  MerchantOperational.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    description = json['description'];
    if (json['merchant_operational_details_attributes'] != null) {
      operationalDetailsAttributes = <OperationalDetailsAttributes>[];
      json['merchant_operational_details_attributes'].forEach((v) {
        operationalDetailsAttributes!
            .add(new OperationalDetailsAttributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_amount'] = this.totalAmount;
    data['description'] = this.description;
    if (this.operationalDetailsAttributes != null) {
      data['merchant_operational_details_attributes'] =
          this.operationalDetailsAttributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OperationalDetailsAttributes {
  int? amount;
  String? description;

  OperationalDetailsAttributes({this.amount, this.description});

  OperationalDetailsAttributes.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
