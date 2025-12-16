import 'package:flutter/material.dart';

// ==============================================================================
// 1. PAGE: หน้ารายละเอียดออเดอร์ (AlbumDetailPage)
// ==============================================================================
class AlbumDetailPage extends StatelessWidget {
  final String statusTitle; 
  final String statusText;  // เช่น "เตรียมจัดส่ง", "ที่ต้องได้รับ", "คืนสินค้า"
  final String dateText;    
  final int barCount;       
  final Color mainColor;    
  final Widget icon;        
  final Color? overrideIconBgColor; 

  const AlbumDetailPage({
    super.key,
    required this.statusTitle,
    required this.statusText,
    required this.dateText,
    required this.barCount,
    required this.mainColor,
    required this.icon,
    this.overrideIconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    // --- ตรวจสอบสถานะ ---
    bool isPreparing = statusText == 'เตรียมจัดส่ง'; 
    bool isShipping = statusText == 'ที่ต้องได้รับ';
    bool isReturned = statusText == 'คืนสินค้า';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ประวัติอัลบั้ม',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ส่วนชื่อสินค้า
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
                Text('จำนวน 1 ชิ้น', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            // สถานะ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  statusText, 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600,
                    color: statusText == 'ยกเลิก' ? Colors.black : mainColor 
                  )
                ),
              ],
            ),
            const SizedBox(height: 8),
            // วันที่และ Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(width: 160, height: 40, child: _buildMiniProgressBar()),
              ],
            ),
            const SizedBox(height: 30),
            // รูปภาพ
            Center(
              child: Image.asset(
                'assets/images/album.png', // *เช็ค path รูปของคุณ*
                fit: BoxFit.contain,
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.photo, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            // ที่อยู่
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
                  const Text('ที่อยู่', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร',
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
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
            const SizedBox(height: 20),

            // ------------------------------------------------------------------
            // ส่วนแสดงกล่องสีฟ้าตามสถานะ
            // ------------------------------------------------------------------
            
            // กรณี "ที่ต้องได้รับ" -> กล่องฟ้า + ปุ่มยืนยัน
            if (isShipping) ...[
              _buildStatusBlueBox(
                context, 
                title: 'พัสดุอยู่ระหว่างการนำส่ง', 
                time: '9 มิ.ย. 11:00',
                targetStatus: 'ที่ต้องได้รับ' // ส่งสถานะไปบอกหน้า Timeline
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _showConfirmDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF05A28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('ยืนยันการจัดส่ง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // กรณี "เตรียมจัดส่ง" -> กล่องฟ้า (ไม่มีปุ่ม)
            if (isPreparing) ...[
              _buildStatusBlueBox(
                context, 
                title: 'กำลังเตรียมพัสดุ', 
                time: '9 มิ.ย. 10:00',
                targetStatus: 'เตรียมจัดส่ง'
              ),
              const SizedBox(height: 40),
            ],

            // กรณี "คืนสินค้า" -> กล่องฟ้า (ไม่มีปุ่ม)
            if (isReturned) ...[
              _buildStatusBlueBox(
                context, 
                title: 'คืนสินค้า', 
                time: '9 มิ.ย. 11:00',
                targetStatus: 'คืนสินค้า'
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }

  // --- Widget Components ---
  Widget _buildMiniProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double iconSize = 32.0;
        double barSpacing = 4.0;
        double barWidth = (totalWidth - 10) / 4; 
        double iconLeftPos = (barCount == 4) ? totalWidth - iconSize : (barWidth * barCount) - (iconSize / 2);
        if (iconLeftPos < 0) iconLeftPos = 0;
        if (iconLeftPos > totalWidth - iconSize) iconLeftPos = totalWidth - iconSize;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: List.generate(4, (index) {
                  bool isActive = index < barCount;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: barSpacing),
                      height: 14,
                      decoration: BoxDecoration(color: isActive ? mainColor : const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              left: iconLeftPos,
              child: Container(
                width: iconSize, height: iconSize,
                decoration: BoxDecoration(
                  color: overrideIconBgColor ?? mainColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [BoxShadow(color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Center(child: SizedBox(width: 18, height: 18, child: FittedBox(child: icon))),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBlueBox(BuildContext context, {required String title, required String time, required String targetStatus}) {
    return GestureDetector(
      onTap: () {
        // ส่ง targetStatus ไปที่หน้า Timeline เพื่อให้แสดงข้อมูลถูก
        Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingTimelinePage(statusType: targetStatus)));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF59A5B3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF59A5B3).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('ยืนยันการจัดส่ง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
                ]),
                const SizedBox(height: 10),
                RichText(text: const TextSpan(text: 'แนบไฟล์หลักฐาน ', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600), children: [TextSpan(text: '*', style: TextStyle(color: Colors.red))])),
                const Text('อัปโหลดรูปภาพ (.png, .jpg)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: CustomPaint(
                    painter: _DashedRectPainter(color: Colors.grey, strokeWidth: 1.0, gap: 5.0),
                    child: Container(height: 100, width: double.infinity, alignment: Alignment.center, child: RichText(textAlign: TextAlign.center, text: TextSpan(text: 'เปิดกล้องหรือ ', style: TextStyle(color: Colors.grey[600], fontSize: 14), children: const [TextSpan(text: 'เลือกจากไฟล์ที่มี', style: TextStyle(color: Colors.blue))]))),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(maxLines: 4, decoration: InputDecoration(hintText: 'คำติชมเพิ่มเติม', hintStyle: TextStyle(color: Colors.grey[400]), contentPadding: const EdgeInsets.all(12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)))),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF05A28), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), elevation: 0), child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==============================================================================
// 2. PAGE: หน้า Timeline สถานะสินค้า (TrackingTimelinePage)
// ==============================================================================
class TrackingTimelinePage extends StatelessWidget {
  final String statusType; // รับค่า status เพื่อแสดงรายการให้ตรง

  const TrackingTimelinePage({super.key, this.statusType = 'ที่ต้องได้รับ'});

  @override
  Widget build(BuildContext context) {
    // กำหนดรายการ Timeline ตามสถานะ
    List<Widget> timelineItems = [];

    if (statusType == 'เตรียมจัดส่ง') {
      timelineItems = [
        _buildTimelineItem(date: '9 มิ.ย.', time: '10:00', status: 'กำลังเตรียมพัสดุ', isFirst: true, isActive: true),
        _buildTimelineItem(date: '9 มิ.ย.', time: '09:00', status: 'ยืนยันคำสั่งซื้อ', isFirst: false, isLast: true),
      ];
    } else if (statusType == 'คืนสินค้า') {
      timelineItems = [
        _buildTimelineItem(date: '10 มิ.ย.', time: '14:00', status: 'คืนสินค้าสำเร็จ', isFirst: true, isActive: true),
        _buildTimelineItem(date: '9 มิ.ย.', time: '11:00', status: 'ร้านค้าได้รับสินค้าคืน', isFirst: false),
        _buildTimelineItem(date: '8 มิ.ย.', time: '09:00', status: 'ส่งคำขอคืนสินค้า', isFirst: false, isLast: true),
      ];
    } else {
      // Default: ที่ต้องได้รับ (Shipping)
      timelineItems = [
        _buildTimelineItem(date: '9 มิ.ย.', time: '11:00', status: 'พัสดุอยู่ระหว่างการนำส่ง', isFirst: true, isActive: true),
        _buildTimelineItem(date: '8 มิ.ย.', time: '15:30', status: 'พัสดุถึงศูนย์คัดแยก', isFirst: false),
        _buildTimelineItem(date: '8 มิ.ย.', time: '10:00', status: 'บริษัทขนส่งเข้ารับพัสดุ', isFirst: false),
        _buildTimelineItem(date: '7 มิ.ย.', time: '09:00', status: 'ยืนยันคำสั่งซื้อ', isFirst: false, isLast: true),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('สถานะสินค้า', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], borderRadius: BorderRadius.circular(4),
                      image: const DecorationImage(image: AssetImage('assets/images/album.png'), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('อัลบั้มสำหรับใส่รูปครอบครัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('สีส้ม   X1', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                      ],
                    ),
                  ),
                  const Text('฿ 599', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: timelineItems),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({required String date, required String time, required String status, bool isFirst = false, bool isLast = false, bool isActive = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(width: 2, height: 5, color: isFirst ? Colors.transparent : Colors.grey[300]),
              Container(width: 12, height: 12, decoration: BoxDecoration(color: isActive ? const Color(0xFF28C668) : Colors.grey[300], shape: BoxShape.circle)),
              Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                status,
                style: TextStyle(color: isActive ? const Color(0xFF28C668) : Colors.grey[500], fontSize: 14, fontWeight: isActive ? FontWeight.w500 : FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// 3. Helper: Class ช่วยวาดเส้นประ
// ==============================================================================
class _DashedRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;
  _DashedRectPainter({this.strokeWidth = 1.0, this.color = Colors.grey, this.gap = 5.0});
  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    double x = size.width; double y = size.height;
    canvas.drawPath(getDashedPath(a: const Offset(0, 0), b: Offset(x, 0), gap: gap), dashedPaint);
    canvas.drawPath(getDashedPath(a: Offset(x, 0), b: Offset(x, y), gap: gap), dashedPaint);
    canvas.drawPath(getDashedPath(a: Offset(0, y), b: Offset(x, y), gap: gap), dashedPaint);
    canvas.drawPath(getDashedPath(a: const Offset(0, 0), b: Offset(0, y), gap: gap), dashedPaint);
  }
  Path getDashedPath({required Offset a, required Offset b, required double gap}) {
    Size size = Size(b.dx - a.dx, b.dy - a.dy); Path path = Path(); path.moveTo(a.dx, a.dy); bool shouldDraw = true; Offset currentPoint = Offset(a.dx, a.dy); double radians = (size.width == 0) ? 1.5708 : 0.0; double distance = (size.width == 0) ? size.height.abs() : size.width.abs();
    for (double i = 0; i < distance; i += gap) {
      if (shouldDraw) {
        if (radians == 0.0) { path.lineTo(currentPoint.dx + gap, currentPoint.dy); currentPoint = Offset(currentPoint.dx + gap, currentPoint.dy); } else { path.lineTo(currentPoint.dx, currentPoint.dy + gap); currentPoint = Offset(currentPoint.dx, currentPoint.dy + gap); }
      } else {
        if (radians == 0.0) { path.moveTo(currentPoint.dx + gap, currentPoint.dy); currentPoint = Offset(currentPoint.dx + gap, currentPoint.dy); } else { path.moveTo(currentPoint.dx, currentPoint.dy + gap); currentPoint = Offset(currentPoint.dx, currentPoint.dy + gap); }
      }
      shouldDraw = !shouldDraw;
    }
    return path;
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}