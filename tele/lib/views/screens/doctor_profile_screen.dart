import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Doctor Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
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

            // Single Card for All Sections
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Professional Details Section
                    _buildSectionTitle("Professional Details"),
                    _buildDetailRow("Full Name", widget.doctor['name']),
                    _buildDetailRow("Hospital", widget.doctor['hospital']),
                    _buildDetailRow("Speciality", widget.doctor['speciality']),
                    _buildDetailRow("Experience", widget.doctor['experience']),
                    _buildDetailRow("Language", widget.doctor['language']),
                    _buildDetailRow("Consultation Fee", widget.doctor['charges']),
                    // const Divider(),

                    // Basic Details Section
                    _buildSectionTitle("Basic Details"),
                    // _buildDetailRow("Rating", "${}"),
                    _buildRating(widget.doctor['rating']),
                    // const Divider(),

                    // About Me Section
                    _buildSectionTitle("About Me"),
                    _buildDetailContainer(widget.doctor['about'] ?? "Passionate and experienced doctor providing the best healthcare services."),
                    // const Divider(),
                    SizedBox(height: 10,),
                    // Extra Activities Section
                    _buildSectionTitle("Extra Activities"),
                    _buildDetailContainer(widget.doctor['extraActivities'] ?? "Volunteers in medical camps and participates in community health programs."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Styling
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Detail Row with Grey Background
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            margin: const EdgeInsets.only(top: 4,),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 17),
              softWrap: true,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  // Styled Container for About Me and Extra Activities
  Widget _buildDetailContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      margin: const EdgeInsets.only(top: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17),
        softWrap: true,
        maxLines: null,
      ),
    );
  }

  // Rating as Stars
  Widget _buildRating(double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RatingBar.builder(
        initialRating: rating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 30,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
        onRatingUpdate: (rating) {},
      ),
    );
  }
}
