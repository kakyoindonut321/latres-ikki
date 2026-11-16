import 'package:flutter/material.dart';
import '../models/show_model.dart';
import '../services/favorite_service.dart';
import '../services/tvmaze_service.dart';
import '../services/notification_service.dart';

class DetailPage extends StatefulWidget {
  final int showId;

  const DetailPage({super.key, required this.showId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TvMazeService _service = TvMazeService();
  final FavoriteService _favorites = FavoriteService();
  late Future<ShowModel> _futureShow;

  @override
  void initState() {
    super.initState();
    _futureShow = _service.fetchShowDetail(widget.showId);
  }

  void _retry() {
    setState(() {
      _futureShow = _service.fetchShowDetail(widget.showId);
    });
  }

    Future<void> _toggleFavorite(ShowModel show) async {
    final bool nowFavorite = await _favorites.toggleFavorite(show);

    // Notifikasi hanya saat DITAMBAHKAN, bukan saat dihapus
    if (nowFavorite) {
      await NotificationService().showFavoriteAdded(show.id, show.name);
    }

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nowFavorite
              ? '${show.name} ditambahkan ke favorit'
              : '${show.name} dihapus dari favorit',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<ShowModel>(
        future: _futureShow,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 8),
                  const Text('Gagal memuat detail'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final ShowModel show = snapshot.data!;
          final bool isFavorite = _favorites.isFavorite(show.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                if (show.imageUrl != null)
                  Image.network(
                    show.imageUrl!,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                      height: 400,
                      child: Center(child: Icon(Icons.movie, size: 64)),
                    ),
                  )
                else
                  const SizedBox(
                    height: 400,
                    child: Center(child: Icon(Icons.movie, size: 64)),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        show.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(show.rating?.toString() ?? '-'),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Genre
                      Text(
                        show.genres.isEmpty ? '-' : show.genres.join(', '),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Tombol favorit
                      ElevatedButton.icon(
                        onPressed: () => _toggleFavorite(show),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                          isFavorite
                              ? 'Hapus dari Favorit'
                              : 'Tambah ke Favorit',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(46),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Summary
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        show.summary.isEmpty
                            ? 'Tidak ada ringkasan.'
                            : show.summary,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}