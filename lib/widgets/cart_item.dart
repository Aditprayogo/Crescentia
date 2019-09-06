import 'package:flutter/material.dart';

class CartItems extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItems({
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          leading: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Image.network(imageUrl),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${price * quantity}'),
          trailing: Text('${quantity}x'),
        ),
      ),
    );
  }
}
