// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';

import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_states.dart';
// Address feature removed

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is! Authenticated) {
      setState(() => _isLoading = true);
      try {
        await authCubit.reloadUserData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1250),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryText),
            onPressed: () {
              authCubit.logOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OpenScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          // Loading
          if (state is AuthLoading || _isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.buttonInSubmit,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Loading profile...",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().reloadUserData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonInSubmit,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Error
          if (state is AuthError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 80),
                  const SizedBox(height: 12),
                  const Text(
                    'Error loading profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context.read<AuthCubit>().reloadUserData(),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Try Again"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonInSubmit,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Not authenticated (or need login)
          if (state is! Authenticated) {
            final firebaseUser = FirebaseAuth.instance.currentUser;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.grey.withOpacity(0.5),
                    size: 120,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    firebaseUser != null
                        ? "Failed to load data from database"
                        : "Please log in to view your profile",
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (firebaseUser != null) {
                        setState(() => _isLoading = true);
                        context.read<AuthCubit>().reloadUserData().whenComplete(
                          () => setState(() => _isLoading = false),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const OpenScreen()),
                        );
                      }
                    },
                    icon: Icon(
                      firebaseUser != null ? Icons.refresh : Icons.login,
                    ),
                    label: Text(
                      firebaseUser != null ? "إعادة المحاولة" : "تسجيل الدخول",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonInSubmit,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Authenticated UI (كله مباشر من غير دوال Widgets)
          final user = state.user;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header بسيط
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.buttonInSubmit.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          (user.gender?.toLowerCase() == 'female')
                              ? Icons.female
                              : Icons.male,
                          size: 70,
                          color: (user.gender?.toLowerCase() == 'female')
                              ? Colors.pink
                              : Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      if (user.username != null)
                        Text(
                          "@${user.username}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      if (user.phoneNumber != null)
                        Text(
                          user.phoneNumber!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryText,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // عنوان للقسم
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // كارت معلومات بسيط
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: _iconBox(
                            Icons.person,
                            AppColors.buttonInSubmit,
                          ),
                          title: const Text(
                            "Full Name",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          subtitle: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        if (user.username != null)
                          _dividerWithTile(
                            leading: _iconBox(
                              Icons.alternate_email,
                              Colors.blue,
                            ),
                            title: "Username",
                            value: user.username!,
                          ),
                        _dividerWithTile(
                          leading: _iconBox(Icons.email, Colors.green),
                          title: "Email",
                          value: user.email,
                        ),
                        if (user.gender != null)
                          _dividerWithTile(
                            leading: _iconBox(
                              (user.gender?.toLowerCase() == 'female')
                                  ? Icons.female
                                  : Icons.male,
                              (user.gender?.toLowerCase() == 'female')
                                  ? Colors.pink
                                  : Colors.blue,
                            ),
                            title: "Gender",
                            value: user.gender!,
                          ),
                        if (user.phoneNumber != null)
                          _dividerWithTile(
                            leading: _iconBox(Icons.phone, Colors.teal),
                            title: "Phone Number",
                            value: user.phoneNumber!,
                            showDivider: false,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Address feature removed from Profile

                  const SizedBox(height: 32),

                  // إعدادات (مختصرة)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: _iconBox(Icons.edit, Colors.blue),
                          title: const Text(
                            "Edit Profile",
                            style: TextStyle(color: AppColors.primaryText),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.secondaryText,
                          ),
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Edit profile will be implemented soon",
                                  ),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              ),
                        ),
                        Divider(
                          height: 1,
                          indent: 72,
                          endIndent: 16,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        ListTile(
                          leading: _iconBox(Icons.lock, Colors.orange),
                          title: const Text(
                            "Change Password",
                            style: TextStyle(color: AppColors.primaryText),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.secondaryText,
                          ),
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Change password will be implemented soon",
                                  ),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              ),
                        ),
                        Divider(
                          height: 1,
                          indent: 72,
                          endIndent: 16,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        ListTile(
                          leading: _iconBox(Icons.notifications, Colors.purple),
                          title: const Text(
                            "Notification Settings",
                            style: TextStyle(color: AppColors.primaryText),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.secondaryText,
                          ),
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Notification settings will be implemented soon",
                              ),
                              duration: Duration(milliseconds: 1000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _dividerWithTile({
    required Widget leading,
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 72,
            endIndent: 16,
            color: Colors.grey.withOpacity(0.2),
          ),
      ],
    );
  }
}
