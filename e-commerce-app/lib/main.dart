import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/review/review_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/views/screens/home_screen.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set Firestore settings to enable offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
   await FirebaseFirestore.instance.collection('products').doc('21').set(
    {
    "id": 21,
    "title": "Nike Training T-Shirt",
    "price": 30,
    "description": "Men's Nike Dri-FIT short sleeve training t-shirt.",
    "category": "men",
    "brand": "Nike",
      "image": "https://res.cloudinary.com/dxpjipiyh/image/upload/v1756682423/1_lrsziy.jpg",
    });

    await FirebaseFirestore.instance.collection('products').doc('21').collection("product_images").add({
      "image": "https://res.cloudinary.com/dxpjipiyh/image/upload/v1756682423/1_lrsziy.jpg",
    });
  // This will upload all products and images every time the app starts.
  // It is recommended to remove this line in a production environment.
  try {
    // await UploadService().uploadProductsAndImages();
  } catch (e) {

    // Handle the error appropriately in a real app
  debugPrint('MAHMOUD :::Error uploading products and images: $e');
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
        BlocProvider(create: (_) => WishlistCubit()),
        BlocProvider(create: (_) => ProductCubit()),
  BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ReviewCubit()),
        BlocProvider(create: (context) {
          final authCubit = AuthCubit(_authService);
          // التحقق من بيانات الدخول المحفوظة عند بدء التطبيق
          Future.microtask(() => authCubit.checkSavedCredentials());
          return authCubit;
        }),
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
              // إظهار شاشة التحميل أثناء التحقق من حالة المصادقة
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData) {
              // إذا كان المستخدم مسجل الدخول
              
              return HomeScreen();
            } else {
              // إذا لم يكن المستخدم مسجل الدخول
              
              return OpenScreen();
            }
          },
        ),
      ),
    );
  }
}