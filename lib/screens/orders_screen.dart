import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/orders.dart';
import 'package:shop_application/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your orders',
        ),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i) => OrderItemWidget(ordersData.orders[i]),
      ),
    );
  }
}
