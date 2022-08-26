import 'merchant_bank.dart';

class BankCreate {
  MerchantBank? bank;

  BankCreate({this.bank});

  BankCreate.fromJson(Map<String, dynamic> json) {
    bank = json['bank'] != null ? new MerchantBank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    return data;
  }
}
