// cart_page.dart
import 'package:flutter/material.dart';
import 'package:project/pages/receipt_page.dart';
import 'package:project/widgets/cart.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final Cart cart;
  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 100,
              height: 300,
              child: Image.asset(
                'images/${cart.items[index].itemName.toLowerCase()}.jpg',
                fit: BoxFit.fill,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cart.items[index].itemName),
                Row(
                  children: [
                    Text(
                      'Rs ${cart.items[index].price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Quantity: ${cart.items[index].quantity}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        cart.decreaseQuantity(index);
                      },
                      child: Text('-'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        cart.increaseQuantity(index, context);
                      },
                      child: Text('+'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        cart.removeItem(index);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
                SizedBox(height: 20)
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: Rs ${cart.total.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: cart.items.isEmpty
                  ? null // Disable button when cart is empty
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(cart: cart),
                        ),
                      );
                    },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
