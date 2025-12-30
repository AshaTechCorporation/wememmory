import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart'; // ตรวจสอบ path ให้ถูกต้อง
import 'package:wememmory/shop/address_model.dart'; // ตรวจสอบ path ให้ถูกต้อง
import 'package:wememmory/shop/editAddressPage.dart'; // ตรวจสอบ path ให้ถูกต้อง

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // ฟังก์ชันไปหน้าเพิ่มที่อยู่
  void _addNewAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditAddressPage(index: null)),
    );
    setState(() {}); // รีเฟรชหน้าจอเมื่อกลับมา
  }

  // ฟังก์ชันไปหน้าแก้ไขที่อยู่
  void _editAddress(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditAddressPage(index: index)),
    );
    setState(() {}); // รีเฟรชหน้าจอเมื่อกลับมา
  }

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFEFEFEF);
    const grey = Color(0xFF9B9B9B);
    const orange = Color(0xFFF29C64);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // สีส้มจาก constants
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8B887),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ที่อยู่',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),

      // พื้นขาวมุมโค้ง + รายการ
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: globalAddressList.isEmpty
              ? const Center(
                  child: Text("ยังไม่มีข้อมูลที่อยู่", style: TextStyle(color: grey)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  itemCount: globalAddressList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = globalAddressList[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                        border: Border.all(color: dividerColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ข้อมูลที่อยู่
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ชื่อ
                                  Text(
                                    item.name, 
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)
                                  ),
                                  const SizedBox(height: 4),
                                  // เบอร์โทร
                                  Text(
                                    item.phone, 
                                    style: const TextStyle(color: grey, fontSize: 13.5)
                                  ),
                                  const SizedBox(height: 4),
          
                                ],
                              ),
                            ),
                            // ปุ่มแก้ไข (ตัวหนังสือเทา)
                            TextButton(
                              onPressed: () => _editAddress(index),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.topRight,
                              ),
                              child: const Text('แก้ไข', style: TextStyle(color: grey, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),

      // ปุ่มเพิ่มที่อยู่ชิดล่าง
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: _addNewAddress, // เรียกฟังก์ชันเพิ่มที่อยู่
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE743B),
              elevation: 0,
              shape: RoundedRectangleBorder(),
            ),
            child: const Text('เพิ่มที่อยู่', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
          ),
        ),
      ),
    );
  }
}