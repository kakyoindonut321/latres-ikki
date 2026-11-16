import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SessionService _session = SessionService();
  late Future<String> _futureUsername;

  @override
  void initState() {
    super.initState();
    _futureUsername = _session.getUsername();
  }

  Future<void> _logout() async {
    await _session.logout();

    if (!mounted) return;

    // Hapus SELURUH tumpukan halaman, lalu ke LoginPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.grey[800],
                child: const Icon(Icons.person, size: 48, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Username dari SharedPreferences
              FutureBuilder<String>(
                future: _futureUsername,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '...',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Kesan & pesan (isi sendiri ya)
              const Text(
                'Kesan: Isi kesanmu selama praktikum di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pesan: Isi pesanmu untuk asisten di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 28),

              // Tombol logout
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 