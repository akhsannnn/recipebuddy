// shared_scaffold.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_navigation.dart';
import 'admin_navigation.dart';

class SharedScaffold extends StatelessWidget {
  final Widget body;

  const SharedScaffold({super.key, required this.body});

  Future<String> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'user';

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    return doc.data()?['role'] ?? 'user';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data!;
        if (role == 'admin') {
          return AdminNavigation(); // full navbar admin
        } else {
          return MainNavigation(); // full navbar user
        }
      },
    );
  }
}
