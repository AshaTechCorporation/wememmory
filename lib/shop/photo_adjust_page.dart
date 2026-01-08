import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class PhotoAdjustPage extends StatefulWidget {
  final File imageFile;

  const PhotoAdjustPage({super.key, required this.imageFile});

  @override
  State<PhotoAdjustPage> createState() => _PhotoAdjustPageState();
}

class _PhotoAdjustPageState extends State<PhotoAdjustPage> {
  final GlobalKey _globalKey = GlobalKey(); // Key สำหรับจับภาพ
  final TransformationController _transformationController = TransformationController();
  bool _isFullFrame = true; // สถานะเริ่มต้นให้เต็มเฟรม

  // ฟังก์ชันสลับโหมดขยายเต็มจอ
  void _toggleFullFrame() {
    setState(() {
      _isFullFrame = !_isFullFrame;
      _transformationController.value = Matrix4.identity();
    });
  }

  // ฟังก์ชันบันทึกภาพที่ซูมแล้ว
  Future<void> _saveAndReturn() async {
    try {
      // 1. จับภาพจาก RepaintBoundary (ซึ่งครอบแค่ InteractiveViewer ไม่รวม Grid)
      RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/cropped_cover_${DateTime.now().millisecondsSinceEpoch}.png').create();
        await file.writeAsBytes(pngBytes);

        if (mounted) {
          Navigator.pop(context, file);
        }
      }
    } catch (e) {
      debugPrint("Error saving image: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกภาพ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('รูปภาพหน้าปกอัลบั้ม', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Kanit')),
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เผื่อหน้าจอเล็ก
        child: Column(
          children: [
            // 1. เว้นระยะจาก AppBar ลงมานิดหน่อย
            const SizedBox(height: 20),

            // 2. พื้นที่แสดงรูปภาพ (เอา Expanded/Center ออก เพื่อให้ชิดด้านบน)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Layer 1: รูปภาพ + Zoom
                        RepaintBoundary(
                          key: _globalKey,
                          child: InteractiveViewer(
                            transformationController: _transformationController,
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Image.file(widget.imageFile, fit: _isFullFrame ? BoxFit.cover : BoxFit.contain),
                          ),
                        ),
                        // Layer 2: เส้น Grid (IgnorePointer เพื่อให้ทะลุไปซูมรูปได้)
                        IgnorePointer(child: CustomPaint(painter: _GridPainter(), child: Container())),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. เว้นระยะห่างระหว่างภาพกับปุ่ม
            const SizedBox(height: 20),

            // 4. ปุ่มขยายภาพเต็มจอ (อยู่ใต้ภาพ)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _toggleFullFrame,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6BB0C5), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text(_isFullFrame ? 'แสดงภาพทั้งหมด' : 'ขยายภาพเต็มจอ ', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            // เว้นระยะด้านล่างเผื่อไว้เล็กน้อย
            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saveAndReturn,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFED7D31), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), elevation: 0),
              child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
            ),
          ),
        ),
      ),
    );
  }
}

// คลาสสำหรับวาดเส้น Grid จุดตัด 9 ช่อง
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white.withOpacity(0.5) // สีขาวจางๆ
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // เส้นแนวตั้ง
    canvas.drawLine(Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(2 * size.width / 3, 0), Offset(2 * size.width / 3, size.height), paint);

    // เส้นแนวนอน
    canvas.drawLine(Offset(0, size.height / 3), Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, 2 * size.height / 3), Offset(size.width, 2 * size.height / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
