import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/orders.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/widgets/app_drawer.dart';
import 'package:shop_application/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your orders',
          ),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  //do error handling stuff

                  return Center(
                    child: Text('No Data occured'),
                  );
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, ordersData, child) => ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (ctx, i) =>
                          OrderItemWidget(ordersData.orders[i]),
                    ),
                  );
                }
              }
            }));
  }
}
