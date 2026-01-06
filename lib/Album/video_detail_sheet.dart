import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:wememmory/models/media_item.dart';

// หน้า รายละเอียดวิดีโอ
class VideoDetailSheet extends StatefulWidget {
  final MediaItem item;

  const VideoDetailSheet({super.key, required this.item});

  @override
  State<VideoDetailSheet> createState() => _VideoDetailSheetState();
}

class _VideoDetailSheetState extends State<VideoDetailSheet> {
  VideoPlayerController? _controller;

  final GlobalKey _captureKey = GlobalKey();
  final TransformationController _transformationController =
      TransformationController();

  bool _isPlaying = false;
  bool _isInitialized = false;

  // ✅ เพิ่มตัวแปรสำหรับล็อกการเลื่อนหน้าจอ
  bool _canScroll = true;

  Uint8List? _tempCapturedImage;

  @override
  void initState() {
    super.initState();
    if (widget.item.capturedImage != null) {
      _tempCapturedImage = widget.item.capturedImage;
    }
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final File? file = await widget.item.asset.file;
    if (file != null) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
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
    _transformationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_tempCapturedImage != null) {
      setState(() {
        _tempCapturedImage = null;
      });
    }

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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final double scaleChange = event.scrollDelta.dy < 0 ? 1.1 : 0.9;
      final Matrix4 matrix = _transformationController.value.clone();
      matrix.scale(scaleChange);
      final currentScale = matrix.entry(0, 0);
      if (currentScale >= 1.0 && currentScale <= 4.0) {
        setState(() {
          _transformationController.value = matrix;
        });
      }
    }
  }

  Future<void> _captureFrame() async {
    if (_controller != null && _controller!.value.isPlaying) {
      await _controller!.pause();
      setState(() => _isPlaying = false);
    }

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary boundary =
          _captureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        setState(() {
          _tempCapturedImage = pngBytes;
          _transformationController.value = Matrix4.identity();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("บันทึกภาพหน้าจอเรียบร้อย"),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error capturing frame: $e");
    }
  }

  void _saveAndClose() {
    if (_tempCapturedImage != null) {
      widget.item.capturedImage = _tempCapturedImage;
    }

    if (_controller != null) _controller!.pause();

    Navigator.pop(context);
  }

  void _undoCapture() {
    setState(() {
      _tempCapturedImage = null;
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/icons/cross.png',
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
                _StepItem(
                  label: 'เลือกรูปภาพ',
                  isActive: true,
                  isFirst: true,
                  isCompleted: true,
                ),
                _StepItem(
                  label: 'แก้ไขและจัดเรียง',
                  isActive: true,
                  isCompleted: false,
                ),
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
              // ✅ แก้ไข 1: ควบคุม Physics ให้ล็อกได้
              physics:
                  _canScroll
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // --- ส่วนแสดงวิดีโอ (Interactive & Capture) ---

                  // ✅ แก้ไข 2: ใช้ Stack ซ้อน Grid ไว้นอก RepaintBoundary
                  // เพื่อให้ Grid ไม่ติดไปตอนแคปภาพ
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // ส่วนที่จะถูกบันทึกภาพ (วิดีโอ/ภาพแคป)
                      RepaintBoundary(
                        key: _captureKey,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 350,
                            width: double.infinity,
                            color: Colors.black,
                            child: Listener(
                              // ✅ แก้ไข 3: ใช้ Listener ครอบเพื่อดักจับการสัมผัส
                              onPointerDown:
                                  (_) => setState(() => _canScroll = false),
                              onPointerUp:
                                  (_) => setState(() => _canScroll = true),
                              onPointerCancel:
                                  (_) => setState(() => _canScroll = true),
                              onPointerSignal: _onPointerSignal,
                              child: InteractiveViewer(
                                transformationController:
                                    _transformationController,
                                minScale: 1.0,
                                maxScale: 4.0,
                                boundaryMargin: const EdgeInsets.all(
                                  double.infinity,
                                ), // ✅ ลากได้ลื่นขึ้น
                                panEnabled: true,
                                scaleEnabled: true,
                                trackpadScrollCausesScale: true,
                                child:
                                    _tempCapturedImage != null
                                        ? Image.memory(
                                          _tempCapturedImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                        : (_isInitialized &&
                                            _controller != null)
                                        ? AspectRatio(
                                          aspectRatio:
                                              _controller!.value.aspectRatio,
                                          child: VideoPlayer(_controller!),
                                        )
                                        : FutureBuilder<Uint8List?>(
                                          future: widget.item.asset
                                              .thumbnailDataWithSize(
                                                const ThumbnailSize(800, 800),
                                              ),
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              return Image.memory(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              );
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ✅ ย้าย Grid มาอยู่นอก RepaintBoundary
                      // แต่ยังอยู่ใน Stack เดียวกัน และครอบด้วย IgnorePointer
                      Positioned.fill(
                        child: IgnorePointer(
                          child: ClipRRect(
                            // Clip ให้ Grid โค้งตามรูป
                            borderRadius: BorderRadius.circular(12),
                            child: _buildGridOverlay(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // --- ส่วน Timeline ---
                  if (_tempCapturedImage == null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isInitialized && _controller != null)
                      VideoProgressIndicator(
                        _controller!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFFED7D31),
                          bufferedColor: Color(0xFFEEEEEE),
                          backgroundColor: Color(0xFFE0E0E0),
                        ),
                      ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "นี่คือภาพที่คุณเลือกจากวิดีโอ",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // --- ส่วนปุ่มควบคุม (Play/Pause) ---
                  if (_tempCapturedImage == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 36,
                            color: Colors.black54,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 30),

                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFED7D31),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _controller != null &&
                                      _controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),

                        const SizedBox(width: 30),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            size: 36,
                            color: Colors.black54,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),

                  // --- ปุ่ม Action ---
                  if (_tempCapturedImage == null)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isInitialized ? _captureFrame : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF67A5BA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "แคปหน้าจอ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _undoCapture,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFED7D31)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        child: const Text(
                          "ยกเลิกภาพนี้",
                          style: TextStyle(
                            color: Color(0xFFED7D31),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveAndClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED7D31),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "บันทึก & ถัดไป",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildGridOverlay() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ],
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
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color:
                      isFirst
                          ? Colors.transparent
                          : (isActive
                              ? const Color(0xFF5AB6D8)
                              : Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 40),
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color:
                      isLast
                          ? Colors.transparent
                          : (isCompleted
                              ? const Color(0xFF5AB6D8)
                              : Colors.grey[300]),
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
