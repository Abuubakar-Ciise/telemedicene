import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/Models/doctor_appointements_model.dart';
import 'package:tele/controllers/doctor_appointment_controller.dart';
import 'package:tele/controllers/write_prescription_controller.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/views/screens/loading_message_screen.dart';
import 'package:toastification/toastification.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  const DoctorPrescriptionScreen({super.key});

  @override
  State<DoctorPrescriptionScreen> createState() =>
      _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final doctorAppointmentController = Get.put(DoctorAppointmentController());
  final writePrescriptionController = Get.put(WritePrescriptionController());

  final TextEditingController patientName = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController advice = TextEditingController();
  String gender = 'Male';

  DoctorAppointementsModel? selectedUser;

  List<Map<String, TextEditingController>> medications = [
    {
      "medicine_name": TextEditingController(),
      "dosage": TextEditingController(),
      "duration": TextEditingController(),
      "frequency": TextEditingController(),
    }
  ];

  String? userId;
  String? pateintId;
  String? appointmentId;


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    setState(() {
      userId = userData["userId"] ?? "Unknown";
      doctorAppointmentController.confimfechtAppointments(userId!);
    });
  }

  void fillUserInfo(DoctorAppointementsModel user) {
    patientName.text = user.patientName;
    age.text = user.patienAge.toString();
    gender = user.patientGender;
    setState(() {});
  }

  void addMedicationField() {
    setState(() {
      medications.add({
        "medicine_name": TextEditingController(),
        "dosage": TextEditingController(),
        "duration": TextEditingController(),
        "frequency": TextEditingController(),
      });
    });
  }

  void removeMedicationField(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  void onSendPressed() async {
    if (selectedUser == null) {
      toastification.show(
        context: context,
        title: const Text('No Patient Selected'),
        description:
            const Text('Please select a user before sending the prescription.'),
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    await writePrescriptionController.writePrescription(
      patientId: pateintId!,
      doctorId: userId!,
      appointmentId: appointmentId!,
      extraDetail: advice.text.trim(),
      medicines: medications.map((med) {
        return {
          "medicine_name": med["medicine_name"]!.text,
          "dosage": med["dosage"]!.text,
          "duration": med["duration"]!.text,
          "frequency": med["frequency"]!.text,
        };
      }).toList(),
    );

    setState(() {
      selectedUser = null;
      appointmentId = null;
      pateintId = null;
      patientName.clear();
      age.clear();
      advice.clear();
      gender = 'Male';
      medications = [
        {
          "medicine_name": TextEditingController(),
          "dosage": TextEditingController(),
          "duration": TextEditingController(),
          "frequency": TextEditingController(),
        }
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Write Prescription",
            style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                if (doctorAppointmentController.isLoading.value) {
                  return LoadingMessage();
                }
                if (doctorAppointmentController
                    .allConfirmedAppointments.isEmpty) {
                  return const Center(child: Text('No appointments found.'));
                }
                return DropdownButtonFormField<DoctorAppointementsModel>(
                  decoration: const InputDecoration(
                    labelText: "Select Patient",
                    border: OutlineInputBorder(),
                  ),
                  items: doctorAppointmentController.allConfirmedAppointments
                      .map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text(user.patientName),
                    );
                  }).toList(),
                  onChanged: (user) {
                    if (user != null) {
                      selectedUser = user;
                      appointmentId = user.id;
                      pateintId = user.patientId;
                      fillUserInfo(user);
                    }
                  },
                  validator: (value) =>
                      value == null ? "Please select a patient" : null,
                );
              }),
              const SizedBox(height: 20),
              TextFormField(
                controller: patientName,
                decoration: const InputDecoration(
                  labelText: "Patient Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Patient name is required"
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: age,
                      decoration: const InputDecoration(
                        labelText: "Age",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return "Age is required";
                        if (int.tryParse(v) == null)
                          return "Enter a valid number";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: gender,
                      items: ["Male", "Female"]
                          .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (value) => setState(() => gender = value!),
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Medications",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const Divider(thickness: 1.2),
              ...List.generate(medications.length, (index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: medications[index]["medicine_name"],
                                decoration: const InputDecoration(
                                  labelText: "Medicine Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Required" : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: medications[index]["dosage"],
                                decoration: const InputDecoration(
                                  labelText: "Dosage (mg)",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Required" : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: medications[index]["duration"],
                                decoration: const InputDecoration(
                                  labelText: "Duration (days)",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Required" : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: medications[index]["frequency"],
                                decoration: const InputDecoration(
                                  labelText: "Frequency",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Required" : null,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => removeMedicationField(index),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      "Add Medication",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onPressed: addMedicationField,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: advice,
                decoration: const InputDecoration(
                  labelText: "Advice / Notes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty
                    ? "Advice or notes required"
                    : null,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("Send Prescription"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: onSendPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
