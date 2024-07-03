import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/pages/summary_page.dart';
import 'package:project/widgets/cart.dart';
import 'package:project/widgets/drawer.dart';

class ReceiptPage extends StatefulWidget {
  final Cart cart;

  ReceiptPage({required this.cart});

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  String selectedPaymentType = 'GPay'; // Default payment type

  // Function to generate a random order ID
  String generateOrderID() {
    var random = Random();
    return 'ORDER${random.nextInt(100000)}';
  }

  // Function to store the transaction in Firestore
  Future<void> storeTransaction(
    String orderId,
    String paymentType,
    List<CartItem> items,
    double totalAmount,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if a user is logged in
    if (user != null) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Update quantity and mark items as delivered
      for (var item in items) {
        try {
          // Find the document with the matching item name
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('notes')
              .where('note', isEqualTo: item.itemName)
              .get();

          // Check if a document was found
          if (querySnapshot.docs.isNotEmpty) {
            // Update the quantity in the first matching document
            DocumentReference itemRef = querySnapshot.docs.first.reference;
            int currentQuantity = querySnapshot.docs.first['quantity'] ?? 0;

            // Update 'quantity' field with the new quantity
            batch
                .update(itemRef, {'quantity': currentQuantity - item.quantity});
          } else {
            print('Document not found for item: ${item.itemName}');
            // Handle error if needed
            return;
          }
        } catch (e) {
          print('Error updating quantity: $e');
          // Handle error if needed
          return;
        }
      }

      try {
        // Commit the batch
        await batch.commit();
        print('Batch committed successfully');
      } catch (e) {
        print('Error committing batch: $e');
        // Handle error if needed
        return;
      }

      try {
        // Store the transaction in the 'orders' collection
        await FirebaseFirestore.instance.collection('Orders').add({
          'orderId': orderId,
          'paymentType': paymentType,
          'items': items
              .map((item) => {
                    'itemName': item.itemName,
                    'price': item.price,
                    'quantity': item.quantity,
                  })
              .toList(),
          'delivered': false, // Mark the order as not delivered initially
          'totalAmount': totalAmount,
          'timestamp': FieldValue.serverTimestamp(),
          'userEmail': user.email, // Store the user's email
        });

        // Navigate to the summary page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryPage(
              cart: widget.cart,
              orderId: orderId,
            ),
          ),
        );

        // Add your payment logic here if needed
        print('Payment button pressed');
        print('Selected Payment Type: $selectedPaymentType');
      } catch (e) {
        print('Error storing transaction: $e');
        // Handle error if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String orderID = generateOrderID();

    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            for (var item in widget.cart.items)
              ListTile(
                title: Text(item.itemName),
                subtitle: Text(
                  'Price: Rs ${item.price.toStringAsFixed(2)} | Quantity: ${item.quantity}',
                ),
              ),
            SizedBox(height: 16),
            Divider(thickness: 2),
            SizedBox(height: 16),
            Text(
              'Total Amount: Rs ${widget.cart.total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Payment Type Dropdown
                DropdownButton<String>(
                  value: selectedPaymentType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentType = newValue!;
                    });
                  },
                  items: <String>['Credit Card', 'GPay', 'PhonePe', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Payment Button
                ElevatedButton(
                  onPressed: () {
                    storeTransaction(
                      orderID,
                      selectedPaymentType,
                      widget.cart.items,
                      widget.cart.total,
                    );
                  },
                  child: Text('Make Payment'),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
