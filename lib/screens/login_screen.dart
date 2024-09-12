import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('Login successful: ${responseData['message']}');

          Fluttertoast.showToast(
            msg: "Login successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          print('Failed to login: ${response.statusCode}');
          print('Response body: ${response.body}');

          Fluttertoast.showToast(
            msg: "Failed to login: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          throw Exception('Failed to login');
        }
      } catch (e) {
        print('Error during login: $e');

        Fluttertoast.showToast(
          msg: "Error during login: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
                          'assets/hiremi_logo.png',
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
                RichText(
                  text: TextSpan(
                    text: 'Email Address',
                    style: AppConstants.fieldTitle,
                    children: const <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'youremail@gmail.com',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 1.0, right: 15),
                      child: Container(
                        height: 53,
                        width: 53,
                        decoration: const BoxDecoration(
                          color: Color(0xfff7f7f7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
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

                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Password',
                    style: AppConstants.fieldTitle,
                    children: const <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: '********',
                    hintStyle: AppConstants.hint,
                    focusColor: Colors.black,
                    focusedBorder: const OutlineInputBorder(),
                    border: const OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 1.0, right: 15),
                      child: Container(
                        height: 53,
                        width: 53,
                        decoration: const BoxDecoration(
                          color: Color(0xfff7f7f7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
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
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: AppConstants.forgotPass,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2, color: Colors.grey),
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Login', style: AppConstants.btnTxtBlk),
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'By logging in, you agree to ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Hiremi\'s Terms & Conditions.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ]),
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
