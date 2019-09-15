import 'package:flutter/material.dart';
import 'package:shop_application/providers/auth.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/orders.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/screens/auth-screen.dart';
import 'package:shop_application/screens/cart_screen.dart';
import 'package:shop_application/screens/new_product_screen.dart';
import 'package:shop_application/screens/orders_screen.dart';
import 'package:shop_application/screens/product_detail_screen.dart';
import 'package:shop_application/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //   provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          // set Cart provider
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          // set Cart provider
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        //   material app bakal rebuild kalau auth changes
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            backgroundColor: Colors.white54,
            primarySwatch: Colors.green,
            accentColor: Colors.deepOrange,
            canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          color: Colors.green,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            NewProductScreen.routeName: (context) => NewProductScreen(),
          },
        ),
      ),
    );
  }
}
