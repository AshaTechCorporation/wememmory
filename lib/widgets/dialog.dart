import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class DialogSuccess extends StatelessWidget {
  const DialogSuccess({super.key, required this.title, required this.pressYes});
  final String title;
  final VoidCallback pressYes;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB377), // สีส้ม
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextButton(onPressed: pressYes, child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
        ],
      ),
    );
  }
}

class DialogError extends StatelessWidget {
  const DialogError({super.key, required this.title, required this.pressYes});
  final String title;
  final VoidCallback pressYes;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Icon(Icons.close, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB377), // สีส้ม
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextButton(onPressed: pressYes, child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
        ],
      ),
    );
  }
}

class DialogYesNo extends StatelessWidget {
  const DialogYesNo({super.key, required this.title, required this.pressYes, required this.pressNo, required this.description});
  final String title, description;
  final VoidCallback pressYes;
  final VoidCallback pressNo;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Image.asset('assets/icons/alert.png', width: 100, height: 100, color: kBackgroundColor),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: const Color(0xFFFAAE73))),
            const SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color.fromARGB(104, 192, 192, 192)), right: BorderSide(color: Color.fromARGB(104, 192, 192, 192))),
                        color: mainColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                      ),
                      child: TextButton(onPressed: pressNo, child: const Text('ยกเลิก', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color.fromARGB(104, 192, 192, 192))),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                      ),
                      child: TextButton(onPressed: pressYes, child: const Text('ยืนยัน', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogQuestion extends StatelessWidget {
  const DialogQuestion({super.key, required this.title, required this.pressYes, required this.pressNo, required this.description});
  final String title, description;
  final VoidCallback pressYes;
  final VoidCallback pressNo;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            // Image.asset(
            //   'assets/icons/danger.png',
            //   width: 100,
            //   height: 100,
            // ),
            // const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: const Color(0xFFFAAE73))),
            const SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.398,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color.fromARGB(104, 192, 192, 192))),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                  ),
                  child: TextButton(onPressed: pressNo, child: const Text('ยกเลิก', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16))),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.398,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color.fromARGB(104, 192, 192, 192))),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                  ),
                  child: TextButton(onPressed: pressYes, child: const Text('ยืนยัน', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
