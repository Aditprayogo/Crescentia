import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/cart.dart' as prefix0;

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
        backgroundColor: Colors.amber,
      ),
      //   body
      body: Column(
        children: <Widget>[
          // Card
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              //   Row
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Total :',
                      style: TextStyle(fontSize: 20),
                    ),
                    //   sized box untuk nambah jarak

                    Chip(
                      label: Text(
                        '\$${cart.totalAmountCart}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    VerticalDivider(
                      width: 1,
                      color: Colors.black,
                    ),
                    // tombol order now
                    FlatButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {},
                      textColor: Theme.of(context).primaryTextTheme.title.color,
                      child: Text('Order Now'),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // listview dalam column tidak work
          // kudu di wrap pake expanded
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItemWidget(
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                imageUrl: cart.items.values.toList()[i].imageProduct,
                productId: cart.items.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}
