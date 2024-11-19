class Wind {
  late String id;
  late double ws;
  late String thoi_gian;

  Wind({
    required this.id,
    required this.ws,
    required this.thoi_gian,
  });
  Wind.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ws = json['ws'].toDouble();
    thoi_gian = json['thoi_gian'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ws'] = this.ws;
    data['thoi_gian'] = this.thoi_gian;
    return data;
  }
}
