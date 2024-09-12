import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:test_app/screens/profil_screen.dart';
import '../constants/app_constants.dart';
import 'package:http/http.dart' as http;

import '../constants/global.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  String? storedEmail = GlobalState().registeredEmail;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await http.get(
        Uri.parse('http://13.127.246.196:8000/api/registers/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final profile = data.firstWhere(
          (element) => element['email'] == GlobalState().registeredEmail,
          orElse: () => null,
        );

        if (profile != null) {
          GlobalState().profileId = profile['id'];

          print('Fetched profile data: $profile');

          setState(() {
            _fullNameController.text = profile['full_name'] ?? '';
            _fatherNameController.text = profile['father_name'] ?? '';
            _emailController.text = profile['email'] ?? '';
            _dateOfBirthController.text = profile['date_of_birth'] ?? '';
            _gender = profile['gender'] ?? 'Male';
            _phoneNumberController.text = profile['phone_number'] ?? '';
            _whatsappNumberController.text = profile['whatsapp_number'] ?? '';
            _selectedCollegeState = profile['college_state'] ?? '';
            _selectedBirthPlace = profile['birth_place'] ?? '';
            _collegeNameController.text = profile['college_name'] ?? '';
            _selectedBranch = profile['branch_name'] ?? '';
            _selectedDegree = profile['degree_name'] ?? '';
            _selectedPassoutYear =
                profile['passing_year']?.toString() ?? '2024';
          });
        } else {
          print('No profile found with the specified email.');
        }
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _updateProfileData(int id) async {
    final Map<String, dynamic> updatedData = {
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
      'passing_year': int.tryParse(_selectedPassoutYear) ?? 2024,
      'password': _passwordController.text,
    };

    try {
      final response = await http.patch(
        Uri.parse(
            'http://13.127.246.196:8000/api/registers/$id/'), // Dynamically use the ID
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Profile updated successfully.');

        if (_emailController.text != GlobalState().registeredEmail) {
          GlobalState().registeredEmail = _emailController.text;
          print('Global email updated: ${GlobalState().registeredEmail}');
        }

        Fluttertoast.showToast(
          msg: "Profile updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        print('Failed to update profile: ${response.statusCode}');
        print('Response body: ${response.body}');

        Fluttertoast.showToast(
          msg: "Failed to update profile: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile data: $e');

      Fluttertoast.showToast(
        msg: "Error updating profile: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  int _selectedIndex = 0;

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 4:
        return _profile();
      default:
        return _home();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {},
          child: Text(
            'HIREMI',
            style: AppConstants.btnTxtSmlr,
          ),
          backgroundColor: Color(0xffad1b27),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 20),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article, size: 20),
                    label: 'Applies',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article,
                        size: 20, color: Colors.transparent),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.help, size: 20),
                    label: 'Queries',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 20),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Color(0xffad1b27),
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedLabelStyle: AppConstants.barTxt,
                unselectedLabelStyle: AppConstants.barTxt),
          ),
        ],
      ),
      body: _getCurrentScreen(),
    );
  }

  Widget _profile() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                SizedBox(height: 30),
                Text(
                  'Update your Profile!',
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
                    const SizedBox(
                      height: 20,
                    ),
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
                            child: Text(
                              birthPlace,
                            ),
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
                      onPressed: () {
                        _updateProfileData(GlobalState().profileId!);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(5)),
                        backgroundColor: const Color(0xffb61628),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('Update', style: AppConstants.btnTxt),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _home() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/profile_image.png'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Harsh Pawar', style: AppConstants.fieldTitle),
                          Row(
                            children: [
                              Text('App ID: ', style: AppConstants.small),
                              Text('123456', style: AppConstants.small),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.verified,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 4),
                              Text('Not Verified', style: AppConstants.small),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Explore Hiremi', style: AppConstants.header),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/explore_hiremi.png'),
            ),
            const SizedBox(height: 20),
            Text('Hiremi\'s Featured', style: AppConstants.header),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFeatureButton('Internships', Colors.orange),
                  const SizedBox(width: 10),
                  _buildFeatureButton('Fresher Jobs', Colors.red),
                  const SizedBox(width: 10),
                  _buildFeatureButton('Experienced Jobs', Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Latest Opportunities', style: AppConstants.header),
            const SizedBox(height: 10),
            _buildOpportunityCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text, style: AppConstants.btnTxtSmlr),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jr. Java Programmer', style: AppConstants.header),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Bhopal, Madhya Pradesh, India',
                    style: AppConstants.small),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.school, color: Colors.grey),
                const SizedBox(width: 4),
                Text('B.E/B.Tech/MCA/MBA/BCA/BSC/MSC',
                    style: AppConstants.small),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.money, color: Colors.grey),
                const SizedBox(width: 4),
                Text('₹ 2.5 LPA', style: AppConstants.small),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.work, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Remote | Job | 2 Year Exp', style: AppConstants.small),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Apply Now', style: AppConstants.btnTxtSmlr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
