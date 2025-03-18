import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tele/services/StorageService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void handleLogout() async {
    await StorageService.clearUserData(); // Clear saved user data
    Get.offAllNamed(
        '/login'); // Navigate to login screen & remove all previous screens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF118C11), // Green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // This Column holds the white container and leaves space at the top
            Column(
              children: [
                // Leave space so the CircleAvatar can overlap the white container
                const SizedBox(height: 60),

                // The main white container
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                              Icons.person,
                              'Name:',
                              'Abuubakar Ciise',
                            ),
                            _buildInfoRow(
                              Icons.public,
                              'Country:',
                              'Somalia',
                            ),
                            _buildInfoRow(
                              Icons.phone,
                              'Phone:',
                              '+252617092491',
                            ),
                            _buildInfoRow(
                              Icons.email,
                              'Email:',
                              'abuubakarciise@gmail.com',
                            ),
                            _buildInfoRow(
                              Icons.person_outline,
                              'User Name:',
                              'abubakar',
                            ),
                            _buildInfoRow(
                              Icons.location_on,
                              'Address:',
                              'Karaan',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Settings Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Settings",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSettingsRow(Icons.lock, 'Change Password'),
                            _buildSettingsRow(Icons.pin, 'Change Pin'),
                            _buildSettingsRow(
                                Icons.language, 'Change Language'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Other",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSettingsRow(Icons.qr_code, 'Share QR code'),
                            _buildSettingsRow(Icons.share, 'Share Apk'),
                            _buildSettingsRow(Icons.logout, 'Log Out',onTap: handleLogout),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Circle Avatar + Pending status (overlapping the white container)
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white, // White border effect
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/138715168?v=4',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Pending",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each info row in the Personal Information section
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build each row in the Settings section
  Widget _buildSettingsRow(IconData icon, String title,{VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
