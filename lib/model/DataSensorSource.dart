import 'package:flutter/material.dart';
import 'package:smart_home/model/Detail.dart';

class DataSensorSource extends DataTableSource {
  List<Detail> _details;
  List<Detail> _filterDetails;

  DataSensorSource(this._details)
      : _filterDetails =
            List.from(_details); // Sao chép mảng _details sang _filterDetails

  void sortND(bool ascending) {
    _details.sort((a, b) => ascending
        ? a.nhiet_do.compareTo(b.nhiet_do)
        : b.nhiet_do.compareTo(a.nhiet_do));
    _filterDetails = List.from(_details);
    notifyListeners(); // Gọi hàm này để cập nhật UI
  }

  void filterND(String x) {
    if (x.isEmpty) {
      _filterDetails = List.from(_details);
    } else {
      final temp = double.tryParse(x);
      if (temp != null) {
        _filterDetails = _details
            .where((detail) => detail.nhiet_do.floor() == temp.floor())
            .toList();
      } else {
        _filterDetails = [];
      }
    }
    print(_filterDetails.map((detail) => detail.toJson()).toList());
    notifyListeners(); // Gọi hàm này để cập nhật UI
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _filterDetails.length) return null;
    final detail = _filterDetails[index];
    return DataRow(
      cells: [
        DataCell(Text(detail.id.toString())),
        DataCell(Text(detail.nhiet_do.toString())),
        DataCell(Text(detail.do_am.toString())),
        DataCell(Text(detail.anh_sang.toString())),
        DataCell(Text(detail.thoi_gian.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _filterDetails.length;

  @override
  int get selectedRowCount => 0;

  List<Detail> getFilteredDetails() {
    return _filterDetails;
  }
}
