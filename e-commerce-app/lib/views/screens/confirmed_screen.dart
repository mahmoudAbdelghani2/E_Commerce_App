// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ConfirmedScreen extends StatelessWidget {
  const ConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Lottie.asset(
                        'assets/lottie/delivery.json',
                        repeat: true,
                        animate: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    const Text(
                      "Order Confirmed!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      "Your order has been confirmed, we will send you confirmation email shortly.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                  ],
                ),
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9775FA),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {

                  context.read<BottomNavCubit>().changeTab(0);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
