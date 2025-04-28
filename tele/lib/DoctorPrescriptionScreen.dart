import 'package:flutter/material.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  const DoctorPrescriptionScreen({super.key});

  @override
  State<DoctorPrescriptionScreen> createState() => _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController patientName = TextEditingController();
  final TextEditingController age = TextEditingController();
  String gender = 'Male';
  final TextEditingController diagnosis = TextEditingController();
  final TextEditingController advice = TextEditingController();
  List<TextEditingController> medications = [TextEditingController()];

  void addMedicationField() {
    setState(() {
      medications.add(TextEditingController());
    });
  }

  void removeMedicationField(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // collect data
      final name = patientName.text;
      final ageVal = int.tryParse(age.text) ?? 0;
      final medList = medications.map((c) => c.text).where((m) => m.isNotEmpty).toList();

      // 🧠 you can now:
      // - Generate PDF
      // - Send to server
      // - Store in Firestore or Supabase
      print("Prescription for $name submitted ✅");

      // Navigate or generate PDF (call your PDF logic here)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Write Prescription")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Patient Info
              TextFormField(
                controller: patientName,
                decoration: InputDecoration(labelText: "Patient Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: age,
                      decoration: InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: gender,
                      items: ["Male", "Female"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (value) => setState(() => gender = value!),
                      decoration: InputDecoration(labelText: "Gender"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: diagnosis,
                decoration: InputDecoration(labelText: "Diagnosis"),
              ),

              const SizedBox(height: 20),
              Text("Medications", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...List.generate(medications.length, (index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: medications[index],
                        decoration: InputDecoration(labelText: "Medication ${index + 1}"),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => removeMedicationField(index),
                    )
                  ],
                );
              }),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add More"),
                onPressed: addMedicationField,
              ),

              TextFormField(
                controller: advice,
                decoration: InputDecoration(labelText: "Advice / Notes"),
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Generate Prescription"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
