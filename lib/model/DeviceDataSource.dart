import 'package:flutter/material.dart';
import 'package:smart_home/model/DeviceModel.dart';

class DeviceDataSource extends DataTableSource {
  final List<DeviceModel> _deviceModels;

  DeviceDataSource(this._deviceModels);

  @override
  DataRow? getRow(int index) {
    if (index >= _deviceModels.length) return null;
    final device = _deviceModels[index];
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
  int get rowCount => _deviceModels.length;

  @override
  int get selectedRowCount => 0;
}
