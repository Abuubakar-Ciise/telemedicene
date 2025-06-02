import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tele/Models/patient_appointements_model.dart';
import 'package:tele/controllers/appoinments_controller.dart';
import 'package:tele/controllers/labs_controller.dart';
import 'package:toastification/toastification.dart';

class LabsRecordScreen extends StatefulWidget {
  const LabsRecordScreen({super.key});

  @override
  _LabsRecordScreenState createState() => _LabsRecordScreenState();
}

class _LabsRecordScreenState extends State<LabsRecordScreen> {
  final AppoinmentsController _appointmentController = Get.put(AppoinmentsController());
  final LabsController _labsController = Get.put(LabsController());

  File? _selectedImage;
  String? _selectedPatientId;
  String? _selectedDoctorId;
  String? _selectedAppointmentId;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _uploadRecord() async {
    if (_selectedImage == null || _selectedAppointmentId == null || _selectedDoctorId == null || _selectedPatientId == null) {
      toastification.show(
        context: context,
        title: const Text("Missing Info"),
        description: const Text("Please complete all fields."),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    await _labsController.uploadLabRecord(
      imageFile: _selectedImage!,
      patientId: _selectedPatientId!,
      doctorId: _selectedDoctorId!,
      appointmentId: _selectedAppointmentId!,
    );

    setState(() {
      _selectedImage = null;
      _selectedDoctorId = null;
      _selectedAppointmentId = null;
      _selectedPatientId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Lab Record")),
      body: Obx(() {
        if (_appointmentController.isLoading.value || _labsController.isUploading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Doctor", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<PatientAppointementsModel>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                hint: const Text("Select Doctor"),
                value: _appointmentController.appointments.firstWhereOrNull((a) => a.id == _selectedAppointmentId),
                items: _appointmentController.appointments
                    .map((a) => DropdownMenuItem(
                          value: a,
                          child: a.doctorName.isNotEmpty ? Text(a.doctorName) : const Text('Unknown'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDoctorId = value.doctorId;
                      _selectedAppointmentId = value.id;
                      _selectedPatientId = value.patientId;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),
              if (_selectedDoctorId != null) ...[
                const Text("Appointment", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  value: _selectedAppointmentId,
                  items: _appointmentController.appointments
                      .where((a) => a.doctorId == _selectedDoctorId)
                      .map((a) => DropdownMenuItem(
                            value: a.id,
                            child: Text("${a.shiftDay} - ${a.shiftTime} (${a.appointmentDate})"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAppointmentId = value;
                      final appointment = _appointmentController.appointments.firstWhereOrNull((a) => a.id == value);
                      _selectedPatientId = appointment?.patientId;
                    });
                  },
                ),
              ],

              const SizedBox(height: 30),
              const Text("Lab Report Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.file(_selectedImage!, height: 220, width: double.infinity, fit: BoxFit.cover),
                      )
                    : const DottedBorderPlaceholder(),
              ),
              const SizedBox(height: 10),

              // Colored pick image button
              Center(
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image_outlined, color: Colors.white),
                  label: const Text("Pick / Change Image", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Green upload button
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
                  label: const Text("Upload & Save Record", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  onPressed: _labsController.isUploading.value ? null : _uploadRecord,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class DottedBorderPlaceholder extends StatelessWidget {
  const DottedBorderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text("Tap to add lab image", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
