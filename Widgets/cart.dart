// cart.dart
import 'package:flutter/material.dart';

class CartItem {
  final String itemName;
  final double price;
  final int availableQuantity; // Add availableQuantity property
  int quantity; // Add quantity property

  CartItem({
    required this.itemName,
    required this.price,
    required this.availableQuantity,
    this.quantity = 1, // Default quantity is 1
  });
}

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    int index =
        _items.indexWhere((element) => element.itemName == item.itemName);

    if (index != -1 && _items[index].quantity < item.availableQuantity) {
      _items[index].quantity += 1;
    } else if (index == -1 && item.availableQuantity > 0) {
      _items.add(item);
    }

    notifyListeners();
  }

  double get total {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void increaseQuantity(int index, BuildContext context) {
    if (_items[index].quantity < _items[index].availableQuantity) {
      _items[index].quantity++;
      notifyListeners();
    } else {
      // Show a snackbar indicating item unavailability
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item is not available in the selected quantity.'),
        ),
      );
    }
  }

  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    items.clear();
  }
}
