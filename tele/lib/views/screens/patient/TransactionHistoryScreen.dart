import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tele/controllers/patient_transection_controller.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/views/screens/loading_message_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final patientTransectionController = Get.put(PatientTransectionController());
  String userId = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    setState(() {
      userId = userData["userId"] ?? "Unknown";
      patientTransectionController.fechtTransection(userId);
    });
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr).toLocal();
    return DateFormat('dd MM yy hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (patientTransectionController.isLoading.value) {
          return LoadingMessage();
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: patientTransectionController.transections.length,
            itemBuilder: (context, index) {
              final transaction = patientTransectionController.transections[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('Sender:', transaction.patientName, transaction.senderPhone),
                      _infoRow('Receiver:', transaction.doctorName, transaction.reciverPhone),
                      _infoRow('Amount:', '','\$${transaction.amount.toString()}'),
                      _infoRow('Date:', '',formatDate(transaction.createDate)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _infoRow(String title, String name, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5), // Small spacing
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (phone.isNotEmpty)
            Text(
              phone,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
