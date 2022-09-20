class Category {
  int? id;
  String? name;
  List<SubCategory>? subCategory;

  Category({this.id, this.name, this.subCategory});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['sub_category'] != null) {
      subCategory = <SubCategory>[];
      json['sub_category'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  String? name;
  List<SubSubCategory>? subSubCategory;

  SubCategory({this.id, this.name, this.subSubCategory});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['sub_sub_category'] != null) {
      subSubCategory = <SubSubCategory>[];
      json['sub_sub_category'].forEach((v) {
        subSubCategory!.add(new SubSubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subSubCategory != null) {
      data['sub_sub_category'] =
          this.subSubCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSubCategory {
  int? id;
  String? name;

  SubSubCategory({this.id, this.name});

  SubSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
