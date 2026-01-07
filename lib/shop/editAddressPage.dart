import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wememmory/shop/address_model.dart';
import 'package:wememmory/shop/addressDetailPage.dart'; // ตรวจสอบว่าไฟล์ AddressPickerPage อยู่ที่ path นี้จริงหรือไม่

class EditAddressPage extends StatefulWidget {
  final int? index;
  const EditAddressPage({super.key, this.index});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _detailController;

  String province = '';
  String district = '';
  String subDistrict = '';
  String postalCode = '';
  
  double? _lat;
  double? _lng;

  // ตัวแปร Controller แผนที่
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      final data = globalAddressList[widget.index!];
      _nameController = TextEditingController(text: data.name);
      
      String formattedPhone = data.phone;
      if (data.phone.length == 10) {
        formattedPhone = '${data.phone.substring(0, 3)}-${data.phone.substring(3, 6)}-${data.phone.substring(6)}';
      }
      _phoneController = TextEditingController(text: formattedPhone);
      
      _detailController = TextEditingController(text: data.detail);
      province = data.province;
      district = data.district;
      subDistrict = data.subDistrict;
      postalCode = data.postalCode ?? '';
      
      _lat = data.lat;
      _lng = data.lng;
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _detailController = TextEditingController();
    }
  }

  void _onSave() {
    final cleanPhone = _phoneController.text.replaceAll('-', '');
    final newData = AddressInfo(
      name: _nameController.text,
      phone: cleanPhone,
      province: province,
      district: district,
      subDistrict: subDistrict,
      detail: _detailController.text,
      postalCode: postalCode,
      lat: _lat, 
      lng: _lng, 
    );

    setState(() {
      if (widget.index != null) {
        globalAddressList[widget.index!] = newData;
      } else {
        globalAddressList.add(newData);
      }
    });
    Navigator.pop(context);
  }
  
  void _onDelete() {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: Text(
                  'ต้องการลบที่อยู่ใช่หรือไม่',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            globalAddressList.removeAt(widget.index!);
                          });
                          Navigator.pop(context); 
                          Navigator.pop(context); 
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text('ยืนยัน',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: const Color(0xFFF36F45),
                          alignment: Alignment.center,
                          child: const Text('ยกเลิก',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.index != null;
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขที่อยู่' : 'เพิ่มที่อยู่',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ชื่อ - นามสกุล', style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'ชื่อ - นามสกุล',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: false,
                border: borderStyle,
                enabledBorder: borderStyle,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text('หมายเลขโทรศัพท์', style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [ThaiPhoneNumberFormatter()],
              decoration: InputDecoration(
                hintText: '0XX-XXX-XXXX',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: false,
                border: borderStyle,
                enabledBorder: borderStyle,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 20),
            const Text('จังหวัด, เขต/อำเภอ, แขวง/ตำบล', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
            const SizedBox(height: 12),
            
            // --- ส่วนเลือกที่อยู่ ---
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ✅ แก้ไขตรงนี้: ส่งค่าเดิมเข้าไปที่ AddressPickerPage
                    builder: (context) => AddressPickerPage(
                      initialProvince: province.isNotEmpty ? province : null,
                      initialDistrict: district.isNotEmpty ? district : null,
                      initialSubdistrict: subDistrict.isNotEmpty ? subDistrict : null,
                      initialDetail: _detailController.text,
                      initialLat: _lat, 
                      initialLng: _lng,
                    ),
                  ),
                );

                if (result != null && result is Map) {
                  setState(() {
                    province = result['province'] ?? '';
                    district = result['district'] ?? result['amphure'] ?? '';
                    subDistrict = result['subDistrict'] ?? result['subdistrict'] ?? result['tambon'] ?? '';
                    postalCode = result['postalCode'] ?? '';

                    if (result['detail'] != null) {
                      _detailController.text = result['detail'];
                    }
                    
                    if (result['lat'] != null && result['lng'] != null) {
                      _lat = result['lat'];
                      _lng = result['lng'];
                      
                      // ✅ สั่งย้ายกล้องมาที่ตำแหน่งใหม่ทันที
                      _mapController?.moveCamera(
                        CameraUpdate.newLatLngZoom(LatLng(_lat!, _lng!), 16)
                      );
                    }
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (province.isEmpty)
                        const Text('เลือกจังหวัด', style: TextStyle(color: Colors.grey)),
                      if (province.isNotEmpty) ...[
                        Text('จังหวัด $province', style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('เขต/อำเภอ $district', style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('แขวง/ตำบล $subDistrict $postalCode', style: const TextStyle(fontSize: 15)),
                      ]
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ✅ ส่วน Map Preview
            if (_lat != null && _lng != null) ...[
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_lat!, _lng!),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected-loc'),
                        position: LatLng(_lat!, _lng!),
                        infoWindow: const InfoWindow(title: 'ตำแหน่งจัดส่ง'),
                      ),
                    },
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              if (isEditing) ...[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _onDelete,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black26),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: const Text('ลบ',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF36F45),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: const Text('ยืนยัน',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThaiPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 10) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }
    final String formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}