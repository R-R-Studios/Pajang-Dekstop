class ResponseBanner {
  List<MerchantBanner>? banners;

  ResponseBanner({this.banners});

  ResponseBanner.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <MerchantBanner>[];
      json['banners'].forEach((v) {
        banners!.add(new MerchantBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MerchantBanner {
  int? id;
  String? name;
  Filename? filename;
  String? description;
  String? createdAt;
  String? imageUrl;

  MerchantBanner({
    this.id,
    this.name,
    this.filename,
    this.description,
    this.createdAt,
    this.imageUrl
  });

  MerchantBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    filename = json['filename'] != null
        ? new Filename.fromJson(json['filename'])
        : null;
    description = json['description'];
    createdAt = json['created_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.filename != null) {
      data['filename'] = this.filename!.toJson();
    }
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Filename {
  String? url;

  Filename({this.url});

  Filename.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
