import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> orderData =
                    orders[index].data() as Map<String, dynamic>;

                if (orderData['isHidden'] == true) {
                  // Skip rendering if the item is hidden
                  return Container();
                }

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Order ID: ${orderData['orderId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Timestamp: ${orderData['timestamp'].toDate()}'),
                        SizedBox(height: 8),
                        Text('Items:'),
                        for (var item in orderData['items'])
                          ListTile(
                            title: Text(item['itemName']),
                            subtitle: Text('Quantity: ${item['quantity']}'),
                          ),
                        SizedBox(height: 8),
                        Container(
                          color: orderData['delivered'] == true
                              ? Colors.green[300]
                              : Colors.blue[300],
                          child: ElevatedButton(
                            onPressed: () {
                              // Toggle delivered status for the entire order
                              markOrderAsDelivered(orderData['orderId'],
                                  !orderData['delivered']);
                            },
                            child: Text(
                              orderData['delivered'] == true
                                  ? 'Delivered'
                                  : 'Mark as Delivered',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Hide the order from the display
                            hideOrder(orders[index].reference);
                          },
                          child: Text(
                            'Hide',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> markOrderAsDelivered(String orderId, bool delivered) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.first.reference
            .update({'delivered': delivered})
            .then((value) => print("Order marked as delivered"))
            .catchError(
                (error) => print("Failed to mark order as delivered: $error"));
      } else {
        print("Document not found for orderId: $orderId");
        // Handle the case when the document is not found
      }
    } catch (error) {
      print("Error getting documents: $error");
      // Handle the error or return a value if needed
      // For example, you can return a Future.error(error) here
    }
  }

  void hideOrder(DocumentReference orderReference) {
    // Hide the order from the local display
    orderReference.update({
      'isHidden': true,
    }).then((value) {
      print("Order hidden from the page.");
    }).catchError((error) {
      print("Failed to hide order: $error");
      // Handle the error or return a value if needed
    });
  }
}
