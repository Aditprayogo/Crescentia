import 'package:flutter/material.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/orders.dart';
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
        ChangeNotifierProvider.value(
          // set Cart provider
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          backgroundColor: Colors.white54,
          primarySwatch: Colors.green,
          accentColor: Colors.deepOrange,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        color: Colors.green,
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
