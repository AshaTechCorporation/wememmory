import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // ✅ จำเป็นต้อง import ตัวนี้
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/order_success_page.dart';
import 'package:wememmory/Album/photo_readonly_page.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/login/memeship_login.dart';
import 'package:wememmory/login/service/LoginService.dart';
import 'package:wememmory/models/media_item.dart';
import 'package:wememmory/models/photo_item.dart';
import 'package:wememmory/profile/historyPayment.dart';
import 'package:wememmory/widgets/ApiExeption.dart';
import 'package:wememmory/widgets/LoadingDialog.dart';
import 'package:wememmory/widgets/dialog.dart';

class PrintSheet extends StatefulWidget {
  final List<MediaItem> items;
  final String monthName;

  const PrintSheet({super.key, required this.items, required this.monthName});

  @override
  State<PrintSheet> createState() => _PrintSheetState();
}

class _PrintSheetState extends State<PrintSheet> {
  bool _isGift = false;

  // ✅ Helper Function: เขียน Bytes ลงไฟล์ชั่วคราว (เพื่อส่ง API)
  Future<File> _writeBytesToTempFile(Uint8List bytes, int index) async {
    final tempDir = await getTemporaryDirectory();
    // ตั้งชื่อไฟล์ไม่ให้ซ้ำกันด้วย timestamp และ index
    final tempFile = File(
      '${tempDir.path}/upload_temp_${DateTime.now().millisecondsSinceEpoch}_$index.jpg',
    );
    return await tempFile.writeAsBytes(bytes);
  }

  int _getYearFromMonthName(String monthNameString) {
    try {
      final RegExp yearRegex = RegExp(r'\d{4}');
      final Iterable<Match> matches = yearRegex.allMatches(monthNameString);

      if (matches.isNotEmpty) {
        String yearStr = matches.last.group(0)!;
        int yearVal = int.parse(yearStr);

        if (yearVal > 2400) {
          return yearVal - 543;
        } else if (yearVal > 2000) {
          return yearVal;
        }
      }
    } catch (e) {
      print("Error parsing year: $e");
    }
    return DateTime.now().year;
  }

  int thaiMonthToNumber(String monthName) {
    const List<String> months = [
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
    for (int i = 0; i < months.length; i++) {
      if (monthName.contains(months[i])) {
        return i + 1;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 61,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'สั่งพิมพ์',
                  style: TextStyle(
                    fontFamily: "Kanit",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 16 / 20,
                    letterSpacing: 0,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/icons/cross.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
            indent: 20,
            endIndent: 20,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "อัลบั้มรูปของคุณ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 16 / 20,
                    ),
                  ),
                  const SizedBox(height: 18),

                  _PrintPreviewSection(
                    items: widget.items,
                    monthName: widget.monthName,
                  ),

                  const SizedBox(height: 24),
                  _buildAddressCard(
                    title: "ที่อยู่",
                    address:
                        "หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง\nแขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร",
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ส่งของขวัญ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      _buildCustomSwitch(
                        _isGift,
                        (val) => setState(() => _isGift = val),
                      ),
                    ],
                  ),

                  if (_isGift) ...[
                    const SizedBox(height: 20),
                    _buildAddressCard(
                      title: "ที่อยู่ผู้รับของขวัญ",
                      address: "กรุณาเลือกที่อยู่ผู้รับ...",
                    ),
                  ],

                  const SizedBox(height: 20),
                  // Credit Box
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF67A5BA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "ยอดเครดิตคงเหลือ : ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/dollar-circle.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "10",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "เติมเครดิตตามจำนวนที่คุณต้องการ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MembershipPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF67A5BA),
                            minimumSize: const Size(80, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "เติมเครดิต",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "รายละเอียดการสั่งพิมพ์",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "อัลบั้มรูปของคุณ",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/dollar-circle.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "10",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar (ปุ่มยืนยัน)
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 16, 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "เครดิตที่ต้องใช้",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/icons/dollar-circle.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "10",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 140,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      // -------------------------------------------------------------
                      // ✅ START: แก้ไข Logic การอัปโหลดไฟล์ (ป้องกัน Video Error 500)
                      // -------------------------------------------------------------
                      try {
                        LoadingDialog.open(context);

                        List<PhotoItem> photoAPI = [];
                        if (widget.items.isNotEmpty) {
                          for (var i = 0; i < widget.items.length; i++) {
                            final item = widget.items[i];
                            File? fileToUpload;

                            // LOGIC 1: มีรูปที่แคปมาแล้ว (หรือรูปแต่ง) -> ใช้รูปนั้น
                            if (item.capturedImage != null) {
                              fileToUpload = await _writeBytesToTempFile(
                                item.capturedImage!,
                                i,
                              );
                            }
                            // LOGIC 2: เป็นวิดีโอ และยังไม่ได้แคปรูป (capturedImage == null)
                            // -> ให้ดึง Thumbnail คุณภาพสูงมาสร้างไฟล์แทน
                            else if (item.type == MediaType.video) {
                              print(
                                "Generating auto-thumbnail for video item $i",
                              );
                              final Uint8List? videoThumb = await item.asset
                                  .thumbnailDataWithSize(
                                    const ThumbnailSize(
                                      1080,
                                      1920,
                                    ), // ขอขนาดใหญ่สุด
                                    quality: 90,
                                  );

                              if (videoThumb != null) {
                                fileToUpload = await _writeBytesToTempFile(
                                  videoThumb,
                                  i,
                                );
                              } else {
                                print(
                                  "⚠️ Warning: Failed to generate thumbnail for video",
                                );
                              }
                            }
                            // LOGIC 3: เป็นรูปภาพปกติ (ไม่ได้แต่ง) -> ใช้ไฟล์ต้นฉบับ
                            else {
                              fileToUpload = await item.asset.file;
                            }

                            // ทำการอัปโหลดเมื่อได้ไฟล์แล้ว
                            if (fileToUpload != null) {
                              final photoupload = await LoginService.addImage(
                                file: fileToUpload,
                                path: 'images/asset/',
                              );

                              final imageData = PhotoItem(
                                seq: i + 1,
                                image: photoupload,
                                caption: item.caption,
                              );
                              photoAPI.add(imageData);
                            } else {
                              print(
                                "❌ Error: File to upload is null at index $i",
                              );
                            }
                          }
                        }
                        // -------------------------------------------------------------
                        // ✅ END: จบส่วนแก้ไข Logic
                        // -------------------------------------------------------------

                        int yearToSend = _getYearFromMonthName(
                          widget.monthName,
                        );
                        int monthToSend = thaiMonthToNumber(widget.monthName);

                        print("🚀 --- FINAL SENDING TO API ---");
                        print("Month: $monthToSend");
                        print("Year: $yearToSend");

                        await HomeService.createOrder(
                          year: yearToSend,
                          month: monthToSend,
                          note: '',
                          photos: photoAPI,
                        );

                        if (!mounted) return;
                        LoadingDialog.close(context);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (context) => OrderSuccessPage(
                                items: widget.items,
                                monthName: widget.monthName,
                              ),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        LoadingDialog.close(context);
                        _showErrorDialog(context, '$e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7D31),
                      shape: const RoundedRectangleBorder(),
                      elevation: 0,
                    ),
                    child: const Text(
                      "สั่งพิมพ์",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => DialogError(
            title: message,
            pressYes: () => Navigator.pop(context, true),
          ),
    );
  }

  Widget _buildAddressCard({required String title, required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSwitch(bool value, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? const Color(0xFFED7D31) : const Color(0xFFE0E0E0),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? Colors.white : const Color(0xFFC7C7C7),
            ),
          ),
        ),
      ),
    );
  }
}

