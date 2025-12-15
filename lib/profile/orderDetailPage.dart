import 'package:flutter/material.dart';

// Enum เก็บสถานะทั้งหมด
enum OrderStatus {
  waitingPayment,
  printing, 
  preparing,
  shipping,
  completed,
  returned,
  cancelled
}

class OrderDetailPage extends StatelessWidget {
  final OrderStatus status;

  const OrderDetailPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูล Configuration ตามสถานะ
    final info = _getStatusInfo(status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        // 1. แก้ชื่อหัวข้อเป็น "ประวัติอัลบั้ม"
        title: const Text(
          'ประวัติอัลบั้ม',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
            // 2. เพิ่มส่วนแสดงชื่อสินค้าและจำนวน (ตามรูป)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: Text(
                    'อัลบั้มสำหรับใส่รูปครอบครัว',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'จำนวน 1 ชิ้น',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(height: 12), // เว้นระยะห่างนิดหน่อย

            // ส่วนหัว: คำว่าสั่งซื้อ และ สถานะ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('สั่งซื้อ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  info.label, 
                  // ถ้าสถานะเป็นยกเลิก ให้สีเป็นสีเทาหรือตาม config
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600,
                    color: status == OrderStatus.cancelled ? Colors.black : info.color
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),

            // 3. ปรับส่วนวันที่และ Progress Bar ให้อยู่บรรทัดเดียวกัน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // วันที่ (ด้านซ้าย)
                const Text(
                  'วันที่ xx มิถุนายน 2568', 
                  style: TextStyle(color: Colors.grey, fontSize: 14)
                ),
                
                // Progress Bar (ด้านขวา) - กำหนดความกว้างให้พอดี (เช่น 160)
                SizedBox(
                  width: 160, 
                  child: _buildDetailProgressBar(info),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- ส่วนด้านล่างเหมือนเดิม ---
            
            // รูปอัลบั้ม
            Center(
              child: Image.asset(
                'assets/images/album.png', 
                fit: BoxFit.contain,
                height: 200, 
              ),
            ),

            const SizedBox(height: 30),

            // ส่วนแสดงที่อยู่
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ที่อยู่',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('ช่องทางชำระเงิน', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('QR พร้อมเพย์', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('ชำระเงิน', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('10 ม.ค. 2025', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            
            if (status == OrderStatus.shipping) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF05A28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('ยืนยันการจัดส่ง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Configuration
  // ---------------------------------------------------------------------------
  _StatusConfig _getStatusInfo(OrderStatus status) {
    const kOrange = Color(0xFFF05A28);
    const kGreen = Color(0xFF28C668);
    const kRed = Color(0xFFFF3B30);
    const kPeach = Color(0xFFFDCB9E);
    const kPeachIcon = Color(0xFFFDB67F);

    Widget icon(IconData data) => Icon(data, color: Colors.white, size: 20); // ลดขนาดไอคอนลงเล็กน้อย
    Widget image(String path) => Image.asset(path, width: 20, height: 20, color: Colors.white);

    switch (status) {
      case OrderStatus.waitingPayment: 
        return _StatusConfig('รอชำระ', 1, kOrange, image('assets/icons/bookmark.png'));
      case OrderStatus.printing: 
        return _StatusConfig('สั่งพิมพ์', 2, kOrange, icon(Icons.print));
      case OrderStatus.preparing: 
        return _StatusConfig('เตรียมจัดส่ง', 2, kOrange, image('assets/icons/truck.png'));
      case OrderStatus.shipping: 
        return _StatusConfig('ที่ต้องได้รับ', 3, kOrange, image('assets/icons/truck.png'));
      case OrderStatus.completed: 
        return _StatusConfig('สำเร็จ', 4, kGreen, icon(Icons.check), isFull: true);
      case OrderStatus.returned: 
        return _StatusConfig('คืนสินค้า', 4, kPeach, image('assets/icons/cube.png'), overrideIconBg: kPeachIcon); 
      case OrderStatus.cancelled: 
        // เปลี่ยนไอคอนเป็น Lock (ถ้ามี assets) หรือใช้ Icon ปกติเพื่อให้เหมือนรูป
        return _StatusConfig('ยกเลิก', 4, kRed, icon(Icons.lock_outline), isFull: true);
    }
  }

  // ---------------------------------------------------------------------------
  // Widget Progress Bar (ปรับขนาดให้เล็กลงเพื่อให้เข้ากับ Layout ใหม่)
  // ---------------------------------------------------------------------------
  Widget _buildDetailProgressBar(_StatusConfig config) {
    return SizedBox(
      height: 40, // ลดความสูงลง
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double iconSize = 36.0; // ลดขนาดวงกลมไอคอน
          double barWidth = (width - 12) / 4; // ปรับ gap ให้เล็กลง
          
          double iconPos = (config.barCount == 4) 
              ? (width - 12) - (iconSize / 2) 
              : (barWidth * config.barCount) - (iconSize / 2);
          
          if (config.barCount == 1) iconPos = barWidth - (iconSize / 2);

          // ป้องกัน Icon หลุดขอบซ้าย/ขวา
          if (iconPos < 0) iconPos = 0;
          if (iconPos > width - iconSize) iconPos = width - iconSize;

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Bar
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: List.generate(4, (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4), // gap เล็กลง
                      height: 16, // bar บางลง
                      decoration: BoxDecoration(
                        color: (i < config.barCount || config.isFull) ? config.color : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
                ),
              ),
              
              // Icon Circle
              Positioned(
                left: iconPos,
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: config.overrideIconBg ?? config.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: (config.overrideIconBg ?? config.color).withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Center(child: config.iconWidget), 
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusConfig {
  final String label;
  final int barCount;
  final Color color;
  final Widget iconWidget; 
  final bool isFull;
  final Color? overrideIconBg;

  _StatusConfig(
    this.label, 
    this.barCount, 
    this.color, 
    this.iconWidget, 
    {this.isFull = false, this.overrideIconBg}
  );
}