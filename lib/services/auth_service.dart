import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/guru_model.dart';
import '../models/outlet_model.dart';
import 'api_service.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<Guru?> login(String idguru, String password) async {
    try {
      print('🔐 Attempting login for ID: $idguru'); // Debug log

      final response = await ApiService.dio.post(
        '/login-guru',
        data: {'idguru': idguru, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'];
        final data = response.data['data'];

        if (token == null || data == null) {
          throw Exception('Response tidak valid dari server');
        }

        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'guru', value: jsonEncode(data));

        // Set token header untuk request selanjutnya
        ApiService.dio.options.headers['Authorization'] = 'Bearer $token';

        return Guru.fromJson(data);
      }

      return null;
    } on DioException catch (e) {
      // Handle berbagai jenis error
      if (e.response != null) {
        final message =
            e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Login gagal';
        throw Exception(message);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Koneksi timeout. Periksa internet Anda.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server tidak merespons. Coba lagi.');
      } else {
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      }
    } catch (e) {
      print('💥 Unexpected error: $e'); // Debug log
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.setTokenHeader();
      await ApiService.dio.post('/absen-guru/logout');
    } catch (_) {}
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'guru');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }
}
