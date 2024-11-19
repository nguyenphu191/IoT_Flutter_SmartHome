import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/model/Wind.dart';
import 'package:smart_home/service/api_service.dart';
import 'dart:async';
import 'package:smart_home/widgets/big_text.dart';

class WindPage extends StatefulWidget {
  const WindPage({super.key});

  @override
  State<WindPage> createState() => _WindPageState();
}

class _WindPageState extends State<WindPage>
    with SingleTickerProviderStateMixin {
  double wind = 0;
  late List<Wind> data = [];
  late ApiService _apiService;
  bool _isloading = false;
  Wind nowwind = new Wind(id: '', ws: 0, thoi_gian: '');
  late AnimationController _animationController;
  bool isBlinking = false;
  Timer? _timer;

  Future<void> _fetchNowWind() async {
    try {
      List<Wind> fetchedData = await _apiService.fetchWS();
      setState(() {
        data = fetchedData;
        nowwind = fetchedData.first;
        wind = nowwind.ws;
        if (wind >= 60) {
          isBlinking = true;
          _animationController.repeat(reverse: true);
        } else {
          isBlinking = false;
          _animationController.stop();
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _startAutoRefresh() {
    _fetchNowWind();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchNowWind();
    });
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
  void initState() {
    super.initState();
    _apiService = ApiService();
    // Thiết lập AnimationController cho hiệu ứng nhấp nháy
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
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
                    'Bài 5',
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
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Wind Speed Now: ${nowwind.ws} m/s',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  height: 350,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: _generateGradient(
                      Colors.white,
                      Colors.blue,
                      nowwind.ws,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.blind,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 120,
                                  child: Center(
                                    child: Text(
                                      'Tốc độ gió',
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
                            child: Center(),
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
                            gridData: FlGridData(show: true), //hiển thị lưới
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
                            maxY: 120,
                            lineBarsData: [
                              LineChartBarData(
                                spots: data
                                    .asMap()
                                    .entries
                                    .map((e) =>
                                        FlSpot(e.key.toDouble(), e.value.ws))
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
            )),
          ),
          Positioned(
            top: 600,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 206, 206),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isloading
                      ? CircularProgressIndicator()
                      : Container(
                          height: 50,
                          width: 50,
                          child: isBlinking
                              ? FadeTransition(
                                  opacity: _animationController,
                                  child: Icon(Icons.lightbulb,
                                      size: 50, color: Colors.yellow),
                                )
                              : Icon(Icons.lightbulb_outline,
                                  size: 50,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
