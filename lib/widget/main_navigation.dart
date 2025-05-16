import 'package:flutter/material.dart';
import '../Pages/home_screen.dart';
import '../Pages/cari_resep.dart';
import '../Pages/upload_recipe_screen.dart';
import '../Pages/profile_screen.dart'; // Pastikan file ini ada ya

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CariResepScreen(),
    const UploadRecipeScreen(),
    const ProfileScreen(), // Buat file ini jika belum ada
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown[600],
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFF8F3EF),
        elevation: 8,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
