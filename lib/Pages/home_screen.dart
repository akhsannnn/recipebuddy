import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> bookmarkedIds = {};
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('bookmarks')
            .get();

    setState(() {
      bookmarkedIds = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  Future<void> toggleBookmark(
    String recipeId,
    Map<String, dynamic> data,
  ) async {
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(recipeId);

    if (bookmarkedIds.contains(recipeId)) {
      await docRef.delete();
      setState(() => bookmarkedIds.remove(recipeId));
    } else {
      await docRef.set({
        'title': data['title'],
        'duration': data['duration'],
        'imageUrl': data['imageUrl'],
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() => bookmarkedIds.add(recipeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('recipes')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada resep tersedia."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final recipeId = doc.id;
              final isBookmarked = bookmarkedIds.contains(recipeId);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data['imageUrl'] ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(data['title'] ?? 'Tanpa Judul'),
                subtitle: Text("Durasi: ${data['duration'] ?? '-'}"),
                trailing: IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.brown : Colors.grey,
                  ),
                  onPressed: () => toggleBookmark(recipeId, data),
                ),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => RecipeDetailScreen(
                              title: data['title'],
                              imageUrl: data['imageUrl'],
                              duration: data['duration'],
                              description:
                                  data['description'] ?? '', // optional
                            ),
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
