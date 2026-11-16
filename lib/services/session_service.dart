import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Ganti dengan NIM kamu
  static const String _validUsername = '123456789';
  static const String _validPassword = '123';

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';

  // Cek kredensial (belum menyimpan apa-apa)
  bool validate(String username, String password) {
    return username == _validUsername && password == _validPassword;
  }

  // Simpan sesi setelah login berhasil
  Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  // Dipakai main.dart untuk menentukan halaman awal
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Dipakai Profile Page
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '-';
  }

  // Logout = hapus sesi
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUsername);
  }
}