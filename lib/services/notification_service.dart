import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton: seluruh app memakai satu objek yang sama
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Dipanggil sekali di main.dart
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);

    // Minta izin notifikasi (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Tampilkan notifikasi "ditambahkan ke favorit"
  Future<void> showFavoriteAdded(int showId, String showName) async {
    const androidDetails = AndroidNotificationDetails(
      'favorite_channel',
      'Favorit',
      channelDescription: 'Notifikasi saat show ditambahkan ke favorit',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.show(
      id: showId,
      title: 'Ditambahkan ke Favorit',
      body: '$showName masuk daftar favoritmu',
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }
}