import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test_app/constants/global.dart';
import 'dart:convert';

import 'package:test_app/screens/login_screen.dart';

import '../constants/app_constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isSecondVisible = true;
  bool isFirstVisible = true;
  String _selectedCollegeState = '';
  String _selectedBirthPlace = '';
  String _selectedBranch = '';

  String _selectedDegree = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _whatsappNumberController =
      TextEditingController();
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _gender = 'Male';
  String _selectedPassoutYear = '2024';
  final List<String> _passoutYears = ['2022', '2023', '2024', '2025', '2026'];
  final List<String> _birthPlaces = [
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Ahmedabad',
    'Lucknow',
    'Kolkata',
    'Jaipur',
    'Bhopal',
    'Chandigarh',
    'Patna'
  ];
  final List<String> _collegeStates = [
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'Gujarat',
    'Uttar Pradesh',
    'West Bengal',
    'Rajasthan',
    'Madhya Pradesh',
    'Punjab',
    'Haryana'
  ];
  final List<String> _branches = [
    'Computer Science',
    'Mechanical Engineering',
    'Civil Engineering',
    'Electronics and Communication',
    'Electrical Engineering',
    'Information Technology',
    'Chemical Engineering',
    'Biotechnology',
    'Aerospace Engineering',
    'Automobile Engineering'
  ];
  final List<String> _degrees = [
    'B.E.',
    'B.Tech',
    'B.Sc',
    'B.Com',
    'B.A.',
    'M.Tech',
    'M.Sc',
    'MCA',
    'MBA',
    'Ph.D.'
  ];

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> postData = {
        'full_name': _fullNameController.text,
        'father_name': _fatherNameController.text,
        'email': _emailController.text,
        'date_of_birth': _dateOfBirthController.text,
        'gender': _gender,
        'phone_number': _phoneNumberController.text,
        'whatsapp_number': _whatsappNumberController.text,
        'college_state': _selectedCollegeState,
        'birth_place': _selectedBirthPlace,
        'college_name': _collegeNameController.text,
        'branch_name': _selectedBranch,
        'degree_name': _selectedDegree,
        'passing_year': int.parse(_selectedPassoutYear),
        'password': _passwordController.text,
      };

      print('Posting data: ${jsonEncode(postData)}');

      try {
        final response = await http.post(
          Uri.parse('http://13.127.246.196:8000/api/registers/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('Registration successful: $responseData');

          GlobalState().registeredEmail = _emailController.text;
          print('Registered email: ${GlobalState().registeredEmail}');

          Fluttertoast.showToast(
            msg: "Registration successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          print('Failed to register: ${response.statusCode}');
          print('Response body: ${response.body}');

          Fluttertoast.showToast(
            msg: "Registration failed: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          throw Exception('Failed to register');
        }
      } catch (e) {
        print('Error during registration: $e');

        Fluttertoast.showToast(
          msg: "Error during registration: $e",
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    'assets/hiremi_logo_1.png',
                    height: 100,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Register to get started',
                    style: AppConstants.header,
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Personal Information',
                          style: AppConstants.header,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Full Name',
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
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          hintText: 'John Doe',
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        style: AppConstants.fieldTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: "Father's Full Name",
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
                        controller: _fatherNameController,
                        decoration: InputDecoration(
                          hintText: 'Robert Dave',
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        style: AppConstants.fieldTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your father\'s full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Gender',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 'Male',
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value.toString();
                                    });
                                  },
                                ),
                                Text(
                                  'Male',
                                  style: AppConstants.fieldTitle,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 'Female',
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value.toString();
                                    });
                                  },
                                ),
                                Text(
                                  'Female',
                                  style: AppConstants.fieldTitle,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 'Other',
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value.toString();
                                    });
                                  },
                                ),
                                Text(
                                  'Other',
                                  style: AppConstants.fieldTitle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
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
                          text: 'Date of Birth',
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
                        controller: _dateOfBirthController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dateOfBirthController.text = formattedDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.only(left: 1.0, right: 15),
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
                              child: const Icon(Icons.calendar_month_rounded),
                            ),
                          ),
                          hintText: 'YYYY-MM-DD',
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(),
                        ),
                        style: AppConstants.fieldTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                            return 'Use the format YYYY-MM-DD';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Birth State',
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
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 250,
                        borderRadius: BorderRadius.circular(10),
                        style: AppConstants.dropdown,
                        isDense: true,
                        value: _selectedBirthPlace.isNotEmpty
                            ? _selectedBirthPlace
                            : null,
                        decoration: InputDecoration(
                          hintText: "Birth State",
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        items: _birthPlaces.map((String birthPlace) {
                          return DropdownMenuItem<String>(
                            value: birthPlace,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(birthPlace),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBirthPlace = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your birth place';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Contact Information',
                          style: AppConstants.header,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Phone Number',
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
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          hintText: '+91',
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        style: AppConstants.fieldTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Whatsapp Number',
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
                        controller: _whatsappNumberController,
                        decoration: InputDecoration(
                          hintText: '+91',
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        style: AppConstants.fieldTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Whatsapp number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Educational Information',
                          style: AppConstants.header,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'College Name',
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
                        controller: _collegeNameController,
                        decoration: InputDecoration(
                          hintText: 'College Name Here',
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        style: AppConstants.fieldTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your college name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: "College's State",
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
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 250,
                        borderRadius: BorderRadius.circular(10),
                        style: AppConstants.dropdown,
                        isDense: true,
                        value: _selectedCollegeState.isNotEmpty
                            ? _selectedCollegeState
                            : null,
                        decoration: InputDecoration(
                          hintText: "Select State",
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        items: _collegeStates.map((String state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(state),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCollegeState = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your college\'s state';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Branch',
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
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 250,
                        borderRadius: BorderRadius.circular(10),
                        style: AppConstants.dropdown,
                        isDense: true,
                        value:
                            _selectedBranch.isNotEmpty ? _selectedBranch : null,
                        decoration: InputDecoration(
                          hintText: "Branch",
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        items: _branches.map((String branch) {
                          return DropdownMenuItem<String>(
                            value: branch,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(branch),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBranch = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your branch';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Degree',
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
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 250,
                        borderRadius: BorderRadius.circular(10),
                        style: AppConstants.dropdown,
                        isDense: true,
                        value:
                            _selectedDegree.isNotEmpty ? _selectedDegree : null,
                        decoration: InputDecoration(
                          hintText: "Degree",
                          hintStyle: AppConstants.hint,
                          focusColor: Colors.black,
                          border: const OutlineInputBorder(),
                        ),
                        items: _degrees.map((String degree) {
                          return DropdownMenuItem<String>(
                            value: degree,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(degree),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDegree = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your degree';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Passout Year',
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
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 250,
                        borderRadius: BorderRadius.circular(10),
                        style: AppConstants.dropdown,
                        isDense: true,
                        value: _selectedPassoutYear,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _passoutYears.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(year),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPassoutYear = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your passout year';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Let's Create Password",
                          style: AppConstants.header,
                        ),
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
                            icon: Icon(isFirstVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isFirstVisible = !isFirstVisible;
                              });
                            },
                          ),
                        ),
                        style: AppConstants.fieldTitle,
                        obscureText: isFirstVisible,
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
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Confirm Password',
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
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          hintText: '********',
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
                            icon: Icon(isSecondVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isSecondVisible = !isSecondVisible;
                              });
                            },
                          ),
                        ),
                        style: AppConstants.fieldTitle,
                        obscureText: isSecondVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                          backgroundColor: const Color(0xffb61628),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text('Register Now', style: AppConstants.btnTxt),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
