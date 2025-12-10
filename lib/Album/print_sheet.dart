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
                  
                  // --- ส่วนแสดงตัวอย่างอัลบั้ม (ขนาดเต็มเหมือน FinalPreview) ---
                  _buildFullAlbumPreview(),
                  
                  const SizedBox(height: 24),

                  // หัวข้อที่อยู่
                  const Text("ที่อยู่", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // กล่องที่อยู่
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
                            "หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง\nแขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร",
                            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
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
                        activeColor: Color.fromARGB(255, 255, 255, 255),  
                        activeTrackColor:  Color(0xFFED7D31).withOpacity(0.4),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),

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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("ยอดเครดิตคงเหลือ : ", style: TextStyle(color: Colors.white, fontSize: 14)),
                                Text("🪙 10", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text("เติมเครดิตตามจำนวนที่คุณต้องการ", style: TextStyle(color: Colors.white70, fontSize: 11)),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("อัลบั้มรูปของคุณ", style: TextStyle(color: Colors.black87, fontSize: 14)),
                      Text("🪙 10", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
              border: Border(top: BorderSide(color: Colors.black12)), // เส้นขอบบนบางๆ
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // ดันซ้าย-ขวาสุดขอบ
              children: [
                // --- ส่วนแสดงเครดิต (ซ้าย) ---
                Row(
                  children: [
                    const Text(
                      "เครดิตที่ต้องใช้",
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.black87, // สีเทาเข้มเกือบดำ
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    const SizedBox(width: 8), // เว้นระยะห่าง
                    
                    // ไอคอนเหรียญ (สีเหลือง)
                    const Icon(
                      Icons.monetization_on, // หรือใช้ Icons.paid
                      size: 24, 
                      color: Color(0xFFFFC107), // สีเหลืองทอง
                    ),
                    
                    const SizedBox(width: 6), // เว้นระยะห่าง
                    
                    const Text(
                      "10",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black87
                      ),
                    ),
                  ],
                ),

                // --- ปุ่มสั่งพิมพ์ (ขวา) ---
                SizedBox(
                  width: 140, // ความกว้างปุ่ม
                  height: 48, // ความสูงปุ่ม
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ ฟังก์ชันเดิม: ส่งข้อมูลไปยังหน้า Success
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
                      backgroundColor: const Color(0xFFED7D31), // สีส้มตามภาพ
                      shape: RoundedRectangleBorder(      
                      ),
                      elevation: 0, // ไม่มีเงา
                    ),
                    child: const Text(
                      "สั่งพิมพ์",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold 
                      ),
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

  // ✅ แสดงอัลบั้มขนาดเต็ม (เหมือนหน้า FinalPreview)
  Widget _buildFullAlbumPreview() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10), // Padding รอบๆ สีเทา
          decoration: BoxDecoration(
            color: const Color(0xFF555555), // สีเทาเข้ม
            // borderRadius: BorderRadius.circular(4),
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            widget.monthName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Slots 1-5: รูปภาพ
                      for (int i = 0; i < 5; i++)
                        if (i < widget.items.length)
                          _StaticPhotoSlot(item: widget.items[i])
                        else
                          const SizedBox(),
                    ],
                  ),
                ),

                const SizedBox(width: 20), // สันหนังสือ

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
                        if ((i + 5) < widget.items.length)
                          _StaticPhotoSlot(item: widget.items[i + 5])
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

  // ใช้ขนาดหน้ากระดาษเท่าเดิม (ไม่ย่อส่วน)
  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }
}

// Widget แสดงรูปภาพแบบนิ่ง
class _StaticPhotoSlot extends StatelessWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

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
              FutureBuilder<Uint8List?>(
                future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  return Container(color: Colors.grey[200]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}