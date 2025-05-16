import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String duration;
  final String description;

  const RecipeDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF8F3EF),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, height: 200, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule),
              const SizedBox(width: 4),
              Text(duration),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Deskripsi:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description.isNotEmpty
                ? description
                : 'Belum ada deskripsi untuk resep ini.',
          ),
        ],
      ),
    );
  }
}
