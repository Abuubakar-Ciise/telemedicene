import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/controllers/appoinments_controller.dart';
import 'package:tele/controllers/doctor_appointment_controller.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/views/screens/components/docotor_appointment_card.dart';
import 'package:tele/views/screens/components/patient_appointment_card.dart';
import 'package:tele/views/screens/loading_message_screen.dart';

class ChatsListScreenAppointment extends StatefulWidget {
  const ChatsListScreenAppointment({super.key});

  @override
  State<ChatsListScreenAppointment> createState() => _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<ChatsListScreenAppointment> {
  final appoinmentsController = Get.put(AppoinmentsController());
  String? userId;
  @override
  void initState() {
    super.initState();
    loadUserData();

  }
  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    setState(() {
      userId = userData["userId"] ?? "Unknown";
      appoinmentsController.fechtAppointments(userId!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if(appoinmentsController.isLoading.value){
            return LoadingMessage();
          }
          if(appoinmentsController.appointments.isEmpty){
            return Center(child: Text("No Appointments Found"));
          }
          return ListView.builder(
            itemCount: appoinmentsController.appointments.length,
            // itemCount: 5,
            itemBuilder: (context,index) {
              final appointment = appoinmentsController.appointments[index];
              // final hasMultiple = appoinmentsController.hasMultipleAppointments(appointment.patientToken);
              print('for doctor ${appointment.doctorToken} -- ${appointment.id}');
              print('for pateint ${appointment.patientToken} -- ${appointment.id}');
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: PatientAppointmentCard(
                  appointmentTime: appointment.shiftTime, 
                  appointmentDate: appointment.appointmentDate, 
                  doctorName: appointment.doctorName, 
                  patientName: appointment.patientName, 
                  patientProfile: appointment.doctorProfile,
                  doctorToken: appointment.doctorToken,
                  patientToken: appointment.patientToken,
                  doctorPhone: appointment.doctorPhone,
                  patientPhone: appointment.patientPhone,
                  id: appointment.id,
                  doctorId: appointment.doctorId,
                  patientId:appointment.patientId ,
                  status: appointment.status,
                  // /status: appointment.status
                  ),
                );
            });
        }),
      ),
    );
  }
}