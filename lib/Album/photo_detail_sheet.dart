import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// ✅ เปลี่ยนเป็น StatefulWidget เพื่อจัดการข้อมูล
class PhotoDetailSheet extends StatefulWidget {
  final MediaItem item;

  const PhotoDetailSheet({super.key, required this.item});

  @override
  State<PhotoDetailSheet> createState() => _PhotoDetailSheetState();
}

class _PhotoDetailSheetState extends State<PhotoDetailSheet> {
  // ตัวควบคุมช่องข้อความ
  late TextEditingController _captionController;
  // ตัวเก็บ Tags ที่ถูกเลือก
  late List<String> _selectedTags;

  // รายชื่อ Tags ทั้งหมดที่มีให้เลือก
  final List<String> _allTags = ["family", "kid", "home", "lover", "favor"];

  @override
  void initState() {
    super.initState();
    // ✅ โหลดข้อมูลเดิมมาแสดง (ถ้ามี)
    _captionController = TextEditingController(text: widget.item.caption);
    _selectedTags = List.from(widget.item.tags);
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // ✅ ฟังก์ชันสลับการเลือก Tag
  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  // ✅ ฟังก์ชันบันทึกข้อมูลกลับไปที่ Item
  void _saveData() {
    widget.item.caption = _captionController.text;
    widget.item.tags = List.from(_selectedTags);
    Navigator.pop(context); // ปิดหน้า Sheet
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // -------------------------------------------------------
          // 1. Header
          // -------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "รายละเอียดรูปภาพ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------
          // 2. Steps Indicator
          // -------------------------------------------------------
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _StepItem(label: 'เลือกรูปภาพ', isActive: true, isFirst: true),
                _StepItem(label: 'แก้ไขและจัดเรียง', isActive: true),
                _StepItem(label: 'พรีวิวสุดท้าย', isActive: false, isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // -------------------------------------------------------
          // 3. Content Area
          // -------------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // รูปภาพ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 350,
                      color: Colors.grey[200],
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FutureBuilder<Uint8List?>(
                            future: widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(800, 800)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                return Image.memory(snapshot.data!, fit: BoxFit.cover);
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                          // Grid Overlay
                          Column(
                            children: [
                              Expanded(child: Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1))))),
                              Expanded(child: Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1))))),
                              Expanded(child: Container()),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Container(decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withOpacity(0.5), width: 1))))),
                              Expanded(child: Container(decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withOpacity(0.5), width: 1))))),
                              Expanded(child: Container()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ปุ่มขยายภาพ
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Logic ขยายภาพเต็มจอ
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF67A5BA),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        elevation: 0,
                      ),
                      child: const Text("ขยายภาพเต็มจอ", style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✅ ช่องกรอกข้อความ (ผูกกับ Controller)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: _captionController, // ผูกตัวแปร
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "เขียนความรู้สึกหรือเรื่องราวเล็ก ๆ ที่ซ่อนอยู่หลังภาพนี้.....",
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ✅ Tags (สร้างจาก Loop)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allTags.map((tag) => _buildTagChip(tag)).toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------
          // 4. Bottom Button (Save)
          // -------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.transparent)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saveData, // ✅ เรียกฟังก์ชันบันทึก
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED7D31),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                  elevation: 0,
                ),
                child: const Text(
                  "บันทึก",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Widget สร้างปุ่ม Tag ที่เปลี่ยนสีได้
  Widget _buildTagChip(String label) {
    bool isSelected = _selectedTags.contains(label);
    
    return GestureDetector(
      onTap: () => _toggleTag(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFED7D31) : Colors.grey[300]!, // ขอบสีส้มเมื่อเลือก
          ),
          borderRadius: BorderRadius.circular(20),
          // ✅ เปลี่ยนสีพื้นหลังเป็นสีส้มเมื่อเลือก
          color: isSelected ? const Color(0xFFED7D31) : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            // ✅ เปลี่ยนสีตัวอักษรเป็นสีขาวเมื่อเลือก
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

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
              Expanded(child: Container(height: 2, color: isFirst ? Colors.transparent : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]))),
              Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300])),
              Expanded(child: Container(height: 2, color: isLast ? Colors.transparent : Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400], fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}