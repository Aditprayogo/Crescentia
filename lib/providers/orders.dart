import 'package:flutter/material.dart';
import 'package:shop_application/providers/cart.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    //   biar di luar kelas ini , kita tidak bisa edit orders
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    const url = 'https://crescentia-b307e.firebaseio.com/orders.json';

    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'products': cartProduct
            .map(
              (cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'imageProduct': cp.imageProduct,
              },
            )
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProduct,
      ),
    );
    // semua widget yang depend melalu order , semuanya bakal di update
    notifyListeners();
  }
}
