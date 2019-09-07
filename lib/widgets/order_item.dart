import 'package:flutter/material.dart';
import 'package:shop_application/providers/orders.dart';

import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {
  // list of order
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(DateFormat.yMMMd().format(order.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
