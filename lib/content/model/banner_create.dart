class BannerCreate {
  Banner? banner;

  BannerCreate({this.banner});

  BannerCreate.fromJson(Map<String, dynamic> json) {
    banner =
        json['banner'] != null ? new Banner.fromJson(json['banner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner!.toJson();
    }
    return data;
  }
}

class Banner {
  String? name;
  String? filename;
  String? description;

  Banner({this.name, this.filename, this.description});

  Banner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    filename = json['filename'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['filename'] = this.filename;
    data['description'] = this.description;
    return data;
  }
}
