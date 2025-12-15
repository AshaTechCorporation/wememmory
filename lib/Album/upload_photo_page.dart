import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart'; // ถ้าไม่ได้ใช้ในหน้านี้เอาออกได้ครับ แต่ผมคงไว้ตามเดิม
import 'package:wememmory/Album/album_layout_page.dart';
import 'package:wememmory/models/media_item.dart';

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
    List<AssetEntity> assets = await primaryAlbum.getAssetListPaged(page: 0, size: pageSize);

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
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
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
          // ---------------------------------------------------------
          // [ส่วนที่เพิ่ม] : Slide Indicator (แถบขีดด้านบน)
          // ---------------------------------------------------------
          const SizedBox(height: 12), // ระยะห่างจากขอบบนสุด
          Container(
            width: 61, // ความกว้างของขีด
            height: 5, // ความหนาของขีด
            decoration: BoxDecoration(
              color: Colors.grey[300], // สีเทาอ่อน
              borderRadius: BorderRadius.circular(2.5), // ความมน
            ),
          ),
          // ---------------------------------------------------------

          // Header
          Padding(
            // ปรับ padding ด้านบนเป็น 10 (จากเดิม 20) เพื่อชดเชยกับพื้นที่ของขีดด้านบน
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${widget.selectedMonth.split(' ')[0]} : เลือก ${selectedItems.length} ของคุณ',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Steps
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                const Text('เลือกแสดงเฉพาะเดือนนี้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Switch(
                  value: showThisMonthOnly,
                  onChanged: _toggleThisMonth,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFFED7D31),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: const Color(0xFFE0E0E0),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: mediaList.length,
                        itemBuilder: (context, index) {
                          final item = mediaList[index];
                          final selectionIndex = selectedItems.indexOf(item);
                          final isSelected = selectionIndex != -1;

                          final future = _thumbnailFutures[item.asset.id] ??=
                              item.asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));

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
                                      if (snapshot.hasData && snapshot.data != null) {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                      return Container(color: Colors.grey.shade200);
                                    },
                                  ),
                                ),

                                if (item.type == MediaType.video)
                                  Positioned(
                                    bottom: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                                      border: Border.all(color: const Color(0xFF5AB6D8), width: 3),
                                    ),
                                  ),

                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF5AB6D8) : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
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

          // Bottom Bar (ปุ่มถัดไป)
          Container(
            padding: const EdgeInsets.all(16),
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
                  backgroundColor: selectedItems.isNotEmpty ? const Color(0xFF5AB6D8) : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(12), // เพิ่ม BorderRadius ให้ปุ่มมนขึ้นเล็กน้อย
                  ),
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

class _StepItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const _StepItem({
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
          Row(
            children: [
              Expanded(
                  child: Container(
                      height: 2,
                      color: isFirst
                          ? Colors.transparent
                          : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]))),
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300])),
              Expanded(
                  child: Container(
                      height: 2,
                      color: isLast ? Colors.transparent : Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[400],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}