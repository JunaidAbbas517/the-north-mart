import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _order = [];

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> fetchAndGetOrders() async {
    const url =
        ('https://the-north-mart-default-rtdb.firebaseio.com/orders.json');

    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrders == <String, dynamic>{}) {
      return;
    }
    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (od) => CartItem(
                      id: od['id'],
                      title: od['title'],
                      quantity: od['quantity'],
                      price: od['price']),
                )
                .toList()),
      );
      _order = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    const url =
        ('https://the-north-mart-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'id': timeStamp.toIso8601String(),
        'amount': total,
        'dateTime': timeStamp.toString(),
        'products': cartProduct
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );
    _order.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timeStamp,
      ),
    );

    notifyListeners();
  }
}
