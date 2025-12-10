import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:wememmory/models/media_item.dart';

class VideoDetailSheet extends StatefulWidget {
  final MediaItem item;

  const VideoDetailSheet({super.key, required this.item});

  @override
  State<VideoDetailSheet> createState() => _VideoDetailSheetState();
}

class _VideoDetailSheetState extends State<VideoDetailSheet> {
  VideoPlayerController? _controller;
  final GlobalKey _globalKey = GlobalKey();
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final File? file = await widget.item.asset.file;
    if (file != null) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          // เพิ่ม Listener เพื่ออัปเดต UI ตามเวลาวิดีโอ
          _controller!.addListener(() {
            if (mounted) setState(() {});
          });
          setState(() {
            _isInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  // ฟังก์ชันแปลงเวลา Duration เป็น String (เช่น 01:25)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _captureFrame() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        setState(() {
          widget.item.capturedImage = pngBytes;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("บันทึกภาพหน้าจอเรียบร้อย"), duration: Duration(seconds: 1)),
          );
        }
      }
    } catch (e) {
      debugPrint("Error capturing frame: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // คำนวณเวลาปัจจุบันและเวลาทั้งหมด
    final duration = _controller?.value.duration ?? Duration.zero;
    final position = _controller?.value.position ?? Duration.zero;

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

          // 3. Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // --- ส่วนแสดงวิดีโอ (สี่เหลี่ยมจัตุรัส) ---
                  RepaintBoundary(
                    key: _globalKey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        // กำหนดความสูงให้เป็นสี่เหลี่ยม (เช่น 350x350 หรือ AspectRatio 1:1)
                        height: 350, 
                        width: double.infinity,
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_isInitialized && _controller != null)
                              AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio, // หรือใช้ 1.0 ถ้าต้องการบังคับ crop
                                child: VideoPlayer(_controller!),
                              )
                            else
                              // Thumbnail ระหว่างรอ
                              FutureBuilder<Uint8List?>(
                                future: widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(800, 800)),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Image.memory(snapshot.data!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
                                  }
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            
                            // Grid Overlay (เส้นขาว)
                            _buildGridOverlay(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- ส่วน Timeline (เวลาซ้าย-ขวา & Progress Bar) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(position), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text(_formatDuration(duration), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar สีส้ม
                  if (_isInitialized && _controller != null)
                    VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFFED7D31), // สีส้ม
                        bufferedColor: Color(0xFFEEEEEE),
                        backgroundColor: Color(0xFFE0E0E0),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // --- ส่วนปุ่มควบคุม (Previous, Play/Pause, Next) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 36, color: Colors.black54),
                        onPressed: () {
                          // Logic ย้อนกลับ (ถ้าต้องการ)
                        },
                      ),
                      const SizedBox(width: 30),
                      
                      // ปุ่ม Play/Pause วงกลมสีส้ม
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 64, 
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFED7D31), // สีส้ม
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Icon(
                            _controller != null && _controller!.value.isPlaying 
                                ? Icons.pause 
                                : Icons.play_arrow_rounded, // ใช้ play_arrow_rounded ให้ดูนมนวลขึ้น
                            color: Colors.white, 
                            size: 40,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 36, color: Colors.black54),
                        onPressed: () {
                          // Logic ถัดไป (ถ้าต้องการ)
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- ปุ่ม Action (แคปหน้าจอ & บันทึก) ---
                  
                  // ปุ่มแคปหน้าจอ (สีฟ้าอมเทา)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isInitialized ? _captureFrame : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF67A5BA), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                        elevation: 0,
                      ),
                      child: const Text("แคปหน้าจอ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // ปุ่มบันทึก & ถัดไป (สีส้ม)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_controller != null) _controller!.pause();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED7D31), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
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

  // เส้น Grid สีขาวทับวิดีโอ
  Widget _buildGridOverlay() {
    return Stack(
      fit: StackFit.expand, // ให้ Grid ขยายเต็มพื้นที่
      children: [
        // เส้นแนวนอน (Column)
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 1)),
                ),
              ),
            ),
            Expanded(child: Container()), // ช่องล่างสุดไม่มีเส้นขอบล่าง
          ],
        ),
        // เส้นแนวตั้ง (Row)
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white.withOpacity(0.5), width: 1)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white.withOpacity(0.5), width: 1)),
                ),
              ),
            ),
            Expanded(child: Container()), // ช่องขวาสุดไม่มีเส้นขอบขวา
          ],
        ),
      ],
    );
  }
}

// Widget Step Item (ตัวบอกขั้นตอน)
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