import 'package:flutter/material.dart';
import 'package:tele/views/screens/appointment_screen.dart';
import 'package:tele/views/screens/doctor_profile_screen.dart';

class VideoConsultationScreen extends StatefulWidget {
  const VideoConsultationScreen({super.key});

  @override
  State<VideoConsultationScreen> createState() =>
      _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Eng Abuubakar Ciise",
      "experience": "12 Years Of Experience",
      "hospital": "Baano HealthCare Technology",
      "speciality": "Pediatric specialist",
      "language": "English, Somali",
      "charges": "\$6.00",
      "rating": 4.5,
      "image":
          "https://avatars.githubusercontent.com/u/138715168?v=4", // Replace with actual URL
      "available" :["9:00", "11:30","8:15", "10:40","1:00 PM"]
    },
    {
      "name": "Eng Adnaan Hassan ",
      "experience": "100 Years Of Experience",
      "hospital": "Somalia HealthCare Technology",
      "speciality": "specialist",
      "language": "Arabic, English",
      "charges": "\$10.00",
      "rating": 5.5,
      "image":
          "https://avatars.githubusercontent.com/u/138715168?v=4", // Replace with actual URL
      "available" :["8:00", "4:00","7:00", "6:00",]
    },
  ];
  void addDoctor() {
    setState(() {
      doctors.add({
        "name": "Dr. New Doctor",
        "experience": "5 Years Of Experience",
        "hospital": "New Hospital",
        "speciality": "General Physician",
        "language": "English, Arabic",
        "charges": "\$10.00",
        "rating": 4.8,
        "image": "https://via.placeholder.com/150", // Placeholder image URL
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search doctor...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            : const Text("Search Doctor"),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, size: 30),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       children: [
      //         DoctorCard(),
      //         const SizedBox(height: 10),
      //         DoctorCard(),
      //         const SizedBox(height: 10),
      //         DoctorCard(),
      //       ],
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: DoctorCard(doctor: doctors[index]),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addDoctor, // Call the addDoctor function
      //   child: const Icon(Icons.add),
      // ),
   );
  }
}

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