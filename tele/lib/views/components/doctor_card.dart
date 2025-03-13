import 'package:flutter/material.dart';
import 'package:tele/views/screens/appointment_screen.dart';
import 'package:tele/views/screens/doctor_profile_screen.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      doctor['image']), // Replace with network image
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'] ?? 'Geust',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        doctor['experience'] ?? "Experience not available",
                        style: TextStyle(color: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => DoctorProfileScreen(doctor: doctor)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 9, 130, 13),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("View Profile",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber),
                Text(doctor['rating'] != null
                    ? doctor['rating'].toString()
                    : 'N/A'),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(height: 10),
                    Text("Hospital: ${doctor['hospital'] ?? 'N/A'}"),
                    const SizedBox(height: 5),
                    Text("Speciality: ${doctor['speciality'] ?? 'N/A'}"),
                    const SizedBox(height: 5),
                    Text("Language: ${doctor['language'] ?? 'N/A'}"),
                    const SizedBox(height: 5),
                    Text("Standard Charges: ${doctor['charges'] ?? 'N/A'}"),
                    //  Text("Standard Charges: ${doctor['charges'] != null ? doctor['charges'].toString() : 'N/A'}"),
                  ],
                )),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => AppointmentScreen(doctor: doctor)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 9, 130, 13),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Book Appointment",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}