// lib/shop/address_model.dart
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Helper Functions
// -----------------------------------------------------------------------------
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _parseString(dynamic value) {
  return value?.toString() ?? '';
}

// -----------------------------------------------------------------------------
// 1. Province
// -----------------------------------------------------------------------------
class Province {
  final int id;      
  final int code;    
  final String nameTh;
  final String nameEn;

  Province({required this.id, required this.code, required this.nameTh, required this.nameEn});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: _parseInt(json['id']),
      code: _parseInt(json['province_code'] ?? json['provinceCode'] ?? json['code']),
      nameTh: _parseString(json['name_th'] ?? json['nameTH']),
      nameEn: _parseString(json['name_en'] ?? json['nameEn']),
    );
  }
  
  @override
  String toString() => nameTh;
  
  @override
  bool operator ==(Object other) => identical(this, other) || other is Province && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

// -----------------------------------------------------------------------------
// 2. District
// -----------------------------------------------------------------------------
class District {
  final int id;           
  final int code;         
  final int provinceId;   
  final String nameTh;
  final String nameEn;

  District({required this.id, required this.code, required this.provinceId, required this.nameTh, required this.nameEn});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: _parseInt(json['id']),
      // ✅ แก้ไข: เพิ่มการเช็ค 'districtCode' และ 'amphure_code' ให้ครอบคลุม
      code: _parseInt(json['districtCode'] ?? json['amphure_code'] ?? json['district_code'] ?? json['code']),
      // ✅ แก้ไข: เช็ค provinceCode ให้ครอบคลุม
      provinceId: _parseInt(json['province_id'] ?? json['provinceCode']),
      nameTh: _parseString(json['name_th'] ?? json['nameTH']),
      nameEn: _parseString(json['name_en'] ?? json['nameEn']),
    );
  }

  @override
  String toString() => nameTh;

  @override
  bool operator ==(Object other) => identical(this, other) || other is District && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

// -----------------------------------------------------------------------------
// 3. Subdistrict
// -----------------------------------------------------------------------------
class Subdistrict {
  final int id;
  final int districtId;  // FK ไปหา District
  final String nameTh;
  final String nameEn;
  final int postalCode;

  Subdistrict({required this.id, required this.districtId, required this.nameTh, required this.nameEn, required this.postalCode});

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      id: _parseInt(json['id']),
      // ✅ แก้ไข: เช็ค districtCode ให้ครอบคลุม เพื่อให้ Link กับ District ได้ถูกต้อง
      districtId: _parseInt(json['districtCode'] ?? json['amphure_id'] ?? json['district_id']),
      nameTh: _parseString(json['name_th'] ?? json['nameTH']),
      nameEn: _parseString(json['name_en'] ?? json['nameEn']),
      postalCode: _parseInt(json['zip_code'] ?? json['postalCode']),
    );
  }

  @override
  String toString() => nameTh;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Subdistrict && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

// -----------------------------------------------------------------------------
// AddressInfo
// -----------------------------------------------------------------------------
class AddressInfo {
  final String name;
  final String phone;
  final String province;
  final String district;
  final String subDistrict;
  final String detail;
  final String? postalCode;
  
  // ✅ เพิ่ม 2 ตัวแปรนี้
  final double? lat; 
  final double? lng;

  const AddressInfo({
    required this.name,
    required this.phone,
    this.province = '',
    this.district = '',
    this.subDistrict = '',
    this.detail = '',
    this.postalCode,
    this.lat, // ✅ เพิ่มใน constructor
    this.lng, // ✅ เพิ่มใน constructor
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AddressInfo && name == other.name && detail == other.detail;
  @override
  int get hashCode => Object.hash(name, phone, detail);
}

// ✅ เพิ่มตัวแปร Global ตามที่ขอครับ
List<AddressInfo> globalAddressList = [];