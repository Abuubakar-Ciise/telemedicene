import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele/controllers/reviews_controller.dart';

class ReviewsScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;

  const ReviewsScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final ReviewsController controller = Get.put(ReviewsController());
  final TextEditingController commentController = TextEditingController();
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controllerScroll) => SingleChildScrollView(
          controller: controllerScroll,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rate the Doctor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (index) {
                  final i = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: rating >= i ? Colors.amber : Colors.grey.shade400,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = i.toDouble();
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text('Leave a Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final comment = commentController.text.trim();

                          if (rating == 0.0 || comment.isEmpty) {
                            Get.snackbar('Incomplete', 'Please give a rating and write a comment');
                            return;
                          }

                          await controller.feedbackPatient(
                            comment,
                            widget.doctorId,
                            widget.patientId,
                            rating,
                          );

                          if (!controller.isLoading.value) {
                            Navigator.of(context).pop(); // Close the screen
                          }
                        },
                        child: const Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
