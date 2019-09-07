import 'package:flutter/material.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/screens/cart_screen.dart';
import 'package:shop_application/screens/product_detail_screen.dart';
import 'package:shop_application/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //   provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          // set products provider
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          // set Cart provider
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
        },
      ),
    );
  }
}
