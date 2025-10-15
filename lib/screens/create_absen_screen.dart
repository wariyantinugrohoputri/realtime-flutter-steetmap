import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/outlet_model.dart';
import 'qr_scan_screen.dart';

class CreateAbsenScreen extends StatefulWidget {
  final Outlet outlet; // ✅ kirim outlet biar bisa ambil lat & lng

  const CreateAbsenScreen({super.key, required this.outlet});

  @override
  State<CreateAbsenScreen> createState() => _CreateAbsenScreenState();
}

class _CreateAbsenScreenState extends State<CreateAbsenScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jadwalController = TextEditingController();

  bool _loading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _message = "Isi jadwal belajar sebelum lanjut ke scan absensi.";
    _jadwalController.text = DateFormat('HH:mm').format(DateTime.now());
  }

  void _goToScan() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScanPage(
            outlet: widget.outlet,
            jadwalBelajar:
                _jadwalController.text, // ✅ gunakan nama yang konsisten
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Absensi Guru')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _message,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _jadwalController,
                      decoration: const InputDecoration(
                        labelText: 'Jadwal Belajar',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.schedule),
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jadwal belajar wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _goToScan,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text(
                          'Lanjut Scan & Absen',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
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
