import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/guru_model.dart';
import '../models/outlet_model.dart';
import 'api_service.dart';

class GuruService {
  final _storage = const FlutterSecureStorage();
  Future<Guru?> getGuru() async {
    final jsonString = await _storage.read(key: 'guru');
    if (jsonString == null) return null;
    return Guru.fromJson(jsonDecode(jsonString));
  }

  Future<bool> updateGuru({
    required int idguru,
    required String guru,
    required String gurupanggilan,
    String? email,
    String? nohp,
    String? tmptlahir,
    String? tgllahir,
    String? alamat,
    String? norekening,
    String? anrekening,
    String? bank,
  }) async {
    try {
      await ApiService.setTokenHeader();

      print('🔄 Sending update to: ${ApiService.baseUrl}/update-guru/$idguru');
      print('📤 Update data: guru=$guru, gurupanggilan=$gurupanggilan');

      final response = await ApiService.dio.put(
        '/update-guru/$idguru',
        data: {
          'guru': guru,
          'gurupanggilan': gurupanggilan,
          'email': email ?? '',
          'nohp': nohp ?? '',
          'tmptlahir': tmptlahir ?? '',
          'tgllahir': tgllahir ?? '',
          'alamat': alamat ?? '',
          'norekening': norekening ?? '',
          'anrekening': anrekening ?? '',
          'bank': bank ?? '',
        },
      );

      print('📡 Update Response: ${response.statusCode}');
      print('📦 Update Data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Update data guru di local storage
        await _storage.write(
          key: 'guru',
          value: jsonEncode(response.data['data']),
        );
        return true;
      }

      return false;
    } on DioException catch (e) {
      print('🚨 Update Error: ${e.type}');
      print('🚨 Error Response: ${e.response?.statusCode}');
      print('🚨 Error Data: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui data guru',
      );
    } catch (e) {
      print('💥 Update Unexpected error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
