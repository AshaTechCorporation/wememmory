import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

class VideoDetailSheet extends StatelessWidget {
  final MediaItem item;

  const VideoDetailSheet({super.key, required this.item});

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
          // 1. Header
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
                    // แสดงลำดับภาพ (ตัวอย่าง)
                    const Text(
                      "รายละเอียดรูปภาพ (2/11)", 
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

          // 2. Steps Indicator
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

          // 3. Video Player Area (UI Mockup)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // กรอบวิดีโอ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 350,
                      width: double.infinity,
                      color: Colors.black, // พื้นหลังวิดีโอเป็นสีดำ
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Thumbnail (แสดงแทนวิดีโอจริงก่อน)
                          FutureBuilder<Uint8List?>(
                            future: item.asset.thumbnailDataWithSize(const ThumbnailSize(800, 800)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                return Opacity(
                                  opacity: 0.7,
                                  child: Image.memory(snapshot.data!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                );
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                          // เส้นตาราง Grid Overlay
                          _buildGridOverlay(),
                          
                          // ปุ่ม Play ตรงกลาง (UI Mockup)
                          // (ของจริงต้องแทนที่ด้วย VideoPlayerController)
                        ],
                      ),
                    ),
                  ),

                  // Timeline & Controls
                  const SizedBox(height: 10),
                  
                  // Progress Bar (Mockup)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1:25", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text("3:15", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: 0.4, 
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFED7D31)),
                  ),

                  const SizedBox(height: 20),

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 36, color: Colors.black54),
                        onPressed: () {},
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFED7D31),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.pause, color: Colors.white, size: 32),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 36, color: Colors.black54),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 4. Action Buttons (Capture & Save)
                  
                  // ปุ่มแคปหน้าจอ
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Logic แคปหน้าจอ
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF67A5BA), // สีฟ้าตามภาพ
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        elevation: 0,
                      ),
                      child: const Text("แคปหน้าจอ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // ปุ่มบันทึก & ถัดไป
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED7D31), // สีส้ม
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        elevation: 0,
                      ),
                      child: const Text("บันทึก & ถัดไป", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // สร้างเส้นตาราง 3x3 บนวิดีโอ
  Widget _buildGridOverlay() {
    return Column(
      children: [
        Expanded(child: Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1))))),
        Expanded(child: Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1))))),
        Expanded(child: Container()),
      ],
    );
  }
}

// Widget Step Indicator (Copy มาใช้เพื่อให้เหมือนกัน)
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