import 'package:flutter/material.dart';
import 'package:smart_home/model/Detail.dart';

class DataSensorSource extends DataTableSource {
  final List<Detail> _details;

  DataSensorSource(this._details);
  void sortByTemperature(bool ascending) {
    _details.sort((a, b) => ascending
        ? a.nhiet_do.compareTo(b.nhiet_do)
        : b.nhiet_do.compareTo(a.nhiet_do));
    notifyListeners(); // Gọi hàm này để cập nhật UI
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _details.length) return null;
    final detail = _details[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(detail.id.toString())),
        DataCell(Text(detail.nhiet_do.toString())),
        DataCell(Text(detail.do_am.toString())),
        DataCell(Text(detail.anh_sang.toString())),
        DataCell(Text(detail.thoi_gian)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _details.length;

  @override
  int get selectedRowCount => 0;
}
