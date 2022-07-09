class Meta {
  int? code;
  dynamic messages;
  Pagination? pagination;

  Meta({this.code, this.messages, this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    messages = json['messages'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['messages'] = this.messages;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? totalPage;
  int? currentPage;
  int? nextPage;
  int? prevPage;
  bool? isFirstPage;
  bool? isLastPage;
  bool? isOutOfRange;

  Pagination({
    this.total,
    this.perPage,
    this.totalPage,
    this.currentPage,
    this.nextPage,
    this.prevPage,
    this.isFirstPage,
    this.isLastPage,
    this.isOutOfRange
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    totalPage = json['total_page'];
    currentPage = json['current_page'];
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
    isFirstPage = json['is_first_page'];
    isLastPage = json['is_last_page'];
    isOutOfRange = json['is_out_of_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['total_page'] = this.totalPage;
    data['current_page'] = this.currentPage;
    data['next_page'] = this.nextPage;
    data['prev_page'] = this.prevPage;
    data['is_first_page'] = this.isFirstPage;
    data['is_last_page'] = this.isLastPage;
    data['is_out_of_range'] = this.isOutOfRange;
    return data;
  }
}
