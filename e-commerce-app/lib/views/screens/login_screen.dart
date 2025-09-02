// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/home_screen.dart';
import 'package:e_commerce_app/views/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSwitched = false;

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
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              ),
            ),
          ),
        ),
        leadingWidth: 56,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Please enter your data to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 130),
                TextFormField(
                  controller: _usernameController,
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

                    final password = value.trim();
                    final regex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
                    );

                    if (!regex.hasMatch(password)) {
                      return 'Password must be at least 8 characters and include upper, lower, and number';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text.rich(
                    TextSpan(
                      text:
                          'By connecting your account confirm that you agree with our ',
                      style: const TextStyle(
                        color: Color(0xFF8F959E),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Term and Condition',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
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
                      if (_formKey.currentState!.validate()) {
                        final authCubit = context.read<AuthCubit>();

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(width: 16),
                                Text('Logging in... Please wait'),
                              ],
                            ),
                            backgroundColor: Colors.blue,
                            duration: Duration(milliseconds: 500),
                          ),
                        );

                        try {
                          await authCubit.logIn(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          if (!mounted) return;

                          await Future.delayed(Duration(milliseconds: 500));
                          if (!mounted) return;

                          final currentState = authCubit.state;

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          if (currentState is Authenticated) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Login successful! Welcome back, ${currentState.user.name}',
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(milliseconds: 500),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } else if (currentState is AuthError) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${currentState.message}'),
                                backgroundColor: Colors.red,
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Login failed. Please try again.',
                                ),
                                backgroundColor: Colors.orange,
                                duration: Duration(milliseconds: 500),
                              ),
                            );

                            final currentUser =
                                FirebaseAuth.instance.currentUser;

                            if (currentUser != null) {
                              try {
                                await authCubit.reloadUserData();
                                if (!mounted) return;

                                await Future.delayed(
                                  Duration(milliseconds: 500),
                                );
                                if (!mounted) return;

                                final newState = authCubit.state;

                                if (!mounted) return;
                                if (newState is Authenticated) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('Reload error: $e');
                              }
                            }
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Login error: ${error.toString()}'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
