class DeviceModel {
  final int id;
  final String ten;
  final String tinh_trang;
  final String thoi_gian;
  DeviceModel(
      {required this.id,
      required this.ten,
      required this.tinh_trang,
      required this.thoi_gian});
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      ten: json['ten'],
      tinh_trang: json['tinh_trang'],
      thoi_gian: json['thoi_gian'],
    );
  }
}
