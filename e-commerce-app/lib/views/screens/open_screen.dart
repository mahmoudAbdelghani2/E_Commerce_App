// ignore_for_file: deprecated_member_use

import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({super.key});

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}
class _OpenScreenState extends State<OpenScreen> {
  bool isSelected1 = true;
  bool isSelected2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // الخلفية بتدرج اللونين
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
          ),
          // صورة الشخص في المنتصف
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset(
                'assets/images/backgroundOpen.png',
                height: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // الكارد الأبيض السفلي
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Look Good, Feel Good",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Create your individual & unique style and look amazing everyday.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // زر Men
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected1 = true;
                                  isSelected2 = false;
                                });
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected1
                                      ? AppColors.buttonInSubmit
                                      : AppColors.buttonUnSelectedInSignUp,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Men",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected1
                                        ? Colors.white
                                        : AppColors.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // زر Women
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected1 = false;
                                  isSelected2 = true;
                                });
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected2
                                      ? AppColors.buttonInSubmit
                                      : AppColors.buttonUnSelectedInSignUp,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Women",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected2
                                        ? Colors.white
                                        : AppColors.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // زر Skip
                      TextButton(
                        onPressed: () {
                          // اللوجيك كما هو
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
