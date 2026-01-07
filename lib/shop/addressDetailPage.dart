import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wememmory/shop/address_model.dart';
import 'package:wememmory/shop/mapPickerPage.dart';


class AddressPickerPage extends StatefulWidget {
  final String? initialProvince;
  final String? initialDistrict;
  final String? initialSubdistrict;
  final String? initialDetail;
  final double? initialLat;
  final double? initialLng;

  const AddressPickerPage({
    super.key,
    this.initialProvince,
    this.initialDistrict,
    this.initialSubdistrict,
    this.initialDetail,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  List<Province> _allProvinces = [];
  List<District> _allDistricts = [];
  List<Subdistrict> _allSubdistricts = [];

  List<District> _shownDistricts = [];
  List<Subdistrict> _shownSubdistricts = [];

  Province? selectedProvince;
  District? selectedDistrict;
  Subdistrict? selectedSubdistrict;
  LatLng? _selectedLatLng;

  // ✅ 1. เพิ่มตัวแปร Controller เพื่อคุมแผนที่
  GoogleMapController? _mapController;

  bool isLoading = true;
  late TextEditingController _detailController;

  @override
  void initState() {
    super.initState();
    _detailController = TextEditingController(text: widget.initialDetail ?? '');

    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedLatLng = LatLng(widget.initialLat!, widget.initialLng!);
    }

    _loadAllAddressData();
  }

  Future<void> _loadAllAddressData() async {
    try {
      final pString = await rootBundle.loadString('assets/provice/provinces.json');
      final dString = await rootBundle.loadString('assets/provice/districts.json');
      final sString = await rootBundle.loadString('assets/provice/subdistricts.json');

      final List<dynamic> pJson = json.decode(pString);
      final List<dynamic> dJson = json.decode(dString);
      final List<dynamic> sJson = json.decode(sString);

      if (mounted) {
        setState(() {
          _allProvinces = pJson.map((e) => Province.fromJson(e)).toList();
          _allDistricts = dJson.map((e) => District.fromJson(e)).toList();
          _allSubdistricts = sJson.map((e) => Subdistrict.fromJson(e)).toList();
          isLoading = false;
          _restoreSelection();
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      print("❌ Error loading data: $e");
    }
  }

  void _restoreSelection() {
    if (widget.initialProvince == null) return;
    try {
      final matchedProvince = _allProvinces.cast<Province?>().firstWhere(
        (e) => e!.nameTh.trim() == widget.initialProvince!.trim(),
        orElse: () => null,
      );

      if (matchedProvince != null) {
        selectedProvince = matchedProvince;
        _shownDistricts = _allDistricts.where((d) => 
          d.provinceId == matchedProvince.id || d.provinceId == matchedProvince.code
        ).toList();

        if (widget.initialDistrict != null) {
          final matchedDistrict = _shownDistricts.cast<District?>().firstWhere(
            (e) => e!.nameTh.trim() == widget.initialDistrict!.trim(),
            orElse: () => null,
          );

          if (matchedDistrict != null) {
            selectedDistrict = matchedDistrict;
            _shownSubdistricts = _allSubdistricts.where((s) => 
              s.districtId == matchedDistrict.id || s.districtId == matchedDistrict.code
            ).toList();

            if (widget.initialSubdistrict != null) {
              final matchedSubdistrict = _shownSubdistricts.cast<Subdistrict?>().firstWhere(
                (e) => e!.nameTh.trim() == widget.initialSubdistrict!.trim(),
                orElse: () => null,
              );
              if (matchedSubdistrict != null) {
                selectedSubdistrict = matchedSubdistrict;
              }
            }
          }
        }
      }
    } catch (e) {
      selectedProvince = null;
      selectedDistrict = null;
      selectedSubdistrict = null;
    }
  }

  Future<void> _openMapAndSelectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    if (result != null) {
      Placemark? place;
      LatLng? latLng;

      if (result is Map) {
        if (result['placemark'] is Placemark) place = result['placemark'];
        if (result['latlng'] is LatLng) latLng = result['latlng'];
      } else if (result is Placemark) {
        place = result;
      }

      if (place != null) {
        _autoFillAddressFromMap(place);
      }
      
      if (latLng != null) {
        setState(() {
          _selectedLatLng = latLng;
        });

        // ✅ 2. สั่งให้กล้องขยับไปหาหมุดทันทีที่ได้รับค่าใหม่
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 17)
        );
      }
    }
  }
  
  String _normalize(String text) {
    if (text.isEmpty) return "";
    return text.toLowerCase()
        .replaceAll(RegExp(r'[^\u0E00-\u0E7Fa-zA-Z0-9]'), '') 
        .replaceAll('จังหวัด', '').replaceAll('province', '')
        .replaceAll('อำเภอ', '').replaceAll('district', '').replaceAll('amphoe', '')
        .replaceAll('เขต', '').replaceAll('khet', '')
        .replaceAll('ตำบล', '').replaceAll('subdistrict', '').replaceAll('tambon', '')
        .replaceAll('แขวง', '').replaceAll('khwaeng', '')
        .replaceAll('เมือง', '').replaceAll('mueang', '') 
        .replaceAll('มหานคร', '').replaceAll('bangkok', 'krungthep')
        .replaceAll(' ', ''); 
  }

  void _onProvinceChanged(Province? val) {
    setState(() {
      selectedProvince = val;
      selectedDistrict = null;
      selectedSubdistrict = null;
      _shownSubdistricts = [];
      if (val != null) {
        _shownDistricts = _allDistricts.where((d) => 
          d.provinceId == val.id || d.provinceId == val.code
        ).toList();
      } else {
        _shownDistricts = [];
      }
    });
  }

  void _onDistrictChanged(District? val) {
    setState(() {
      selectedDistrict = val;
      selectedSubdistrict = null;
      if (val != null) {
        _shownSubdistricts = _allSubdistricts.where((s) => 
          s.districtId == val.id || s.districtId == val.code
        ).toList();
      } else {
        _shownSubdistricts = [];
      }
    });
  }

  void _autoFillAddressFromMap(Placemark place) {
    // Logic คงเดิม
    String gZip = place.postalCode ?? "";
    List<String> searchWords = [
      _normalize(place.subLocality ?? ""),
      _normalize(place.subAdministrativeArea ?? ""),
      _normalize(place.locality ?? ""),
    ];
    searchWords.removeWhere((s) => s.isEmpty);

    Subdistrict? targetSubdistrict;
    if (gZip.isNotEmpty) {
      List<Subdistrict> candidates = _allSubdistricts.where((s) => s.postalCode.toString() == gZip).toList();
      for (var s in candidates) {
        String th = _normalize(s.nameTh);
        String en = _normalize(s.nameEn);
        if (searchWords.any((w) => th.contains(w) || w.contains(th) || en.contains(w) || w.contains(en))) {
          targetSubdistrict = s;
          break;
        }
      }
      if (targetSubdistrict == null && candidates.isNotEmpty) targetSubdistrict = candidates.first;
    }

    if (targetSubdistrict != null) {
      District? targetDistrict;
      try {
        targetDistrict = _allDistricts.firstWhere((d) => d.id == targetSubdistrict!.districtId || d.code == targetSubdistrict!.districtId);
      } catch (_) {}

      Province? targetProvince;
      if (targetDistrict != null) {
        try {
          targetProvince = _allProvinces.firstWhere((p) => p.id == targetDistrict!.provinceId || p.code == targetDistrict!.provinceId);
        } catch (_) {}
      }

      setState(() {
        if (targetProvince != null) {
          selectedProvince = targetProvince;
          _shownDistricts = _allDistricts.where((d) => d.provinceId == targetProvince!.id || d.provinceId == targetProvince.code).toList();
          
          if (targetDistrict != null) {
             try {
               var d = _shownDistricts.firstWhere((item) => item.id == targetDistrict!.id);
               selectedDistrict = d;
               _shownSubdistricts = _allSubdistricts.where((s) => s.districtId == d.id || s.districtId == d.code).toList();

               if (targetSubdistrict != null) {
                 try {
                   selectedSubdistrict = _shownSubdistricts.firstWhere((item) => item.id == targetSubdistrict!.id);
                 } catch (_) {}
               }
             } catch (_) {}
          }
        }
        String rawStreet = "${place.thoroughfare ?? ''} ${place.subThoroughfare ?? ''}".trim();
        if (rawStreet.isNotEmpty) _detailController.text = rawStreet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('แก้ไขที่อยู่', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // ส่วนหัว: ปรับปุ่มให้ใหญ่ขึ้น
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ที่อยู่', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                      ),
                      SizedBox(
                        height: 50,
                        width: 250, 
                        child: OutlinedButton.icon(
                          onPressed: _openMapAndSelectLocation,
                          icon: const Icon(Icons.map, color: Color(0xFF2D9CDB), size: 30), 
                          label: const Text('เลือกจากแผนที่', style: TextStyle(color: Color(0xFF2D9CDB), fontSize: 14, fontWeight: FontWeight.w500)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2D9CDB)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('จังหวัด'),
                  _buildDropdown<Province>(
                    hint: 'เลือกจังหวัด',
                    value: selectedProvince,
                    items: _allProvinces,
                    labelKey: (item) => item.nameTh,
                    onChanged: _onProvinceChanged,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('อำเภอ/เขต'),
                  _buildDropdown<District>(
                    hint: 'เลือกอำเภอ/เขต',
                    value: selectedDistrict,
                    items: _shownDistricts,
                    enabled: selectedProvince != null,
                    labelKey: (item) => item.nameTh,
                    onChanged: _onDistrictChanged,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('ตำบล/แขวง'),
                  _buildDropdown<Subdistrict>(
                    hint: 'เลือกตำบล/แขวง',
                    value: selectedSubdistrict,
                    items: _shownSubdistricts,
                    enabled: selectedDistrict != null,
                    labelKey: (item) => item.nameTh,
                    onChanged: (val) => setState(() => selectedSubdistrict = val),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('รายละเอียดเพิ่มเติม'),
                  TextField(
                    controller: _detailController,
                    decoration: InputDecoration(
                      hintText: 'บ้านเลขที่, ซอย, หมู่, ถนน',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      filled: false,
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),

                  // ✅ ส่วนแสดงแผนที่พร้อมหมุด
                  if (_selectedLatLng != null) ...[
                    const SizedBox(height: 20),
                    const Text('ตำแหน่งบนแผนที่', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    
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
                          // ✅ 3. เก็บ Controller และสั่งย้ายกล้องทันทีที่สร้างเสร็จ
                          onMapCreated: (controller) {
                            _mapController = controller;
                            // บังคับให้กล้องไปที่ตำแหน่งหมุดทันทีที่โหลดเสร็จ
                            if (_selectedLatLng != null) {
                              _mapController?.moveCamera(
                                CameraUpdate.newLatLngZoom(_selectedLatLng!, 17)
                              );
                            }
                          },
                          initialCameraPosition: CameraPosition(
                            target: _selectedLatLng!,
                            zoom: 17,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('selected-loc'),
                              position: _selectedLatLng!,
                              infoWindow: const InfoWindow(title: 'ตำแหน่งที่เลือก'),
                            ),
                          },
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
       bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'province': selectedProvince?.nameTh,
                  'amphure': selectedDistrict?.nameTh,
                  'tambon': selectedSubdistrict?.nameTh,
                  'postalCode': selectedSubdistrict?.postalCode.toString(),
                  'detail': _detailController.text,
                  'lat': _selectedLatLng?.latitude,
                  'lng': _selectedLatLng?.longitude,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF36F45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Helper Widgets เหมือนเดิม
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8), 
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
  );

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) labelKey,
    required Function(T?) onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade100,
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((item) => DropdownMenuItem<T>(
            value: item, 
            child: Text(labelKey(item), style: const TextStyle(fontSize: 16))
          )).toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}