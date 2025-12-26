import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FanStackDetailPage extends StatelessWidget {
  final String monthName;
  // ✅ เปลี่ยนเป็น dynamic เพื่อรองรับข้อมูลจาก Server
  final List<dynamic> items;

  const FanStackDetailPage({
    super.key,
    required this.monthName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // --- Title Section ---
          Center(
            child: Column(
              children: [
                Text(
                  "ความทรงจำใน$monthName",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "0 ครั้งที่แชร์ไปในเดือนนี้",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          // --- List Section ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 4, // จำลองข้อมูล 4 รายการ
              itemBuilder: (context, index) {
                // คำนวณวันที่จำลอง (หรือดึงจากข้อมูลจริงถ้ามี)
                int day = 4 - index; 
                
                bool isLeftAligned = index % 2 == 0; 

                return Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isLeftAligned
                        ? [
                            // แบบ A: รูปซ้าย - ข้อความขวา
                            Expanded(flex: 5, child: _buildFanImageStack()),
                            const SizedBox(width: 8 ),
                            Expanded(
                              flex: 4, 
                              child: _buildTextContent(day, CrossAxisAlignment.start)
                            ),
                          ]
                        : [
                            // แบบ B: ข้อความซ้าย - รูปขวา
                            Expanded(
                              flex: 4, 
                              child: _buildTextContent(day, CrossAxisAlignment.end)
                            ),
                            const SizedBox(width: 26),
                            Expanded(flex: 5, child: _buildFanImageStack()),
                          ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(int day, CrossAxisAlignment alignment) {
    // แยกปีออกจาก monthName เพื่อมาแสดง (ถ้ามี)
    // หรือจะ Hardcode 2025 ไปก่อนตามดีไซน์ก็ได้
    return Column(
      crossAxisAlignment: alignment,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$day $monthName",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "ผู้ที่เข้าชม 23+",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFanImageStack() {
    // ดึงข้อมูลรูปภาพมาแสดง (ถ้ามีน้อยกว่า 4 ก็เอาเท่าที่มี)
    final displayItems = items.take(4).toList();
    return SizedBox(
      height: 120, 
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < displayItems.length; i++)
            _buildFanItem(displayItems[i], index: i),
        ],
      ),
    );
  }

  Widget _buildFanItem(dynamic item, {required int index}) {
    const double cardWidth = 104.0;
    const double cardHeight = 91.0;

    List<double> rotations = [0.08, -0.1, 0.08, -0.1];
    double angle = (index < rotations.length) ? rotations[index] : 0.0;
    
    double leftOffset = index * 18.0; 

    return Positioned(
      left: leftOffset,
      top: 25,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            // ✅ ใช้ฟังก์ชันแสดงภาพจาก URL
            child: _buildImage(item),
          ),
        ),
      ),
    );
  }

  // ✅ Helper method แสดงรูปจาก URL
  Widget _buildImage(dynamic item) {
    // ดึง URL จาก property .image (ปรับตาม Model ของคุณ)
    final imageUrl = (item.image is String) ? item.image : "";

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey[200]),
      errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: const Icon(Icons.error)),
    );
  }
}