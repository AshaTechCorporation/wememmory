// lib/home/widgets/WeMemoryList.dart
import 'package:flutter/material.dart';

class WeMemoryList extends StatelessWidget {
  const WeMemoryList({super.key, required this.data});

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    // ใช้ ListView.separated ที่ shrinkWrap + no scroll
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final e = data[i];
        return _WeMemoryItem(imagePath: e['image'] as String, title: e['title'] as String, tags: (e['hastag'] as List).cast<String>());
      },
    );
  }
}

class _WeMemoryItem extends StatelessWidget {
  const _WeMemoryItem({required this.imagePath, required this.title, required this.tags});

  final String imagePath;
  final String title;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);
    const tagBlue = Color(0xFF5CA7FF);

    return SizedBox(
      width: double.infinity, // ✅ คุมความกว้างแน่นอน
      child: Container(
        decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.all(12),

        child: Container(
          width: double.infinity, // ✅ กล่องขาวต้องมีความกว้างชัดเจน
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูปซ้าย: ขนาดคงที่ ป้องกัน unbounded ใน Row
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(width: 110, height: 110, child: Image.asset(imagePath, fit: BoxFit.cover)),
              ),
              const SizedBox(width: 12),

              // เนื้อความกินพื้นที่ที่เหลือ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      style: const TextStyle(color: Color(0xFF5F5F5F), fontSize: 14.5, height: 1.35, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                          tags.map((t) => Text(t, style: const TextStyle(color: tagBlue, fontSize: 14.5, fontWeight: FontWeight.w700))).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
