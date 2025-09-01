import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/models/adress_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/add_address_screen.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  
  void _checkCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    print("Current Firebase user in Profile: ${user?.uid ?? 'null'}");
    
    if (user != null) {
      final authCubit = context.read<AuthCubit>();
      final state = authCubit.state;
      print("Current auth state in Profile: $state");
      
      if (state is! Authenticated) {
        setState(() {
          _isLoading = true;
        });
        try {
          print("Manually triggering user data reload in Profile");
          
          await Future.delayed(Duration(milliseconds: 500));
          
          await authCubit.reloadUserData();
          
          final newState = authCubit.state;
          print("New auth state after reload in Profile: $newState");
          
          if (newState is AuthError) {
            print("Error state after reload in Profile: ${newState.message}");
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error loading profile: ${newState.message}"),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          } else if (newState is Authenticated) {
            print("Successfully loaded profile data for: ${newState.user.name}");
          }
        } catch (e) {
          print("Error reloading user data in Profile: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
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
                MaterialPageRoute(builder: (context) => const OpenScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || _isLoading) {
            return _buildLoadingState();
          } else if (state is Authenticated) {
            return _buildAuthenticatedState(state.user);
          } else if (state is AuthError) {
            return _buildErrorState(state.message);
          } else {
            return _buildUnauthenticatedState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.buttonInSubmit),
          const SizedBox(height: 20),
          const Text(
            "Loading profile...",
            style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().reloadUserData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonInSubmit,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedState(dynamic user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 24),
            
            _buildSectionTitle("Personal Information"),
            _buildInfoCard([
              _buildInfoTile(
                title: "Full Name",
                value: user.name,
                icon: Icons.person,
                iconColor: AppColors.buttonInSubmit,
              ),
              if (user.username != null)
                _buildInfoTile(
                  title: "Username",
                  value: user.username!,
                  icon: Icons.alternate_email,
                  iconColor: Colors.blue,
                ),
              _buildInfoTile(
                title: "Email",
                value: user.email,
                icon: Icons.email,
                iconColor: Colors.green,
              ),
              if (user.gender != null)
                _buildInfoTile(
                  title: "Gender",
                  value: user.gender!,
                  icon: user.gender?.toLowerCase() == 'female' ? Icons.female : Icons.male,
                  iconColor: user.gender?.toLowerCase() == 'female' ? Colors.pink : Colors.blue,
                ),
              if (user.phoneNumber != null)
                _buildInfoTile(
                  title: "Phone Number",
                  value: user.phoneNumber!,
                  icon: Icons.phone,
                  iconColor: Colors.teal,
                ),
            ]),
            
            const SizedBox(height: 24),
            
            _buildSectionTitle("Addresses"),
            
            if (user.addresses.isEmpty) 
              _buildEmptyAddressCard()
            else
              ...user.addresses.map((address) => _buildAddressCard(address)).toList(),
            
            const SizedBox(height: 16),
            
            _buildAddButton("Add New Address", Icons.add_location_alt, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddressScreen(
                    isFirstAddress: user.addresses.isEmpty,
                    onAddressAdded: (newAddress) async {
                      try {
                        // Show loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Saving address..."), duration: Duration(seconds: 2)),
                        );
                        
                        // If the new address is set as default, we need to update all other addresses
                        final updatedAddresses = List<AddressModel>.from(user.addresses);
                        
                        if (newAddress.isPrimary) {
                          // Set all other addresses as non-default
                          for (int i = 0; i < updatedAddresses.length; i++) {
                            if (updatedAddresses[i].isPrimary) {
                              updatedAddresses[i] = updatedAddresses[i].copyWith(isPrimary: false);
                            }
                          }
                        }
                        
                        // Add the new address
                        updatedAddresses.add(newAddress);
                        
                        // Update user in Firestore
                        final authCubit = context.read<AuthCubit>();
                        await authCubit.updateUserAddresses(updatedAddresses);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Address saved successfully!"), backgroundColor: Colors.green),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error saving address: $e"), backgroundColor: Colors.red),
                        );
                      }
                    },
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // Account Settings Section
            _buildSectionTitle("Account Settings"),
            _buildSettingsCard(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.buttonInSubmit.withOpacity(0.1),
          child: Icon(
            user.gender?.toLowerCase() == 'female' ? Icons.female : Icons.male,
            size: 70,
            color: user.gender?.toLowerCase() == 'female' ? Colors.pink : Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
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
              fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
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
    );
  }

  Widget _buildEmptyAddressCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off,
                size: 48,
                color: AppColors.secondaryText,
              ),
              const SizedBox(height: 8),
              Text(
                "No address added",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.buttonInSubmit.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.buttonInSubmit,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    address.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                  ),
                  if (address.isPrimary)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Primary",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address.address}, ${address.city}, ${address.country}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${address.name} | ${address.phoneNumber}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert, color: AppColors.secondaryText),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                    onTap: () {
                      // TODO: Implement edit address
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
                    onTap: () {
                      // TODO: Implement delete address
                    },
                  ),
                  if (!address.isPrimary)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text("Set as primary"),
                        ],
                      ),
                      onTap: () {
                        // TODO: Implement set as primary
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonInSubmit,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildSettingsTile(
            title: "Edit Profile",
            icon: Icons.edit,
            iconColor: Colors.blue,
            onTap: () {
              // TODO: Implement edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit profile will be implemented soon")),
              );
            },
          ),
          _buildSettingsTile(
            title: "Change Password",
            icon: Icons.lock,
            iconColor: Colors.orange,
            onTap: () {
              // TODO: Implement change password
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Change password will be implemented soon")),
              );
            },
          ),
          _buildSettingsTile(
            title: "Notification Settings",
            icon: Icons.notifications,
            iconColor: Colors.purple,
            onTap: () {
              // TODO: Implement notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notification settings will be implemented soon")),
              );
            },
          ),
          _buildSettingsTile(
            title: "Privacy Policy",
            icon: Icons.privacy_tip,
            iconColor: Colors.green,
            onTap: () {
              // TODO: Show privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Privacy policy will be shown soon")),
              );
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.secondaryText),
          onTap: onTap,
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

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 80),
          const SizedBox(height: 16),
          Text(
            'Error loading profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AuthCubit>().reloadUserData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonInSubmit,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedState() {
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
          const SizedBox(height: 24),
          Text(
            firebaseUser != null 
              ? "Failed to load data from database" 
              : "Please log in to view your profile",
            style: TextStyle(fontSize: 18, color: AppColors.secondaryText),
            textAlign: TextAlign.center,
          ),
          if (firebaseUser != null) ...[
            const SizedBox(height: 16),
            Text(
              "We need to reload your data",
              style: TextStyle(fontSize: 16, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (firebaseUser != null) {
                    // Try to reload data
                    setState(() => _isLoading = true);
                    context.read<AuthCubit>().reloadUserData().then((_) {
                      setState(() => _isLoading = false);
                    }).catchError((e) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("حدث خطأ: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  } else {
                    // الانتقال إلى شاشة تسجيل الدخول
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OpenScreen()),
                    );
                  }
                },
                icon: Icon(firebaseUser != null ? Icons.refresh : Icons.login),
                label: Text(firebaseUser != null ? "إعادة المحاولة" : "تسجيل الدخول"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonInSubmit,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (firebaseUser != null) ...[
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () async {
                    try {
                      // تسجيل الخروج وإعادة تسجيل الدخول
                      await context.read<AuthCubit>().logOut();
                      
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const OpenScreen()),
                        (route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("حدث خطأ: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
