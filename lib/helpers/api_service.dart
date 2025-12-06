import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // CI4 base URL
  //static const String baseUrl = 'http://10.0.2.2/responsi-api/public';
  static const String baseUrl = 'http://localhost/responsi-api/public';


  // ============= AUTH =============
  static Future<Map<String, dynamic>> registrasi(
      String nama, String email, String password) async {
    final url = Uri.parse('$baseUrl/registrasi');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': nama, 'email': email, 'password': password}),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  // ============= INVENTARIS =============
  static Future<List<dynamic>> getInventaris() async {
    final url = Uri.parse('$baseUrl/inventaris');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'] as List<dynamic>;
    }
    throw Exception('Gagal load data');
  }

  static Future<Map<String, dynamic>> addInventaris(
      String nama, int harga, int jumlah, String tanggalMasuk) async {
    final url = Uri.parse('$baseUrl/inventaris');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'harga': harga,
        'jumlah': jumlah,
        'tanggal_masuk': tanggalMasuk,
      }),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> updateInventaris(
      int id, String nama, int harga, int jumlah, String tanggalMasuk) async {
    final url = Uri.parse('$baseUrl/inventaris/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'harga': harga,
        'jumlah': jumlah,
        'tanggal_masuk': tanggalMasuk,
      }),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> deleteInventaris(int id) async {
    final url = Uri.parse('$baseUrl/inventaris/$id');
    final response = await http.delete(url);
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
}
