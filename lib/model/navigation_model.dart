class NavigationModel {
  String? key;
  String? name;
  String? icon;

  NavigationModel({this.key, this.name, this.icon});

  NavigationModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}