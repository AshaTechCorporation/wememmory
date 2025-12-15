import 'package:flutter/material.dart';

// --- Widget หลักสำหรับแสดงผล ---
class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200, 
          child: PageView(
            controller: PageController(viewportFraction: 1.0),
            children: const [
              // การ์ดที่ 1
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'เรื่องราวที่น่าจดจำ',
                  count: '88',
                  countColor: Color(0xFF5AB6D8),
                  imagePaths: [
                    'assets/images/Hobby1.png',
                    // 'assets/images/image2.png',
                    // 'assets/images/image3.png',
                  ],
                  topCaptionTitle: 'ช่วงเวลาดีดี',
                  topCaptionSub: '#ครอบครัว #ความรัก',
                ),
              ),
              
              // การ์ดที่ 2
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'ทริปต่างประเทศ',
                  count: '12',
                  countColor: Color(0xFFFF8C66),
                  imagePaths: [
                    'assets/images/image1.png',
                    'assets/images/image5.png',
                  ],
                  topCaptionTitle: 'เที่ยวญี่ปุ่น',
                  topCaptionSub: '#Travel #Japan',
                ),
              ),
              
              // การ์ดที่ 3
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'ร้านอาหารโปรด',
                  count: '34',
                  countColor: Color(0xFF8BC34A),
                  topCaptionTitle: 'อร่อยมาก',
                  topCaptionSub: '#Food #Yummy',
                ),
              ),
              // การ์ดที่ 4 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'ร้านอาหารโปรด',
                  count: '34',
                  countColor: Color(0xFF8BC34A),
                  topCaptionTitle: 'อร่อยมาก',
                  topCaptionSub: '#Food #Yummy',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ---------------------------------------------------------
// InfoCard: การ์ดสีขาวหลัก
// ---------------------------------------------------------
class InfoCard extends StatelessWidget {
  final String title;
  final String count;
  final Color countColor;
  final List<String>? imagePaths; 
  final String topCaptionTitle;   
  final String topCaptionSub;

  const InfoCard({
    super.key,
    required this.title,
    required this.count,
    this.countColor = const Color(0xFF5AB6D8),
    this.imagePaths,
    this.topCaptionTitle = '',
    this.topCaptionSub = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.15),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 35, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _PhotoStack(
              imagePaths: imagePaths,
              topCaptionTitle: topCaptionTitle,
              topCaptionSub: topCaptionSub,
            ),
            
            const Spacer(), 
            
            // ✅ ปรับให้ข้อความจัดกึ่งกลางกันเอง
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // เปลี่ยนจาก .end เป็น .center
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    color: countColor,
                    height: 1.0, 
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ... (ส่วน _PhotoStack และ _PhotoCard คงเดิมทุกประการ) ...
// ---------------------------------------------------------
// _PhotoStack
// ---------------------------------------------------------
class _PhotoStack extends StatelessWidget {
  final List<String>? imagePaths;
  final String topCaptionTitle;
  final String topCaptionSub;

  const _PhotoStack({
    this.imagePaths,
    required this.topCaptionTitle,
    required this.topCaptionSub,
  });

  @override
  Widget build(BuildContext context) {
    const double w = 95; 
    const double h = 125; 
    
    String? img1 = (imagePaths != null && imagePaths!.isNotEmpty) ? imagePaths![0] : null;
    String? img2 = (imagePaths != null && imagePaths!.length > 1) ? imagePaths![1] : null;
    String? img3 = (imagePaths != null && imagePaths!.length > 2) ? imagePaths![2] : null;

    return SizedBox(
      width: w + 25, 
      height: h + 10,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 15,
            top: 5,
            child: Transform.rotate(
              angle: 0.12, 
              child: _PhotoCard(
                width: w,
                height: h,
                rotation: 0, 
                imagePath: img3,
                isBackCard: true,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 5,
            child: Transform.rotate(
              angle: -0.15, 
              child: _PhotoCard(
                width: w,
                height: h,
                rotation: 0,
                imagePath: img2,
                isBackCard: true,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 0,
            child: _PhotoCard(
              width: w,
              height: h,
              rotation: 0.0, 
              imagePath: img1,
              isBackCard: false, 
              captionTitle: topCaptionTitle,
              captionSub: topCaptionSub,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// _PhotoCard
// ---------------------------------------------------------
class _PhotoCard extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final String? imagePath; 
  final bool isBackCard;   
  final String captionTitle;
  final String captionSub;

  const _PhotoCard({
    required this.width,
    required this.height,
    required this.rotation,
    this.imagePath,
    this.isBackCard = false,
    this.captionTitle = '',
    this.captionSub = '',
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2), 
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4, 
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                padding: const EdgeInsets.all(10), 
                clipBehavior: Clip.antiAlias,
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 20)),
                      )
                    : const Center(
                        child: Icon(Icons.photo, color: Colors.white, size: 30),
                      ),
              ),
            ),
            
            if (!isBackCard) ...[
              const SizedBox(height: 8), 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    captionTitle, 
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    captionSub, 
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xFF5AB6D8), 
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ] else ...[
               const Spacer(flex: 3), 
            ]
          ],
        ),
      ),
    );
  }
}