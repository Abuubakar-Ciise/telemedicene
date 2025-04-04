import 'package:flutter/material.dart';
import 'package:tele/views/screens/empty_notification_screen';

class NotificationScreen extends StatelessWidget {
  final bool hasNotifications;

  const NotificationScreen({super.key, this.hasNotifications = true});

  @override
  Widget build(BuildContext context) {
    return hasNotifications
        ?  NotificationScreenContent()
        : EmptyNotificationScreen();
  }
}

class NotificationScreenContent extends StatelessWidget {
  const NotificationScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Notification",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterButton("All"),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Today", count: 3),
                    _buildNotificationTile(
                        "Hey Rafi",
                        "Your password was successfully reset",
                        Colors.blueAccent),
                    _buildNotificationTile("Privacy Policy",
                        "Change by Medicon authority", Colors.lightBlue),
                    _buildNotificationTile("Appointment Completed",
                        "With doctor Tamim Ikraim", Colors.amber),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Yesterday", count: 22),
                    _buildNotificationTile(
                        "Hey Rafi",
                        "Your password was successfully reset",
                        Colors.blueAccent),
                    _buildNotificationTile("Privacy Policy",
                        "Change by Medicon authority", Colors.lightBlue),
                    _buildNotificationTile("Appointment Completed",
                        "With doctor Tamim Ikraim", Colors.amber),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmptyNotificationScreen(),
                  ),
                );
              },
              child: const Text("Clear"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  Widget _buildSectionTitle(String title, {required int count}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 10,
                child: Text(
                  "$count",
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              )
            ],
          ),
          const Text("MARK ALL AS READ",
              style: TextStyle(color: Colors.blue, fontSize: 12))
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
      String title, String subtitle, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(Icons.lock, color: iconColor),
        ),
        title: RichText(
          text: TextSpan(
            text: "$title",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: ", $subtitle",
                style: const TextStyle(color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }
}