import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/views/screens/cart_screen.dart';
import 'package:e_commerce_app/views/screens/product_screen.dart';
import 'package:e_commerce_app/views/screens/profile_screen.dart';
import 'package:e_commerce_app/views/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    ProductScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: _screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => context.read<BottomNavCubit>().changeTab(index),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xFF9775FA),
            unselectedItemColor: const Color(0xFF8F959E),
            items: [
              BottomNavigationBarItem(
                icon: currentIndex == 0 ? const SizedBox.shrink() : const Icon(Icons.store),
                activeIcon: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Color(0xFF9775FA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                label: currentIndex == 0 ? "Home" : '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 1 ? const SizedBox.shrink() : const Icon(Icons.favorite),
                activeIcon: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Wishlist",
                    style: TextStyle(
                      color: Color(0xFF9775FA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                label: currentIndex == 1 ? "Wishlist" : '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 2 ? const SizedBox.shrink() : const Icon(Icons.shopping_cart),
                activeIcon: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Cart",
                    style: TextStyle(
                      color: Color(0xFF9775FA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                label: currentIndex == 2 ? "Cart" : '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 3 ? const SizedBox.shrink() : const Icon(Icons.person),
                activeIcon: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Color(0xFF9775FA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                label: currentIndex == 3 ? "Profile" : '',
              ),
            ],
          ),
        );
      },
    );
  }
}
