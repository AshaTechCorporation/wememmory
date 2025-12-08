import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart'; // 👈 เพิ่มบรรทัดนี้

// import 'package:wememmory/create/upload_photo_page.dart'; // ⚠️ Import ไฟล์ที่มีคลาส MediaItem ของคุณที่นี่

// (ถ้าคุณยังไม่ได้แยกไฟล์ Model ให้ใช้ Class นี้แทนชั่วคราว หรือ Import จากไฟล์เดิม)
// ---------------------------------------------------------------------------
// enum MediaType { image, video }

// class MediaItem {
//   final AssetEntity asset;
//   final MediaType type;
//   MediaItem({required this.asset, required this.type});
// }
// // ---------------------------------------------------------------------------

class AlbumLayoutPage extends StatefulWidget {
  final List<MediaItem> selectedItems;
  final String monthName; // เช่น "ตุลาคม 2568"

  const AlbumLayoutPage({
    super.key,
    required this.selectedItems,
    required this.monthName,
  });

  @override
  State<AlbumLayoutPage> createState() => _AlbumLayoutPageState();
}

class _AlbumLayoutPageState extends State<AlbumLayoutPage> {
  @override
  Widget build(BuildContext context) {
    // ตัดปีออกเอาแค่ชื่อเดือน
    final String monthTitle = widget.monthName.split(' ')[0]; 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // -------------------------------------------------------
            // 1. Header
            // -------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$monthTitle : อัลบั้ม (0 แก้ไข)',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // -------------------------------------------------------
            // 2. Steps Indicator (Step 2 Active)
            // -------------------------------------------------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _StepItem(label: 'เลือกรูปภาพ', isActive: true, isFirst: true),
                  _StepItem(label: 'แก้ไขและจัดเรียง', isActive: true), // 🔵 Active
                  _StepItem(label: 'พรีวิวสุดท้าย', isActive: false, isLast: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------
            // 3. Hint Text
            // -------------------------------------------------------
            const Text(
              "แตะเพื่อแก้ไข • ลากเพื่อจัดลำดับ",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            // -------------------------------------------------------
            // 4. Album Grid Layout
            // -------------------------------------------------------
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100], // พื้นหลังสีเทาอ่อน
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // แบ่ง 2 คอลัมน์ (ซ้าย-ขวา)
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8, // สัดส่วนแนวตั้ง (ปรับได้ตามชอบ)
                  ),
                  // แสดง 6 คู่ (12 รูป) หรือตามจำนวนรูปที่เลือกมา + ช่องว่าง
                  itemCount: 6 * 2, 
                  itemBuilder: (context, index) {
                    // ตรวจสอบว่า index นี้มีรูปหรือไม่
                    final MediaItem? item = index < widget.selectedItems.length 
                        ? widget.selectedItems[index] 
                        : null;

                    return _AlbumSlot(item: item, index: index);
                  },
                ),
              ),
            ),

            // -------------------------------------------------------
            // 5. Bottom Buttons
            // -------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Column(
                children: [
                  // ปุ่มบันทึก
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Logic บันทึกอัลบั้ม
                        print("บันทึกอัลบั้ม");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED7D31), // สีส้ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'บันทึก',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ปุ่มย้อนกลับ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ย้อนกลับ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// Widget ย่อย: ช่องใส่อัลบั้ม (แสดงรูป)
// -------------------------------------------------------
class _AlbumSlot extends StatelessWidget {
  final MediaItem? item;
  final int index;

  const _AlbumSlot({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: item != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                // แสดงรูปภาพ
                FutureBuilder<Uint8List?>(
                  future: item!.asset.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && 
                        snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                    return Container(color: Colors.grey[200]);
                  },
                ),
                
                // ถ้าเป็นวิดีโอ แสดงไอคอน Play
                if (item!.type == MediaType.video)
                  const Center(
                    child: Icon(Icons.play_circle_fill, 
                      color: Colors.white70, size: 36),
                  ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ถ้าไม่มีรูป ให้แสดงเป็น Placeholder หรือชื่อเดือน
                  Text(
                    "รูปที่ ${index + 1}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// -------------------------------------------------------
// Widget ย่อย: Step Indicator (นำมาจากหน้าเก่า)
// -------------------------------------------------------
class _StepItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const _StepItem({
    required this.label,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                      height: 2,
                      color: isFirst
                          ? Colors.transparent
                          : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]))),
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300])),
              Expanded(
                  child: Container(
                      height: 2,
                      color: isLast ? Colors.transparent : Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}