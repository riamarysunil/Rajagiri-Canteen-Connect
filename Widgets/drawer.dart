import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/pages/cart_page.dart';
import 'package:project/pages/history.dart';
import 'package:project/pages/st_login.dart';
import 'package:project/pages/student_home.dart';
import 'package:project/widgets/cart.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    // Call getUserData() when initializing the widget
    getUserData();
  }

  void getUserData() async {
    if (user != null) {
      // Query the Users collection to get the user document based on email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: user!.email)
          .get();

      // Extract user data from the first document in the result (assuming there is only one match)
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userData = querySnapshot.docs[0].data() as Map<String, dynamic>;

          // If "Name" field is not available or empty, use a default value
          if (userData?['Name'] == null || userData?['Name'].isEmpty) {
            userData?['Name'] = 'Guest';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              accountName: Text(
                user != null ? (userData?['Name'] ?? 'Guest') : 'Guest',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              accountEmail: Text(
                user != null
                    ? user!.email ?? 'abcd@gmail.com'
                    : 'abcd@gmail.com',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              currentAccountPicture: CircleAvatar(
                // Use a default profile image or replace it with the actual path
                backgroundImage: AssetImage("images/profile.jpg"),
              ),
            ),
          ),

          // List Tile
          ListTile(
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.red,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => StudentHome()));
            },
          ),

          // List Tile
          ListTile(
            leading: Icon(
              CupertinoIcons.cart,
              color: Colors.red,
            ),
            title: Text(
              "Cart",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartPage(
                            cart: Cart(),
                          )));
            },
          ),

          ListTile(
            leading: Icon(
              Icons.history,
              color: Colors.red,
            ),
            title: Text(
              "History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            },
          ),

          // List Tile
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()))
                  });
            },
          ),
        ],
      ),
    );
  }
}
