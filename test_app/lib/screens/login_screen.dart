import 'package:flutter/material.dart';

import 'package:test_app/screens/registreation_screen.dart';
import '../constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = true;

  Future<void> _login() async {
    if (_loginFormKey.currentState!.validate()) {
      final Map<String, String> loginData = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      // Print the login data being posted for debugging purposes
      print('Posting login data: ${jsonEncode(loginData)}');

      try {
        final response = await http.post(
          Uri.parse('http://13.127.246.196:8000/login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(loginData),
        );

        if (response.statusCode == 200) {
          // Successfully logged in
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('Login successful: ${responseData['message']}');

          // Navigate to LoginScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );        } else {
          // Failed to log in, show the status code and body for debugging
          print('Failed to login: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception('Failed to login');
        }
      } catch (e) {
        // Handle exceptions like network issues, decoding errors, etc.
        print('Error during login: $e');
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Image.asset(
                          'assets/hiremi_logo.png', // Add your logo image here
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Let's Sign Into Hiremi",
                        style: AppConstants.header,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Text(
                  'Email Address',
                  textAlign: TextAlign.start,
                  style: AppConstants.fieldTitle,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'youremail@gmail.com',
                    prefixIcon: Padding(
                      padding:
                      const EdgeInsets.only(left: 1.0, right: 15),
                      child: Container(
                        height: 53,
                        width: 53,
                        decoration: const BoxDecoration(
                          color: Color(0xfff7f7f7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                5), // Top-left corner radius
                            bottomLeft: Radius.circular(
                                5), // Bottom-left corner radius
                          ),
                          border: Border(
                            right: BorderSide(
                              // Apply border to the right side
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                        ),
                        child: const Icon(Icons.person_2_outlined),
                      ),
                    ),
                    hintStyle: AppConstants.hint,
                    focusColor: Colors.black,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
                  ),
                  style: AppConstants.fieldTitle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    // Add email format validation
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Password',
                  textAlign: TextAlign.start,
                  style: AppConstants.fieldTitle,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: '********',
                    hintStyle: AppConstants.hint,
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(),
                    border: const OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding:
                      const EdgeInsets.only(left: 1.0, right: 15),
                      child: Container(
                        height: 53,
                        width: 53,
                        decoration: const BoxDecoration(
                          color: Color(0xfff7f7f7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                5), // Top-left corner radius
                            bottomLeft: Radius.circular(
                                5), // Bottom-left corner radius
                          ),
                          border: Border(
                            right: BorderSide(
                              // Apply border to the right side
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                        ),
                        child: const Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: AppConstants.fieldTitle,
                  obscureText: isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Ensure this field has at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Add logic for forgot password
                    },
                    child:  Text('Forgot Password?', style: AppConstants.forgotPass,),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Colors.grey),
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Login', style: AppConstants.btnTxtBlk),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'By logging in, you agree to Hiremi\'s Terms & Conditions.',
                    textAlign: TextAlign.center,
                    style: AppConstants.small,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'or',
                    style: AppConstants.fieldTitle,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    backgroundColor: const Color(0xffb61628),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Register Now', style: AppConstants.btnTxt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
