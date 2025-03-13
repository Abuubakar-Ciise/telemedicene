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
    // Center(child: Text("Screen 3")),
    Center(child: Text("Screen 4")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedItem],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.loop, "Transaction", 1),
            _buildNavItem(Icons.call, "Contact", 2),
            _buildNavItem(Icons.settings, "Settings", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedItem == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 9, 130, 13).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            if (isSelected) ...[
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
