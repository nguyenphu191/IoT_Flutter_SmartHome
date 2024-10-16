class DeviceHis {
  late String id;
  late String ten;
  late String tinh_trang;
  late String thoi_gian;
  DeviceHis(
      {required this.id,
      required this.ten,
      required this.tinh_trang,
      required this.thoi_gian});
  DeviceHis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ten = json['ten'];
    tinh_trang = json['tinh_trang'];
    thoi_gian = json['thoi_gian'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ten'] = this.ten;
    data['tinh_trang'] = this.tinh_trang;
    data['thoi_gian'] = this.thoi_gian;
    return data;
  }
}
// class DeviceHis {
//   int? id;
//   String? ten;
//   String? tinhTrang;
//   String? thoiGian;

//   DeviceHis({this.id, this.ten, this.tinhTrang, this.thoiGian});

//   DeviceHis.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     ten = json['ten'];
//     tinhTrang = json['tinh_trang'];
//     thoiGian = json['thoi_gian'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['ten'] = this.ten;
//     data['tinh_trang'] = this.tinhTrang;
//     data['thoi_gian'] = this.thoiGian;
//     return data;
//   }
// }
