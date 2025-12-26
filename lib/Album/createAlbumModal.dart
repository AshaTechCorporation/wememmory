import 'package:flutter/material.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/albumModel.dart';

class CreateAlbumModal extends StatefulWidget {
  const CreateAlbumModal({super.key});

  @override
  State<CreateAlbumModal> createState() => _CreateAlbumModalState();
}

class _CreateAlbumModalState extends State<CreateAlbumModal> {
  // แยกเก็บข้อมูลตามปี เพื่อความแม่นยำในการเช็ค
  List<AlbumModel> _albumsCurrentYear = []; // ปีปัจจุบัน
  List<AlbumModel> _albumsPreviousYear = []; // ปีก่อนหน้า (เผื่อช่วงต้นปี)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllYearsStatus();
  }

  // ✅ 1. ดึงข้อมูลของปีปัจจุบันและปีก่อนหน้า (Dynamic)
  Future<void> _fetchAllYearsStatus() async {
    try {
      final currentYearAD = DateTime.now().year; // ปี ค.ศ. ปัจจุบัน
      
      // ดึงปีปัจจุบัน
      final listCurrent = await HomeService.getAlbums(year: '$currentYearAD');
      // ดึงปีก่อนหน้า (เผื่อ user เลือกดูย้อนหลัง)
      final listPrev = await HomeService.getAlbums(year: '${currentYearAD - 1}');

      if (mounted) {
        setState(() {
          _albumsCurrentYear = listCurrent;
          _albumsPreviousYear = listPrev;
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

  // ✅ Helper: แปลงค่าเดือนจาก API เป็นชื่อเดือนภาษาไทย
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

  // ✅ 2. ฟังก์ชันเช็คสถานะ (รองรับปี พ.ศ.)
  bool _checkIfMonthCompleted(String fullDateString) {
    // Input: "มกราคม 2568"
    final parts = fullDateString.split(' ');
    if (parts.length < 2) return false;

    final String targetMonthName = parts[0]; // "มกราคม"
    final int targetYearBE = int.tryParse(parts[1]) ?? 0; // 2568
    final int targetYearAD = targetYearBE - 543; // แปลงเป็น ค.ศ. (2025)

    final currentYearAD = DateTime.now().year;

    // เลือก List ข้อมูลให้ตรงกับปี
    List<AlbumModel> targetList;
    if (targetYearAD == currentYearAD) {
      targetList = _albumsCurrentYear;
    } else if (targetYearAD == currentYearAD - 1) {
      targetList = _albumsPreviousYear;
    } else {
      return false; // ไม่ได้โหลดข้อมูลปีนี้ไว้
    }

    // ค้นหาว่ามีอัลบั้มนี้อยู่หรือไม่
    final bool exists = targetList.any((album) {
      String dbMonthName = _getThaiMonthName(album.month);
      // เงื่อนไข: ชื่อเดือนตรงกัน และมีรูปภาพ
      return dbMonthName == targetMonthName && (album.photos != null && album.photos!.isNotEmpty);
    });

    return exists;
  }

  // ✅ ฟังก์ชันสร้างรายการเดือนย้อนหลัง (ตามที่คุณขอ)
  List<String> _generateMonthList() {
    final now = DateTime.now();
    final List<String> thaiMonths = [
      'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
      'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
    ];

    List<String> result = [];
    
    // วนลูปย้อนหลัง 12 เดือน (หรือตามต้องการ)
    // เริ่มจากเดือนปัจจุบัน ถอยหลังไปเรื่อยๆ
    for (int i = 0; i < 12; i++) {
      // คำนวณเดือนและปี โดยการลบเดือนออกจากวันปัจจุบัน
      // DateTime(year, month - i) จะจัดการเรื่องข้ามปีให้อัตโนมัติ (เช่น เดือน 1 - 1 = เดือน 12 ปีก่อนหน้า)
      final targetDate = DateTime(now.year, now.month - i, 1);
      
      final monthName = thaiMonths[targetDate.month - 1];
      final yearBE = targetDate.year + 543; // แปลง ค.ศ. เป็น พ.ศ.

      result.add("$monthName $yearBE");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ เรียกใช้ฟังก์ชันสร้างรายการเดือน
    final List<String> allMonths = _generateMonthList();

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

                      // เช็คสถานะ
                      final bool isDone = _checkIfMonthCompleted(monthName);

                      return _AlbumOptionItem(
                        month: monthName,
                        statusText: isDone ? "สร้างอัลบั้มสำเร็จ" : "สร้างอัลบั้ม",
                        isDone: isDone,
                        onTap: () {
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87
                  )
                ),
                const SizedBox(height: 4),
                // ข้อความสถานะ
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDone ? const Color(0xFF66BB6A) : Colors.black87,
                  )
                ),
              ],
            ),
            // ✅ แสดงรูปภาพ Check.png ถ้าเสร็จแล้ว
            if (isDone)
              Image.asset(
                'assets/icons/createSuccess.png', // ตรวจสอบชื่อไฟล์ให้ตรง
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              )
          ],
        ),
      ),
    );
  }
}