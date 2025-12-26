import 'package:flutter/material.dart';
import 'package:wememmory/Album/upload_photo_page.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/albumModel.dart';

class CreateAlbumModal extends StatefulWidget {
  const CreateAlbumModal({super.key});

  @override
  State<CreateAlbumModal> createState() => _CreateAlbumModalState();
}

class _CreateAlbumModalState extends State<CreateAlbumModal> {
  // แยกเก็บข้อมูลตามปี เพื่อความแม่นยำในการเช็ค
  List<AlbumModel> _albums2025 = [];
  List<AlbumModel> _albums2026 = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllYearsStatus();
  }

  // ✅ 1. ดึงข้อมูลของทั้งปี 2025 และ 2026 มาเตรียมไว้
  Future<void> _fetchAllYearsStatus() async {
    try {
      // ดึงปี 2025
      final list2025 = await HomeService.getAlbums(year: '2025');
      // ดึงปี 2026
      final list2026 = await HomeService.getAlbums(year: '2026');

      if (mounted) {
        setState(() {
          _albums2025 = list2025;
          _albums2026 = list2026;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching albums: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ Helper: แปลงค่าเดือนจาก API (int/String) เป็นชื่อเดือนภาษาไทยเพื่อเปรียบเทียบ
  String _getThaiMonthName(dynamic monthInput) {
    const List<String> thaiMonths = [
      "", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
      "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
    ];
    try {
      int monthNum = 0;
      if (monthInput is int) {
        monthNum = monthInput;
      } else {
        monthNum = int.tryParse(monthInput.toString()) ?? 0;
      }
      if (monthNum >= 1 && monthNum <= 12) {
        return thaiMonths[monthNum];
      }
      return monthInput.toString(); 
    } catch (e) {
      return monthInput.toString();
    }
  }

  // ✅ 2. ฟังก์ชันเช็คสถานะที่แม่นยำขึ้น (เช็คทั้งชื่อเดือน และ ปี)
  bool _checkIfMonthCompleted(String fullDateString) {
    // Input: "มกราคม 2026"
    // แยกส่วน: parts = ["มกราคม", "2026"]
    final parts = fullDateString.split(' ');
    if (parts.length < 2) return false;

    final String targetMonthName = parts[0]; // "มกราคม"
    final String targetYear = parts[1];      // "2026"

    // เลือก List ข้อมูลให้ตรงกับปี
    List<AlbumModel> targetList = (targetYear == '2026') ? _albums2026 : _albums2025;

    // ค้นหาว่ามีอัลบั้มนี้อยู่หรือไม่
    // โดยการแปลงเดือนใน API ให้เป็นภาษาไทยก่อน แล้วเทียบกับ targetMonthName
    final bool exists = targetList.any((album) {
      String dbMonthName = _getThaiMonthName(album.month);
      // เงื่อนไข: ชื่อเดือนตรงกัน และมีรูปภาพ (ถือว่าสร้างแล้ว)
      return dbMonthName == targetMonthName && (album.photos != null && album.photos!.isNotEmpty);
    });

    return exists;
  }

  @override
  Widget build(BuildContext context) {
    // รายชื่อเดือนทั้งหมดที่จะแสดง
    final List<String> allMonths = [
      "มกราคม 2026",
      "ธันวาคม 2025", "พฤศจิกายน 2025", "ตุลาคม 2025",
      "กันยายน 2025", "สิงหาคม 2025", "กรกฎาคม 2025",
      "มิถุนายน 2025", "พฤษภาคม 2025", "เมษายน 2025",
      "มีนาคม 2025", "กุมภาพันธ์ 2025", "มกราคม 2025"
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          // --- Slide Indicator ---
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // --- Header ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
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

          // --- Credit Info ---
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

          // --- List of Months ---
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: allMonths.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                    itemBuilder: (context, index) {
                      final monthName = allMonths[index];
                      
                      // เช็คสถานะว่าอัปโหลดเสร็จหรือยัง
                      final bool isDone = _checkIfMonthCompleted(monthName);

                      return _AlbumOptionItem(
                        month: monthName,
                        // ✅ ถ้าเสร็จแล้วแสดง "สร้างอัลบั้มสำเร็จ", ถ้ายังแสดง "สร้างอัลบั้ม"
                        statusText: isDone ? "สร้างอัลบั้มสำเร็จ" : "สร้างอัลบั้ม",
                        isDone: isDone,
                        onTap: () {
                           // ✅ ถ้าเสร็จแล้ว ห้ามกด (isDone เป็น true)
                           // ถ้ายังไม่เสร็จ ให้ส่งค่ากลับไปหน้า FirstPage เพื่อเริ่ม process
                           if (!isDone) {
                             Navigator.pop(context, monthName); 
                           }
                        },
                      );
                    },
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
  final VoidCallback onTap;

  const _AlbumOptionItem({
    required this.month,
    required this.statusText,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDone ? null : onTap, // ✅ Disable tap ถ้าเสร็จแล้ว
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อเดือน
                Text(
                  month, 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500, 
                    // ถ้าเสร็จแล้วอาจจะให้สีจางลงนิดหน่อย หรือสีดำปกติก็ได้ตามดีไซน์
                    color: Colors.black87 
                  )
                ),
                const SizedBox(height: 4),
                // ข้อความสถานะ
                Text(
                  statusText, 
                  style: TextStyle(
                    fontSize: 13, 
                    // ✅ ถ้าเสร็จแล้วเป็นสีเขียว (#66BB6A), ถ้ายังเป็นสีเทา
                    color: isDone ? const Color(0xFF66BB6A) : const Color(0xFF66BB6A) // สีเขียวทั้งคู่ตามภาพ? หรือปกติอันล่างเป็นสีเทา? 
                    // ตาม UX ปกติ: ถ้าเสร็จแล้ว = เขียว, ถ้ายัง = สีเทาหรือสี Theme(ส้ม)
                    // แก้ไข: ให้ "สร้างอัลบั้มสำเร็จ" เป็นสีเขียว, "สร้างอัลบั้ม" เป็นสีส้มหรือเทา
                  )
                ),
              ],
            ),
            // ✅ แสดงไอคอนติ๊กถูกสีเขียว ถ้าเสร็จแล้ว
            if (isDone) 
              const Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 24)
            // else
            //   // ถ้ายังไม่เสร็จ อยากแสดง icon อื่นไหม? (เช่น chevron_right) ถ้าไม่ก็ปล่อยว่างไว้
            //   const Icon(Icons.chevron_right, color: Colors.grey, size: 24) 
          ],
        ),
      ),
    );
  }
}