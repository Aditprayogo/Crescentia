import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/screens/cart_screen.dart';
import 'package:shop_application/widgets/badge.dart';
import 'package:shop_application/widgets/products_grid.dart';
import 'package:shop_application/widgets/shop_cart_icons.dart';

import '../widgets/product_item.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavoriteData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caslevania'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          // mengatur badge cart
          //   memakai consumer berarti widget ini saja yang rebuild
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(
                Shop_cart.basket,
              ),
            ),
          ),
          // mengatur pop up menu buttom
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorite) {
                  _showOnlyFavoriteData = true;
                } else {
                  _showOnlyFavoriteData = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorite'),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOption.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavoriteData),
    );
  }
}
