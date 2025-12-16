import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

class MemorySlidePage extends StatelessWidget {
  final String monthName;
  final List<MediaItem> items;

  const MemorySlidePage({
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "ความทรงจำใน$monthName",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "0 แท็กที่ใช้ไปในเดือนนี้", 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: GridView.builder(
          scrollDirection: Axis.horizontal, // ✅ เลื่อนแนวนอน
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // ✅ 2 แถว
            crossAxisSpacing: 24, // ระยะห่างระหว่างแถวบน-ล่าง
            mainAxisSpacing: 16, // ระยะห่างระหว่างคอลัมน์ซ้าย-ขวา
            childAspectRatio: 1.3, // สัดส่วนการ์ด (กว้าง/สูง) ปรับเลขนี้ถ้าการ์ดอ้วนหรือผอมไป
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            // สลับ Tag สีส้ม
            final String tag = index % 2 == 0 ? "#ครอบครัว" : "#ความรัก";
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- ส่วนการ์ดสีขาว ---
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Image Area (พื้นที่รูปภาพ) ---
                        Expanded(
                          // ✅ ปรับแก้ตรงนี้: เพิ่มค่า flex เป็น 6 (จากเดิม 4) เพื่อให้รูปใหญ่ขึ้น
                          flex: 6, 
                          child: Padding(
                            padding: const EdgeInsets.all(8.0), // ลด Padding ลงเล็กน้อยเพื่อให้รูปเต็มขึ้น
                            child: _StaticPhotoSlot(item: items[index]),
                          ),
                        ),
                        
                        // --- Caption Area (พื้นที่ข้อความ) ---
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                          child: Text(
                            "อากาศดี วิวสวย ครอบครัวพร้อม", 
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // --- Tag Text (ข้อความสีส้มด้านล่าง) ---
                Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFFED7D31),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget ช่วยโหลดและแสดงผลรูปภาพ (เหมือนเดิม)
// ----------------------------------------------------------------------------
class _StaticPhotoSlot extends StatelessWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (item.capturedImage != null)
            Image.memory(item.capturedImage!, fit: BoxFit.cover)
          else
            FutureBuilder<Uint8List?>(
              future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return Container(color: Colors.grey[200]);
              },
            ),
        ],
      ),
    );
  }
}