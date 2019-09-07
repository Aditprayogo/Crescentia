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
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      //   end direction

      //   Card
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 100,
        child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: ListTile(
            //   Image
            leading: Container(
              padding: EdgeInsets.all(4),
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              //   image
              child: Image.network(imageUrl),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
      //   end card
    );
  }
}
