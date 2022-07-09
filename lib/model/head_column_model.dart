class HeadColumnModel {
  String? key;
  String? name;
  bool? ischecked;

  HeadColumnModel({this.key, this.name, this.ischecked});

  HeadColumnModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    ischecked = json['ischecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['ischecked'] = this.ischecked;
    return data;
  }
}