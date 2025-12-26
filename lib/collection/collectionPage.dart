import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:wememmory/collection/month_detail_page.dart';
import 'package:wememmory/collection/share_sheet.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/data/album_data.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/albumModel.dart';
import 'package:wememmory/models/media_item.dart' hide AlbumCollection;
import 'package:wememmory/shop/chooseMediaItem.dart';
import 'package:wememmory/widgets/ApiExeption.dart';
import 'package:wememmory/widgets/dialog.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => CollectionPageState(); 
}

class CollectionPageState extends State<CollectionPage> {
  List<AlbumModel> albums = [];
  
  // เก็บเป็น ค.ศ. เพื่อส่ง API (เช่น "2025")
  String selectedYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAlbums();
    });
  }

  // ฟังก์ชันเรียก API (ส่ง ค.ศ. ไป)
  getAlbums() async {
    try {
      print(selectedYear);
      final albumData = await HomeService.getAlbums(year: selectedYear);
      if (mounted) {
        setState(() {
          albums = albumData;
        });
      }
    } on ClientException catch (e) {
      if (!mounted) return;
      _showErrorDialog('$e');
    } on ApiException catch (e) {
      if (!mounted) return;
      _showErrorDialog('$e');
    } on SocketException {
       if (!mounted) return;
      _showErrorDialog('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
    } on TimeoutException {
       if (!mounted) return;
      _showErrorDialog('คำขอหมดเวลา โปรดลองอีกครั้ง');
    } on Exception catch (e) {
      if (!mounted) return;
      _showErrorDialog('เกิดข้อผิดพลาด: $e');
    }
  }

  void updateYearAndRefresh(String year) {
    if (selectedYear != year) {
      setState(() {
        selectedYear = year;
      });
    }
    getAlbums(); 
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => DialogError(
        title: message,
        pressYes: () {
          Navigator.pop(context, true);
        },
      ),
    );
  }

  String _getThaiMonth(dynamic monthInput) {
    const List<String> thaiMonths = [
      "", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
      "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
    ];
    try {
      int monthNum;
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

  // ✅ Helper Function: แปลง ค.ศ. -> พ.ศ.
  String _convertToBuddhistYear(String yearAD) {
    int? year = int.tryParse(yearAD);
    if (year != null) {
      return (year + 543).toString();
    }
    return yearAD;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ❌ เอา SafeArea ตัวใหญ่ออก เพื่อให้พื้นที่ด้านล่างทะลุลงไปได้
      body: Column(
        children: [
          // ✅ 1. ใส่ SafeArea เฉพาะส่วนหัว (bottom: false)
          Container(
            color: Colors.white, // กันพื้นหลังโปร่งใสช่วง Status Bar
            child: SafeArea(
              bottom: false, // ให้ด้านล่างทะลุได้
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  children: [
                    _SearchBar(),
                    const SizedBox(height: 24),
                    _DynamicTabSelector(year: selectedYear),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ),
          
          // ✅ 2. ส่วน List รายการ
          Expanded(
            child: albums.isEmpty
                ? Center(
                    child: Text("ยังไม่มีคอลเลกชัน ปี $selectedYear",
                        style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    // ✅ 3. เพิ่ม padding ด้านล่างเยอะๆ (เช่น 120) เพื่อให้ item สุดท้ายพ้น BottomNavBar
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                    itemCount: albums.length,
                    cacheExtent: 500,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      final String thaiMonthName = _getThaiMonth(album.month);
                      final String titleWithYear = "$thaiMonthName $selectedYear";

                      return Column(
                        children: [
                          _MonthSectionHeader(
                              title: titleWithYear, items: album),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MonthDetailPage(
                                    monthName: titleWithYear,
                                    items: album.photos ?? [],
                                  ),
                                ),
                              );
                            },
                            child: _AlbumPreviewSection(
                                items: album, monthTitle: titleWithYear),
                          ),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget ส่วนประกอบย่อย
// ---------------------------------------------------------------------------

class _DynamicTabSelector extends StatelessWidget {
  final String year; // รับค่าปี พ.ศ. มาแสดง
  const _DynamicTabSelector({required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.orange, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              // ✅ แสดง "ปี 2568"
              child: Text("ปี $year", 
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Text("เดือน",
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: 16)))),
        ],
      ),
    );
  }
}

// ... (Widget อื่นๆ เหมือนเดิม: _MonthSectionHeader, _AlbumPreviewSection, _StaticPhotoSlot, _SearchBar) ...
// คุณสามารถก็อปปี้ส่วนที่เหลือจากไฟล์เดิมมาต่อท้ายได้เลยครับ เพราะไม่ได้มีการเปลี่ยนแปลง
class _MonthSectionHeader extends StatelessWidget {
  final String title;
  final AlbumModel? items;

  const _MonthSectionHeader({
    required this.title,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: _buildIconButton('assets/icons/print.png'),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ShareSheet(),
                );
              },
              child: _buildIconButton('assets/icons/share.png'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(String iconPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(10),
      child: Image.asset(iconPath,
          width: 20,
          height: 20,
          color: const Color(0xFF6BB0C5),
          fit: BoxFit.contain),
    );
  }
}

class _AlbumPreviewSection extends StatelessWidget {
  final AlbumModel items;
  final String monthTitle;

  const _AlbumPreviewSection({required this.items, required this.monthTitle});

  @override
  Widget build(BuildContext context) {
    final photos = items.photos ?? [];

    return Center(
      // 1. ใช้ Container สีเทาเป็นกรอบหลัก และกำหนดความกว้างให้ชัดเจน (หรือใช้ constraints)
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF555555), // พื้นหลังสีเทา
          borderRadius: BorderRadius.circular(4), // (Optional) ใส่โค้งมนนิดหน่อยให้สวย
        ),
        // 2. ใช้ IntrinsicWidth เพื่อให้กล่องสีเทาหดเท่ากับเนื้อหาข้างใน
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min, // ให้ Row หดสั้นที่สุดเท่าที่ทำได้
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- กล่องซ้าย (มีชื่อเดือน) ---
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero, // สำคัญ! เอา padding ของ GridView ออก
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Center(
                        child: Text(
                          monthTitle.split(' ')[0],
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    for (int i = 0; i < 5; i++)
                      if (i < photos.length)
                        _StaticPhotoSlot(item: photos[i].image!)
                      else
                        const SizedBox(),
                  ],
                ),
              ),
              
              const SizedBox(width: 20), // ระยะห่างระหว่าง 2 หน้า

              // --- กล่องขวา ---
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero, // สำคัญ! เอา padding ของ GridView ออก
                  children: [
                    for (int i = 0; i < 6; i++)
                      if ((i + 5) < photos.length)
                        _StaticPhotoSlot(item: photos[i + 5].image!)
                      else
                        const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // กำหนดขนาดกล่องย่อยให้เป๊ะๆ
  Widget _buildPageContainer({required Widget child}) {
    // คำนวณขนาด: (กว้างรูป x 2) + (ช่องว่าง x 1)
    // สมมติรูปกว้างประมาณ 78-80 
    return SizedBox(
      width: 160, 
      height: 245, 
      child: child
    );
  }
}

class _StaticPhotoSlot extends StatelessWidget {
  final String item;
  const _StaticPhotoSlot({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          color: Colors.grey[200],
          child: CachedNetworkImage(
            imageUrl: item,
            fit: BoxFit.cover,
            memCacheWidth: 250,
            maxWidthDiskCache: 250,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            placeholder: (context, url) => const ColoredBox(color: Color(0xFFEEEEEE)),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
          color: const Color(0x0D6BB0C5),
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset('assets/icons/Search.png',
              width: 18, height: 18, color: Colors.black),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontSize: 14.5),
              decoration: InputDecoration(
                  hintText: 'ค้นหาความทรงจำตามแท็กและโน้ต.....',
                  isDense: true,
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}