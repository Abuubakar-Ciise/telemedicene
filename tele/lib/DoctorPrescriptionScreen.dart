import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/controllers/write_prescription_controller.dart';
import 'package:toastification/toastification.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  final String patientId;
  final String doctorId;
  final String appointmentId;
  final String doctorToken;
  final String patientToken;

  const DoctorPrescriptionScreen({
    super.key,
    required this.patientId,
    required this.doctorId,
    required this.appointmentId,
    required this.doctorToken,
    required this.patientToken,
  });

  @override
  State<DoctorPrescriptionScreen> createState() =>
      _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final writePrescriptionController = Get.put(WritePrescriptionController());
  final TextEditingController advice = TextEditingController();

  List<Map<String, TextEditingController>> medications = [
    {
      "medicine_name": TextEditingController(),
      "dosage": TextEditingController(),
      "duration": TextEditingController(),
      "frequency": TextEditingController(),
    }
  ];

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
    if (!_formKey.currentState!.validate()) return;

    await writePrescriptionController.writePrescription(
      patientId: widget.patientId,
      doctorId: widget.doctorId,
      appointmentId: widget.appointmentId,
      extraDetail: advice.text.trim(),
      medicines: medications.map((med) {
        return {
          "medicine_name": med["medicine_name"]!.text,
          "dosage": med["dosage"]!.text,
          "duration": med["duration"]!.text,
          "frequency": med["frequency"]!.text,
        };
      }).toList(),
      doctorToken: widget.doctorToken,
      patientToken: widget.patientToken
    );

    // Navigator.pop(context);
    

    // toastification.show(
    //   context: context,
    //   title: const Text('Prescription Sent'),
    //   type: ToastificationType.success,
    //   style: ToastificationStyle.flat,
    //   alignment: Alignment.topCenter,
    //   autoCloseDuration: const Duration(seconds: 3),
    //   icon: const Icon(Icons.check_circle, color: Colors.green),
    // );
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
