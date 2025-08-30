import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_repo.dart';
import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_repo.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_repo.dart';
import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_repo.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/views/screens/home_screen.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirestoreService().uploadProductsFromJson();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavCubit()),
        BlocProvider(create: (_) => WishlistCubit(WishlistRepository())),
        BlocProvider(create: (_) => ProductCubit(ProductRepository(FirestoreService()))),
        BlocProvider(create: (_) => CartCubit(CartRepository())),
        BlocProvider(create: (_) => AuthCubit(AuthRepository(AuthService()))),
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