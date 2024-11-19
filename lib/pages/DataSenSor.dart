import 'package:flutter/material.dart';
import 'package:smart_home/model/DataSensorSource.dart';
import 'package:smart_home/model/Detail.dart';
import 'package:smart_home/service/api_service.dart';
import 'package:smart_home/widgets/big_text.dart';

class DataSensor extends StatefulWidget {
  const DataSensor({super.key});

  @override
  State<DataSensor> createState() => _DataSensorState();
}

class _DataSensorState extends State<DataSensor> {
  late Future<List<Detail>> _detailFuture;
  late ApiService _apiService;
  bool _isAscending = true;
  late TextEditingController _searchController;
  late TextEditingController _pageController;
  late TextEditingController _limitController;
  late DataSensorSource _dataSource;

  void _searchByTemperature() {
    setState(() {
      _detailFuture = _apiService.searchDetails(_searchController.text);
    });
  }

  void _detailpage() {
    setState(() {
      int page = int.tryParse(_pageController.text) ?? 1;
      int limit = int.tryParse(_limitController.text) ?? 10;
      _detailFuture = _apiService.fetchDetailPage(page: page, limit: limit);
    });
  }

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _detailFuture = _apiService.fetchDetail();
    _searchController = TextEditingController();
    _pageController = TextEditingController();
    _limitController = TextEditingController();
  }

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
                  Text(
                    'Data Sensor',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'page1',
                            child: BigText('', text: 'Home', size: 15),
                          ),
                          PopupMenuItem<String>(
                            value: 'page2',
                            child:
                                BigText('', text: 'Action History', size: 15),
                          ),
                          PopupMenuItem<String>(
                            value: 'page3',
                            child: BigText('', text: 'Profile', size: 15),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        // Xử lý khi lựa chọn một mục trong danh sách
                        if (value == 'page1') {
                          Navigator.pushNamed(context, '/');
                        } else if (value == 'page2') {
                          Navigator.pushNamed(context, '/actionhistory');
                        } else {
                          Navigator.pushNamed(context, '/profile');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Row(
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
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(
                                Icons.search_sharp,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () {
                                _searchByTemperature();
                              }),
                          IconButton(
                              icon: const Icon(
                                Icons.arrow_upward,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isAscending = true;
                                  _dataSource.sortND(_isAscending);
                                  _dataSource = DataSensorSource(
                                      _dataSource.getFilteredDetails());
                                });
                              }),
                          IconButton(
                              icon: const Icon(
                                Icons.arrow_downward,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isAscending = false;
                                  _dataSource.sortND(_isAscending);
                                  _dataSource = DataSensorSource(
                                      _dataSource.getFilteredDetails());
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.8),
                            ),
                            child: TextField(
                              controller: _pageController,
                              decoration: InputDecoration(
                                hintText: 'Page',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 20, bottom: 10),
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.8),
                            ),
                            child: TextField(
                              controller: _limitController,
                              decoration: InputDecoration(
                                hintText: 'Limit',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 20, bottom: 10),
                              ),
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
                                Icons.search_sharp,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () {
                                _detailpage();
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 180,
            left: 10,
            right: 10,
            bottom: 10,
            child: FutureBuilder<List<Detail>>(
              future: _detailFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Data Available'));
                } else {
                  final detailList = snapshot.data!;
                  _dataSource = DataSensorSource(detailList);

                  return SingleChildScrollView(
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
                      columnSpacing: 5, // Khoảng cách giữa các cột
                      horizontalMargin: 10,
                    ),
                  );
                }
              },
            ),
          )
        ],
      )),
    );
  }
}
