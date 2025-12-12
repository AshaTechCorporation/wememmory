import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/order_success_page.dart';
import 'package:wememmory/models/media_item.dart';

class PrintSheet extends StatefulWidget {
  final List<MediaItem> items;
  final String monthName;

  const PrintSheet({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  State<PrintSheet> createState() => _PrintSheetState();
}

class _PrintSheetState extends State<PrintSheet> {
  bool _isGift = false;

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
          // 1. Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'สั่งพิมพ์',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 2. Content Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้ออัลบั้ม
                  const Text("อัลบั้มรูปของคุณ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  // ส่วนแสดงรูป (ใช้ Widget ที่แยกไว้)
                  _PrintPreviewSection(items: widget.items, monthName: widget.monthName),

                  const SizedBox(height: 24),

                  // 1. ที่อยู่ผู้ส่ง (แสดงตลอด)
                  _buildAddressCard(
                    title: "ที่อยู่จัดส่ง",
                    address: "หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง\nแขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร",
                  ),

                  const SizedBox(height: 24),

                  // Toggle ส่งของขวัญ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ส่งของขวัญ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Switch(
                        value: _isGift,
                        onChanged: (val) => setState(() => _isGift = val),
                        activeColor: const Color.fromARGB(255, 255, 255, 255),
                        activeTrackColor: const Color(0xFFED7D31).withOpacity(0.4),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),

                  // 2. ที่อยู่ผู้รับ (แสดงเมื่อเปิด Gift Mode)
                  if (_isGift) ...[
                    const SizedBox(height: 20),
                    _buildAddressCard(
                      title: "ที่อยู่ผู้รับของขวัญ",
                      address: "กรุณาเลือกที่อยู่ผู้รับ...",
                    ),
                  ],

                  const SizedBox(height: 20),

                  // กล่องยอดเครดิต
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF67A5BA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("ยอดเครดิตคงเหลือ : ", style: TextStyle(color: Colors.white, fontSize: 14)),
                                // ✅ แก้ไข: เปลี่ยนไอคอนเหรียญ
                                Image.asset(
                                  'assets/icons/dollar-circle.png',
                                  width: 24, // ปรับขนาดให้พอดีกับ Text fontSize 16
                                  height: 24,
                                ),
                                const SizedBox(width: 4),
                                const Text("10", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text("เติมเครดิตตามจำนวนที่คุณต้องการ", style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF67A5BA),
                            minimumSize: const Size(80, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("เติมเครดิต", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // รายละเอียดการสั่งพิมพ์
                  const Text("รายละเอียดการสั่งพิมพ์", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("อัลบั้มรูปของคุณ", style: TextStyle(color: Colors.black87, fontSize: 14)),
                      // ✅ แก้ไข: เปลี่ยนไอคอนเหรียญ
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/dollar-circle.png',
                            width: 24, // ขนาดเท่า fontSize
                            height: 24,
                          ),
                          const SizedBox(width: 4),
                          const Text("10", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- ส่วนแสดงเครดิต (ซ้าย) ---
                Row(
                  children: [
                    const Text(
                      "เครดิตที่ต้องใช้",
                      style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/icons/dollar-circle.png',
                      width: 24, // ขนาดเดิมของ Icon
                      height: 24,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "10",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),

                // --- ปุ่มสั่งพิมพ์ (ขวา) ---
                SizedBox(
                  width: 140,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSuccessPage(
                            items: widget.items,
                            monthName: widget.monthName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: const RoundedRectangleBorder(),
                      elevation: 0,
                    ),
                    child: const Text(
                      "สั่งพิมพ์",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper Widget สำหรับสร้างกล่องที่อยู่ (ใช้ซ้ำได้)
  Widget _buildAddressCard({required String title, required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}

// ✅ แยก Widget แสดงผลอัลบั้มออกมาเป็น const เพื่อป้องกันการ Rebuild
class _PrintPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;

  const _PrintPreviewSection({
    required this.items,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFF555555),
          ),
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
                            monthName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      for (int i = 0; i < 5; i++)
                        if (i < items.length)
                          _StaticPhotoSlot(item: items[i]) // ✅ ใช้ Widget ที่โหลดรูปแล้ว
                        else
                          const SizedBox(),
                    ],
                  ),
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
    if (widget.item.capturedImage != null) {
      if (mounted) {
        setState(() {
          _imageData = widget.item.capturedImage;
        });
      }
    } else {
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
                Container(color: Colors.grey[200]),
            ],
          ),
        ),
      ),
    );
  }
}