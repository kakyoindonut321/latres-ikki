import 'package:flutter/material.dart';
import '../models/show_model.dart';
import '../services/tvmaze_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TvMazeService _service = TvMazeService();
  late Future<List<ShowModel>> _futureShows;

  @override
  void initState() {
    super.initState();
    _futureShows = _service.fetchShows();
  }

  void _retry() {
    setState(() {
      _futureShows = _service.fetchShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skuy Nonton!')),
      body: FutureBuilder<List<ShowModel>>(
        future: _futureShows,
        builder: (context, snapshot) {
          // 1. Masih loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 8),
                  const Text('Gagal memuat data'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          // 3. Sukses
          final List<ShowModel> shows = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final ShowModel show = shows[index];
              return _ShowCard(
                show: show,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(showId: show.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Widget kartu satu show (private, hanya dipakai di file ini)
class _ShowCard extends StatelessWidget {
  final ShowModel show;
  final VoidCallback onTap;

  const _ShowCard({required this.show, required this.onTap});

  Widget _placeholder() {
    return Container(
      color: Colors.grey[850],
      child: const Center(
        child: Icon(Icons.movie, size: 40, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar mengisi sisa ruang
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: show.imageUrl == null
                    ? _placeholder()
                    : Image.network(
                        show.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _placeholder(),
                      ),
              ),
            ),
            // Judul + rating
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        show.rating?.toString() ?? '-',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}