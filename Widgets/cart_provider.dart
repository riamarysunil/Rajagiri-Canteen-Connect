import 'package:flutter/material.dart';
import 'cart.dart';

class CartProvider extends InheritedNotifier {
  final Cart cart;

  const CartProvider({Key? key, required Widget child, required this.cart})
      : super(key: key, child: child, notifier: cart);

  static Cart of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartProvider>()!.cart;
  }
}
