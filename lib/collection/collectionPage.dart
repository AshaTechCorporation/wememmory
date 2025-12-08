import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        toolbarHeight: 72,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage('assets/images/userpic.png'),
            backgroundColor: Colors.white.withOpacity(.25),
          ),
        ),
        titleSpacing: 1,
        title: Text(
          'korakrit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/icons/icon.png', width: 22, height: 22),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔎 Search bar ตามภาพ
              _SearchBar(),
              const SizedBox(height: 24), // เว้นระยะห่าง
              // 2. Tab Selector (ปุ่ม ปี / เดือน) ✅ เพิ่มตรงนี้
              const _TabSelector(),

              const SizedBox(height: 30),

              // 3. ส่วนเนื้อหาอื่นๆ (ตัวอย่างแสดงรายการเดือนเมษายน)
              const _MonthSectionHeader(title: "เมษายน 2025"),
              const SizedBox(height: 12),
              _PhotoGridLayout(
                leftTitle: "ตุลาคม",
                imageColors: [
                  Colors.green.shade200,
                  Colors.blue.shade200,
                  Colors.orange.shade200,
                  Colors.purple.shade200,
                  Colors.red.shade200,
                  Colors.teal.shade200,
                  Colors.amber.shade200,
                  Colors.pink.shade200,
                  Colors.indigo.shade200,
                  Colors.brown.shade200,
                  Colors.cyan.shade200,
                ],
              ),
              SizedBox(height: 20),
              const _MonthSectionHeader(title: "มีนาคม 2025"),
              const SizedBox(height: 12),
              _PhotoGridLayout(
                leftTitle: "ตุลาคม",
                imageColors: [
                  Colors.green.shade200,
                  Colors.blue.shade200,
                  Colors.orange.shade200,
                  Colors.purple.shade200,
                  Colors.red.shade200,
                  Colors.teal.shade200,
                  Colors.amber.shade200,
                  Colors.pink.shade200,
                  Colors.indigo.shade200,
                  Colors.brown.shade200,
                  Colors.cyan.shade200,
                ],
              ),

              // เพิ่มวิดเจ็ตอื่น ๆ ของหน้า Collection ต่อจากนี้ได้เลย…
            ],
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
        color: const Color.fromARGB(
          255,
          192,
          192,
          192,
        ).withOpacity(0.25), // โปร่งเหมือนภาพ
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset('assets/icons/Search.png', width: 18, height: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              cursorColor: const Color.fromARGB(255, 0, 0, 0),
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 14.5,
              ),
              decoration: InputDecoration(
                hintText: 'ค้นหาความทรงจำตามแท็กและโน้ต.....',
                // hintStyle: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 14.5),
                isDense: true,
                border: InputBorder.none,
              ),
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
      height: 48, // ความสูงปุ่ม
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // ขอบมน
        border: Border.all(color: Colors.grey.shade300), // เส้นขอบสีเทา
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ปุ่ม "ปี" (Selected - สีส้ม)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(
                4,
              ), // เว้นขอบเล็กน้อยเพื่อให้ดูเหมือนปุ่มลอย
              decoration: BoxDecoration(
                color: Colors.orange, // สีส้มตามภาพ
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "ปี",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // ปุ่ม "เดือน" (Unselected - สีขาว)
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "เดือน",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📅 Month Section Header
// -----------------------------------------------------------------
class _MonthSectionHeader extends StatelessWidget {
  final String title;
  const _MonthSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            _buildIconButton(Icons.print_outlined),
            const SizedBox(width: 8),
            _buildIconButton(Icons.share_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.blueGrey, size: 22),
    );
  }
}

// -----------------------------------------------------------------
// 🖼️ Photo Grid Layout
// -----------------------------------------------------------------
class _PhotoGridLayout extends StatelessWidget {
  final String leftTitle;
  final List<Color> imageColors;

  const _PhotoGridLayout({required this.leftTitle, required this.imageColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF666666),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextCell(leftTitle)),
                    const SizedBox(width: 4),
                    Expanded(child: _buildImageCell(imageColors[0])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _buildImageCell(imageColors[1])),
                    const SizedBox(width: 4),
                    Expanded(child: _buildImageCell(imageColors[2])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _buildImageCell(imageColors[3])),
                    const SizedBox(width: 4),
                    Expanded(child: _buildImageCell(imageColors[4])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildImageCell(imageColors[5])),
                    const SizedBox(width: 4),
                    Expanded(child: _buildImageCell(imageColors[6])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _buildImageCell(imageColors[7])),
                    const SizedBox(width: 4),
                    Expanded(child: _buildImageCell(imageColors[8])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _buildImageCell(imageColors[9])),
                    const SizedBox(width: 4),
                    Expanded(child: _buildImageCell(imageColors[10])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCell(String text) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildImageCell(Color color) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: color,
        child: const Icon(Icons.photo, color: Colors.white38),
      ),
    );
  }
}
