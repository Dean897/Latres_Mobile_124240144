import 'package:flutter/material.dart';

import 'favorite_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import '../theme/app_colors.dart';

/// Container navigasi utama setelah user berhasil login.
///
/// [IndexedStack] menjaga state tiap halaman saat user berpindah tab.
class MainNavView extends StatefulWidget {
  /// Membuat navigasi utama.
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _selectedIndex = 0;
  final _pages = const [HomeView(), FavoriteView(), ProfileView()];

  /// Membuat body halaman dan navigasi bawah.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: AppColors.navigation,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.mutedText,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
