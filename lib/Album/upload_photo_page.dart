import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:wememmory/Album/album_layout_page.dart';
import 'package:wememmory/models/media_item.dart';

// หน้าการอัปโหลดรูปภาพจากอุปกรณ์
class UploadPhotoPage extends StatefulWidget {
  final String selectedMonth;

  const UploadPhotoPage({super.key, required this.selectedMonth});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final List<MediaItem> mediaList = [];
  final List<MediaItem> selectedItems = [];
  final Map<String, Future<Uint8List?>> _thumbnailFutures = {};

  bool showThisMonthOnly = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllMediaFromDevice();
  }

  // ฟังก์ชันจัดรูปแบบเวลา
  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  // ฟังก์ชันการดึงข้อมูลจากเครื่อง
  Future<void> _loadAllMediaFromDevice() async {
    setState(() => isLoading = true);
    final ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      PhotoManager.openSetting();
      setState(() => isLoading = false);
      return;
    }

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      onlyAll: true,
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    if (albums.isEmpty) {
      setState(() {
        mediaList.clear();
        isLoading = false;
      });
      return;
    }

    final AssetPathEntity primaryAlbum = albums.first;
    const int pageSize = 1000;
    List<AssetEntity> assets =
        await primaryAlbum.getAssetListPaged(page: 0, size: pageSize);

    if (showThisMonthOnly) {
      final now = DateTime.now();
      assets = assets.where((a) {
        final dt = a.createDateTime;
        return dt.year == now.year && dt.month == now.month;
      }).toList();
    }

    final List<MediaItem> temp = assets.map((a) {
      return MediaItem(
        asset: a,
        type: a.type == AssetType.video ? MediaType.video : MediaType.image,
      );
    }).toList();

    setState(() {
      mediaList.clear();
      mediaList.addAll(temp);
      _thumbnailFutures.clear();
      isLoading = false;
    });
  }


  
  void _toggleThisMonth(bool value) {
    setState(() {
      showThisMonthOnly = value;
    });
    _loadAllMediaFromDevice();
  }

  void _toggleSelection(MediaItem item) {
    setState(() {
      // 🔍 ค้นหาว่ารูปนี้ (ดูจาก ID) เคยถูกเลือกหรือยัง
      final existingIndex = selectedItems.indexWhere((s) => s.asset.id == item.asset.id);

      if (existingIndex != -1) {
        // ✅ ถ้ามีอยู่แล้ว ให้ลบตัวเดิมออก (ใช้ index ลบ)
        selectedItems.removeAt(existingIndex);
      } else {
        // ✅ ถ้ายังไม่มี ให้เพิ่มเข้าไป
        if (selectedItems.length < 11) {
          selectedItems.add(item);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('เลือกได้สูงสุด 11 ไฟล์เท่านั้น'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    });
  }

  void _onNextPressed() {
    if (selectedItems.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AlbumLayoutPage(
          selectedItems: selectedItems,
          monthName: widget.selectedMonth,
        ),
      );
    }
  }

  
  // ปุ่ม Switch Widget
  
  Widget _buildCustomSwitch() {
    return GestureDetector(
      onTap: () => _toggleThisMonth(!showThisMonthOnly),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // พื้นหลัง: สีส้ม (เปิด) / สีเทาอ่อน (ปิด)
          color: showThisMonthOnly
              ? const Color(0xFFED7D31)
              : const Color(0xFFE0E0E0),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          // สลับตำแหน่งซ้าย-ขวา
          alignment:
              showThisMonthOnly ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // [แก้ไข]: วงกลมเป็นสีขาวเมื่อเปิด, เป็นสีเทาเมื่อปิด
              color: showThisMonthOnly ? Colors.white : Color(0xFFC7C7C7), 
              // boxShadow: [
              //   BoxShadow(
              //     color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.1),
              //     blurRadius: 2,
              //     offset: const Offset(0, 1),
              //   ),
              // ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          
          // ปุ่มขีด Slide Indicator
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
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${widget.selectedMonth.split(' ')[0]} : เลือก ${selectedItems.length} ของคุณ',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/icons/cross.png', // อ้างอิง Path ในโปรเจกต์
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Steps (Process Bar)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              children: [
                _StepItem(label: 'เลือกรูปภาพ', isActive: true, isFirst: true),
                _StepItem(label: 'แก้ไขและจัดเรียง', isActive: false),
                _StepItem(label: 'พรีวิวสุดท้าย', isActive: false, isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('เลือกแสดงเฉพาะเดือนนี้',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                // เรียกใช้ Widget Custom Switch ที่สร้างไว้ด้านบน
                _buildCustomSwitch(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0 , vertical: 3),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'เลือก 11 ภาพที่สะท้อนเรื่องราวและความทรงจำของเดือนนี้',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Media Grid
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : mediaList.isEmpty
                    ? const Center(child: Text("ไม่พบรูปภาพ"))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: mediaList.length,
                        itemBuilder: (context, index) {
                          final item = mediaList[index];
                          final selectionIndex = selectedItems.indexWhere((s) => s.asset.id == item.asset.id);
                          final isSelected = selectionIndex != -1;
                          final future = _thumbnailFutures[item.asset.id] ??=
                          item.asset.thumbnailDataWithSize(
                          const ThumbnailSize(200, 200));
                          return GestureDetector(
                            onTap: () => _toggleSelection(item),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: FutureBuilder<Uint8List?>(
                                    future: future,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                      return Container(
                                          color: Colors.grey.shade200);
                                    },
                                  ),
                                ),
                                if (item.type == MediaType.video)
                                  Positioned(
                                    bottom: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _formatDuration(item.asset.duration),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (isSelected)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFF5AB6D8),
                                          width: 3),
                                    ),
                                  ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF5AB6D8)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Text(
                                              '${selectionIndex + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedItems.isNotEmpty ? _onNextPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItems.isNotEmpty
                      ? const Color(0xFF5AB6D8)
                      : Colors.grey[400],
                  shape: const RoundedRectangleBorder(),
                  elevation: 0,
                ),
                child: Text(
                  'ถัดไป: เพิ่มโน้ตรูปภาพ (${selectedItems.length}/11)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// _StepItem (แก้ไขให้เส้นแยกออกจากจุด)
class _StepItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const _StepItem({
    super.key,
    required this.label,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // แถวของเส้นและวงกลม
          Row(
            children: [
              // เส้นด้านซ้าย
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color: isFirst
                      ? Colors.transparent
                      : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]),
                ),
              ),
              // ช่องว่างซ้าย (เพื่อให้เส้นไม่ติดจุด)
              const SizedBox(width: 40),
              // วงกลม (ขนาด 11x11)
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300],
                ),
              ),
              // ช่องว่างขวา (เพื่อให้เส้นไม่ติดจุด)
              const SizedBox(width: 40),
              // เส้นด้านขวา
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color: isLast ? Colors.transparent : Colors.grey[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // ข้อความด้านล่าง
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}