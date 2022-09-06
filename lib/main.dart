import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './models/auth.dart';
import './models/orders.dart';
import './models/products.dart';
import './models/cart.dart';

import './pages/auth_page.dart';
import './pages/add_edit_product_page.dart';
import './pages/manage_product_page.dart';
import './pages/orders_overview_page.dart';
import './pages/cart_overview_page.dart';
import './pages/product_detail_page.dart';
import './pages/product_overview_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, []),
          update: (ctx, auth, previousData) => Products(
              auth.fetchSignInUserId,
              // ignore: unnecessary_null_comparison
              previousData!.items == null ? [] : previousData.items),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, []),
          update: (context, auth, previousData) => Orders(
              auth.fetchSignInUserId,
              // ignore: unnecessary_null_comparison
              previousData!.orders == null ? [] : previousData.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
                .copyWith(secondary: Colors.deepOrange),
            primarySwatch: Colors.pink,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? const ProductOverviewPage() : const AuthPage(),
          routes: {
            ProductDetailPage.routeName: (context) => const ProductDetailPage(),
            CartOverviewPage.routeName: (context) => const CartOverviewPage(),
            OrdersOverviewPage.routeName: (context) =>
                const OrdersOverviewPage(),
            ManageProductPage.routeName: (context) => const ManageProductPage(),
            AddEditProductPage.routeName: (context) =>
                const AddEditProductPage(),
          },
        ),
      ),
    );
  }
}
