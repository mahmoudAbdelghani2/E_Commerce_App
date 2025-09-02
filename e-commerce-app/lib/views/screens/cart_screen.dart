// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_state.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/confirmed_screen.dart';
import 'package:e_commerce_app/views/widgets/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  // Address feature removed — Cart shows a fixed delivery address
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        automaticallyImplyLeading: false,
        title: const Text(
          "Cart",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cart'),
                  content: const Text(
                    'Are you sure you want to clear your cart?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CartCubit>().clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        context.read<BottomNavCubit>().changeTab(0);
                      },
                      child: const Text("Start Shopping"),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = state.cartItems[index];
                          return ListWidget(product: cartItem);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Address",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    // Fixed delivery address (hardcoded)
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "abokabir, cairo, egypt",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      subtitle: Text(
                        "Store | 01001373691",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Method",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //ToDo: Navigate to payment method screen
                          },
                          icon: Icon(Icons.arrow_forward_ios),
                          color: AppColors.primaryText,
                        ),
                      ],
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Credit Card",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      subtitle: const Text(
                        "John Doe | +1 234 567 890",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtotal:",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          "\$${cartCubit.getSubtotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tax:",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          "\$${cartCubit.getTaxTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          "\$${cartCubit.getTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Checkout'),
                              content: const Text('Proceed to checkout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<CartCubit>(
                                      context,
                                    ).clearCart();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ConfirmedScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
