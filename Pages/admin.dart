import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/admin_home.dart';
import 'package:project/pages/admin_login.dart';
import 'package:project/pages/view_orders.dart';

class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Add Items page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHome()),
                );
              },
              child: Text('Add Items'),
              style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(vertical: 20), // Adjust the height
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the View Orders page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewOrders()),
                );
              },
              child: Text('View Orders'),
              style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(vertical: 20), // Adjust the height
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdminLogin()))
                    });
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set the button color to red
                padding:
                    EdgeInsets.symmetric(vertical: 20), // Adjust the height
              ),
            ),
          ],
        ),
      ),
    );
  }
}
