import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/print_sheet.dart'; 
import 'package:wememmory/models/media_item.dart';

// หน้า พรีวิวสุดท้าย & ยืนยัน
class FinalPreviewSheet extends StatefulWidget {
  final List<MediaItem> items;
  final String monthName;

  const FinalPreviewSheet({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  State<FinalPreviewSheet> createState() => _FinalPreviewSheetState();
}

class _FinalPreviewSheetState extends State<FinalPreviewSheet> {
  bool _withCaption = false;
  bool _withDate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ---------------------------------------------------------
          // [ส่วนที่เพิ่ม] : Slide Indicator (แถบขีดด้านบน)
          // ---------------------------------------------------------
          const SizedBox(height: 12), // ระยะห่างจากขอบบนสุด
          Container(
            width: 61, // ความกว้างของขีด
            height: 5, // ความหนาของขีด
            decoration: BoxDecoration(
              color: Colors.grey[300], // สีเทาอ่อน
              borderRadius: BorderRadius.circular(2.5), // ความมน
            ),
          ),
          // ---------------------------------------------------------

          // 1. Header
          Padding(
            // ปรับระยะห่างด้านบนเป็น 10 (เดิม 20) เพื่อชดเชยพื้นที่ขีด
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'พรีวิวสุดท้าย & ยืนยัน',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Steps Indicator
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _StepItem(label: 'เลือกรูปภาพ', isActive: true, isFirst: true, isCompleted: true),
                _StepItem(label: 'แก้ไขและจัดเรียง', isActive: true, isCompleted: true),
                _StepItem(label: 'พรีวิวสุดท้าย', isActive: true, isLast: true), 
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Toggle Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildToggleOption("พิมพ์พร้อมคำบรรยาย", _withCaption, (val) => setState(() => _withCaption = val)),
                const SizedBox(height: 12),
                _buildToggleOption("พิมพ์พร้อมวันที่", _withDate, (val) => setState(() => _withDate = val)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Preview Text
          Text(
            "คอลเลกชัน${widget.monthName}ของคุณจะออกมาเป็นแบบนี้..\nพร้อมที่จะสร้างความทรงจำที่จับต้องได้แล้วหรือยัง?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // 5. Album Preview Area (The Book)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ✅ ใช้ Widget ที่แยกออกมาเพื่อแก้ปัญหาการกระพริบ
                  _AlbumPreviewSection(items: widget.items, monthName: widget.monthName),

                  const SizedBox(height: 20),

                  // กล่องข้อความสีฟ้าอ่อน
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFB3E0EE)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "พร้อมแบ่งปันความทรงจำแล้วหรือยัง?",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "สร้างภาพสวยๆ เพื่อแชร์ลงโซเชียลมีเดียได้เลย!",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 6. Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => PrintSheet(
                          items: widget.items,
                          monthName: widget.monthName,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                      elevation: 0,
                    ),
                    child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                    ),
                    child: const Text('ย้อนกลับ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 255, 255, 255),
          activeTrackColor: const Color(0xFFED7D31),
        ),
      ],
    );
  }
}

// ✅ แยก Widget แสดงผลอัลบั้มออกมาเป็น const เพื่อป้องกันการ Rebuild
class _AlbumPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;

  const _AlbumPreviewSection({
    required this.items,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF555555), // สีเทาเข้ม
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หน้าซ้าย
                  _buildPageContainer(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Slot 0: ชื่อเดือน
                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Center(
                            child: Text(
                              monthName,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Slot 1-5: รูปภาพ
                        for (int i = 0; i < 5; i++)
                          if (i < items.length)
                            _StaticPhotoSlot(item: items[i]) // ✅ ใช้ Widget ที่โหลดรูปแล้ว
                          else
                            const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // หน้าขวา
                  _buildPageContainer(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 1.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Slots 6-11: รูปภาพ
                        for (int i = 0; i < 6; i++)
                          if ((i + 5) < items.length)
                            _StaticPhotoSlot(item: items[i + 5])
                          else
                            const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }
}

// ✅ ปรับ _StaticPhotoSlot ให้เป็น Stateful เพื่อโหลดรูปครั้งเดียว
class _StaticPhotoSlot extends StatefulWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

  @override
  State<_StaticPhotoSlot> createState() => _StaticPhotoSlotState();
}

class _StaticPhotoSlotState extends State<_StaticPhotoSlot> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    // ถ้ามีรูปแคป ให้ใช้เลย
    if (widget.item.capturedImage != null) {
      if (mounted) {
        setState(() {
          _imageData = widget.item.capturedImage;
        });
      }
    } else {
      // ถ้าไม่มี ให้โหลด Thumbnail
      final data = await widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300));
      if (mounted) {
        setState(() {
          _imageData = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_imageData != null)
                Image.memory(_imageData!, fit: BoxFit.cover)
              else
                Container(color: Colors.grey[200]), // Loading state
            ],
          ),
        ),
      ),
    );
  }
}

// ... _StepItem (เหมือนเดิม ไม่ต้องแก้) ...
class _StepItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;

  const _StepItem({
    required this.label,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF5AB6D8); 
    const inactiveColor = Colors.grey;

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
                      : (isActive ? activeColor : Colors.grey[300]),
                ),
              ),
              Container(
                width: 10, 
                height: 10, 
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  color: isActive ? activeColor : Colors.grey[300],
                ),
              ),
              Expanded(
                child: Container(
                  height: 2, 
                  color: isLast 
                      ? Colors.transparent 
                      : (isCompleted ? activeColor : Colors.grey[300]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label, 
            textAlign: TextAlign.center, 
            style: TextStyle(
              fontSize: 10, 
              color: isActive ? activeColor : Colors.grey[400], 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}