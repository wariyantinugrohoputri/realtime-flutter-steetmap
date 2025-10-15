import 'dart:convert';
import 'package:belajar02/models/absensi_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/guru_model.dart';
import 'api_service.dart';

class AbsensiService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> checkAbsen() async {
    try {
      await ApiService.setTokenHeader();

      final jsonString = await _storage.read(key: 'guru');
      if (jsonString == null) throw Exception('Data guru tidak ditemukan');

      final guru = Guru.fromJson(jsonDecode(jsonString));
      final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final response = await ApiService.dio.post(
        '/check-absen',
        data: {'guru_idguru': guru.idguru, 'tanggal': tanggal},
      );
      if (response.statusCode == 200) {
        return response
            .data; // misal: { "status": true, "message": "Belum absen" }
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memeriksa absensi');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal konek ke server');
    } catch (e) {
      throw Exception('Kesalahan: $e');
    }
  }

  Future<bool> absenGuru({
    required String status, // 'in' atau 'out'
    String? jadwalBelajar, // ubah jadi opsional
  }) async {
    try {
      await ApiService.setTokenHeader();

      final jsonString = await _storage.read(key: 'guru');
      if (jsonString == null) throw Exception('Data guru tidak ditemukan');

      final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final waktuSekarang = DateFormat('HH:mm:ss').format(DateTime.now());

      late final Response response;

      // Tentukan data dan endpoint berdasarkan status
      if (status == 'in') {
        final data = {
          'tanggal': tanggal,
          'jadwalbelajar': jadwalBelajar ?? '', // kirim string kosong jika null
          'jamdatang': waktuSekarang,
        };

        response = await ApiService.dio.post('/store-absensi-guru', data: data);
      } else if (status == 'out') {
        final data = {'tanggal': tanggal, 'jampulang': waktuSekarang};

        response = await ApiService.dio.post(
          '/update-absensi-guru',
          data: data,
        );
      } else {
        throw Exception('Status absen tidak valid: $status');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Gagal menyimpan absensi');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengirim absensi');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<Absensi>> getRiwayatAbsensi(int idGuru) async {
    try {
      await ApiService.setTokenHeader();
      final response = await ApiService.dio.get('/absensi-guru/$idGuru');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List absensiList = response.data['absensi'] ?? [];
        return absensiList.map((a) => Absensi.fromJson(a)).toList();
      } else {
        throw Exception('Gagal memuat data absensi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
