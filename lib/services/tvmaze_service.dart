import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_model.dart';

class TvMazeService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  // GET /shows -> daftar semua show
  Future<List<ShowModel>> fetchShows() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => ShowModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat daftar show (${response.statusCode})');
    }
  }

  // GET /shows/{id} -> detail satu show
  Future<ShowModel> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ShowModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail show (${response.statusCode})');
    }
  }
}