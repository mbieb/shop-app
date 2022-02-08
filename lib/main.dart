import 'package:flutter/material.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';

import 'package:provider/provider.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(null, null, []),
          update: (context, value, previous) => Products(value.token,
              value.userId, previous == null ? [] : previous.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null, null, []),
          update: (context, value, previous) => Orders(
            value.token,
            value.userId,
            previous == null ? [] : previous.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Shop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen()
          },
        ),
      ),
    );
  }
}
