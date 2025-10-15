import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:belajar02/screens/home_screen.dart';
import 'package:belajar02/screens/map_screen.dart';
import 'package:belajar02/screens/profil_screen.dart';
import 'package:belajar02/constants/app_colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _animationController.forward(from: 0.0);
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isKehadiranSelected = _selectedIndex == 1;
    final navBarColor = isKehadiranSelected
        ? AppColors.white
        : AppColors.primaryBlue;
    final shadowColor = isKehadiranSelected
        ? Colors.grey.withOpacity(0.2)
        : AppColors.darkBlue.withOpacity(0.3);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // White background that extends to bottom
          Positioned.fill(child: Container(color: Colors.white)),
          // PageView on top
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: const [HomeScreen(), MapScreen(), ProfilScreen()],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: navBarColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(color: shadowColor, spreadRadius: 1, blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.calendar_today_rounded, 'Kehadiran'),
              _buildNavItem(2, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final isKehadiranPage = _selectedIndex == 1;

    Color itemColor;
    FontWeight fontWeight;

    if (isSelected) {
      itemColor = isKehadiranPage ? AppColors.primaryBlue : Colors.white;
      fontWeight = FontWeight.bold;
    } else {
      itemColor = isKehadiranPage
          ? Colors.grey.shade600
          : Colors.white.withOpacity(0.7);
      fontWeight = FontWeight.w500;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          // We don't need a background color or border on the item itself anymore
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: itemColor, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontWeight: fontWeight,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
