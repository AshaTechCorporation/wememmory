import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _currentPosition; 
  GoogleMapController? _mapController;
  bool _isConfirmLoading = false;
  bool _isFirstLoading = true; 

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isFirstLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Fallback ไปที่อนุสาวรีย์ชัยฯ ถ้าหาตำแหน่งไม่ได้
          _currentPosition = const LatLng(13.7649, 100.5383); 
          _isFirstLoading = false;
        });
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('กรุณาเปิด GPS');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง');
    }
    
    if (permission == LocationPermission.deniedForever) return Future.error('สิทธิ์ถูกปิดถาวร');

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      final newPosition = LatLng(position.latitude, position.longitude);
      setState(() => _currentPosition = newPosition);
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPosition, zoom: 16)));
    } catch (e) {
      // Handle error
    }
  }

  // --- จุดที่แก้ไข: ส่งกลับเป็น Map {placemark, latlng} ---
  Future<void> _confirmLocation() async {
    if (_currentPosition == null) return;

    setState(() => _isConfirmLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        localeIdentifier: "th_TH",
      );

      if (placemarks.isNotEmpty && mounted) {
        // ✅ แก้ไข: ส่งค่ากลับไปทั้ง Placemark และ LatLng
        Navigator.pop(context, {
          'placemark': placemarks.first,
          'latlng': _currentPosition, // ส่งพิกัดกลับไปด้วยเพื่อเอาไปโชว์ Map Preview
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isConfirmLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLoading || _currentPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFFF36F45))));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("เลือกตำแหน่งจัดส่ง", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 16),
            zoomControlsEnabled: false,
            onMapCreated: (c) => _mapController = c,
            onCameraMove: (p) => _currentPosition = p.target,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          // หมุดกลางจอ
          const Center(child: Padding(padding: EdgeInsets.only(bottom: 40), child: Icon(Icons.location_on, size: 50, color: Color(0xFFF36F45)))),
          
          // ปุ่มกลับไปตำแหน่งปัจจุบัน
          Positioned(
            right: 20, bottom: 30,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location, color: Color(0xFFF36F45)),
            ),
          ),
          
          if (_isConfirmLoading) Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator(color: Color(0xFFF36F45)))),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isConfirmLoading ? null : _confirmLocation,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF36F45),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),),
              child: const Text('ยืนยันตำแหน่งนี้', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}