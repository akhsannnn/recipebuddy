import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.brown[100],
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Halaman Profil akan ditampilkan di sini'),
      ),
    );
  }
}
