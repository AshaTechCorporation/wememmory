import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart'; // จำเป็นสำหรับ ThumbnailSize
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/models/media_item.dart';

// ✅ ใช้ StatefulWidget เพื่อจัดการ Animation
class OrderSuccessPage extends StatefulWidget {
  final List<MediaItem> items;
  final String monthName;

  const OrderSuccessPage({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  // ตัวแปรเช็คว่าแสดง Animation เสร็จหรือยัง (ถ้าเสร็จแล้วจะซ่อนไปเลย)
  bool _showSuccessPopup = true;

  @override
  void initState() {
    super.initState();
    
    // ตั้งค่า Controller (ความเร็วในการเด้งขึ้น)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), 
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // เริ่มเล่น Animation
    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      // 1. เด้งขึ้นมา
      await _controller.forward();
      
      // 2. ค้างไว้ 3 วินาที (เพิ่มเวลาให้อ่านทัน)
      await Future.delayed(const Duration(seconds: 3));
      
      if (!mounted) return;

      // 3. จางหายไป (เล่นถอยหลัง)
      await _controller.reverse();
      
      if (!mounted) return;
      
      // 4. ซ่อน Widget ออกไปเลยเมื่อเสร็จ
      setState(() {
        _showSuccessPopup = false;
      });
    } catch (e) {
      // กัน Error กรณีปิดหน้าไปก่อน Animation จบ
      debugPrint("Animation interrupted: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shareAndGoHome(BuildContext context) {
    print("Sharing content...");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => FirstPage(
          initialIndex: 1,
          newAlbumItems: widget.items,
          newAlbumMonth: widget.monthName,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.white,
        child: Stack(
          children: [
            // --- 1. เนื้อหาหลัก (Background) ---
            Column(
              children: [
                const SizedBox(height: 12),
                // --- Handle Bar ---
                Center(
                  child: Container(
                    width: 61,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                
                // --- Header ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 13, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'สั่งพิมพ์',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context), 
                        child: Image.asset(
                          'assets/icons/cross.png', 
                          width: 25, height: 25, fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.close, color: Colors.black54),
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Divider(height: 1, color: Colors.grey.withOpacity(0.2), indent: 20, endIndent: 20),

                // --- Content Scrollable ---
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FullAlbumPreview(items: widget.items, monthName: widget.monthName),

                          const SizedBox(height: 24),
                          
                          const Text(
                            'ได้รับออเดอร์คุณแล้ว',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _shareAndGoHome(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFED7D31),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                elevation: 0,
                              ),
                              child: const Text('แชร์', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'ได้รับเพิ่ม 3 คะแนนเมื่อแชร์รูป',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- 2. Popup Animation Overlay (ลอยทับอยู่ข้างหน้า) ---
            if (_showSuccessPopup)
              Positioned.fill(
                child: Container(
                  color: const Color.fromARGB(255, 188, 188, 188).withOpacity(0.6), // พื้นหลังจางๆ
                  alignment: Alignment.center,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ไอคอน Success
                          Image.asset(
                            'assets/icons/Success.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.celebration, size: 100, color: Colors.orange),
                          ),
                          const SizedBox(height: 10),
                          
                          // แต้ม Point
                          const Text(
                            '3 Point',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 0, 0, 0),
                              // shadows: [
                              //   Shadow(blurRadius: 10, color: Colors.black45, offset: Offset(0, 2))
                              // ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),

                          // ✅ แก้ไขตรงนี้: เอา Container สีส้มออก เหลือแค่ข้อความ
                          Column(
                            children: [
                              _buildWhiteTextItem('+ ความสม่ำเสมอของการสร้างอัลบั้มในแต่ละปี'),
                              const SizedBox(height: 8),
                              _buildWhiteTextItem('+ สร้างอัลบั้มรูปครบ 11 รูป'),
                              const SizedBox(height: 8),
                              _buildWhiteTextItem('+ สร้างอัลบั้มรูปตรงตามเวลาที่กำหนด'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget ช่วยสร้างข้อความสีขาวในกล่องส้ม
  Widget _buildWhiteTextItem(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white, 
        fontSize: 14,
        fontWeight: FontWeight.w500
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper Widgets (เหมือนเดิม ไม่ต้องแก้)
// ---------------------------------------------------------------------------

class _FullAlbumPreview extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;
  const _FullAlbumPreview({required this.items, required this.monthName});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color(0xFF555555)),
          child: IntrinsicWidth(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageContainer(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Text(
                            monthName.split(' ')[0],
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)
                          )
                        )
                      ),
                      for (int i = 0; i < 5; i++)
                        if (i < items.length)
                          _SimplePhotoSlot(item: items[i])
                        else
                          const SizedBox()
                    ]
                  )
                ),
                const SizedBox(width: 20),
                _buildPageContainer(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < 6; i++)
                        if ((i + 5) < items.length)
                          _SimplePhotoSlot(item: items[i + 5])
                        else
                          const SizedBox()
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
  
  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }
}

class _SimplePhotoSlot extends StatefulWidget {
    final MediaItem item;
    const _SimplePhotoSlot({required this.item});
    @override
    State<_SimplePhotoSlot> createState() => _SimplePhotoSlotState();
}

class _SimplePhotoSlotState extends State<_SimplePhotoSlot> {
    Uint8List? _imageData;
    @override
    void initState() { super.initState(); _loadImage(); }
    
    Future<void> _loadImage() async {
        if (widget.item.capturedImage != null) { 
          if (mounted) setState(() => _imageData = widget.item.capturedImage); 
        } else { 
          final data = await widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)); 
          if (mounted) setState(() => _imageData = data); 
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
                child: _imageData != null 
                  ? Image.memory(_imageData!, fit: BoxFit.cover) 
                  : null,
              ),
            )
        );
    }
}