import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const YemeniStoreApp());
}

class YemeniStoreApp extends StatelessWidget {
  const YemeniStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductsProvider()..loadProducts()),
        ChangeNotifierProvider(
            create: (_) => FavoritesProvider()..loadFavorites()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'متجر اليمن',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C66)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F6F8),
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        locale: const Locale('ar'),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const MainNavigation(),
      ),
    );
  }
}
