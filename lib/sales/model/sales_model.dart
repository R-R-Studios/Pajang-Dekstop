
class SalesModel{
  String? item;
  String? itemName;
  int? price;
  int? quantity;
  int? disc;
  int? total;

  bool selected = false;

  SalesModel(
      {
        this.item,
        this.itemName,
        this.price,
        this.quantity,
        this.disc,
        this.total});

  SalesModel.fromJson(Map<String, dynamic> json) {
    item = json['item#'];
    itemName = json['item_name'];
    price = json['price'];
    quantity = json['quantity'];
    disc = json['disc'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item#'] = this.item;
    data['item_name'] = this.itemName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['disc'] = this.disc;
    data['total'] = this.total;
    return data;
  }
}