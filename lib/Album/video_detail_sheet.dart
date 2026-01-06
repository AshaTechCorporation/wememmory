import 'dart:async'; // ✅ อย่าลืม import ตัวนี้เพิ่มครับ
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
// ตรวจสอบ path import ให้ถูกต้อง
import 'package:wememmory/models/media_item.dart';

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
  bool _canScroll = true;
  bool _isFilled = false;

  // --- ตัวแปรสำหรับควบคุม Slider ---
  bool _isDragging = false;
  double _dragValue = 0.0;
  bool _wasPlayingBeforeDrag = false; 

  Uint8List? _tempCapturedImage;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    if (widget.item.capturedImage != null) {
      _tempCapturedImage = widget.item.capturedImage;
    }
    _loadThumbnail();
    _initializeVideo();
  }

  Future<void> _loadThumbnail() async {
    final bytes = await widget.item.asset.thumbnailDataWithSize(
      const ThumbnailSize(1080, 1920),
    );
    if (mounted) {
      setState(() {
        _thumbnailBytes = bytes;
      });
    }
  }

  Future<void> _initializeVideo() async {
    final File? file = await widget.item.asset.file;
    if (file != null) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          _controller!.addListener(() {
            if (mounted) {
              // ✅ Logic สำคัญ: ถ้าลากอยู่ "ห้าม" อัปเดต Slider ตามวิดีโอเด็ดขาด
              if (!_isDragging) {
                setState(() {
                  if (_controller != null) {
                    _isPlaying = _controller!.value.isPlaying;
                  }
                });
              }
            }
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

  void _toggleFitMode() {
    setState(() {
      _isFilled = !_isFilled;
      _transformationController.value = Matrix4.identity();
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
    final double maxDuration = duration.inMilliseconds.toDouble();

    // คำนวณค่า Slider: ถ้ากำลังลากให้ใช้ค่าที่นิ้วลาก (_dragValue)
    final double sliderValue = _isDragging
        ? _dragValue
        : position.inMilliseconds.toDouble().clamp(0.0, maxDuration);

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

          // Header
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

          // Steps
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

          // Content Area
          Expanded(
            child: SingleChildScrollView(
              physics:
                  _canScroll
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // --- Video Stack ---
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      RepaintBoundary(
                        key: _captureKey,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 350,
                            width: double.infinity,
                            color: Colors.black,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Listener(
                                  onPointerDown: (_) =>
                                      setState(() => _canScroll = false),
                                  onPointerUp: (_) =>
                                      setState(() => _canScroll = true),
                                  onPointerCancel: (_) =>
                                      setState(() => _canScroll = true),
                                  onPointerSignal: _onPointerSignal,
                                  child: InteractiveViewer(
                                    transformationController:
                                        _transformationController,
                                    minScale: 1.0,
                                    maxScale: 4.0,
                                    boundaryMargin: EdgeInsets.zero,
                                    panEnabled: true,
                                    scaleEnabled: true,
                                    child: _buildVideoContent(constraints),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: IgnorePointer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildGridOverlay(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // --- Timeline (Slider) ---
                  if (_tempCapturedImage == null) ...[
                    if (_isInitialized &&
                        _controller != null &&
                        maxDuration > 0)
                      SizedBox(
                        height: 20,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4.0,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 12.0),
                            activeTrackColor: const Color(0xFFED7D31),
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: const Color(0xFFED7D31),
                          ),
                          child: Slider(
                            value: sliderValue,
                            min: 0.0,
                            max: maxDuration,
                            
                            onChangeStart: (value) {
                              _wasPlayingBeforeDrag = _controller!.value.isPlaying;
                              if (_wasPlayingBeforeDrag) {
                                _controller!.pause();
                              }
                              setState(() {
                                _isDragging = true;
                                _dragValue = value;
                              });
                            },

                            onChanged: (value) {
                              setState(() {
                                _dragValue = value;
                              });
                              // สั่ง Seek แบบไม่ต้อง await (Real-time scrubbing)
                              _controller!
                                  .seekTo(Duration(milliseconds: value.toInt()));
                            },

                            // ✅ แก้ไข: เพิ่ม Delay เพื่อรอให้ Video Player ย้ายตำแหน่งเสร็จจริง ๆ
                            // ป้องกัน Slider ดีดกลับไปที่ 0 หรือจุดเริ่มต้น
                            onChangeEnd: (value) async {
                              final targetPosition = Duration(milliseconds: value.toInt());
                              
                              // 1. สั่งย้ายตำแหน่ง
                              await _controller!.seekTo(targetPosition);
                              
                              // 2. ถ้าเดิมเล่นอยู่ ก็สั่งเล่นต่อ
                              if (_wasPlayingBeforeDrag) {
                                await _controller!.play();
                                if(mounted) {
                                  setState(() { _isPlaying = true; });
                                }
                              }
                              
                              // 3. (สำคัญ) รอ 500ms ก่อนจะปลดล็อค Slider
                              // เพื่อให้ Controller อัปเดต position ให้ทันกับที่เราลาก
                              Future.delayed(const Duration(milliseconds: 500), () {
                                if (mounted) {
                                  setState(() {
                                    _isDragging = false;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Row(
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

                  // --- Control Buttons ---
                  if (_tempCapturedImage == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dummy Left
                        Opacity(
                          opacity: 0.0,
                          child: IconButton(
                            icon: const Icon(Icons.zoom_in_map, size: 28),
                            onPressed: null,
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Previous
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 36,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            final newPos =
                                position - const Duration(seconds: 5);
                            _controller!.seekTo(newPos);
                          },
                        ),

                        const SizedBox(width: 30),

                        // Play/Pause
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
                              _isPlaying 
                                  ? Icons.pause
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),

                        const SizedBox(width: 30),

                        // Next
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            size: 36,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            final newPos =
                                position + const Duration(seconds: 5);
                            _controller!.seekTo(newPos);
                          },
                        ),

                        const SizedBox(width: 15),

                        // Fit Icon
                        IconButton(
                          onPressed: _toggleFitMode,
                          tooltip:
                              _isFilled ? 'แสดงขนาดต้นฉบับ' : 'แสดงเต็มเฟรม',
                          icon: Icon(
                            _isFilled
                                ? Icons.zoom_in_map
                                : Icons.zoom_out_map,
                            size: 28,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),

                  // --- Action Buttons ---
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

  Widget _buildVideoContent(BoxConstraints constraints) {
    if (_tempCapturedImage != null) {
      return Image.memory(
        _tempCapturedImage!,
        fit: _isFilled ? BoxFit.cover : BoxFit.contain,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );
    }

    final double viewWidth = constraints.maxWidth;
    final double viewHeight = constraints.maxHeight;

    final double videoAspect =
        _controller != null && _controller!.value.isInitialized
            ? _controller!.value.aspectRatio
            : 16 / 9;

    final double viewAspect = viewWidth / viewHeight;

    Widget videoWidget;
    if (_isInitialized && _controller != null) {
      if (_isFilled) {
        double renderWidth;
        double renderHeight;

        if (videoAspect > viewAspect) {
          renderHeight = viewHeight;
          renderWidth = viewHeight * videoAspect;
        } else {
          renderWidth = viewWidth;
          renderHeight = viewWidth / videoAspect;
        }

        videoWidget = Center(
          child: SizedBox(
            width: renderWidth,
            height: renderHeight,
            child: VideoPlayer(_controller!),
          ),
        );
      } else {
        videoWidget = SizedBox(
          width: viewWidth,
          height: viewHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        );
      }
    } else {
      videoWidget = Container(color: Colors.black);
    }

    Widget? thumbnailWidget;
    if (_thumbnailBytes != null && !_isInitialized) {
      thumbnailWidget = Container(
        color: Colors.black,
        width: viewWidth,
        height: viewHeight,
        child: Image.memory(
          _thumbnailBytes!,
          fit: _isFilled ? BoxFit.cover : BoxFit.contain,
          width: viewWidth,
          height: viewHeight,
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        videoWidget,
        if (thumbnailWidget != null) thumbnailWidget,
        if (!_isInitialized && _thumbnailBytes == null)
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      ],
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