import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/widgets/drawer.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('userEmail', isEqualTo: user?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }

          List<DocumentSnapshot> transactions = snapshot.data!.docs;

          // Sort orders based on timestamp in descending order
          transactions.sort((a, b) =>
              b['timestamp'].toDate().compareTo(a['timestamp'].toDate()));

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> transactionData =
                  transactions[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 5,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Date: ${transactionData['timestamp'].toDate()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in transactionData['items'])
                        ListTile(
                          title: Text('Item: ${item['itemName']}'),
                          subtitle: Text(
                            'Quantity: ${item['quantity']}',
                          ),
                        ),
                      SizedBox(height: 8),
                      Text(
                        'Total Amount: Rs ${transactionData['totalAmount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: DrawerWidget(),
    );
  }
}
