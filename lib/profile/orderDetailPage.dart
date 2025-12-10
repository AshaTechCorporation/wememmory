import 'package:flutter/material.dart';

// Enum เก็บสถานะทั้งหมด
enum OrderStatus {
  waitingPayment,
  printing, // ใช้แทนขั้นตอนที่ 1
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
    // ดึงข้อมูลตามสถานะ (สี, ไอคอน, ข้อความ)
    final info = _getStatusInfo(status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('ประวัติสินค้า', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ส่วนหัว
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('สั่งซื้อ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(info.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 4),
            Row(children: const [Text('วันที่ xx มิถุนายน 2568', style: TextStyle(color: Colors.grey, fontSize: 14))]),
            const SizedBox(height: 20),

            // หลอด Progress Detail
            _buildDetailProgressBar(info),

            const SizedBox(height: 30),

            // รูปอัลบั้ม
            Image.asset('assets/images/Rectangle1.png', fit: BoxFit.contain), // เปลี่ยนเป็นรูปอัลบั้มกางของคุณ

            const SizedBox(height: 30),

            // ที่อยู่
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ที่อยู่', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3...', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24),
                  const Center(child: Text('แสดงน้อยลง', style: TextStyle(color: Colors.white70, fontSize: 12))),
                ],
              ),
            ),
            
            // ปุ่ม Action (ถ้ามี)
             if (status == OrderStatus.shipping) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF05A28), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('ยืนยันการจัดส่ง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // Helper Config
  _StatusConfig _getStatusInfo(OrderStatus status) {
    const kOrange = Color(0xFFF05A28);
    const kGreen = Color(0xFF28C668);
    const kRed = Color(0xFFFF3B30);
    const kPeach = Color(0xFFFDCB9E);
    const kPeachIcon = Color(0xFFFDB67F);

    switch (status) {
      case OrderStatus.waitingPayment: return _StatusConfig('รอชำระ', 1, kOrange, Icons.payment);
      case OrderStatus.printing: return _StatusConfig('สั่งพิมพ์', 2, kOrange, Icons.print);
      case OrderStatus.preparing: return _StatusConfig('เตรียมจัดส่ง', 2, kOrange, Icons.inventory_2_outlined);
      case OrderStatus.shipping: return _StatusConfig('ที่ต้องได้รับ', 3, kOrange, Icons.local_shipping_outlined);
      case OrderStatus.completed: return _StatusConfig('สำเร็จ', 4, kGreen, Icons.check, isFull: true);
      case OrderStatus.returned: return _StatusConfig('คืนสินค้า', 3, kPeach, Icons.cached, overrideIconBg: kPeachIcon); // ปรับ barCount เป็น 3 หรือ 4 ตามชอบ
      case OrderStatus.cancelled: return _StatusConfig('ยกเลิก', 4, kRed, Icons.lock_outline, isFull: true);
    }
  }

  Widget _buildDetailProgressBar(_StatusConfig config) {
    return SizedBox(
      height: 50,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double iconSize = 46.0;
          double barWidth = (width - 20) / 4;
          double iconPos = (config.barCount == 4) ? (width - 20) - (iconSize / 2) : (barWidth * config.barCount) - (iconSize / 2);
          if (config.barCount == 1) iconPos = barWidth - (iconSize / 2);

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(children: List.generate(4, (i) => Expanded(child: Container(margin: const EdgeInsets.only(right: 4), height: 24, decoration: BoxDecoration(color: (i < config.barCount || config.isFull) ? config.color : const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(6)))))),
              ),
              Positioned(left: iconPos, child: Container(width: iconSize, height: iconSize, decoration: BoxDecoration(color: config.overrideIconBg ?? config.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: [BoxShadow(color: (config.overrideIconBg ?? config.color).withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 4))]), child: Icon(config.icon, color: Colors.white, size: 24))),
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
  final IconData icon;
  final bool isFull;
  final Color? overrideIconBg;
  _StatusConfig(this.label, this.barCount, this.color, this.icon, {this.isFull = false, this.overrideIconBg});
}