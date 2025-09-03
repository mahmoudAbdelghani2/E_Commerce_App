import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/views/screens/cart_screen.dart';
import 'package:e_commerce_app/views/screens/product_screen.dart';
import 'package:e_commerce_app/views/screens/profile_screen.dart';
import 'package:e_commerce_app/views/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';

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
            onTap: (_) {},
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xFF9775FA),
            unselectedItemColor: const Color(0xFF8F959E),
            items: [
              _navItem(
                context: context,
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.store,
                label: "Home",
              ),
              _navItem(
                context: context,
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.favorite,
                label: "Wishlist",
              ),
              _navItem(
                context: context,
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.shopping_cart,
                label: "Cart",
              ),
              _navItem(
                context: context,
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.person,
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _navItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: LikeButton(
        size: 28,
        isLiked: currentIndex == index,
        circleColor: const CircleColor(
          start: Color(0xff9b5de5),
          end: Color(0xfff15bb5),
        ),
        bubblesColor: const BubblesColor(
          dotPrimaryColor: Color(0xff9b5de5),
          dotSecondaryColor: Color(0xfff15bb5),
        ),
        likeBuilder: (bool isLiked) {
          return Icon(
            icon,
            color: isLiked ? const Color(0xFF9775FA) : const Color(0xFF8F959E),
          );
        },
        onTap: (isLiked) async {
          context.read<BottomNavCubit>().changeTab(index);
          return true;
        },
      ),
      label: currentIndex == index ? label : '',
    );
  }
}
