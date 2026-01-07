import 'package:flutter/material.dart';
import 'package:wememmory/Album/upload_photo_page.dart'; // Import หน้า Upload
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/albumModel.dart';
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/widgets/FormNum.dart';

class CreateAlbumModal extends StatefulWidget {
  final Map<String, List<MediaItem>> existingDrafts;
  const CreateAlbumModal({super.key, required this.existingDrafts});

  @override
  State<CreateAlbumModal> createState() => _CreateAlbumModalState();
}

class _CreateAlbumModalState extends State<CreateAlbumModal> {
  // เปลี่ยนมาใช้ Map เพื่อเก็บข้อมูลหลายๆ ปี (Key = ปี ค.ศ., Value = รายการอัลบั้ม)
  final Map<int, List<AlbumModel>> _cachedAlbums = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllYearsStatus();
  }

  //  ดึงข้อมูลย้อนหลัง 4 ปีปฏิทิน (เพื่อให้ครอบคลุม 36 เดือน)
  Future<void> _fetchAllYearsStatus() async {
    try {
      final currentYearAD = DateTime.now().year;

      // รายการปีที่ต้องดึง (ปีปัจจุบัน และย้อนหลังไป 3 ปี)
      // เช่น ถ้าปี 2025 จะดึง: 2025, 2024, 2023, 2022
      List<int> yearsToFetch = [
        currentYearAD,
        currentYearAD - 1,
        currentYearAD - 2,
        currentYearAD - 3,
      ];

      // ดึงข้อมูลแบบ Parallel (พร้อมกัน) เพื่อความรวดเร็ว
      await Future.wait(
        yearsToFetch.map((year) async {
          try {
            final albums = await HomeService.getAlbums(year: '$year');
            if (mounted) {
              setState(() {
                _cachedAlbums[year] = albums;
              });
            }
          } catch (e) {
            debugPrint("Error fetching albums for year $year: $e");
          }
        }),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Global error fetching albums: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  //เพิ่มฟังก์ชันสำหรับเปิดหน้า UploadPhotoPage โดยตรง
  void _openUploadPage(String monthName) async {
    // A. เช็คว่ามี Draft ของเดือนนี้ไหม
    List<MediaItem>? currentDraft;
    if (widget.existingDrafts.containsKey(monthName)) {
      currentDraft = widget.existingDrafts[monthName];
    }

    // B. ✅ ใช้ showModalBottomSheet เพื่อให้เป็น Sheet เหมือนเดิม
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ให้ขยายความสูงได้ตาม child widget
      backgroundColor: Colors.transparent, // ให้พื้นหลังใส เพื่อโชว์ขอบมน
      builder:
          (context) => UploadPhotoPage(
            selectedMonth: monthName,
            initialSelectedItems: currentDraft,
          ),
    );

    // C. เมื่อปิด Sheet ลงมา (ส่งค่ากลับ)
    if (result != null && result is List<MediaItem>) {
      if (mounted) {
        // ส่งคืนเป็น Map: {ชื่อเดือน, รูปภาพ} กลับไปให้ Recommended/FirstPage
        Navigator.pop(context, {'month': monthName, 'items': result});
      }
    }
  }

  String _getThaiMonthName(dynamic monthInput) {
    const List<String> thaiMonths = [
      "",
      "มกราคม",
      "กุมภาพันธ์",
      "มีนาคม",
      "เมษายน",
      "พฤษภาคม",
      "มิถุนายน",
      "กรกฎาคม",
      "สิงหาคม",
      "กันยายน",
      "ตุลาคม",
      "พฤศจิกายน",
      "ธันวาคม",
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

  // ✅ 2. ฟังก์ชันเช็คสถานะ (รองรับการค้นหาจาก Map)
  bool _checkIfMonthCompleted(String fullDateString) {
    // Input: "มกราคม 2568"
    final parts = fullDateString.split(' ');
    if (parts.length < 2) return false;

    final String targetMonthName = parts[0];
    final int targetYearBE = int.tryParse(parts[1]) ?? 0;
    final int targetYearAD = targetYearBE - 543; // แปลง พ.ศ. -> ค.ศ.

    // ดึง List ข้อมูลจาก Map ตามปี ค.ศ.
    List<AlbumModel>? targetList = _cachedAlbums[targetYearAD];

    // ถ้ายังไม่มีข้อมูลปีนั้น หรือ List ว่าง ให้ return false
    if (targetList == null || targetList.isEmpty) {
      return false;
    }

    // ค้นหาอัลบั้ม
    final bool exists = targetList.any((album) {
      String dbMonthName = _getThaiMonthName(album.month);
      return dbMonthName == targetMonthName &&
          (album.photos != null && album.photos!.isNotEmpty);
    });

    return exists;
  }

  // ✅ 3. สร้างรายการเดือนย้อนหลัง 36 เดือน
  List<String> _generateMonthList() {
    final now = DateTime.now();
    final List<String> thaiMonths = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    List<String> result = [];

    // วนลูปย้อนหลัง 36 เดือน
    for (int i = 0; i < 36; i++) {
      final targetDate = DateTime(now.year, now.month - i, 1);
      final monthName = thaiMonths[targetDate.month - 1];
      final yearBE = targetDate.year + 543; // พ.ศ.

      result.add("$monthName $yearBE");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allMonths = _generateMonthList();

    return Container(
      height:
          MediaQuery.of(context).size.height *
          0.85, // เพิ่มความสูงหน่อยเพราะรายการยาวขึ้น
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
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
                    fontFamily: "Kanit",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
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
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: allMonths.length,
                      separatorBuilder:
                          (context, index) => const Divider(
                            height: 1,
                            indent: 24,
                            endIndent: 24,
                            color: Colors.black12,
                          ),
                      itemBuilder: (context, index) {
                        final monthName = allMonths[index];

                        final bool isDone = _checkIfMonthCompleted(monthName);

                        return _AlbumOptionItem(
                          month: monthName,
                          statusText:
                              isDone ? "สร้างอัลบั้มสำเร็จ" : "สร้างอัลบั้ม",
                          isDone: isDone,
                          onTap: () {
                            if (!isDone) {
                              _openUploadPage(monthName);
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
      onTap: isDone ? null : onTap,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDone ? const Color(0xFF66BB6A) : Colors.black87,
                  ),
                ),
              ],
            ),
            if (isDone)
              Image.asset(
                'assets/icons/createSuccess.png', // เปลี่ยนเป็น Check.png ตามที่คุณใช้
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }
}
