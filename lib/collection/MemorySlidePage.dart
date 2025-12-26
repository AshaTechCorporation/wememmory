import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemorySlidePage extends StatelessWidget {
  final String monthName;
  // ✅ เปลี่ยนเป็น dynamic
  final List<dynamic> items;

  const MemorySlidePage({
    super.key,
    required this.monthName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // แบ่งข้อมูลออกเป็น 2 ชุดสำหรับ 2 แถว
    final int halfLength = (items.length / 2).ceil();
    final List<dynamic> firstRowItems = items.take(halfLength).toList();
    final List<dynamic> secondRowItems = items.skip(halfLength).toList();

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ส่วนหัวข้อ ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "ความทรงจำใน$monthName",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "100 แท็กที่ใช้ไปในเดือนนี้",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- แถวที่ 1 ---
            _buildMemoryRow(firstRowItems, "#ครอบครัว"),

            const SizedBox(height: 40),
            
            // --- แถวที่ 2 ---
            _buildMemoryRow(secondRowItems, "#ความรัก"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryRow(List<dynamic> rowItems, String tagLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: rowItems.length,
            itemBuilder: (context, index) {
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        // ✅ เรียกใช้ Widget ที่แสดงรูป URL
                        child: _StaticPhotoSlot(item: rowItems[index]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: Text(
                        "อากาศดี วิวสวย ครอบครัวพร้อม",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8),
          child: Text(
            tagLabel,
            style: const TextStyle(
              color: Color(0xFFED7D31),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ ปรับ _StaticPhotoSlot ให้แสดงรูปจาก URL
class _StaticPhotoSlot extends StatelessWidget {
  final dynamic item;
  const _StaticPhotoSlot({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // ดึง URL
    final imageUrl = (item.image is String) ? item.image : "";

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        color: Colors.grey[200],
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      ),
    );
  }
}