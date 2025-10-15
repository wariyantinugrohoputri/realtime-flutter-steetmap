import 'dart:async';
import 'package:belajar02/screens/create_absen_screen.dart';
import 'package:belajar02/screens/qr_scan_screen.dart';
import 'package:belajar02/services/absensi_service.dart';
import 'package:belajar02/services/guru_service.dart';
import 'package:belajar02/services/outlet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/auth_service.dart';
import '../models/guru_model.dart';
import '../models/outlet_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _officeLatLng;
  final MapController _mapController = MapController();
  final AuthService _authService = AuthService();
  final AbsensiService _absensiService = AbsensiService();
  final GuruService _guruService = GuruService();

  Guru? _guru;
  Outlet? _outlet;
  Position? _currentPosition;
  double _distance = 0.0;
  bool _isWithinRange = false;
  bool _loading = true;
  String _status = "Mendeteksi lokasi...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final guru = await _guruService.getGuru();
      final outlet = await OutletService.getOutlet();

      if (outlet == null) {
        setState(() {
          _status = "Data outlet tidak ditemukan.";
          _loading = false;
        });
        return;
      }

      final officeLatLng = LatLng(outlet.lat, outlet.lng);

      setState(() {
        _guru = guru;
        _outlet = outlet;
        _officeLatLng = officeLatLng;
      });

      _checkPermission();
    } catch (e) {
      setState(() {
        _status = 'Gagal memuat data: $e';
        _loading = false;
      });
    }
  }

  Future<void> _checkPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        _getCurrentLocation();
      });
    } else {
      setState(() {
        _status = "Izin lokasi ditolak";
        _loading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_officeLatLng == null) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final distance = Geolocator.distanceBetween(
        _officeLatLng!.latitude,
        _officeLatLng!.longitude,
        pos.latitude,
        pos.longitude,
      );

      setState(() {
        _currentPosition = pos;
        _distance = distance;
        _isWithinRange = distance <= 15;
        _status = _isWithinRange
            ? "Dalam jangkauan absensi (${distance.toStringAsFixed(2)} m)"
            : "Di luar jangkauan (${distance.toStringAsFixed(2)} m)";
        _loading = false;
      });

      _mapController.move(LatLng(pos.latitude, pos.longitude), 18);
    } catch (e) {
      setState(() {
        _status = "Gagal mendapatkan lokasi: $e";
        _loading = false;
      });
    }
  }

  void _navigateToAbsenForm() async {
    if (!_isWithinRange || _outlet == null) return;

    setState(() {
      _loading = true;
      _status = "Memeriksa status absensi...";
    });

    final result = await _absensiService.checkAbsen();
    print('💡 Hasil checkAbsen: $result');
    try {
      if (result['status'] == false) {
        // ✅ Belum ada absen → ke halaman Create Absen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAbsenScreen(outlet: _outlet!),
          ),
        );
      } else {
        // ⚠️ Sudah ada absen → ke halaman Scan Absen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRScanPage(outlet: _outlet!)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = _currentPosition?.latitude.toStringAsFixed(6) ?? '-';
    final lng = _currentPosition?.longitude.toStringAsFixed(6) ?? '-';
    final guruName = _guru?.guru ?? '-';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'Absensi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (_outlet != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _outlet!.outlet,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Lat: ${_outlet!.lat.toStringAsFixed(2)} | Lng: ${_outlet!.lng.toStringAsFixed(6)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Map
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      if (_officeLatLng != null)
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _officeLatLng!,
                            initialZoom: 18,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              userAgentPackageName: "com.example.belajar02",
                            ),
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: _officeLatLng!,
                                  color: Colors.blue.withOpacity(0.3),
                                  borderColor: Colors.blue,
                                  borderStrokeWidth: 2,
                                  radius: 15,
                                ),
                              ],
                            ),
                            if (_currentPosition != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade500,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      if (_officeLatLng == null || _loading)
                        const Center(child: CircularProgressIndicator()),

                      // Status Info
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isWithinRange
                                  ? [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ]
                                  : [Colors.red.shade400, Colors.red.shade600],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            _status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Info Card
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Guru Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade400,
                                Colors.blue.shade600,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guruName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Lat: $lat | Lng: $lng',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isWithinRange ? _navigateToAbsenForm : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.qr_code_scanner_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "SCAN & ABSEN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
