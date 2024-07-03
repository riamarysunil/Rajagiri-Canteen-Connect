import 'package:flutter/material.dart';
import 'package:project/pages/student_home.dart';
import 'package:project/widgets/cart.dart';
import 'package:project/widgets/drawer.dart';

class SummaryPage extends StatelessWidget {
  final Cart cart;
  final String orderId;

  SummaryPage({required this.cart, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Success'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              SizedBox(height: 16),
              Text(
                'Order Placed Successfully!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Order ID: $orderId',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items Ordered:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Display items from the cart
                  for (var item in cart.items)
                    ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(
                        'Price: Rs ${item.price.toStringAsFixed(2)} | Quantity: ${item.quantity}',
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Clear the cart
                  cart.clearCart();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentHome()),
                  );
                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