// ... _PrintPreviewSection & _StaticPhotoSlot & _StepItem (คงเดิมไม่ต้องแก้)
class _PrintPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthName;
  const _PrintPreviewSection({required this.items, required this.monthName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color(0xFF555555)),
          child: IntrinsicWidth(
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
                          child: Text(
                            monthName.split(' ')[0],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      for (int i = 0; i < 5; i++)
                        if (i < items.length)
                          _StaticPhotoSlot(item: items[i], allItems: items)
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
                        if ((i + 5) < items.length)
                          _StaticPhotoSlot(item: items[i + 5], allItems: items)
                        else
                          const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }
}

class _StaticPhotoSlot extends StatefulWidget {
  final MediaItem item;
  final List<MediaItem> allItems;

  const _StaticPhotoSlot({
    super.key,
    required this.item,
    required this.allItems,
  });

  @override
  State<_StaticPhotoSlot> createState() => _StaticPhotoSlotState();
}

class _StaticPhotoSlotState extends State<_StaticPhotoSlot> {
  Uint8List? _imageData;
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.item.capturedImage != null) {
      if (mounted) setState(() => _imageData = widget.item.capturedImage);
    } else {
      final data = await widget.item.asset.thumbnailDataWithSize(
        const ThumbnailSize(300, 300),
      );
      if (mounted) setState(() => _imageData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdited =
        widget.item.caption.isNotEmpty || widget.item.tags.isNotEmpty;

    return GestureDetector(
      onTap:
          isEdited
              ? () {
                List<MediaItem> editedItems =
                    widget.allItems.where((e) {
                      return e.caption.isNotEmpty || e.tags.isNotEmpty;
                    }).toList();

                int initialIndex = editedItems.indexOf(widget.item);

                if (initialIndex != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PhotoReadonlyPage(
                            items: editedItems,
                            initialIndex: initialIndex,
                          ),
                    ),
                  );
                }
              }
              : null,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            color: Colors.grey[200],
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_imageData != null)
                  Image.memory(_imageData!, fit: BoxFit.cover)
                else
                  Container(color: Colors.grey[200]),
                if (isEdited)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/alert.png',
                              width: 11,
                              height: 11,
                              color: Colors.white,
                              fit: BoxFit.contain,
                            ),
                            const Text(
                              "แตะเพื่ออ่าน",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
