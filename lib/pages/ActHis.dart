import 'package:flutter/material.dart';
import 'package:smart_home/service/api_service.dart';
import 'package:smart_home/model/DeviceHis.dart';
import 'package:smart_home/model/DeviceDataSource.dart';
import 'package:smart_home/widgets/big_text.dart';

class ActHis extends StatefulWidget {
  const ActHis({super.key});

  @override
  State<ActHis> createState() => _ActHisState();
}

class _ActHisState extends State<ActHis> {
  late Future<List<DeviceHis>> _deviceHisFuture;
  late ApiService _apiService;
  late TextEditingController _searchController;
  late TextEditingController _pageController;
  late TextEditingController _limitController;

  void _searchByName() {
    setState(() {
      String name = _searchController.text;
      _deviceHisFuture = _apiService.searchDevice(name);
    });
  }

  void _devicehispage() {
    setState(() {
      int page = int.tryParse(_pageController.text) ?? 1;
      int limit = int.tryParse(_limitController.text) ?? 10;
      _deviceHisFuture =
          _apiService.fetchDeviceHisPage(page: page, limit: limit);
    });
  }

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _searchController = TextEditingController();
    _pageController = TextEditingController();
    _limitController = TextEditingController();
    _deviceHisFuture =
        _apiService.fetchAllDeviceHis(); // Lấy dữ liệu khi khởi tạo
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
                      'Action History',
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
                              child: BigText('', text: 'Data Sensor', size: 15),
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
                            Navigator.pushNamed(context, '/datasensor');
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
                                  _searchByName();
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
                                  _devicehispage();
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
              child: FutureBuilder<List<DeviceHis>>(
                future: _deviceHisFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Data Available'));
                  } else {
                    final deviceHisList = snapshot.data!;
                    final dataSource = DeviceDataSource(deviceHisList);

                    return SingleChildScrollView(
                      child: PaginatedDataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Thiết bị')),
                          DataColumn(label: Text('Trạng thái')),
                          DataColumn(label: Text('Thời gian')),
                        ],
                        source: dataSource,
                        rowsPerPage: 10, // Số hàng trên mỗi trang
                        columnSpacing: 10, // Khoảng cách giữa các cột
                        horizontalMargin: 10,
                        showCheckboxColumn: false,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
