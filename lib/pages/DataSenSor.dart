import 'package:flutter/material.dart';
import 'package:smart_home/model/DataSensorSource.dart';
import 'package:smart_home/data/fakedata.dart' as fakedata;

class DataSensor extends StatefulWidget {
  const DataSensor({super.key});

  @override
  State<DataSensor> createState() => _DataSensorState();
}

class _DataSensorState extends State<DataSensor> {
  final DataSensorSource _dataSource = DataSensorSource(fakedata.ListDT);
  bool _isAscending = true;
  TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    'Data Sensor',
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
            top: 100,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 200,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.8),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 20, bottom: 10),
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _dataSource.filterND(_searchController.text);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.arrow_upward,
                            size: 25,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isAscending = true;
                              _dataSource.sortND(_isAscending);
                            });
                          }),
                      IconButton(
                          icon: const Icon(
                            Icons.arrow_downward,
                            size: 25,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isAscending = false;
                              _dataSource.sortND(_isAscending);
                            });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 140,
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
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Nhiệt độ')),
                    DataColumn(label: Text('Độ ẩm')),
                    DataColumn(label: Text('Ánh sáng')),
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
