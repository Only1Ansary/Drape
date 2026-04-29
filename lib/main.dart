import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/cubits/auth/auth_cubit.dart';
import 'package:project/screens/first.dart';
import 'package:project/cubits/products/product_cubit.dart';
import 'package:project/cubits/cart/cart_cubit.dart';
import 'package:project/cubits/wishlist/wishlist_cubit.dart';
import 'package:project/services/api_services.dart';
import 'package:project/services/firestore_services.dart'; // new service
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreServices = FirebaseServices();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(firestoreServices)..fetchProducts(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<WishlistCubit>(
          create: (context) => WishlistCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(firestoreServices),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: First(),
      ),
    );
  }
}
