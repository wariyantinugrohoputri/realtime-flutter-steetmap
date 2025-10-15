import 'package:flutter/material.dart';
import '../models/absensi_model.dart';
import '../services/absensi_service.dart';
import 'package:intl/intl.dart';

class AbsensiRiwayatScreen extends StatefulWidget {
  final int idGuru;

  const AbsensiRiwayatScreen({super.key, required this.idGuru});

  @override
  State<AbsensiRiwayatScreen> createState() => _AbsensiRiwayatScreenState();
}

class _AbsensiRiwayatScreenState extends State<AbsensiRiwayatScreen> {
  late Future<List<Absensi>> _futureAbsensi;

  @override
  void initState() {
    super.initState();
    final absensiService = AbsensiService();
    _futureAbsensi = absensiService.getRiwayatAbsensi(widget.idGuru);
  }

  String formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return tanggal;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on time':
        return Colors.green;
      case 'late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Absensi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Absensi>>(
        future: _futureAbsensi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final absensiList = snapshot.data ?? [];

          if (absensiList.isEmpty) {
            return const Center(child: Text('Belum ada data absensi.'));
          }

          final totalFee = absensiList.fold<int>(
            0,
            (sum, a) => sum + (a.fee ?? 0),
          );

          return Column(
            children: [
              // Total Fee Card
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Fee',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp $totalFee',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Daftar Absensi
              Expanded(
                child: ListView.builder(
                  itemCount: absensiList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final absensi = absensiList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: getStatusColor(absensi.status ?? ''),
                          child: const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          formatTanggal(absensi.tanggal ?? ''),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Jam Datang: ${absensi.jamdatang ?? "-"}'),
                            Text('Jam Pulang: ${absensi.jampulang ?? "-"}'),
                            Text('Status: ${absensi.status ?? "-"}'),
                            Text('Fee: Rp ${absensi.fee ?? 0}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
