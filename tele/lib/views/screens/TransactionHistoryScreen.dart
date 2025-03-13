import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {
      'phone': '617092491',
      'amount': '\$0.01',
      'date': '2024-07-29',
      'time': '11:23:12'
    },
    {
      'phone': '610736551',
      'amount': '\$0.01',
      'date': '2024-07-30',
      'time': '07:30:57'
    },
    {
      'phone': '610736551',
      'amount': '\$0.01',
      'date': '2024-07-30',
      'time': '07:30:57'
    },
  ];

   TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, 
        centerTitle: true,
        title: const Text(
          'Transaction',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
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
                    _infoRow('Phone', transaction['phone']!),
                    _infoRow('Amount', transaction['amount']!),
                    _infoRow('Date', transaction['date']!),
                    _infoRow('Time', transaction['time']!),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
