import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_state.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/widgets/grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        automaticallyImplyLeading: false,
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                BlocProvider.of<BottomNavCubit>(context).changeTab(2);
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistLoaded) {
            final wishlist = state.wishlistItems;
            if (wishlist.isEmpty) {
              return const Center(
                child: Text(
                  "Your wishlist is empty",
                  style: TextStyle(fontSize: 18, color: AppColors.primaryText),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${wishlist.length} ${wishlist.length == 1 ? 'item' : 'items'}",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    "in wishlist",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: wishlist.length,
                      itemBuilder: (context, index) {
                        final product = wishlist[index];
                        return GridWidget(product: product);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WishlistError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: Text(
                "Something went wrong!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
