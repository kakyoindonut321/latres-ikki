import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/show_model.dart';

class FavoriteService {
  static const String boxName = 'favorites';

  // Mengambil box yang sudah dibuka di main.dart
  Box get _box => Hive.box(boxName);
    // Dipakai FavoritePage untuk auto-refresh saat isi box berubah
  ValueListenable<Box> get listenable => _box.listenable();

  // Semua favorit -> List<ShowModel>
  List<ShowModel> getFavorites() {
    return _box.values.map((item) => ShowModel.fromMap(item as Map)).toList();
  }

  // Cek apakah show ini sudah difavoritkan
  bool isFavorite(int id) {
    return _box.containsKey(id);
  }

  // Tambah favorit: key = id show, value = Map
  Future<void> addFavorite(ShowModel show) async {
    await _box.put(show.id, show.toMap());
  }

  // Hapus favorit berdasarkan id
  Future<void> removeFavorite(int id) async {
    await _box.delete(id);
  }

  // Kalau sudah favorit -> hapus, kalau belum -> tambah
  // Mengembalikan status terbaru (true = sekarang favorit)
  Future<bool> toggleFavorite(ShowModel show) async {
    if (isFavorite(show.id)) {
      await removeFavorite(show.id);  
      return false;
    } else {
      await addFavorite(show);
      return true;
    }
  }
}