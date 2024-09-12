import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'profil_screen.dart'; // Import your profile screen

class TestTScreen extends StatefulWidget {
  @override
  State<TestTScreen> createState() => _TestTScreenState();
}

class _TestTScreenState extends State<TestTScreen> {
  int _selectedIndex = 0;

  // Method to get the current screen widget
  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 3:
        return _profile(); // Assuming ProfileScreen is the profile widget
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
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          // Handle middle button press
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
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
                    icon: Icon(Icons.article, size: 20, color: Colors.transparent),
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
                selectedItemColor: Colors.red,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedLabelStyle: AppConstants.barTxt,
                unselectedLabelStyle: AppConstants.barTxt
            ),
          ),
        ],
      ),
      body: _getCurrentScreen(), // Show the appropriate screen based on the index
    );
  }

  Widget _home() {
    return Center(child: Text('Home'));
  }  Widget _profile() {
    return Center(child: Text('Profile'));
  }
}
