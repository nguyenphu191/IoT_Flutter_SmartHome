class Detail {
  late String id;
  late double nhiet_do;
  late double do_am;
  late double anh_sang;
  late String thoi_gian;

  Detail({
    required this.id,
    required this.nhiet_do,
    required this.do_am,
    required this.anh_sang,
    required this.thoi_gian,
  });

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nhiet_do = json['nhiet_do'].toDouble();
    do_am = json['do_am'].toDouble();
    anh_sang = json['anh_sang'].toDouble();
    thoi_gian = json['thoi_gian'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nhiet_do'] = this.nhiet_do;
    data['do_am'] = this.do_am;
    data['anh_sang'] = this.anh_sang;
    data['thoi_gian'] = this.thoi_gian;
    return data;
  }
}
