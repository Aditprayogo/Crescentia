import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;
  final String productId;

  CartItemWidget({
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        //   Mengatur icon
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),

      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //   Dialog Box
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Remove Item'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are You Sure Want To Delete ?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                shape: StadiumBorder(),
                child: Text('Confirm'),
                onPressed: () {
                  //   Provider.of<Cart>(context, listen: false).removeItem(
                  //     productId,
                  //   );
                  Navigator.of(ctx).pop(true);
                },
                color: Colors.green,
              ),
              FlatButton(
                shape: StadiumBorder(),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('Cancel'),
              )
            ],
          ),
        );
        //   end Dialog Box
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context).removeItem(productId);
      },
      //   end direction
      //   Card
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: ListTile(
            //   Image
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(0)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
      //   end card
    );
  }
}
