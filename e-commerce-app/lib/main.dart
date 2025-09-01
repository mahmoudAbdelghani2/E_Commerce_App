import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/adress/adress_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/review/review_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/views/screens/home_screen.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavCubit()),
        BlocProvider(create: (_) => WishlistCubit()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => AdressCubit()),
        BlocProvider(create: (_) => ReviewCubit()),
        BlocProvider(create: (_) => AuthCubit(AuthService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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