import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:tele/controllers/HospitalController.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000';
  // final HospitalController hospitalController = Get.put(HospitalController());
  final hospitalController = Get.put(HospitalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search Hospital...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            : const Text("Search Hosipitals"),
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
        centerTitle: true,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 12),
        //   child: GestureDetector(
        //     onTap: () {
        //       Get.offAllNamed('/mainscreen');
        //     },
        //     child: Container(
        //       width: 36,
        //       height: 36,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: Colors.black26),
        //       ),
        //       child: const Icon(Icons.arrow_back, color: Colors.black),
        //     ),
        //   ),
        // ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Obx(() {
            if (hospitalController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 9, 130, 13)),
                ),
              );
            }
            // Check if the list of hospitals is empty
            if (hospitalController.hospitals.isEmpty) {
              return Center(
                child: Text(
                  "No hospitals available. ${hospitalController.hospitals.length}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 8, 
                    mainAxisSpacing: 5
                    ),
                itemCount: hospitalController.hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = hospitalController.hospitals[index];
                  return HospitalCards(
                    name: hospital.name,
                    picture: hospital.picture,
                  );
                });
          })),
    );
  }
}

class HospitalCards extends StatefulWidget {
  final String name;
  final String picture;
  const HospitalCards({super.key, required this.name, required this.picture});

  @override
  State<HospitalCards> createState() => _HospitalCardsState();
}

class _HospitalCardsState extends State<HospitalCards> {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 1), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50, // Adjust size as needed
                backgroundImage: (widget.picture?.isNotEmpty ?? false) &&
                        widget.picture != "N/A"
                    ? NetworkImage("$baseUrl/${widget.picture}")
                    : AssetImage('assets/default_image.png') as ImageProvider,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
