import 'package:flutter/material.dart';
import 'package:tele/views/screens/PatientDetailsScreen.dart';

class SelectPackageWidget extends StatefulWidget {
   final Map<String, dynamic> doctor;
  final DateTime selectedDay;
  final String? selectedTime;
  final Function(int) onPackageSelected;
  final int? selectedPackage;

  const SelectPackageWidget({
    super.key,
    required this.onPackageSelected,
    required this.selectedPackage,
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
  });

  @override
  _SelectPackageWidgetState createState() => _SelectPackageWidgetState();
}

class _SelectPackageWidgetState extends State<SelectPackageWidget> {
  List<Map<String, dynamic>> packages = [
    {
      "title": "Video Conversation",
      "price": "\$13.88 Per 30 Minutes",
      "icon": Icons.videocam,
      "color": Colors.purple,
    },
    {
      "title": "Audio Conversation",
      "price": "\$10.34 Per 30 Minutes",
      "icon": Icons.phone,
      "color": Colors.redAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Package",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(packages.length, (index) {
              bool isSelected = widget.selectedPackage == index;
              return GestureDetector(
                onTap: () {
                  widget.onPackageSelected(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? packages[index]["color"].withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? packages[index]["color"]
                          : Colors.black26,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: packages[index]["color"],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(packages[index]["icon"], color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              packages[index]["title"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              packages[index]["price"],
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: widget.selectedPackage,
                        onChanged: (value) {
                          widget.onPackageSelected(value!);
                        },
                        activeColor: packages[index]["color"],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 9, 130, 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (widget.selectedPackage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Please select a package before proceeding.")),
                );
                return;
              }
              // Handle appointment booking
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientDetailsScreen(
                            doctor: widget.doctor,
                            selectedPackage: packages[widget.selectedPackage!],
                            selectedDay: widget.selectedDay,
                            selectedTime: widget.selectedTime,
                            // selectedPackage: widget.selectedPackage!,
                          )));
            },
            child: const Text(
              "Set Appointment",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
