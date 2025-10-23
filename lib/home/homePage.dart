import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/home/widgets/LastYearThisMonthCard.dart';
import 'package:wememmory/home/widgets/MemoryTipCard.dart';
import 'package:wememmory/home/widgets/RecommendedForYouCard.dart';
import 'package:wememmory/home/widgets/WeMemoryList.dart';
import 'widgets/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        titleSpacing: 0,
        title: const Text('korakrit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [IconButton(onPressed: () {}, icon: Image.asset('assets/icons/icon.png', width: 22, height: 22)), const SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSearchBar(),
              SizedBox(height: 16),
              ReminderCard(),
              SizedBox(height: 20),
              SummaryStrip(), // ✅ ใช้แท่งเดียว ไม่ล้น ไม่แยก
              SizedBox(height: 16),
              MemoryTipCard(),
              SizedBox(height: 16),
              RecommendedForYouCard(), // ⬅️ การ์ดใหม่ตามภาพ
              SizedBox(height: 16),
              LastYearThisMonthCard(), // ⬅️ การ์ดใหม่ตามภาพ
              SizedBox(height: 16),
              Image.asset('assets/images/image2.png', fit: BoxFit.cover),
              SizedBox(height: 16),
              // ✅ แสดงการ์ดตามข้อมูล wedata
              WeMemoryList(data: wedata),
            ],
          ),
        ),
      ),
    );
  }
}
