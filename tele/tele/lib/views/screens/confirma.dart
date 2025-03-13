import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tele/views/screens/PaymentStatusScreen.dart'; // Added for date formatting

class ConfirmScreen extends StatefulWidget {
  final String userName;
  final String phone;
  final String charges;
  final String selectedDay;

  const ConfirmScreen({
    super.key,
    required this.phone,
    required this.charges,
    required this.userName,
    required this.selectedDay,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to left
              children: [
                _infoRow('Full Name', widget.userName),
                _infoRow('Phone Number', widget.phone),
                _infoRow('Charges', widget.charges),
                _infoRow('Selected Day', widget.selectedDay),
                _infoRow(
                    'Current Time',
                    DateFormat('hh:mm a')
                        .format(DateTime.now())), // Fixed DateTime formatting

                const SizedBox(height: 20), // Added spacing
                SizedBox(
                  width: double.infinity, // Button takes full width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 130, 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // Handle payment submission
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentStatusScreen(
                              isSuccess:
                                  false), // Pass true for success, false for failure
                        ),
                      );
                    },
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Info row widget
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
