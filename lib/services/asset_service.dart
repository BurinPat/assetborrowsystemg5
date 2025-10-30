import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asset.dart';  // นำเข้าโมเดล Asset

class AssetService {
  static const String _baseUrl = 'http://localhost:5000/api';  // URL ของ API

  // ฟังก์ชันเพื่อดึงรายการครุภัณฑ์จาก API
  static Future<List<Asset>> getAssets() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/assets'));

      if (response.statusCode == 200) {
        // ถ้าการร้องขอสำเร็จ, แปลง JSON เป็น List<Asset>
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Asset.fromJson(item)).toList();  // แปลง JSON เป็นรายการ Asset
      } else {
        throw Exception('Failed to load assets');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load assets');
    }
  }
}

class Asset {
  final int id;
  final String name;
  final String status;
  final String imageUrl;  // เพิ่ม imageUrl สำหรับ URL ของภาพ

  Asset({
    required this.id,
    required this.name,
    required this.status,
    required this.imageUrl,
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็น Asset
  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      imageUrl: json['image_url'],  // เชื่อมโยงกับคีย์ 'image_url' จาก API
    );
  }
}
