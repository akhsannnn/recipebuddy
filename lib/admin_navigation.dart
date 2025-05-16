import 'package:flutter/material.dart';
import 'admin_recipe_list.dart';
import 'admin_user_manage.dart';
import 'admin_dashboard.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboard(),
    AdminRecipeList(),
    AdminUserManage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown[400],
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFF8F3EF),
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Resep'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
        ],
      ),
    );
  }
}
