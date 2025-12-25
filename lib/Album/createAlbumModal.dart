import 'package:flutter/material.dart';
import 'package:wememmory/Album/upload_photo_page.dart';
import 'package:wememmory/home/service/homeservice.dart'; // ✅ Import Service
import 'package:wememmory/models/albumModel.dart';       // ✅ Import Model

class CreateAlbumModal extends StatefulWidget {
  const CreateAlbumModal({super.key});

  @override
  State<CreateAlbumModal> createState() => _CreateAlbumModalState();
}

class _CreateAlbumModalState extends State<CreateAlbumModal> {
  // ตัวแปรเก็บรายการอัลบั้มที่ดึงมาจาก Server
  List<AlbumModel> _existingAlbums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbumStatus();
  }

  // ฟังก์ชันดึงข้อมูล (เลียนแบบ CollectionPage)
  Future<void> _fetchAlbumStatus() async {
    try {
      final albums = await HomeService.getAlbums();
      if (mounted) {
        setState(() {
          _existingAlbums = albums;
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

  // ฟังก์ชันเช็คสถานะของแต่ละเดือน
  // return true ถ้าเดือนนั้นมีอัลบั้มและมีรูปครบ 11 รูปแล้ว
  bool _checkIfMonthCompleted(String monthName) {
    // ค้นหาอัลบั้มที่ชื่อเดือนตรงกัน
    final foundAlbum = _existingAlbums.firstWhere(
      (album) => album.month == monthName,
      orElse: () => AlbumModel(month: null, photos: []), // คืนค่าว่างถ้าไม่เจอ
    );

    // เช็คเงื่อนไข: ต้องมีอัลบั้มจริง (month ไม่ว่าง) และมีรูป >= 11
    if (foundAlbum.month != '' && (foundAlbum.photos?.length ?? 0) >= 11) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // รายชื่อเดือนทั้งหมดที่จะแสดง (คุณอาจจะ Gen แบบ Dynamic ก็ได้)
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
                ? const Center(child: CircularProgressIndicator()) // แสดง Loading ระหว่างดึงข้อมูล
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: allMonths.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black12),
                    itemBuilder: (context, index) {
                      final monthName = allMonths[index];
                      
                      // ✅ เรียกใช้ฟังก์ชันตรวจสอบสถานะจริงจาก API
                      final bool isDone = _checkIfMonthCompleted(monthName);

                      return _AlbumOptionItem(
                        month: monthName,
                        statusText: isDone ? "สร้างอัลบั้มสำเร็จ" : "สร้างอัลบั้ม",
                        isDone: isDone,
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

  const _AlbumOptionItem({
    required this.month,
    required this.statusText,
    required this.isDone,
  });

  void _showUploadPhotoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UploadPhotoPage(selectedMonth: month),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDone ? null : () { // ถ้าเสร็จแล้ว (isDone = true) ห้ามกด
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (context.mounted) {
            _showUploadPhotoSheet(context);
          }
        });
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
                    color: isDone ? Colors.grey[600] : Colors.black87
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  statusText, 
                  style: TextStyle(
                    fontSize: 13, 
                    color: isDone ? const Color(0xFF66BB6A) : Colors.grey[600]
                  )
                ),
              ],
            ),
            // ✅ แสดงไอคอนติ๊กถูกถ้าเสร็จแล้ว
            if (isDone) const Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 24),
          ],
        ),
      ),
    );
  }
}