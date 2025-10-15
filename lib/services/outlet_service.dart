import 'package:dio/dio.dart';
import '../models/outlet_model.dart';
import 'api_service.dart';

class OutletService {
  // Ambil outlet sesuai login guru
  static Future<Outlet?> getOutlet() async {
    try {
      final response = await ApiService.dio.get('/outlet');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) return Outlet.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error saat mengambil outlet',
      );
    }
  }
}
