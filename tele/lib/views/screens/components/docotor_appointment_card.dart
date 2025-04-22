import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tele/views/screens/DoctorScreens/doctor_appointment_chat_screen.dart';
import 'package:tele/views/screens/components/config.dart';

class DocotorAppointmentCard extends StatelessWidget {
  final String appointmentTime;
  final String appointmentDate;
  final String doctorName;
  final String patientName;
  final String patientProfile;
  final String doctorToken;
  final String patientToken;
  final String id;
  final bool hasMultipleAppointments;

  const DocotorAppointmentCard({
    super.key,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.doctorName,
    required this.patientName,
    required this.patientProfile,
    required this.doctorToken,
    required this.patientToken,
    required this.id,
    required this.hasMultipleAppointments,
  });

  @override
  Widget build(BuildContext context) {
    DateTime appointmentDateTime;
    try {
      appointmentDateTime = DateTime.parse(appointmentDate);
    } catch (e) {
      appointmentDateTime = DateFormat('dd MMMM yyyy').parse(appointmentDate);
    }

    String formattedDate = DateFormat('EEE, dd MMM yyyy').format(appointmentDateTime);
    final url = Config.baseUrl;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorAppointmentChatScreen(
              patientName: patientName,
              doctorName: doctorName,
              patientProfile: patientProfile,
              doctorToken: doctorToken,
              patientToken: patientToken,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              // Patient Image
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: (patientProfile.isNotEmpty && patientProfile != "N/A")
                      ? NetworkImage('$url/$patientProfile')
                      : const AssetImage('assets/default_image.png') as ImageProvider,
                ),
              ),
              const SizedBox(width: 16),

              // Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Text(
                          appointmentTime,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    if (hasMultipleAppointments)
                      const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(
                          "Multiple Appointments",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
