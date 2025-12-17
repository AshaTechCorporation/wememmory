import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

// --- Imports จากโปรเจกต์ของคุณ ---
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/shop/paymentPage.dart'; 

// =======================================================================
// 1. หน้า AlbumGiftPage (หน้าหลักสินค้า + แสดงรูปปกที่เลือก)
// =======================================================================
class AlbumGiftPage extends StatefulWidget {
  const AlbumGiftPage({super.key});

  @override
  State<AlbumGiftPage> createState() => _AlbumGiftPageState();
}

class _AlbumGiftPageState extends State<AlbumGiftPage> {
  int _quantity = 1;
  int _selectedColorIndex = 0;
  
  // ตัวแปรสำหรับเก็บไฟล์รูปปกที่เลือกกลับมา
  File? _selectedCoverImage;

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'เทา', 'color': const Color(0xFF424242)},
    {'name': 'ส้ม', 'color': const Color(0xFFFF7043)},
    {'name': 'ดำ', 'color': const Color(0xFF000000)},
    {'name': 'น้ำเงิน', 'color': const Color(0xFF26C6DA)},
  ];

  final List<String> _storyImages = [
    'assets/images/exGife.png',
    'assets/images/exGife1.png',
    'assets/images/exGife2.png',
  ];

  final List<String> _storyImagesVertical = [
    'assets/images/family.png',
    'assets/images/Rectangle569.png',
    'assets/images/exProfile.png',
  ];

  // ฟังก์ชันเริ่มกระบวนการเลือกรูป
  Future<void> _startPickImageProcess() async {
    // 1. ขอสิทธิ์เข้าถึงรูปภาพ
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth && !ps.hasAccess) {
      debugPrint("ไม่ได้รับอนุญาตให้เข้าถึงรูปภาพ");
      return;
    }

    // 2. ดึงอัลบั้ม
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isNotEmpty) {
      // 3. ดึงรูป 100 รูปแรก
      final List<AssetEntity> photos = await albums[0].getAssetListRange(start: 0, end: 100);
      
      // 4. แปลงเป็น MediaItem
      final List<MediaItem> myItems = photos.map((asset) {
        return MediaItem(asset: asset, type: MediaType.image);
      }).toList();

      // 5. ไปหน้าเลือกรูป และรอรับค่ากลับมา (await)
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlbumCoverSelectionPage(items: myItems),
          ),
        );

        // 6. ถ้ามีการเลือกรูปกลับมา (result ไม่เป็น null)
        if (result != null && result is MediaItem) {
          File? file = await result.asset.file;
          if (file != null) {
            setState(() {
              _selectedCoverImage = file; // อัปเดตรูปในหน้าจอนี้
            });
          }
        }
      }
    } else {
      debugPrint("ไม่พบรูปภาพในเครื่อง");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'อัลบั้ม',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนแสดงรูปสินค้าด้านบน
            Container(
              width: double.infinity,
              height: 300,
              color: const Color(0xFFBCAAA4),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/Rectangle1.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.photo_album, size: 80, color: Colors.white54),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ตัวเลือกสี
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colorOptions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedColorIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColorIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFF8A3D) : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _colorOptions[index]['color'],
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _colorOptions[index]['name'],
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFFFF8A3D) : Colors.grey,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ชื่อสินค้า และ ราคา
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'อัลบั้มสำหรับคนสำคัญ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF8A3D)),
                      ),
                      Text(
                        '฿ 599',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF8A3D)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // -----------------------------------------------------------
                  // ส่วนการ์ดเลือกรูปหน้าปก (ปรับปรุงให้แสดงรูปที่เลือกมา)
                  // -----------------------------------------------------------
                  GestureDetector(
                    onTap: _startPickImageProcess, // กดที่การ์ดเพื่อเลือกรูปใหม่ได้
                    child: Container(
                      width: double.infinity,
                      height: _selectedCoverImage != null ? 200 : null, // ถ้ามีรูปให้สูง 200
                      padding: _selectedCoverImage != null ? EdgeInsets.zero : const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                        // ถ้ามีรูป ให้แสดงเป็น Background
                        image: _selectedCoverImage != null 
                          ? DecorationImage(
                              image: FileImage(_selectedCoverImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      ),
                      child: _selectedCoverImage != null 
                      ? Stack(
                          children: [
                            // ปุ่มแก้ไขรูป (overlay)
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text("เปลี่ยนรูป", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('รูปภาพหน้าปกอัลบั้ม', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F7FA).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text('เลือกรูปที่ไว้ใส่หน้าปกของคุณ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                  ),
                                  ElevatedButton(
                                    onPressed: _startPickImageProcess,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6BB0C5), // สีส้ม
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    child: const Text('เลือกรูปภาพ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  _buildStorySection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('฿ 599', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: () { if (_quantity > 1) setState(() => _quantity--); }),
                  Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.add), onPressed: () { setState(() => _quantity++); }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('เก็บทุกช่วงเวลาที่คุณรัก...ไว้ในเล่มเดียว', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Text('รวมทุกภาพที่มีความหมายที่สุดของคุณไว้ในอัลบั้มสุดอบอุ่น...', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
        const SizedBox(height: 24),
        Column(
          children: _storyImagesVertical.map((imagePath) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 200, color: Colors.grey[300])),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        const Text('เลือกภาพที่คุณรัก มาเป็นหน้าปกอัลบั้ม', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        SizedBox(
          height: 350,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _storyImages.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(_storyImages[index], fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 350, color: Colors.grey[300])),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =======================================================================
// 2. หน้า AlbumCoverSelectionPage (เลือกรูปปก)
// =======================================================================
class AlbumCoverSelectionPage extends StatefulWidget {
  final List<MediaItem> items;

  const AlbumCoverSelectionPage({super.key, required this.items});

  @override
  State<AlbumCoverSelectionPage> createState() => _AlbumCoverSelectionPageState();
}

class _AlbumCoverSelectionPageState extends State<AlbumCoverSelectionPage> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('รูปภาพหน้าปกอัลบั้ม', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text("เลือก 1 ภาพที่สะท้อนเรื่องราวและความทรงจำของคุณ", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ),
          Expanded(
            child: widget.items.isEmpty
                ? const Center(child: Text("ไม่มีรูปภาพที่จะแสดง"))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0,
                    ),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(12), child: _DebugCoverImageTile(item: item, index: index)),
                            if (isSelected)
                              Positioned(
                                top: 8, right: 8,
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF67A5BA), shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedIndex == null
                  ? null
                  : () {
                      // ส่ง MediaItem ที่เลือกกลับไปหน้าก่อนหน้า (AlbumGiftPage)
                      Navigator.pop(context, widget.items[_selectedIndex!]);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED7D31),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 0,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================================
// 3. Widget Shared: แสดงรูปภาพพร้อม Error Handling
// =======================================================================
class _DebugCoverImageTile extends StatefulWidget {
  final MediaItem item;
  final int index;
  const _DebugCoverImageTile({required this.item, required this.index});
  @override
  State<_DebugCoverImageTile> createState() => _DebugCoverImageTileState();
}

class _DebugCoverImageTileState extends State<_DebugCoverImageTile> {
  Uint8List? _imageData;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant _DebugCoverImageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() { _imageData = null; _hasError = false; });
    try {
      if (widget.item.capturedImage != null) {
        if (mounted) setState(() => _imageData = widget.item.capturedImage);
        return;
      }
      final asset = widget.item.asset;
      if (!await asset.exists) { if (mounted) setState(() => _hasError = true); return; }
      final data = await asset.thumbnailDataWithSize(const ThumbnailSize(300, 300), quality: 80);
      if (data != null) { if (mounted) setState(() => _imageData = data); } else { if (mounted) setState(() => _hasError = true); }
    } catch (e) {
      print("Error loading image index ${widget.index}: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, color: Colors.grey));
    if (_imageData != null) return Image.memory(_imageData!, fit: BoxFit.cover, gaplessPlayback: true);
    return Container(color: Colors.grey[200], child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))));
  }
}