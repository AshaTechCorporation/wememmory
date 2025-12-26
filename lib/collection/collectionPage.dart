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

// หน้า สมุดภาพ
class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<AlbumModel> albums = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAlbums();
    });
  }

  getAlbums() async {
    try {
      final album1 = await HomeService.getAlbums();
      if (mounted) {
        setState(() {
          albums = album1;
        });
      }
    } on ClientException catch (e) {
      if (!mounted) return;
      _showErrorDialog('$e');
    } on ApiException catch (e) {
      if (!mounted) return;
      _showErrorDialog('$e');
    } on Exception catch (e) {
      if (!mounted) return;
      _showErrorDialog('$e');
    }
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
                  const _TabSelector(),
                  const SizedBox(height: 20)
                ])),
            Expanded(
              child: albums.isEmpty
                  ? const Center(
                      child: Text("ยังไม่มีคอลเลกชัน",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                      itemCount: albums.length,
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        
                        // ✅ แปลงค่าเดือนเป็นภาษาไทยเก็บไว้ในตัวแปร
                        final String thaiMonthName = _getThaiMonth(album.month);

                        return Column(
                          children: [
                            // ✅ ใช้ตัวแปรภาษาไทยที่แปลงแล้ว
                            _MonthSectionHeader(
                                title: thaiMonthName, items: album),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => MonthDetailPage(monthName: album.month, items: album.items)));
                              },
                              // ✅ ใช้ตัวแปรภาษาไทยที่แปลงแล้ว
                              child: _AlbumPreviewSection(
                                  items: album,
                                  monthTitle: thaiMonthName),
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
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color(0xFF555555)),
          // 🚀 Optimization: ลบ IntrinsicWidth ออก เพราะ Container ลูกมีขนาดตายตัวอยู่แล้ว (ช่วยลดการคำนวณ Layout)
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
                            child: Text(monthTitle,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)))),
                    for (int i = 0; i < 5; i++)
                      if (i < items.photos!.length)
                        _StaticPhotoSlot(item: items.photos![i].image!)
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
                      if ((i + 5) < items.photos!.length)
                        _StaticPhotoSlot(item: items.photos![i + 5].image!)
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

// ✅ ปรับจูนให้เร็วสุดๆ
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
            
            // 🚀 เทคนิค 1: ลดขนาด Cache ทั้งใน RAM และ Disk
            // ช่วยให้เปิดแอปครั้งถัดไปเร็วขึ้นมากๆ เพราะไฟล์ที่บันทึกไว้เล็กนิดเดียว
            memCacheWidth: 250, 
            maxWidthDiskCache: 250, 
            
            // 🚀 เทคนิค 2: ปิด Animation Fade-in
            // ทำให้รูปรู้สึก "เด้ง" มาทันทีที่โหลดเสร็จ ไม่ต้องรอค่อยๆ ชัด
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,

            // 🚀 เทคนิค 3: Placeholder แบบธรรมดา (สีเทา)
            // การไม่ใส่ Loading หมุนๆ ในรูปเล็กๆ ช่วยลดการใช้ CPU ได้ถ้ามีรูปเยอะมากๆ
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

class _TabSelector extends StatelessWidget {
  const _TabSelector();
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
              child: const Text("ปี",
                  style: TextStyle(
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