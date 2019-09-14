import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/cart.dart' as prefix0;
import 'package:shop_application/providers/orders.dart';

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
                        '\$${cart.totalAmountCart.toStringAsFixed(0)}',
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
                    OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void _showcontent() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          elevation: 10,
          title: new Text('Success'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Berhasil menambahkan orders'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
      onPressed: (widget.cart.totalAmountCart <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              //   buat menconver ke list , jadi di tambahin values
              await Provider.of<Orders>(context).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmountCart,
              );

              _showcontent();

              setState(() {
                _isLoading = false;
              });

              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryTextTheme.title.color,
    );
  }
}
