import 'package:flutter/material.dart';
import 'package:smart_home/data/fakedata.dart' as fakedata;
import 'package:smart_home/model/DeviceDataSource.dart';

class ActHis extends StatefulWidget {
  const ActHis({super.key});

  @override
  State<ActHis> createState() => _ActHisState();
}

class _ActHisState extends State<ActHis> {
  final DeviceDataSource _dataSource = DeviceDataSource(fakedata.listMD);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bgr1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 80,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'Action History',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(0.8),
              //   borderRadius: BorderRadius.circular(20),
              // ),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  header: Text('Lịch sử bật/tắt thiết bị'),
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Thiết bị')),
                    DataColumn(label: Text('Trạng thái')),
                    DataColumn(label: Text('Thời gian')),
                  ],
                  source: _dataSource,
                  rowsPerPage: 10, // Số hàng trên mỗi trang
                  columnSpacing: 10, // Khoảng cách giữa các cột
                  horizontalMargin: 10,
                  showCheckboxColumn: false,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
