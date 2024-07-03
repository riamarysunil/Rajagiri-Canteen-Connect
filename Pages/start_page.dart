import 'package:flutter/material.dart';
import 'package:project/pages/admin_login.dart';
import 'package:project/pages/st_login.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          // Profile Dropdown
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle), // Set the profile icon
            onSelected: (value) {
              if (value == 'Canteen Staff') {
                // Handle admin option
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminLogin(),
                  ),
                );
              } else if (value == 'Student') {
                // Handle student option
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Canteen Staff',
                child: Text('Canteen Staff'),
              ),
              PopupMenuItem<String>(
                value: 'Student',
                child: Text('Student'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0), // Adjust the padding as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.jpg',
                width: 500, // Adjust the width as needed
                height: 250, // Adjust the height as needed
              ),
              SizedBox(height: 20),
              Text(
                'Good Food, Good Mood!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '"Experience a world of tasty delights at our canteen. Where every bite is a treat and every meal is a celebration!"',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
