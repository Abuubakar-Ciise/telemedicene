import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/views/Hospitals/HospitalListScreen.dart';
import 'package:tele/views/auth/login_screen.dart';
import 'package:tele/views/components/reusable.card.dart';
import 'package:tele/views/screens/Video_Consultation_Screen.dart';
import 'package:tele/views/screens/user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000';
  String username = "Loading...";
  String userId = "Loading...";
  String? picture;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    String fullName = userData["username"] ?? "Unknown";
    String firstName = fullName.split(" ").first; // Extract first name
    setState(() {
      username = firstName;
      userId = userData["userId"] ?? "Unknown";
       picture = userData['picture'] ?? "N/A";
    });
  }

  final List<Map<String, dynamic>> services = [
    {
      "icon": Icons.video_call,
      "text": "Consultation",
      // "text": "Video Consultation",
      'route': VideoConsultationScreen()
    },
    {
      "icon": Icons.apartment,
      // "text": "Book on Appointment",
      "text": "Hospital",
      'route': HospitalListScreen()
    },
    {"icon": Icons.person_pin, "text": "self manage", 'route': null},
    {"icon": Icons.health_and_safety, "text": "My Treatment", 'route': null},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 65.0, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back,",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child:  CircleAvatar(
                      radius: 28,
                      backgroundImage: (picture?.isNotEmpty ?? false) && picture != "N/A"
                            ? NetworkImage('$baseUrl/$picture')
                            : AssetImage('assets/default_image.png')
                                as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            // Main Card with Title Centered
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              color: const Color(0xff90B4CE),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://avatars.githubusercontent.com/u/138715168?v=4'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "30 Doctors available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Get free consultation for new users",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Find a doctor",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              child: GridView.builder(
                shrinkWrap:
                    true, // Prevents unnecessary scrolling inside SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 cards per row
                  crossAxisSpacing: 18, // Spacing between columns
                  mainAxisSpacing: 18, // Spacing between rows
                  childAspectRatio: 1, // Square-like shape
                ),
                itemBuilder: (context, index) {
                  return ReusableCard(
                    icon: services[index]["icon"],
                    text: services[index]["text"],
                    iconColor: Color.fromARGB(255, 9, 130, 13),
                    onTap: () {
                      if (services[index]['route'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => services[index]['route']),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("No screen available for this service")),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Appointments',
                style: TextStyle(fontSize: 20),
              ),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appointment date header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Appointment date",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 9, 130, 13)
                                      .withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(Icons.check,
                                      color: Colors.white, size: 16),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Confirmed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    // Time slot row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "08:00 ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right_alt,
                              color: Colors.redAccent,
                            ),
                            Text(
                              " 09:00",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Wed Jun 20",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Doctor information
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              'https://avatars.githubusercontent.com/u/138715168?v=4'), // Replace with actual image
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Abuubakar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        CircleAvatar(
                          radius: 5,
                          backgroundColor:
                              Colors.green, // Online status indicator
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
