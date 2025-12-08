import 'package:flutter/material.dart';

class CreateAlbumModal extends StatelessWidget {
  const CreateAlbumModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // สูง 75% ของจอ
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12 )),
      ),
      child: Column(
        children: [
          // 1. Header (ชื่อหน้า + ปุ่มปิด)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'สร้างอัลบั้มรูป',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28, color: Colors.grey),
                ),
              ],
            ),
          ),

          // 2. Credit Info (ส่วนเครดิต)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                Text(
                  'คุณมีอยู่ 10 เครดิต',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ให้แต่ละเดือนบอกเล่าเรื่องราวของคุณ ผ่านภาพแห่งความทรงจำ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          const Divider(height: 1, color: Colors.black12),

          // 3. List of Months (รายการเดือน - Scrollable)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              // ใช้ physics: BouncingScrollPhysics() เพื่อให้เด้งๆ แบบ iOS หรือ ClampingScrollPhysics() แบบ Android
              physics: const BouncingScrollPhysics(), 
              children: const [
                // --- 2026 (อนาคต - ตัวอย่าง) ---
                _AlbumOptionItem(month: "มกราคม 2569", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),

                // --- 2025 ---
                _AlbumOptionItem(month: "ธันวาคม 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                
                _AlbumOptionItem(month: "พฤศจิกายน 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),

                _AlbumOptionItem(month: "ตุลาคม 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                
                _AlbumOptionItem(month: "กันยายน 2568", statusText: "สร้างอัลบั้มสำเร็จ", isDone: true),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                
                _AlbumOptionItem(month: "สิงหาคม 2568", statusText: "สร้างอัลบั้มสำเร็จ", isDone: true),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                
                _AlbumOptionItem(month: "กรกฎาคม 2568", statusText: "สร้างอัลบั้มสำเร็จ", isDone: true),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                
                _AlbumOptionItem(month: "มิถุนายน 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                
                _AlbumOptionItem(month: "พฤษภาคม 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),

                _AlbumOptionItem(month: "เมษายน 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),

                _AlbumOptionItem(month: "มีนาคม 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),

                _AlbumOptionItem(month: "กุมภาพันธ์ 2568", statusText: "สร้างอัลบั้ม", isDone: false),
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),

                _AlbumOptionItem(month: "มกราคม 2568", statusText: "สร้างอัลบั้มสำเร็จ", isDone: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ย่อยสำหรับแต่ละแถว (Row Item)
class _AlbumOptionItem extends StatelessWidget {
  final String month;
  final String statusText;
  final bool isDone; 

  const _AlbumOptionItem({
    required this.month,
    required this.statusText,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDone ? null : () {
        print("เลือกสร้างอัลบั้มเดือน $month");
        Navigator.pop(context); 
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDone ? Colors.grey[600] : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDone ? const Color(0xFF66BB6A) : Colors.grey[600], 
                  ),
                ),
              ],
            ),
            if (isDone)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF66BB6A), 
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}