import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';
// 📌 Import หน้า Sheet ทั้งหมด
import 'package:wememmory/Album/photo_detail_sheet.dart'; 
import 'package:wememmory/Album/video_detail_sheet.dart';
import 'package:wememmory/Album/final_preview_sheet.dart'; // 👈 Import หน้า Final Preview

// --- Data Model สำหรับการลากย้าย ---
class PhotoDragData {
  final int index;
  PhotoDragData(this.index);
}

class AlbumLayoutPage extends StatefulWidget {
  final List<MediaItem> selectedItems;
  final String monthName;

  const AlbumLayoutPage({
    super.key,
    required this.selectedItems,
    required this.monthName,
  });

  @override
  State<AlbumLayoutPage> createState() => _AlbumLayoutPageState();
}

class _AlbumLayoutPageState extends State<AlbumLayoutPage> {
  late List<MediaItem> _items;
  bool _isDragging = false;

  // กำหนดค่าความโค้ง
  final double _imageRadius = 6.0; 
  final double _frameRadius = 0.0; 

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.selectedItems);
  }

  void _handlePhotoDrop(PhotoDragData source, int targetIndex) {
    if (source.index == targetIndex) return;
    setState(() {
      final temp = _items[source.index];
      _items[source.index] = _items[targetIndex];
      _items[targetIndex] = temp;
    });
  }

  // ✅ ฟังก์ชันตรวจสอบและเปิด Sheet ตามประเภทไฟล์ (Photo/Video Detail)
  Future<void> _handlePhotoTap(int index) async {
    final selectedItem = _items[index];
    
    // ตรวจสอบประเภทไฟล์
    if (selectedItem.type == MediaType.video) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => VideoDetailSheet(item: selectedItem),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PhotoDetailSheet(item: selectedItem),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String monthTitle = widget.monthName.split(' ')[0];

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$monthTitle : อัลบั้ม (0 แก้ไข)',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Steps Indicator
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

          const SizedBox(height: 20),

          // Hint Text
          const Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey),
              children: [
                TextSpan(
                  text: "แตะ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 121, 121, 121)),
                ),
                TextSpan(text: "เพื่อแก้ไข • "),
                TextSpan(
                  text: "ลาก",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 121, 121, 121)),
                ),
                TextSpan(text: "เพื่อจัดลำดับ"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Album Layout Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Wrapper พื้นหลังสีเทาเข้ม
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF555555), // สีเทาเข้ม
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
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            monthTitle,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Slot 1-5: รูปภาพ
                                      for (int i = 0; i < 5; i++)
                                        if (i < _items.length)
                                          _ReorderableSlot(
                                            item: _items[i],
                                            index: i,
                                            onDrop: _handlePhotoDrop,
                                            onTap: () => _handlePhotoTap(i),
                                            onDragStart: () => setState(() => _isDragging = true),
                                            onDragEnd: () => setState(() => _isDragging = false),
                                            imageRadius: _imageRadius,
                                            frameRadius: _frameRadius,
                                          )
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
                                        if ((i + 5) < _items.length)
                                          _ReorderableSlot(
                                            item: _items[i + 5],
                                            index: i + 5,
                                            onDrop: _handlePhotoDrop,
                                            onTap: () => _handlePhotoTap(i + 5),
                                            onDragStart: () => setState(() => _isDragging = true),
                                            onDragEnd: () => setState(() => _isDragging = false),
                                            imageRadius: _imageRadius,
                                            frameRadius: _frameRadius,
                                          )
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
                  ),

                  // ข้อความเชิญชวนด้านล่าง
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 24, 30, 10),
                    child: Text(
                      "นี่คืออัลบั้มรูปของคุณในเดือน$monthTitle พร้อมจะเปลี่ยนช่วงเวลาเหล่านี้ให้\nเป็นความทรงจำสุดพิเศษแล้วหรือยัง?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 61, 61, 61),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Buttons
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
                      // ✅ แก้ไข: เมื่อกดปุ่มบันทึก ให้ไปหน้า FinalPreviewSheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FinalPreviewSheet(
                          items: _items,
                          monthName: monthTitle,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                      elevation: 0,
                    ),
                    child: const Text('บันทึก', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(
      width: 160,
      height: 245,
      child: child,
    );
  }
}

// ... (ReorderableSlot, PhotoSlot, StepItem เหมือนเดิม ไม่ต้องแก้) ...
class _ReorderableSlot extends StatelessWidget {
  final MediaItem item;
  final int index;
  final Function(PhotoDragData, int) onDrop;
  final VoidCallback onTap;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final double imageRadius;
  final double frameRadius;

  const _ReorderableSlot({
    required this.item,
    required this.index,
    required this.onDrop,
    required this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
    required this.imageRadius,
    required this.frameRadius,
  });

  @override
  Widget build(BuildContext context) {
    final photoWidget = _PhotoSlot(item: item, frameRadius: frameRadius, imageRadius: imageRadius);

    return DragTarget<PhotoDragData>(
      onWillAcceptWithDetails: (details) => details.data.index != index,
      onAcceptWithDetails: (details) => onDrop(details.data, index),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(frameRadius),
            border: isHovered ? Border.all(color: const Color(0xFF5AB6D8), width: 3) : null,
          ),
          child: LongPressDraggable<PhotoDragData>(
            data: PhotoDragData(index),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 75,
                height: 75,
                child: Opacity(opacity: 0.9, child: photoWidget),
              ),
            ),
            childWhenDragging: Opacity(opacity: 0.3, child: photoWidget),
            onDragStarted: onDragStart,
            onDragEnd: (_) => onDragEnd(),
            child: GestureDetector(
              onTap: onTap,
              child: photoWidget,
            ),
          ),
        );
      },
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  final MediaItem item;
  final double frameRadius;
  final double imageRadius;

  const _PhotoSlot({
    required this.item, 
    required this.frameRadius, 
    required this.imageRadius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        // borderRadius: BorderRadius.circular(frameRadius), 
      ),
      padding: const EdgeInsets.all(4.0), 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(imageRadius), 
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder<Uint8List?>(
                future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  }
                  return Container(color: Colors.grey[200]);
                },
              ),
              if (item.type == MediaType.video)
                const Center(child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 24)),
            ],
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
              Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300])),
              Expanded(child: Container(height: 2, color: isLast ? Colors.transparent : Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400], fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}