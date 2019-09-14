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

  Future<void> fetchAndSetOrders() async {
    const url = 'https://crescentia-b307e.firebaseio.com/orders.json';

    final response = await http.get(url);

    final List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          // buat convert ke list of items
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  imageProduct: item['imageProduct'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
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
                'price': cp.price,
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
