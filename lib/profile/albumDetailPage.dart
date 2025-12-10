import 'package:flutter/material.dart';

class AlbumDetailPage extends StatelessWidget {
  final String statusTitle;
  final String statusText;
  final String dateText;
  final int barCount;
  final Color mainColor;
  final IconData iconData;
  final Color? overrideIconBgColor;

  const AlbumDetailPage({
    super.key,
    required this.statusTitle,
    required this.statusText,
    required this.dateText,
    required this.barCount,
    required this.mainColor,
    required this.iconData,
    this.overrideIconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ประวัติอัลบั้ม', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(statusText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 4),
            Text(dateText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),

            // หลอดสถานะ Detail Page
            SizedBox(
              height: 50,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double totalWidth = constraints.maxWidth;
                  double iconSize = 46.0;
                  double rightPadding = 20.0;
                  double barAreaWidth = totalWidth - rightPadding;
                  double singleBarWidth = barAreaWidth / 4;
                  double iconLeftPos = (singleBarWidth * barCount) - (iconSize / 2);

                  if (barCount == 4) iconLeftPos = barAreaWidth - (iconSize / 2);
                  else if (barCount == 1) iconLeftPos = singleBarWidth - (iconSize / 2);

                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: rightPadding),
                        child: Row(
                          children: List.generate(4, (index) {
                            bool isActive = index < barCount;
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 4),
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isActive ? mainColor : const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        left: iconLeftPos,
                        child: Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: overrideIconBgColor ?? mainColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Icon(iconData, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            
            // รูปอัลบั้ม
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // *** อย่าลืมเปลี่ยนเป็นรูปอัลบั้มกางออกที่คุณมี ***
                child: Image.asset('assets/images/banner.png', width: double.infinity, fit: BoxFit.contain),
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
                children: const [
                  Text('ที่อยู่', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(
                    'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร',
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}