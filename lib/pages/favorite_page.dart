import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/show_model.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteService service = FavoriteService();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorit')),
      body: ValueListenableBuilder<Box>(
        valueListenable: service.listenable,
        builder: (context, box, child) {
          final List<ShowModel> favorites = service.getFavorites();

          // Kondisi kosong
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Belum ada favorit',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final ShowModel show = favorites[index];

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(showId: show.id),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: show.imageUrl == null
                        ? const SizedBox(
                            width: 48,
                            height: 64,
                            child: Icon(Icons.movie, color: Colors.grey),
                          )
                        : Image.network(
                            show.imageUrl!,
                            width: 48,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                              width: 48,
                              height: 64,
                              child: Icon(Icons.movie, color: Colors.grey),
                            ),
                          ),
                  ),
                  title: Text(
                    show.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(show.rating?.toString() ?? '-'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await service.removeFavorite(show.id);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${show.name} dihapus dari favorit'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}