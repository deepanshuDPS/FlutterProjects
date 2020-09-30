import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/auth.dart';
import 'package:flutter_shop/screens/product_overview_screen.dart';
import 'package:flutter_shop/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'helper/custom_route.dart';
import 'providers/orders.dart';
import 'screens/cart_screen.dart';
import 'providers/cart.dart';
import 'screens/product_detail_screen.dart';
import 'providers/products_provider.dart';
import 'screens/order_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProduct) => Products(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items),
          create: null,
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (ctx, auth, previousOrders) => Order(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.items),
          create: null,
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android:CustomPageTransactionBuilder(),
              TargetPlatform.iOS:CustomPageTransactionBuilder(),
            }
          )),
          routes: {
            "/": (ctx) => auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    initialData: auth.isLogin(),
                    builder: (ctx, dataSnapshot) =>
                        dataSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        );
      }),
    );
  }
}
