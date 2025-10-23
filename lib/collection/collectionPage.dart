import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
        title: Text('korakrit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [IconButton(onPressed: () {}, icon: Image.asset('assets/icons/icon.png', width: 22, height: 22)), const SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔎 Search bar ตามภาพ
              _SearchBar(),
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
        color: Colors.white.withOpacity(0.25), // โปร่งเหมือนภาพ
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset('assets/icons/Search.png', width: 18, height: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 14.5),
              decoration: InputDecoration(
                hintText: 'ค้นหาความทรงจำตามแท็กและโน้ต.....',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 14.5),
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
