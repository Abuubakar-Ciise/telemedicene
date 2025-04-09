import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/controllers/self_managment_controller.dart';
import 'package:tele/views/screens/components/article_card.dart';
import 'package:tele/views/screens/loading_message_screen.dart';

class Selfmanagement extends StatefulWidget {
  const Selfmanagement({super.key});

  @override
  State<Selfmanagement> createState() => _SelfmanagementState();
}
class _SelfmanagementState extends State<Selfmanagement> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final selfManagmentController = Get.put(SelfManagmentController());

  @override
  void initState(){
    super.initState();
    _searchController.addListener((){
       selfManagmentController.filteredSelfManagment(_searchController.text);
    });
  }
  @override
  void dispose(){
    super.dispose();
    _searchController.clear();
    selfManagmentController.filteredSelfManagment('');
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
                  hintText: "Search",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              )
            : const Text("Search "),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, size: 30),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  selfManagmentController.filteredSelfManagment('');
                }
              });
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        if (selfManagmentController.isLoading.value) {
          return LoadingMessage();
        }
        if (selfManagmentController.filteredSelfManagments.isEmpty) {
          return Center(
            child: Text("Waxne"),
          );
        }
        return ListView.builder(
            itemCount: selfManagmentController.filteredSelfManagments.length,
            itemBuilder: (context, index) {
              final self = selfManagmentController.filteredSelfManagments[index];
              return ArticleCard(
                imagePath: self.picture,
                title: self.title,
                description: self.extraDetail,
                createdDate: self.createDate,
              );
            },
          );
      }),
    );
  }
}
