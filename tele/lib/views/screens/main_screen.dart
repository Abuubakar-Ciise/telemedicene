import 'package:flutter/material.dart';
import 'package:tele/views/screens/TransactionHistoryScreen.dart';
import 'package:tele/views/screens/contact_us_screen.dart';
import 'package:tele/views/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedItem = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  final List<Widget> screens = [
    HomeScreen(),
    TransactionHistoryScreen(),
    ContactUsScreen(),
    Center(child: Text("Settings Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedItem,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        // showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.loop),
            label: "Transaction",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: "Contact",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}