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

// ✅ 1. เปลี่ยนชื่อ State Class เป็น Public (ลบ _ ออก)
class CollectionPage extends StatefulWidget {
  // รับ Key จาก FirstPage ได้ (FirstPage จะส่ง GlobalKey มาที่นี่)
  const CollectionPage({super.key});

  @override
  // เปลี่ยน _CollectionPageState เป็น CollectionPageState (ลบ _ ข้างหน้า)
  State<CollectionPage> createState() => CollectionPageState(); 
}

// ✅ 2. เปลี่ยนชื่อ Class นี้ด้วย (ลบ _ ออก)
class CollectionPageState extends State<CollectionPage> {
  List<AlbumModel> albums = [];
  
  // ✅ ตัวแปรเก็บปีที่เลือก (เริ่มที่ปีปัจจุบัน)
  String selectedYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAlbums();
    });
  }

  // ✅ ฟังก์ชันเรียก API โดยใช้ selectedYear
  getAlbums() async {
    try {
      // เรียก Service โดยส่งปีที่เลือกไป
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

  // ✅✅ 3. ฟังก์ชันสำคัญ: ให้ FirstPage เรียกใช้ผ่าน GlobalKey เพื่อเปลี่ยนปีและรีเฟรช
  void updateYearAndRefresh(String year) {
    // ถ้าปีเปลี่ยนให้เซ็ตค่าใหม่
    if (selectedYear != year) {
      setState(() {
        selectedYear = year;
      });
    }
    // สั่งโหลดข้อมูลใหม่ทันที (ไม่ว่าปีจะเปลี่ยนหรือไม่ เพื่อความชัวร์ว่าได้ข้อมูลล่าสุด)
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

  // เพิ่มฟังก์ชันแปลงเดือนเป็นภาษาไทย
  String _getThaiMonth(dynamic monthInput) {
    // รายชื่อเดือนภาษาไทย (index 0 เว้นว่างไว้ เพื่อให้ index 1 ตรงกับมกราคม)
    const List<String> thaiMonths = [
      "", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
      "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
    ];

    try {
      int monthNum;
      // แปลง input ให้เป็นตัวเลข (ไม่ว่าจะมาเป็น int หรือ String)
      if (monthInput is int) {
        monthNum = monthInput;
      } else {
        monthNum = int.tryParse(monthInput.toString()) ?? 0;
      }

      // เช็คว่าตัวเลขอยู่ในช่วง 1-12 หรือไม่
      if (monthNum >= 1 && monthNum <= 12) {
        return thaiMonths[monthNum];
      }
      return monthInput.toString(); // ถ้าไม่ใช่ 1-12 ให้คืนค่าเดิมกลับไป
    } catch (e) {
      return monthInput.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(children: [
                  _SearchBar(),
                  const SizedBox(height: 24),
                  
                  // ✅ แสดงปีที่เลือกใน TabSelector (ปรับแก้เล็กน้อยให้แสดงปีด้วย)
                  Container(
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
                            // ✅ แสดงปีที่เลือกตรงนี้
                            child: Text("ปี $selectedYear",
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
                  ),
                  
                  const SizedBox(height: 20)
                ])),
            Expanded(
              child: albums.isEmpty
                  ? Center(
                      child: Text("ยังไม่มีคอลเลกชัน ปี $selectedYear",
                          style: const TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                      itemCount: albums.length,
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        
                        final String thaiMonthName = _getThaiMonth(album.month);
                        
                        // ✅ แสดงชื่อเดือนคู่กับปีที่เลือก
                        final String titleWithYear = "$thaiMonthName $selectedYear";

                        return Column(
                          children: [
                            _MonthSectionHeader(
                                title: titleWithYear, items: album),
                            const SizedBox(height: 12),
                            GestureDetector(
                              // onTap: () {
                              //   // กดแล้วไปหน้ารายละเอียด ส่งชื่อพร้อมปีไปด้วย
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => MonthDetailPage(monthName: titleWithYear, items: album.photos ?? [])));
                              // },
                              child: _AlbumPreviewSection(
                                  items: album,
                                  monthTitle: titleWithYear), // แสดงที่หน้าปก
                            ),
                            const SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget ส่วนประกอบย่อย (คงเดิม)
// ---------------------------------------------------------------------------

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
    // ป้องกัน null safety
    final photos = items.photos ?? [];

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color(0xFF555555)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Center(
                            child: Text(monthTitle.split(' ')[0], // แสดงแค่ชื่อเดือนในกล่องเล็ก
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)))),
                    for (int i = 0; i < 5; i++)
                      if (i < photos.length)
                        _StaticPhotoSlot(item: photos[i].image!)
                      else
                        const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildPageContainer(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
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