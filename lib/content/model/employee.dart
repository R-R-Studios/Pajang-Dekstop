class Employee {
  int? id;
  String? name;
  String? jobDesk;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  int? merchantId;

  Employee({
    this.id,
    this.name,
    this.jobDesk,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.merchantId
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    jobDesk = json['job_desk_id'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantId = json['merchant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['job_desk_id'] = this.jobDesk;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['merchant_id'] = this.merchantId;
    return data;
  }
}