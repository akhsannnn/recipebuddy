import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  int currentTab = 0; // 0: Postingan, 1: Disimpan

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          username = data['username'];
          email = data['email'];
        });
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            "Profile Page",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Icon(Icons.account_circle, size: 100, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            username ?? 'Username',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(email ?? 'email@gmail.com'),
          const SizedBox(height: 16),

          // Tab Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.article,
                  color: currentTab == 0 ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => currentTab = 0),
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: currentTab == 1 ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => currentTab = 1),
              ),
            ],
          ),
          const Divider(),

          // Content Area
          Expanded(
            child:
                currentTab == 0
                    ? const Center(
                      child: Text("You haven’t posted anything yet!"),
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: List.generate(3, (index) {
                          return Image.network(
                            "https://i.imgur.com/2yaf2wb.jpg",
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton:
          currentTab == 0
              ? FloatingActionButton(
                onPressed: () {
                  // Tambah resep baru
                },
                backgroundColor: Colors.brown[300],
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
