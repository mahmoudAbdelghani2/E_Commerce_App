import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/signup_screen.dart';
import 'package:flutter/material.dart';

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
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
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
                    if (!RegExp(r'\\d').hasMatch(value)) {
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
                    if (!RegExp(r'\\d').hasMatch(value)) {
                      return 'Password must contain at least one number';
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // تنفيذ عملية تسجيل الدخول
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
