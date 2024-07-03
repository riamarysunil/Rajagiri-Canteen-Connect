import 'package:flutter/material.dart';
import 'package:project/pages/admin.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Predefined credentials
  final String predefinedUserId = "admin@rccrset";
  final String predefinedPassword = "collegecanteen123";

  bool _isLoginFailed = false;
  bool _showPassword = false;

  void _login() {
    // Check if entered credentials match predefined values
    if (_userIdController.text == predefinedUserId &&
        _passwordController.text == predefinedPassword) {
      // Successful login, navigate to the next screen or perform other actions
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Admin()),
      );
    } else {
      // Login failed
      setState(() {
        _isLoginFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image at the center
              Image.asset(
                'images/logo.jpg', // Replace with your image asset
                width: 500, // Adjust the width as needed
                height: 200, // Adjust the height as needed
              ),
              SizedBox(height: 16),

              // TextFields for User ID and Password
              TextField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey, // Set the color to black
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),

              // ElevatedButton for login
              ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20), // Adjusted size here
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 15), // Increased font size here
                    ),
                  ),
                ),
              ),

              // Error message if login fails
              if (_isLoginFailed)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Incorrect User ID or Password. Please try again.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
