import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
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
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryBackground,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     final scaffoldMessenger = ScaffoldMessenger.of(context);
                    //     try {
                    //       scaffoldMessenger.showSnackBar(
                    //         const SnackBar(
                    //             content: Text('Uploading... Please wait.')),
                    //       );
                    //       scaffoldMessenger.showSnackBar(
                    //         const SnackBar(
                    //             content:
                    //                 Text('Upload completed successfully!')),
                    //       );
                    //     } catch (e) {
                    //       scaffoldMessenger.showSnackBar(
                    //         SnackBar(content: Text('Upload failed: $e')),
                    //       );
                    //     }
                    //   },
                    //   child: const Text("Upload Products to Firebase"),
                    // ),
                  ],
                ),
              ),
            );
          } else if (state is AuthError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            // Unauthenticated or Initial state
            return const Center(child: Text("Please log in."));
          }
        },
      ),
    );
  }
}
