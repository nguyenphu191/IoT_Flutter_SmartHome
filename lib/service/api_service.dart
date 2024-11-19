import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home/model/Wind.dart';
import 'package:smart_home/model/Detail.dart';
import 'package:smart_home/model/DeviceHis.dart';

class ApiService {
  final String baseUrl = 'http://172.20.10.2/api';
  // final String baseUrl = 'http://localhost:5000/api';
  Future<List<Wind>> fetchWS() async {
    List<Wind> alldata = [];
    int page = 1;
    int limit = 10;
    bool hasMoreData = true;

    while (hasMoreData) {
      final response = await http.get(
        Uri.parse('$baseUrl/ws/getByPage?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['wss'] != null && data['wss'] is List) {
          List<Wind> dt = (data['wss'] as List)
              .map((dtJson) => Wind.fromJson(dtJson))
              .toList();

          if (dt.isNotEmpty) {
            alldata.addAll(dt);
            page++;
          } else {
            hasMoreData = false;
          }
        } else {
          hasMoreData = false; // Không có dữ liệu để tải thêm
        }
      } else {
        throw Exception('Failed to load Detail');
      }
    }

    return alldata;
  }

  Future<Map<String, dynamic>> getDeviceCounts() async {
    final url = Uri.parse('$baseUrl/device_counts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch device counts');
    }
  }

  Future<void> PostDetail(Detail detail) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/details'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(detail.toJson()),
      );

      if (response.statusCode == 201) {
        print('Detail successfully saved: ${response.body}');
      } else {
        print('Failed to save detail: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to save detail');
      }
    } catch (e) {
      print('Error while saving detail: $e');
    }
  }

  Future<void> controlled(String device, String action) async {
    final String mqttControlUrl = '$baseUrl/controlled_device';
    final response = await http.post(
      Uri.parse(mqttControlUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'device': device, 'action': action}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to control LED');
    }
  }

  Future<List<Detail>> fetchDetailPage({int page = 1, int limit = 10}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/details/getByPage?page=$page&limit=$limit'), // Thêm page và limit vào URL
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Detail> details = (data['details'] as List)
          .map((detailJson) => Detail.fromJson(detailJson))
          .toList();
      return details;
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<List<Detail>> fetchDetail() async {
    List<Detail> allDetails = [];
    int page = 1;
    int limit = 10;
    bool hasMoreData = true;

    while (hasMoreData) {
      final response = await http.get(
        Uri.parse('$baseUrl/details/getByPage?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Detail> detail = (data['details'] as List)
            .map((detailJson) => Detail.fromJson(detailJson))
            .toList();

        if (detail.isNotEmpty) {
          allDetails.addAll(detail);
          page++;
        } else {
          hasMoreData = false;
        }
      } else {
        throw Exception('Failed to load Detail');
      }
    }

    return allDetails;
  }

  // Hàm lấy dữ liệu trong ngày hiện tại
  Future<List<Detail>> fetchTodayDetails() async {
    final response = await http.get(
      Uri.parse('$baseUrl/details/today'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Detail> todayDetails = (data['details'] as List)
          .map((detailJson) => Detail.fromJson(detailJson))
          .toList();
      return todayDetails;
    } else {
      throw Exception('Failed to load today\'s details');
    }
  }

  Future<List<Detail>> searchDetails(String t) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/details/search?query=$t'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((detailJson) => Detail.fromJson(detailJson)).toList();
      } else {
        throw Exception('Failed to search details');
      }
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }

  Future<List<DeviceHis>> fetchDeviceHisPage(
      {int page = 1, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/devicehis/getByPage?page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<DeviceHis> deviceHistories = (data['deviceHistories'] as List)
          .map((deviceJson) => DeviceHis.fromJson(deviceJson))
          .toList();
      return deviceHistories;
    } else {
      throw Exception('Failed to load DeviceHis');
    }
  }

  Future<List<DeviceHis>> fetchAllDeviceHis() async {
    List<DeviceHis> allDeviceHis = [];
    int page = 1;
    int limit = 10;
    bool hasMoreData = true;

    while (hasMoreData) {
      final response = await http.get(
        Uri.parse('$baseUrl/devicehis/getByPage?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra xem 'devicehis' có tồn tại trong data không
        if (data['deviceHistories'] != null) {
          List<DeviceHis> device = (data['deviceHistories'] as List)
              .map((devicehisJson) => DeviceHis.fromJson(devicehisJson))
              .toList();

          if (device.isNotEmpty) {
            allDeviceHis.addAll(device);
            page++; // Tăng trang để lấy dữ liệu tiếp theo
          } else {
            hasMoreData = false; // Không còn dữ liệu nữa
          }
        } else {
          hasMoreData =
              false; // Nếu không có 'devicehis', ngừng việc tải thêm trang
        }
      } else {
        throw Exception('Failed to load DeviceHis');
      }
    }

    return allDeviceHis;
  }

  Future<List<DeviceHis>> searchDevice(String t) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devicehis/search?thoi_gian=$t'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((devicehisJson) => DeviceHis.fromJson(devicehisJson))
            .toList();
      } else {
        throw Exception('Failed to search device history');
      }
    } catch (e) {
      throw Exception('Error fetching : $e');
    }
  }
}
