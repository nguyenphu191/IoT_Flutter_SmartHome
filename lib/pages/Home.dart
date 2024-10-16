import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_home/model/Detail.dart';
import 'package:smart_home/model/DeviceHis.dart';
import 'package:smart_home/service/api_service.dart';
import 'package:smart_home/widgets/big_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Detail> data = [];
  late Detail nowdetail;
  double nhietdo = 0;
  double doam = 0;
  double as = 0;
  bool _isSwitched1 = false;
  bool _isSwitched2 = false;
  bool _isSwitched3 = false;
  final ApiService apiService = ApiService();

  void controlled(String device, String action) async {
    try {
      await apiService.controlled(device, action);
    } catch (e) {
      print('Lỗi điều khiển: $e');
    }
  }

  void _toggleSwitch1() {
    setState(() {
      _isSwitched1 = !_isSwitched1;
    });
  }

  void _toggleSwitch2() {
    setState(() {
      _isSwitched2 = !_isSwitched2;
    });
  }

  void _toggleSwitch3() {
    setState(() {
      _isSwitched3 = !_isSwitched3;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTodayData();
    _fetchDataDevice();
    _fetchNowDetail();
  }

  Future<void> _fetchTodayData() async {
    try {
      List<Detail> fetchedData = await ApiService().fetchDetail();
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchDataDevice() async {
    try {
      List<DeviceHis> fetchedData = await ApiService().fetchAllDeviceHis();
      fetchedData = fetchedData.reversed.toList();
      for (var device in fetchedData) {
        if (device.ten == 'Quạt') {
          setState(() {
            _isSwitched1 = device.tinh_trang == 'ON';
          });
        } else if (device.ten == 'Đèn') {
          setState(() {
            _isSwitched2 = device.tinh_trang == 'ON';
          });
        } else if (device.ten == 'Điều hòa') {
          setState(() {
            _isSwitched3 = device.tinh_trang == 'ON';
          });
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchNowDetail() async {
    try {
      List<Detail> fetchedData = await ApiService().fetchDetail();
      setState(() {
        nowdetail = fetchedData.last;
        nhietdo = nowdetail.nhiet_do;
        doam = nowdetail.do_am;
        as = nowdetail.anh_sang;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  LinearGradient _generateGradient(
      Color startColor, Color endColor, double value, double min, double max) {
    double normalizedValue = (value - min) / (max - min);
    return LinearGradient(
      colors: [
        startColor,
        Color.lerp(startColor, endColor, normalizedValue)!,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
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
              padding: EdgeInsets.all(20),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fu Smart Home',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'page1',
                              child: BigText('', text: 'Data Sensor', size: 15),
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
                            Navigator.pushNamed(context, '/datasensor');
                          } else if (value == 'page2') {
                            Navigator.pushNamed(context, '/actionhistory');
                          } else {
                            Navigator.pushNamed(context, '/profile');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 100,
              left: 10,
              right: 10,
              child: Container(
                height: 350,
                width: double.maxFinite,
                child: PageView(
                  children: [
                    Container(
                      height: 350,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: _generateGradient(
                          Colors.white,
                          Colors.red,
                          nhietdo,
                          0,
                          80,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 160,
                                margin: EdgeInsets.only(left: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/nhietdo.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                        child: Text(
                                          'Nhiệt độ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 120,
                                margin: EdgeInsets.only(right: 30),
                                child: Center(
                                  child: Text(
                                    '${nhietdo.round()}°C',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            width: double.maxFinite,
                            color: Colors.black,
                          ),
                          Container(
                            height: 270,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 10),
                            child: LineChart(
                              LineChartData(
                                gridData:
                                    FlGridData(show: true), //hiển thị lưới
                                titlesData: FlTitlesData(
                                    //Cấu hình cho trục dọc
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 5, // Khoảng cách giữa các số
                                        reservedSize: 40,
                                      ),
                                    ),
                                    //Cấu hình cho trục ngang
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                        // getTitlesWidget: (value, meta) {
                                        //   int index = value.toInt();
                                        //   if (index >= 0 && index < data.length) {
                                        //     return Text(data[index]
                                        //         .thoi_gian
                                        //         .split(' ')[0]);
                                        //   }
                                        //   return Text('');
                                        // },
                                      ),
                                    ),
                                    topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: false,
                                    ))),
                                borderData: FlBorderData(show: true),
                                minX: 0,
                                maxX: data.length.toDouble() - 1,
                                minY: 0,
                                maxY: 60,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: data
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(
                                            e.key.toDouble(), e.value.nhiet_do))
                                        .toList(),
                                    isCurved: true,
                                    color: const Color.fromARGB(255, 1, 1, 1),
                                    barWidth: 1,
                                    belowBarData: BarAreaData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 350,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: _generateGradient(
                          Colors.white,
                          Colors.blue,
                          doam,
                          0,
                          100,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 160,
                                margin: EdgeInsets.only(left: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/doam.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 120,
                                      child: Center(
                                        child: Text(
                                          'Độ ẩm',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 120,
                                margin: EdgeInsets.only(right: 30),
                                child: Center(
                                  child: Text(
                                    '${doam.round()}%',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            width: double.maxFinite,
                            color: Colors.black,
                          ),
                          Container(
                            height: 270,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 10),
                            child: LineChart(
                              LineChartData(
                                gridData:
                                    FlGridData(show: true), //hiển thị lưới
                                titlesData: FlTitlesData(
                                  //Cấu hình cho trục dọc
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 10, // Khoảng cách giữa các số
                                      reservedSize: 40,
                                    ),
                                  ),
                                  //Cấu hình cho trục ngang
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                      // getTitlesWidget: (value, meta) {
                                      //   int index = value.toInt();
                                      //   if (index >= 0 && index < data.length) {
                                      //     return Text(data[index]
                                      //         .thoi_gian
                                      //         .split(' ')[0]);
                                      //   }
                                      //   return Text('');
                                      // },
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: false,
                                  )),
                                ),
                                borderData: FlBorderData(show: true),
                                minX: 0,
                                maxX: data.length.toDouble() - 1,
                                minY: 10,
                                maxY: 100,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: data
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(
                                            e.key.toDouble(), e.value.do_am))
                                        .toList(),
                                    isCurved: true,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    barWidth: 1,
                                    belowBarData: BarAreaData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 350,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: _generateGradient(
                          Colors.white,
                          Colors.yellow,
                          as,
                          0,
                          1000,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 160,
                                margin: EdgeInsets.only(left: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/anhsang.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 120,
                                      child: Center(
                                        child: Text(
                                          'Ánh sáng',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 160,
                                margin: EdgeInsets.only(right: 15),
                                child: Center(
                                  child: Text(
                                    '${as.round()}lux',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            width: double.maxFinite,
                            color: Colors.black,
                          ),
                          Container(
                            height: 270,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 10),
                            child: LineChart(
                              LineChartData(
                                gridData:
                                    FlGridData(show: true), //hiển thị lưới
                                titlesData: FlTitlesData(
                                  //Cấu hình cho trục dọc
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 100, // Khoảng cách giữa các số
                                      reservedSize: 40,
                                    ),
                                  ),
                                  //Cấu hình cho trục ngang
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                      // getTitlesWidget: (value, meta) {
                                      //   int index = value.toInt();
                                      //   if (index >= 0 && index < data.length) {
                                      //     return Text(data[index]
                                      //         .thoi_gian
                                      //         .split(' ')[0]);
                                      //   }
                                      //   return Text('');
                                      // },
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: false,
                                  )),
                                ),
                                borderData: FlBorderData(show: true),
                                minX: 0,
                                maxX: data.length.toDouble() - 1,
                                minY: 0,
                                maxY: 1000,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: data
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(
                                            e.key.toDouble(), e.value.anh_sang))
                                        .toList(),
                                    isCurved: true,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    barWidth: 1,
                                    belowBarData: BarAreaData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
            top: 480,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 206, 206),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                child: _isSwitched1
                                    ? Icon(Icons.air,
                                        size: 60, color: Colors.blue)
                                    : Icon(
                                        Icons.air,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _toggleSwitch1();
                                          controlled('device1',
                                              _isSwitched1 ? 'ON' : 'OFF');
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            _isSwitched1
                                                ? Icons.check
                                                : Icons.close,
                                            size: 40,
                                            color: _isSwitched1
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _isSwitched1 ? Text('ON') : Text('OFF'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 206, 206),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 70,
                                width: 70,
                                // decoration: BoxDecoration(
                                //   borderRadius:
                                //       BorderRadius.circular(50),
                                //   image: DecorationImage(
                                //     image: _isSwitched2
                                //         ? AssetImage(
                                //             'assets/images/light3.png')
                                //         : AssetImage(
                                //             'assets/images/light1.jpg'),
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                child: _isSwitched2
                                    ? Icon(FontAwesomeIcons.lightbulb,
                                        size: 60,
                                        color: const Color.fromARGB(
                                            255, 255, 230, 0))
                                    : Icon(
                                        FontAwesomeIcons.lightbulb,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _toggleSwitch2();
                                          controlled('device2',
                                              _isSwitched2 ? 'ON' : 'OFF');
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            _isSwitched2
                                                ? Icons.check
                                                : Icons.close,
                                            size: 40,
                                            color: _isSwitched2
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _isSwitched2 ? Text('ON') : Text('OFF'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 206, 206),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                child: _isSwitched3
                                    ? Icon(Icons.ac_unit,
                                        size: 60, color: Colors.blue)
                                    : Icon(
                                        Icons.ac_unit,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _toggleSwitch3();
                                          controlled('device3',
                                              _isSwitched3 ? 'ON' : 'OFF');
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            _isSwitched3
                                                ? Icons.check
                                                : Icons.close,
                                            size: 30,
                                            color: _isSwitched3
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _isSwitched3 ? Text('ON') : Text('OFF'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    // mqttService.disconnect(); // Ngắt kết nối khi không cần thiết
    super.dispose();
  }
}
