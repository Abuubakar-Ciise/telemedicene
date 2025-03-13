import 'package:flutter/material.dart';

class DoctorProfileScreens extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorProfileScreens({super.key, required this.doctor});

  @override
  State<DoctorProfileScreens> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.doctor['name']),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.doctor['image']),
            ),
            const SizedBox(height: 16),

            // Basic Details Card (Name & Rating)
            _buildDetailCard(
              title: "Basic Details",
              details: [
                _buildDetailRow(Icons.person, "Full Name", widget.doctor['name']),
                _buildDetailRow(Icons.star, "Rating", widget.doctor['rating'].toString()),
              ],
            ),
            const SizedBox(height: 16),

            // Professional Details
            _buildDetailCard(
              title: "Professional Details",
              details: [
                _buildDetailRow(Icons.business, "Hospital", widget.doctor['hospital']),
                _buildDetailRow(Icons.medical_services, "Speciality", widget.doctor['speciality']),
                _buildDetailRow(Icons.access_time, "Experience", widget.doctor['experience']),
                _buildDetailRow(Icons.language, "Language", widget.doctor['language']),
                _buildDetailRow(Icons.attach_money, "Consultation Fee", widget.doctor['charges']),
              ],
            ),

            const SizedBox(height: 16),

            // About Me Section
            _buildDetailCard(
              title: "About Me",
              details: [
                Text(
                  "Passionate and experienced doctor providing the best healthcare services.",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Extra Activity Section
            _buildDetailCard(
              title: "Extra Activities",
              details: [
                Text(
                  "Volunteers in medical camps and participates in community health programs.",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required List<Widget> details}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Column(children: details),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700], size: 24),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
