import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:tele/controllers/HospitalController.dart';
import 'package:tele/views/screens/loading_message_screen.dart';

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
  final hospitalController = Get.put(HospitalController());

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      hospitalController.filterHospitals(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search Hospital...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              )
            : const Text("Search Hospitals"),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, size: 30),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  hospitalController.filterHospitals('');
                }
              });
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20),
        child: Obx(() {
          if (hospitalController.isLoading.value) {
            return LoadingMessage();
          }

          if (hospitalController.filteredHospitals.isEmpty) {
            return LoadingMessage(animationAsset: 'assets/animations/no_hospital.json',);
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemCount: hospitalController.filteredHospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitalController.filteredHospitals[index];
              return HospitalCards(
                name: hospital.name,
                picture: hospital.picture,
              );
            },
          );
        }),
      ),
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
                spreadRadius: 0.5,
                blurRadius: 3,
                offset: Offset(0,0), // Shadow position
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
