import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // จำลองข้อมูล (Mock Data) ตามภาพ
    final List<Map<String, dynamic>> notifications = [
      {
        "text": "อัลบั้มของคุณอยู่ในระหว่างการจัดส่ง",
        "time": "1h ago",
        "isUnread": true, // สีส้ม
      },
      {
        "text": "โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น โปรโมชั่น",
        "time": "2h ago",
        "isUnread": false, // สีเทา
      },
      {
        "text": "ข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสารข่าวสาร",
        "time": "3h ago",
        "isUnread": false, // สีเทา
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false, // จัด Title ชิดซ้ายตาม Android หรือปรับตามต้องการ
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'การแจ้งเตือน',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          //  style: GoogleFonts.prompt(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 30, color: Color(0xFFEEEEEE), thickness: 1),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return _buildNotificationItem(text: item['text'], time: item['time'], isUnread: item['isUnread']);
        },
      ),
    );
  }

  Widget _buildNotificationItem({required String text, required String time, required bool isUnread}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // ให้ text เริ่มบรรทัดบนสุด
      children: [
        // --- ส่วนไอคอน (Stack) ---
        Stack(
          children: [
            // วงกลมพื้นหลังสีดำ
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF333333), // สีเทาเข้มเกือบดำ
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mail_outline, // หรือใช้ Icons.email_outlined
                color: Colors.white,
                size: 24,
              ),
            ),
            // จุดแจ้งเตือน (Badge)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color:
                      isUnread
                          ? const Color(0xFFEE743B) // สีส้ม (ยังไม่อ่าน)
                          : const Color(0xFF9E9E9E), // สีเทา (อ่านแล้ว)
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2), // ขอบขาว
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 16), // ระยะห่างระหว่างไอคอนกับข้อความ
        // --- ส่วนข้อความ ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5, // ระยะห่างระหว่างบรรทัด,
                ),
                // style: GoogleFonts.prompt(
                //   fontSize: 14,
                //   color: Colors.black87,
                //   height: 1.5, // ระยะห่างระหว่างบรรทัด
                // ),
                maxLines: 3, // จำกัดบรรทัดเผื่อยาวเกิน
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black, // ในภาพสีดำเข้มชัดเจน
                  fontWeight: FontWeight.bold,
                ),
                // style: GoogleFonts.prompt(
                //   fontSize: 12,
                //   color: Colors.black, // ในภาพสีดำเข้มชัดเจน
                //   fontWeight: FontWeight.bold,
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
