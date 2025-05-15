import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tele/Models/doctor_prescriptions_model.dart';
import 'package:tele/PrescriptionDetailScreen.dart';
import 'package:tele/controllers/doctor_prescription_controller.dart';
import 'package:tele/services/StorageService.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final DoctorPrescriptionController controller = Get.put(DoctorPrescriptionController());
  String? userId;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    userId = userData["userId"];
    setState(() {
      userId = userData["userId"] ?? "Unknown";
      controller.getPrescriptions(userId!);
      print("✅✅✅✅");
          print(userId);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescriptions")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.prescriptions.isEmpty) {
          return const Center(child: Text("No prescriptions found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.prescriptions.length,
          itemBuilder: (context, index) {
            final DoctorPrescriptionModel prescription = controller.prescriptions[index];
            final String doctorName = prescription.doctorName;
            final String patientName = prescription.patientName;
            final String date = DateFormat.yMMMMd().add_jm().format(prescription.createDate);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionDetailScreen(prescription: prescription),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prescription from Dr. $doctorName", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Patient: $patientName"),
                      Text("Date: $date"),
                      const SizedBox(height: 12),
                      const Text("Tap for details...", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
