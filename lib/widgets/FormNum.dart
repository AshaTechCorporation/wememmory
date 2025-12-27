import 'package:flutter/material.dart';

class NumberAwareText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String numberFontFamily;
  final double numberOffset; // เพิ่มตัวนี้: ติดลบ=ขยับขึ้น, บวก=ขยับลง
  final double? numberFontSize; // เผื่ออยากปรับขนาดตัวเลขแยกต่างหาก

  const NumberAwareText(
    this.text, {
    super.key,
    this.style,
    required this.numberFontFamily,
    this.numberOffset = -2, // ค่า default คือ 0 (ไม่ขยับ)
    this.numberFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final mainStyle = style ?? DefaultTextStyle.of(context).style;

    // กำหนดสไตล์ตัวเลข
    final numberStyle = mainStyle.copyWith(fontFamily: numberFontFamily, fontSize: numberFontSize ?? mainStyle.fontSize);

    final RegExp regex = RegExp(r'([0-9]+)');
    final Iterable<Match> matches = regex.allMatches(text);

    List<InlineSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      // 1. ข้อความปกติ (ภาษาไทย/อังกฤษ)
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start), style: mainStyle));
      }

      // 2. ตัวเลข -> ใช้ WidgetSpan เพื่อขยับตำแหน่ง
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Transform.translate(
            // ปรับแกน Y: ถ้าตัวเลขลอยสูงไป ให้ใส่ค่าบวก (เช่น 2.0)
            // ถ้าตัวเลขจมลงไป ให้ใส่ค่าลบ (เช่น -2.0)
            offset: Offset(0, numberOffset),
            child: Text(text.substring(match.start, match.end), style: numberStyle),
          ),
        ),
      );

      currentIndex = match.end;
    }

    // 3. ข้อความส่วนที่เหลือ
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex), style: mainStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
