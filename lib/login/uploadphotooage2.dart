// lib/Album/upload_photo_page.dart

import 'package:flutter/material.dart';
import 'package:wememmory/models/media_item.dart'; // import model ของคุณ

class UploadPhotoPage extends StatefulWidget {
  final String selectedMonth;
  final List<MediaItem>? initialSelectedItems; // รับรูปเดิมเข้ามา

  const UploadPhotoPage({
    Key? key, 
    required this.selectedMonth, 
    this.initialSelectedItems
  }) : super(key: key);

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  List<MediaItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    // โหลดรูปเดิมมาใส่ตัวแปร state
    if (widget.initialSelectedItems != null) {
      _selectedItems = List.from(widget.initialSelectedItems!);
    }
  }

  void _onSave() {
    // ส่งข้อมูลกลับไปให้หน้า Recommended
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // ใช้ Scaffold ใน Sheet ได้ เพื่อให้มี AppBar/Body ปกติ
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.selectedMonth),
        automaticallyImplyLeading: false, // ปิดปุ่ม Back มาตรฐาน
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text("เสร็จสิ้น", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          // ... ส่วน Grid แสดงรูปภาพ และ Logic การเลือกรูป ...
          Expanded(
            child: Center(child: Text("พื้นที่เลือกรูปสำหรับ ${widget.selectedMonth}")),
          ),
        ],
      ),
    );
  }
}