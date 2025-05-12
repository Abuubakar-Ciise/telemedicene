import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/controllers/HospitalController.dart';
import 'package:tele/controllers/specialist_controller.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:tele/views/screens/loading_message_screen.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final hospitalController = Get.put(HospitalController());
  final specialistController = Get.put(SpecialistController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _searchController.addListener(() {
      final searchText = _searchController.text;
      final tabIndex = _tabController.index;

      if (tabIndex == 0) {
        hospitalController.filterHospitals(searchText);
      } else {
        specialistController.filterSpecialist(searchText);
      }
    });

    _tabController.addListener(() {
      final searchText = _searchController.text;
      if (_tabController.index == 0) {
        hospitalController.filterHospitals(searchText);
      } else if (_tabController.index == 1) {
        specialistController.filterSpecialist(searchText);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    hospitalController.filterHospitals('');
    specialistController.filterSpecialist('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              )
            : const Text("Search Hospitals",
                style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                size: 28, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  hospitalController.filterHospitals('');
                  specialistController.filterSpecialist('');
                }
              });
            },
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: "Hospitals"),
            Tab(text: "Specialist"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Hospitals Tab
          Obx(() {
            if (hospitalController.isLoading.value) {
              return const LoadingMessage();
            }
            if (hospitalController.filteredHospitals.isEmpty) {
              return const LoadingMessage(
                  animationAsset: 'assets/animations/no_hospital.json');
            }
            return _buildHospitalGrid();
          }),

          // Specialist Tab
          Obx(() {
            if (specialistController.isLoading.value) {
              return const LoadingMessage();
            }
            if (specialistController.filteredSpecialist.isEmpty) {
              return const LoadingMessage(
                  animationAsset: 'assets/animations/no_hospital.json');
            }
            return _buildSpecialistGrid();
          }),
        ],
      ),
    );
  }

  Widget _buildHospitalGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: hospitalController.filteredHospitals.length,
      itemBuilder: (context, index) {
        final hospital = hospitalController.filteredHospitals[index];
        return HospitalCard(
          name: hospital.name,
          picture: hospital.picture,
        );
      },
    );
  }

  Widget _buildSpecialistGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: specialistController.filteredSpecialist.length,
      itemBuilder: (context, index) {
        final specialist = specialistController.filteredSpecialist[index];
        return SpecialistCard(
          name: specialist.name,
          picture: specialist.picture,
        );
      },
    );
  }
}

class SpecialistCard extends StatelessWidget {
  final String name;
  final String picture;
  const SpecialistCard({super.key, required this.name, required this.picture});

  @override
  Widget build(BuildContext context) {
    final url = Config.baseUrl;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: (picture.isNotEmpty && picture != "N/A")
                ? NetworkImage("$url/$picture")
                : const AssetImage('assets/default_image.png') as ImageProvider,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final String name;
  final String picture;
  const HospitalCard({super.key, required this.name, required this.picture});

  @override
  Widget build(BuildContext context) {
    final url = Config.baseUrl;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: (picture.isNotEmpty && picture != "N/A")
                ? NetworkImage("$url/$picture")
                : const AssetImage('assets/default_image.png') as ImageProvider,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}