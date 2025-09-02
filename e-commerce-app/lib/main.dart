// ignore_for_file: deprecated_member_use

import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/review/review_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/views/screens/home_screen.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  const doSeed = true;
  if (doSeed) {
    try {
      await FirestoreService().fetchProducts();
    } catch (e) {
      debugPrint('Product seeding failed: $e.');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavCubit()),
        BlocProvider(create: (_) => WishlistCubit(
            FirestoreService(),
            FirebaseAuth.instance.currentUser?.uid ?? ''
        )),
        BlocProvider(create: (_) => ProductCubit(FirestoreService())),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ReviewCubit(FirestoreService())),
        BlocProvider(create: (_) => AuthCubit(_authService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(
          primaryColor: const Color(0xFF9775FA),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF9775FA),
          ),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return OpenScreen();
            }
          },
        ),
      ),
    );
  }
}