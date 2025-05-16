import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_user_edit.dart';

class AdminUserDetail extends StatelessWidget {
  final String userId;
  const AdminUserDetail({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      appBar: AppBar(
        title: const Text("Detail User"),
        backgroundColor: const Color(0xFFF8F3EF),
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Username: ${data['username']}"),
                Text("Email: ${data['email']}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AdminUserEdit(
                                userId: userId,
                                currentData: data,
                              ),
                        ),
                      ),
                  child: const Text("Edit Profil"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
