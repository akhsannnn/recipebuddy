import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CariResepScreen extends StatefulWidget {
  const CariResepScreen({super.key});

  @override
  State<CariResepScreen> createState() => _CariResepScreenState();
}

class _CariResepScreenState extends State<CariResepScreen> {
  String searchQuery = "";
  String? uid;
  Set<String> bookmarkedIds = {};

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
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Resep",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('recipes')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada resep ditemukan."),
                  );
                }

                final filtered =
                    snapshot.data!.docs.where((doc) {
                      final title = doc['title'].toString().toLowerCase();
                      return title.contains(searchQuery);
                    }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final recipeId = doc.id;
                    final isBookmarked = bookmarkedIds.contains(recipeId);

                    return ListTile(
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.person, size: 14),
                              SizedBox(width: 4),
                              Text("User"),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.brown : Colors.grey,
                        ),
                        onPressed: () => toggleBookmark(recipeId, data),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
