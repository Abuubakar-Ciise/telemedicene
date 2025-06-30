import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tele/PrescriptionDetailScreen.dart';
import 'package:tele/controllers/doctor_prescription_controller.dart';
import 'package:tele/controllers/labs_report_controller.dart';
import 'package:tele/services/StorageService.dart';
import 'package:tele/services/firebase_api.dart';
import 'package:tele/views/screens/CallPage/call_page.dart';
import 'package:tele/views/screens/components/config.dart';
import 'package:tele/views/screens/patient/LabReportViewerScreen.dart';
import 'package:tele/views/screens/patient/labs_records_screen.dart';

class PatientAppointmentChatScreen extends StatefulWidget {
  final String id;
  final String doctorName;
  final String patientName;
  final String patientProfile;
  final String doctorToken;
  final String patientToken;
  final String doctorPhone;
  final String patientPhone;
  final String doctorId;
  final String patientId;

  const PatientAppointmentChatScreen({
    super.key,
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.patientProfile,
    required this.doctorToken,
    required this.patientToken,
    required this.doctorPhone,
    required this.patientPhone,
    required this.doctorId,
    required this.patientId,
  });

  @override
  State<PatientAppointmentChatScreen> createState() =>
      _PatientAppointmentChatScreenState();
}

class _PatientAppointmentChatScreenState
    extends State<PatientAppointmentChatScreen> {
  final url = Config.baseUrl;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _prescriptionScrollController = ScrollController();
  final ScrollController _labsScrollController = ScrollController();

  double _avatarSize = 40;
  bool _showFullAppBar = true;
  String? picture;
  String? userId;

  final DoctorPrescriptionController controller =
      Get.put(DoctorPrescriptionController());
  final LabsReportController labs = Get.put(LabsReportController());

  @override
  void initState() {
    super.initState();
    loadUserData();
    _scrollController.addListener(_handleScroll);
  }

  Future<void> loadUserData() async {
    Map<String, String?> userData = await StorageService.getUserData();
    picture = userData['picture'] ?? "N/A";
    userId = userData["userId"] ?? "Unknown";

    await controller.getPatientPrescriptions(
      userId!,
      widget.doctorId,
    );
    await labs.labsReports(widget.patientId, widget.doctorId, widget.id);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    if (offset > 0 && offset < 100) {
      setState(() {
        _avatarSize = 40 - (offset * 0.3).clamp(0, 16);
        _showFullAppBar = offset < 30;
      });
    } else if (offset <= 0) {
      setState(() {
        _avatarSize = 40;
        _showFullAppBar = true;
      });
    }
  }

  void _addLabs() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: LabsRecordScreen(patientId: widget.patientId,doctorId: widget.doctorId,appointmentId: widget.id,doctorToken: widget.doctorToken,patientToken: widget.patientToken,),
        ),
      );
    },
  );
}


  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.teal),
            onPressed: () => Navigator.pop(context),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: _avatarSize,
            height: _avatarSize,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (widget.patientProfile.isNotEmpty &&
                      widget.patientProfile != "N/A")
                  ? NetworkImage('$url/${widget.patientProfile}')
                  : const AssetImage('assets/default_image.png')
                      as ImageProvider,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_showFullAppBar) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.teal),
            onPressed: () async {
              final roomId = "call_${DateTime.now().millisecondsSinceEpoch}";

              await FirebaseApis().sendCallFCM(
                widget.doctorToken,
                widget.doctorName,
                roomId,
                widget.doctorPhone,
                widget.patientProfile,
                '0',
                widget.patientToken,
                widget.doctorToken,
                widget.doctorId,
                widget.patientId,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallPage(callId: roomId, callType: '0'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.teal),
            onPressed: () async {
              final roomId = "call_${DateTime.now().millisecondsSinceEpoch}";

              await FirebaseApis().sendCallFCM(
                widget.doctorToken,
                widget.doctorName,
                roomId,
                widget.doctorPhone,
                widget.patientProfile,
                '1',
                widget.patientToken,
                widget.doctorToken,
                widget.doctorId,
                widget.patientId,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallPage(callId: roomId, callType: '1'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionTab() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.patientPrescriptions.isEmpty) {
              return const Center(child: Text("No prescriptions found."));
            }

            return ListView.builder(
              // controller: _scrollController,
              controller: _prescriptionScrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.patientPrescriptions.length,
              itemBuilder: (context, index) {
                final item = controller.patientPrescriptions[index];
                final date =
                    DateFormat.yMMMMd().add_jm().format(item.createDate);
                final medicineCount = item.medicines?.length ?? 0;
                final summary = medicineCount > 0
                    ? "$medicineCount medicine${medicineCount > 1 ? 's' : ''} prescribed"
                    : "No medicines listed";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              PrescriptionDetailScreen(prescription: item)),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.medical_services,
                                  color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("Dr. ${item.doctorName}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 18, color: Colors.green),
                              const SizedBox(width: 6),
                              Text("Patient: ${item.patientName}",
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Colors.orange),
                              const SizedBox(width: 6),
                              Text("Date: $date",
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.list_alt,
                                  size: 18, color: Colors.purple),
                              const SizedBox(width: 6),
                              Text(summary,
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                              child: Text(
                                "Tap to view full prescription",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: SizedBox(
        //     width: double.infinity,
        //     child: ElevatedButton(
        //       onPressed: () {
        //         // TODO: Implement add prescription logic
        //         print("appointmentId ${widget.id}");
        //         print("pateintId ${widget.patientId}");
        //         print("doctorId ${widget.doctorId}");
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.teal,
        //         padding: const EdgeInsets.symmetric(vertical: 14),
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(12)),
        //       ),
        //       child: const Text("Add Prescription",
        //           style: TextStyle(fontSize: 16, color: Colors.white)),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Widget _buildLabsTab() {
  //   return Column(
  //     children: [],
  //   );
  // }
  Widget _buildLabsTab() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (labs.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (labs.labsReport.isEmpty) {
              return const Center(child: Text("No lab reports found."));
            }

            return ListView.builder(
              // controller: _scrollController,
              controller: _labsScrollController,
              padding: const EdgeInsets.all(16),
              itemCount: labs.labsReport.length,
              itemBuilder: (context, index) {
                final report = labs.labsReport[index];
                final date =
                    DateFormat.yMMMMd().add_jm().format(report.createDate);
                final reportUrl = '$url/${report.reportUrl}';

                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.biotech, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Dr. ${report.doctorName}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.person,
                                size: 18, color: Colors.green),
                            const SizedBox(width: 6),
                            Text("Patient: ${report.patientName}",
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 18, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text("Date: $date",
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.insert_drive_file,
                                size: 18, color: Colors.blue),
                            const SizedBox(width: 6),
                            Text("Report ID: ${report.sequenceId}",
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse(reportUrl);
                            // if (await canLaunchUrl(uri)) {
                            //   await launchUrl(uri,
                            //       mode: LaunchMode.externalApplication);
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text("Could not open report")),
                            //   );
                            // }
                            // Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LabReportViewerScreen(reportUrl: reportUrl),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                              child: Text(
                                "Tap to view lab report",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print("appointmentId ${widget.id}");
                print("pateintId ${widget.patientId}");
                print("doctorId ${widget.doctorId}");
                _addLabs();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Add Lab Report",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // _buildHeader(),
              const TabBar(
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(text: "Prescription"),
                  Tab(text: "Labs"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPrescriptionTab(),
                    _buildLabsTab(),
                    // Center(child: Text("labs")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
