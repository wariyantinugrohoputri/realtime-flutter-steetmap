import 'dart:async'; // Tambahkan import ini
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi Map',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const markerPoint = LatLng(-8.118368, 111.922317);
  LatLng? userPoint; // posisi user
  String status = "Menunggu lokasi...";
  StreamSubscription<Position>? positionStreamSubscription;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  @override
  void dispose() {
    // Batalkan subscription ketika widget dihapus
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // cek GPS nyala
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => status = "GPS tidak aktif");
      return;
    }

    // cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => status = "Izin lokasi ditolak");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => status = "Izin lokasi permanen ditolak");
      return;
    }

    // Mulai melacak pergerakan user secara real-time
    _startTracking();
  }

  void _startTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1, // Update setiap 1 meter perpindahan
    );

    positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            setState(() {
              userPoint = LatLng(position.latitude, position.longitude);

              // Hitung jarak user ke marker
              final distance = Distance().as(
                LengthUnit.Meter,
                userPoint!,
                markerPoint,
              );

              status = distance <= 2
                  ? "✅ Berada dalam radius 2 meter (ABSENSI VALID)"
                  : "❌ Diluar radius (jarak: ${distance.toStringAsFixed(2)} m)";
            });

            // Optionally, pan the map to follow the user
            mapController.move(userPoint!, mapController.camera.zoom);
          },
        );

    // Also get the initial position
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        userPoint = LatLng(position.latitude, position.longitude);

        // Hitung jarak user ke marker
        final distance = Distance().as(
          LengthUnit.Meter,
          userPoint!,
          markerPoint,
        );

        status = distance <= 2
            ? "✅ Berada dalam radius 2 meter (ABSENSI VALID)"
            : "❌ Diluar radius (jarak: ${distance.toStringAsFixed(2)} m)";
      });
    });
  }

  void _stopTracking() {
    positionStreamSubscription?.cancel();
    setState(() {
      status = "Pelacakan dihentikan";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Absensi dengan Radius")),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: markerPoint,
                initialZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                // lingkaran radius 2 meter
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: markerPoint,
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                      useRadiusInMeter: true,
                      radius: 2, // 2 meter
                    ),
                  ],
                ),
                // marker statis dan user
                MarkerLayer(
                  markers: [
                    Marker(
                      point: markerPoint,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    if (userPoint != null)
                      Marker(
                        point: userPoint!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              status,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _checkLocation,
                child: const Text("Mulai Lacak"),
              ),
              ElevatedButton(
                onPressed: _stopTracking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Hentikan Lacak"),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
