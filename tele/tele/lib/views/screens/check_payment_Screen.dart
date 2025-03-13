import 'package:flutter/material.dart';
import 'package:tele/views/screens/confirma.dart';

class CheckPaymentScreen extends StatefulWidget {
  final String userName;
  final String phone;
  final String charges;
  final String selectedDay;

  const CheckPaymentScreen(
      {super.key,
      required this.phone,
      required this.charges,
      required this.userName,
      required this.selectedDay});

  @override
  State<CheckPaymentScreen> createState() => _CheckPaymentScreenState();
}

class _CheckPaymentScreenState extends State<CheckPaymentScreen> {
  late TextEditingController phoneController;
  late TextEditingController chargesController;

  @override
  void initState() {
    super.initState();
    phoneController =
        TextEditingController(text: widget.phone); // ✅ Set initial phone value
    chargesController = TextEditingController(
        text: widget.charges); // ✅ Set initial charges value
  }

  @override
  void dispose() {
    phoneController.dispose();
    chargesController.dispose();
    super.dispose();
  }

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
                const Text(
                  "Phone Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // Space between text and field
                TextField(
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Increased spacing

                const Text(
                  "Charges",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  controller: chargesController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

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
                      String phone = phoneController.text;
                      String charges = chargesController.text;

                      print("Phone: $phone, Charges: $charges");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmScreen(
                                phone: phone,
                                charges: charges,
                                userName: widget.userName,
                                selectedDay: widget.selectedDay)),
                      );
                    },
                    child: const Text(
                      'Continue',
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
}
