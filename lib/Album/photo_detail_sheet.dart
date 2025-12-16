import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า รายละเอียดรูปภาพ
class PhotoDetailSheet extends StatefulWidget {
  final MediaItem item;

  const PhotoDetailSheet({super.key, required this.item});

  @override
  State<PhotoDetailSheet> createState() => _PhotoDetailSheetState();
}

class _PhotoDetailSheetState extends State<PhotoDetailSheet> {
  late TextEditingController _captionController;
  late List<String> _selectedTags;

  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformationController = TransformationController();
  BoxFit _currentFit = BoxFit.contain;

  final List<String> _allTags = ["family", "kid", "home", "lover", "favor"];
  
  // ✅ เพิ่มตัวแปรเก็บรูปภาพ เพื่อไม่ให้โหลดใหม่ทุกครั้งที่ setState
  Uint8List? _imageData;
  bool _isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.item.caption);
    _selectedTags = List.from(widget.item.tags);
    
    // ✅ โหลดรูปภาพทีเดียวตอนเริ่มต้น
    _loadImage();
  }

  // ✅ ฟังก์ชันโหลดรูปภาพ
  Future<void> _loadImage() async {
    // ถ้ามีรูปที่แคปไว้แล้ว ให้ใช้รูปนั้นเลย
    if (widget.item.capturedImage != null) {
      setState(() {
        _imageData = widget.item.capturedImage;
        _isLoadingImage = false;
      });
    } else {
      // ถ้าไม่มี ให้โหลดจาก Asset (ความละเอียดสูง)
      final data = await widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(1000, 1000));
      if (mounted) {
        setState(() {
          _imageData = data;
          _isLoadingImage = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _toggleImageScale() {
    setState(() {
      if (_currentFit == BoxFit.contain) {
        _currentFit = BoxFit.cover;
      } else {
        _currentFit = BoxFit.contain;
      }
      _transformationController.value = Matrix4.identity();
    });
  }

  Future<void> _saveData() async {
    try {
      RenderRepaintBoundary boundary = _cropKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); 
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        widget.item.capturedImage = byteData.buffer.asUint8List();
        widget.item.caption = _captionController.text;
        widget.item.tags = List.from(_selectedTags);

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint("Error capturing photo: $e");
      widget.item.caption = _captionController.text;
      widget.item.tags = List.from(_selectedTags);
      if (mounted) Navigator.pop(context);
    }
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
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          // 1. Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/icons/cross.png', // อ้างอิง Path ในโปรเจกต์
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Steps Indicator
           const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
            child: Row(
              children: [
                // Step 1: เลือกรูปภาพ
                _StepItem(
                  label: 'เลือกรูปภาพ', 
                  isActive: true,
                  isFirst: true,
                  isCompleted: true,
                ),
                // Step 2: แก้ไขและจัดเรียง
                _StepItem(
                  label: 'แก้ไขและจัดเรียง', 
                  isActive: true,
                  isCompleted: false, // ยังไม่เสร็จ (เส้นขวาจะเป็นสีเทา)
                ),
                // Step 3: พรีวิวสุดท้าย
                _StepItem(
                  label: 'พรีวิวสุดท้าย', 
                  isActive: false,
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RepaintBoundary(
                    key: _cropKey, 
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 350,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // InteractiveViewer
                            InteractiveViewer(
                              transformationController: _transformationController,
                              minScale: 1.0,
                              maxScale: 4.0,
                              // ✅ ใช้ _imageData ที่โหลดมาแล้วแทน FutureBuilder
                              child: _isLoadingImage
                                  ? const Center(child: CircularProgressIndicator())
                                  : _imageData != null
                                      ? Image.memory(
                                          _imageData!,
                                          fit: _currentFit,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : const Center(child: Text("ไม่สามารถโหลดรูปภาพได้")),
                            ),
                            
                            // Grid Overlay
                            IgnorePointer(
                              child: Stack(
                                children: [
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
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ปุ่มขยายภาพ
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _toggleImageScale,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF67A5BA),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentFit == BoxFit.contain ? "ขยายภาพเต็มกรอบ" : "แสดงภาพทั้งหมด",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ช่องกรอกข้อความ
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: _captionController,
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

                  // Tags
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

          // 4. Bottom Button (Save)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 38),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.transparent)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saveData,
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

  Widget _buildTagChip(String label) {
    bool isSelected = _selectedTags.contains(label);
    
    return GestureDetector(
      onTap: () => _toggleTag(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFED7D31) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? const Color(0xFFED7D31) : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
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
  final bool isCompleted;

  const _StepItem({
    super.key,
    required this.label,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              // --- เส้นซ้าย ---
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  // ถ้า Active เส้นซ้ายเป็นสีฟ้า
                  color: isFirst
                      ? Colors.transparent
                      : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]),
                ),
              ),
              
              const SizedBox(width: 40),
              
              // --- จุดวงกลม ---
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300],
                ),
              ),
              
              const SizedBox(width: 40),
              
              // --- เส้นขวา ---
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  // Logic: ถ้าไม่ใช่ตัวสุดท้าย และ isCompleted เป็นจริง ให้เป็นสีฟ้า
                  color: isLast
                      ? Colors.transparent
                      : (isCompleted ? const Color(0xFF5AB6D8) : Colors.grey[300]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}