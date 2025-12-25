import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/models/albumModel.dart';
import 'package:wememmory/models/photo_item.dart';
import 'package:wememmory/widgets/ApiExeption.dart';

class HomeService {
  const HomeService();

  static Future<dynamic> getUserById({required int id}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      final url = Uri.https(publicUrl, '/api/member/$id');
      final response = await http.get(headers: headers, url);
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        return data['data'];
      } else if (response.statusCode == 500 || response.statusCode == 501 || response.statusCode == 502) {
        throw ApiException('ระบบขัดข้อง\nกรุณารอสักครู่แล้วลองใหม่อีกครั้ง');
      } else {
        final data = convert.jsonDecode(response.body);
        throw ApiException(data['message']);
      }
    } on SocketException {
      // ไม่มีเน็ต
      throw ApiException('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
    } on TimeoutException {
      // รอ response เกินเวลา
      throw ApiException('คำขอหมดเวลา โปรดลองอีกครั้ง');
    } catch (e) {
      // error อื่น ๆ
      throw ApiException('เกิดข้อผิดพลาด: $e');
    }
  }

  static Future<List<AlbumModel>> getAlbums() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.https(publicUrl, 'public/api/get_album_months', {"year": '2025'});
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      final response = await http.get(url, headers: headers).timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        final list = data['data'] as List;
        return list.map((e) => AlbumModel.fromJson(e)).toList();
      } else if (response.statusCode == 500 || response.statusCode == 501 || response.statusCode == 502) {
        throw ApiException('ระบบขัดข้อง\nกรุณารอสักครู่แล้วลองใหม่อีกครั้ง');
      } else {
        final data = convert.jsonDecode(response.body);
        throw ApiException(data['message']);
      }
    } on SocketException {
      // ไม่มีเน็ต
      throw ApiException('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
    } on TimeoutException {
      // รอ response เกินเวลา
      throw ApiException('คำขอหมดเวลา โปรดลองอีกครั้ง');
    } catch (e) {
      // error อื่น ๆ
      throw ApiException('เกิดข้อผิดพลาด: $e');
    }

    
  }

    static Future createOrder({
    int? year,
    int? month,
    List<PhotoItem>? photos,
    String? note,
 
  }) async {
    try {
      final url = Uri.https(publicUrl, '/public/api/album_months');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
      final response = await http.post(url,
          headers: headers,
          body: convert.jsonEncode({
            "year": year,
            "month": month,
            "photos": photos,
            "note": note,
         
          }));
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        return data;
      } else {
        final data = convert.jsonDecode(response.body);
        throw ApiException(data['message']);
      }
    } on SocketException {
      // ไม่มีเน็ต
      throw ApiException('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
    } on TimeoutException {
      // รอ response เกินเวลา
      throw ApiException('คำขอหมดเวลา โปรดลองอีกครั้ง');
    } catch (e) {
      // error อื่น ๆ
      throw ApiException('เกิดข้อผิดพลาด: $e');
    }
  }

    
}
