import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tele/views/screens/confirmation_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final DateTime selectedDay;
  final String? selectedTime;
  final Map<String, dynamic>? selectedPackage;

  const PatientDetailsScreen({
    super.key,
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
    this.selectedPackage,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  String m = '';
  int selectedGender = 0;

  @override
  void initState() {
    super.initState();

    // // Check if selectedPackage is not null and extract relevant info
    // if (widget.selectedPackage != null) {
    //   m = widget.selectedPackage?['title'] ?? ''; // Set name based on package title
    // }

    // nameController.text = m; // Set the nameController text as the extracted package title
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: const Text(
          "Patient Details",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Input
            const Text("Full name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Phone Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            // Text("${DateFormat('MMM d, yyyy').format(widget.selectedDay)}"),
            TextField(
               keyboardType: TextInputType.number,
              controller: phoneController,
              decoration: InputDecoration(
                hintText: "Enter your Number",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),

            // Age Input
            const Text("Age",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your age",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),

            // Gender Selection
            const Text("Gender",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: Color.fromARGB(255, 9, 130, 13),
              color: Colors.black,
              isSelected: [selectedGender == 0, selectedGender == 1],
              onPressed: (int index) {
                setState(() {
                  selectedGender = index;
                });
              },
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Male")),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Female")),
              ],
            ),

            const SizedBox(height: 16),

            // Problem Input
            const Text("Write your problem",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: problemController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your problem",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 24),

            // Next Button
            ElevatedButton(
              onPressed: () {
                // Create a map of patient data
                final patientData = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'age': ageController.text,
                  'gender': selectedGender == 0 ? 'Male' : 'Female',
                  'problem': problemController.text,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      patientData: patientData,
                      doctor: widget.doctor,
                      selectedDay: widget.selectedDay,
                      selectedTime: widget.selectedTime,
                      selectedPackage: widget.selectedPackage,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 9, 130, 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Next",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
