import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
// ตรวจสอบ path import ให้ตรงกับโปรเจกต์ของคุณ
import 'package:wememmory/Album/album_layout_page.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/models/media_item.dart';

class UploadPhotoPage extends StatefulWidget {
  final String selectedMonth;
  final List<MediaItem>? initialSelectedItems;

  const UploadPhotoPage({
    super.key,
    required this.selectedMonth,
    this.initialSelectedItems,
  });

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final List<MediaItem> mediaList = [];
  final List<MediaItem> selectedItems = [];
  final Map<String, Future<Uint8List?>> _thumbnailFutures = {};

  // Album Variables
  List<AssetPathEntity> albumList = [];
  AssetPathEntity? currentAlbum;

  bool showThisMonthOnly = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedItems != null) {
      selectedItems.addAll(widget.initialSelectedItems!);
    }
    _initAndLoadAlbums();
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  Future<void> _initAndLoadAlbums() async {
    setState(() => isLoading = true);
    final ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      PhotoManager.openSetting();
      setState(() => isLoading = false);
      return;
    }

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: true,
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

    setState(() {
      albumList = albums;
      currentAlbum = albums.first;
    });

    _loadAssetsFromCurrentAlbum();
  }

  Future<void> _loadAssetsFromCurrentAlbum() async {
    if (currentAlbum == null) return;

    setState(() => isLoading = true);

    const int pageSize = 1000;
    List<AssetEntity> assets =
        await currentAlbum!.getAssetListPaged(page: 0, size: pageSize);

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
    _loadAssetsFromCurrentAlbum();
  }

  void _toggleSelection(MediaItem item) {
    setState(() {
      final existingIndex = selectedItems.indexWhere((s) => s.asset.id == item.asset.id);
      if (existingIndex != -1) {
        selectedItems.removeAt(existingIndex);
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
    if (selectedItems.isEmpty) return;

    if (selectedItems.length == 11) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AlbumLayoutPage(
          selectedItems: selectedItems,
          monthName: widget.selectedMonth,
        ),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FirstPage(
            initialIndex: 0,
            newAlbumItems: selectedItems,
            newAlbumMonth: widget.selectedMonth,
          ),
        ),
        (route) => false,
      );
    }
  }

  // ✅ ฟังก์ชันแสดง Modal เลือกอัลบั้ม (ธีมสีขาว)
  void _showIGStyleAlbumPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white, // ✅ พื้นหลังสีขาว
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // --- Drag Handle ---
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // ✅ สีเทาอ่อน
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  
                  // --- Header ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "ยกเลิก",
                            style: TextStyle(color: Colors.black87, fontSize: 16), // ✅ สีดำ
                          ),
                        ),
                        const Text(
                          "เลือกอัลบั้ม",
                          style: TextStyle(
                            color: Colors.black, // ✅ สีดำ
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  
                  const Divider(color: Colors.grey, height: 1, thickness: 0.2), // ✅ เส้นแบ่งสีเทาจางๆ

                  // --- Album Grid ---
                  Expanded(
                    child: GridView.builder(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: albumList.length,
                      itemBuilder: (context, index) {
                        final album = albumList[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentAlbum = album;
                            });
                            _loadAssetsFromCurrentAlbum();
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // รูปหน้าปกอัลบั้ม
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12), // ปรับให้มนสวยขึ้น
                                  child: Container(
                                    color: Colors.grey[200], // ✅ พื้นหลังรูปโหลดเป็นสีเทาอ่อน
                                    child: _AlbumCover(album: album),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // ชื่ออัลบั้ม
                              Text(
                                album.name,
                                style: const TextStyle(
                                  color: Colors.black87, // ✅ สีดำ
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // จำนวนรูป
                              FutureBuilder<int>(
                                future: album.assetCountAsync,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      "${snapshot.data}",
                                      style: TextStyle(
                                        color: Colors.grey[600], // ✅ สีเทาเข้มขึ้น
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
          color: showThisMonthOnly
              ? const Color(0xFFED7D31)
              : const Color(0xFFE0E0E0),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          alignment:
              showThisMonthOnly ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: showThisMonthOnly ? Colors.white : const Color(0xFFC7C7C7),
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
          // Slide Indicator
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
                  onTap: () {
                    Navigator.pop(context);
                  },
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

          const SizedBox(height: 16),

          // Steps
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

          // Toggle Switch
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('เลือกแสดงเฉพาะเดือนนี้',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                _buildCustomSwitch(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'เลือก 11 ภาพที่สะท้อนเรื่องราวและความทรงจำของเดือนนี้',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),

          // ปุ่มเลือกอัลบั้ม (เปิด Modal)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: albumList.isNotEmpty ? _showIGStyleAlbumPicker : null,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentAlbum?.name ?? (isLoading ? "กำลังโหลด..." : "เลือกอัลบั้ม"),
                        style: const TextStyle(
                          color: Colors.black87, 
                          fontSize: 14, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),
          ),

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
                                      if (snapshot.hasData && snapshot.data != null) {
                                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
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
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
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
                                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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

// Widget โหลดรูปปกอัลบั้ม (ปรับไอคอนสำหรับธีมขาว)
class _AlbumCover extends StatelessWidget {
  final AssetPathEntity album;

  const _AlbumCover({required this.album});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetEntity>>(
      future: album.getAssetListRange(start: 0, end: 1),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final asset = snapshot.data!.first;
          return FutureBuilder<Uint8List?>(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, thumbSnapshot) {
              if (thumbSnapshot.hasData && thumbSnapshot.data != null) {
                return Image.memory(
                  thumbSnapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              }
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            },
          );
        }
        return const Icon(Icons.image_not_supported, color: Colors.grey); // ✅ ไอคอนสีเทา
      },
    );
  }
}

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
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 2,
                  color: isFirst
                      ? Colors.transparent
                      : (isActive ? const Color(0xFF5AB6D8) : Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 40),
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF5AB6D8) : Colors.grey[300],
                ),
              ),
              const SizedBox(width: 40),
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