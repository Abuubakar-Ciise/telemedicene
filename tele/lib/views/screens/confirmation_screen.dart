import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tele/views/screens/check_payment_Screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, String> patientData;
  final Map<String, dynamic> doctor;
  final DateTime selectedDay;
  final String? selectedTime;
  final Map<String, dynamic>? selectedPackage;

  const ConfirmationScreen({
    super.key,
    required this.patientData,
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
    this.selectedPackage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment Method',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorCard(),
            const SizedBox(height: 16),
            _sectionTitle('Scheduled Appointment'),
            _infoRow('Date', DateFormat('MMM d, yyyy').format(selectedDay)),
            _infoRow('Time', selectedTime ?? 'N/A'),
            _infoRow('Duration', '30 Minutes'),
            const SizedBox(height: 16),
            _sectionTitle('Patient Information'),
            _infoRow('Name', patientData['name'] ?? 'N/A'),
            _infoRow('phone', patientData['phone'] ?? 'N/A'),
            _infoRow('Gender', patientData['gender'] ?? 'N/A'),
            _infoRow('Age', patientData['age'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildSelectedPackageCard(),
            const SizedBox(height: 24),
            _buildPayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black));
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              doctor['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${doctor['speciality']} • ${doctor['experience']}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(doctor['rating'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // const Icon(Icons.location_on, color: Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSelectedPackageCard() {
    if (selectedPackage == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedPackage!['color'],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(selectedPackage!['icon'], color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedPackage!['title'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(selectedPackage!['price'],
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          Radio(
            value: true,
            groupValue: true,
            onChanged: (value) {},
            activeColor: Color.fromARGB(255, 9, 130, 13),
          )
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 9, 130, 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          // Handle payment
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckPaymentScreen(
                  phone: patientData['phone'] ?? 'N/A',
                  charges: doctor['charges'],
                  selectedDay: DateFormat('MMM d, yyyy').format(selectedDay),
                  userName: patientData['name'] ?? 'N/A'),
            ),
          );
        },
        child: Text(
          'Payment ${doctor['charges'].toString()}',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
