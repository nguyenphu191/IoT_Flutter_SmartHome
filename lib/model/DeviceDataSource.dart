import 'package:flutter/material.dart';
import 'package:smart_home/model/DeviceHis.dart';

class DeviceDataSource extends DataTableSource {
  final List<DeviceHis> _deviceHistories;

  DeviceDataSource(this._deviceHistories);

  @override
  DataRow? getRow(int index) {
    if (index >= _deviceHistories.length) return null;
    final device = _deviceHistories[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(device.id.toString())),
        DataCell(Text(device.ten)),
        DataCell(Text(device.tinh_trang)),
        DataCell(Text(device.thoi_gian)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _deviceHistories.length;

  @override
  int get selectedRowCount => 0;
}
