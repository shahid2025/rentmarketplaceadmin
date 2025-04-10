import 'package:flutter/material.dart';
import 'package:rentmarketplaceadmin/screen/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Static credentials
  final String staticEmail = "admin@gmail.com";
  final String staticPassword = "password123";

  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State for password visibility toggle
  bool _isPasswordVisible = false;

  // Function to handle login
  void _handleLogin() {
    if (emailController.text == staticEmail &&
        passwordController.text == staticPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials!")),
      );
    }
  }

  // Function to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  // Mobile layout
  Widget _buildMobileLayout() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextFields(),
              const SizedBox(height: 20),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Desktop layout
  Widget _buildDesktopLayout() {
    return Center(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextFields(),
              const SizedBox(height: 20),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build text fields
  Widget _buildTextFields() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          obscureText: !_isPasswordVisible, // Toggle visibility
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon:
              Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: _togglePasswordVisibility, // Call toggle function
            ),
          ),
        ),
      ],
    );
  }

  // Method to build login button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style:
      ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      child: const Text("Login"),
    );
  }
}

