// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/home_screen.dart';
import 'package:e_commerce_app/views/screens/login_screen.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  final String? selectedGender;
  
  const SignUpScreen({super.key, this.selectedGender});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSwitched = false;
  bool showValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF5F6FA),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OpenScreen(),
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 56,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: showValidationErrors
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 130),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    label: Text('Name'),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE7E6E9)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonInSubmit),
                    ),
                    suffixIcon: (_formKey.currentState?.validate() ?? false)
                        ? Icon(Icons.check, color: Color(0xFF34C559))
                        : null,
                    errorMaxLines: 2,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name can only contain letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    label: Text('Username'),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE7E6E9)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonInSubmit),
                    ),
                    suffixIcon: (_formKey.currentState?.validate() ?? false)
                        ? Icon(Icons.check, color: Color(0xFF34C559))
                        : null,
                    errorMaxLines: 2,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your username';
                    }
                    if (value.trim().length < 6) {
                      return 'Username must be at least 6 characters';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Username must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Username must contain at least one number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    label: Text('Password'),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE7E6E9)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonInSubmit),
                    ),
                    suffixIcon: (_formKey.currentState?.validate() ?? false)
                        ? Icon(Icons.check, color: Color(0xFF34C559))
                        : null,
                    errorMaxLines: 2,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    label: Text('Email'),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE7E6E9)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonInSubmit),
                    ),
                    suffixIcon: (_formKey.currentState?.validate() ?? false)
                        ? Icon(Icons.check, color: Color(0xFF34C559))
                        : null,
                    errorMaxLines: 2,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                SwitchListTile(
                  title: Text(
                    'Remember me',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 15,
                    ),
                  ),
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonInSubmit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      setState(() {
                        showValidationErrors = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(color: AppColors.buttonInSubmit),
                                  SizedBox(height: 16),
                                  Text("Creating account... Please wait"),
                                ],
                              ),
                            ),
                          );
                          
                          final authCubit = context.read<AuthCubit>();
                          
                          if (widget.selectedGender != null) {
                            await authCubit.signUpWithGender(
                              _nameController.text, 
                              _emailController.text, 
                              _passwordController.text,
                              gender: widget.selectedGender
                            );
                          } else {
                            await authCubit.signUp(
                              _nameController.text, 
                              _emailController.text, 
                              _passwordController.text
                            );
                          }
                          
                          await Future.delayed(Duration(milliseconds: 500));
                          
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Account created successfully! Redirecting to home...'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        } catch (error) {
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                          
                          String errorMessage = error.toString();
                          if (errorMessage.contains("email-already-in-use")) {
                            errorMessage = "Email is already in use";
                          } else if (errorMessage.contains("weak-password")) {
                            errorMessage = "Password is too weak";
                          } else if (errorMessage.contains("invalid-email")) {
                            errorMessage = "Invalid email format";
                          } else if (errorMessage.contains("permission-denied")) {
                            errorMessage = "Permission denied. Check Firebase rules";
                          }
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to create account: $errorMessage'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: AppColors.buttonInSubmit,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
