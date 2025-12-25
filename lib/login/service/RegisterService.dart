import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/widgets/ApiExeption.dart';

class Registerservice {
  const Registerservice();
  static Future register({required String fullname,required String username, required String avatar, required String language}) async {
    try {

      final url = Uri.https(publicUrl, '/public/api/member');
      final response = await http.post(url, body: {'full_name': fullname,'username': username, 'phone': username,'password': username,'avatar': avatar,'language':language,},).timeout(const Duration(minutes: 1));

      if (response.statusCode == 200||response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);
        return data;
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

  static Future addImage({File? file, required String path}) async {
    const apiUrl = '$baseUrl/public/api/upload_images';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var formData = FormData.fromMap({'image': await MultipartFile.fromFile(file!.path), 'path': path});
    final response = await Dio().post(apiUrl, data: formData, options: Options(headers: headers));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'];
      return data;
    } else {
      throw Exception('อัพโหดลไฟล์ล้มเหลว');
    }
  }
}