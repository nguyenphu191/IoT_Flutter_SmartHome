class Detail {
  final int id;
  final double nhiet_do;
  final double do_am;
  final double anh_sang;
  final String thoi_gian;
  Detail(
      {required this.id,
      required this.nhiet_do,
      required this.do_am,
      required this.anh_sang,
      required this.thoi_gian});
  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: json['id'],
      nhiet_do: json['nhiet_do'],
      do_am: json['do_am'],
      anh_sang: json['anh_sang'],
      thoi_gian: json['thoi_gian'],
    );
  }
}
